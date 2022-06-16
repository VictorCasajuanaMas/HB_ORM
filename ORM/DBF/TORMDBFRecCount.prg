/* CLASS: TORMDBFRecCount 
    Devuelve el número de registros de la tabla
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFRecCount FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD RecCount()

    PROTECTED:
        DATA oTORMModel AS OBJECT Init Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFRecCount

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

// Group: PROTECTED METHODS

/* METHOD: RecCount(  )
    Devuelve el número de registros de la tabla
    
Devuelve:
    TReturn
*/
METHOD RecCount(  ) CLASS TORMDbfRecCount


    Local cAlias 
    Local oReturn := TReturn():New()
    Local nRecCount := 0

    If TORMDBFTableExist():New( ::oTORMModel ):Exists( 'dbf' ):Fail()
        
        TORMDBFCreateTable():New( ::oTORMModel ):Create()
        
    Endif

    cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()

    If ::oTORMModel:Success()

        try 

            ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[25][1], TORM_INFO_MESSAGE[25][2], { ::oTORMModel:TableName,cAlias} ) )
            ( cAlias )->( DbGoTop( ) )
            DbEval( { | | nRecCount++ }, { | | TORMDBFWhere():New( ::oTORMModel, cAlias ):Success() } ) // Hago esto porque el DbRecCount tiene en cuenta los registros borrados
            oReturn:Return := nRecCount
            oReturn:Success := .T.
            
        catch oError

            oReturn:Return  := 0
            oReturn:Success := .F.
            ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[36][1], TORM_ERROR_MESSAGE[36][2], { ::oTORMModel:TableName, cAlias, TTryCatchShowerror():New( oError ):ToString() } ) )
            
        end

        TORMDBFCloseTable():New( ::oTORMModel ):Close( cAlias )

    Else

        oReturn:Return := 0

    Endif

Return ( oReturn )