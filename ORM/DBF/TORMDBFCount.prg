/* CLASS: TORMDBFCount
    Cuenta los registros de una tabla teniendo en cuenta los filtros where y wherein
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFCount FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Count( )

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil
        DATA cAlias        AS CHARACTER INIT ''

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFCount

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Count( )
    Cuenta los registros

Devuelve:
    Numerico
*/
METHOD Count( ) CLASS TORMDBFCount

    Local aRecnos := Array( 0 )
    Local nRecno := 0
    Local oReturn := TReturn():New()

    If TORMDBFTableExist():New( ::oTORMModel ):Exists( 'dbf' ):Fail()
        
        TORMDBFCreateTable():New( ::oTORMModel ):Create()
        
    Endif

    ::cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()
    
    If ::oTORMModel:Success()

        aRecnos := TORMDBFGetOrdCondSet():New( ::oTORMModel ):Get( ::cAlias )
        aRecnos:ArrayInsert( TORMDBFGetRecnosWhereIn():New( ::oTORMModel ):Get( ::cAlias ) )

        If ::oTORMModel:Success

            ::oTORMModel:LogWrite( hb_StrReplace( TORM_INFO_MESSAGE[9][1],TORM_INFO_MESSAGE[9][2], {::cAlias, ::oTORMModel:TableName() } ))
            oReturn:Return := aRecnos:Len()
            oReturn:Success := .T.

        else

            oReturn:Return := 0
            oReturn:Success := .F.
            ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[63][1],TORM_ERROR_MESSAGE[63][2], { ::oTORMModel:TableName()}) )

        Endif

        TORMDBFCloseTable():New( ::oTORMModel ):Close( ::cAlias )
        
    Endif

Return ( oReturn )

// Group: PROTECTED METHODS