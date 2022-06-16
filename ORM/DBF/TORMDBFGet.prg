/* CLASS: TORMDBFGet 
    Ejecuta una consulta con los parámetros de los métodos where, orderby, select, etc...
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'


CREATE CLASS TORMDBFGet FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Get( )

            DATA oTORMModel AS OBJECT INIT Nil
            DATA cAlias        AS CHARACTER INIT ''
    PROTECTED:
        METHOD Order( aData )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFGet

    ::Super:New()
    ::oTORMModel := oTORMModel

    
Return ( Self )

/* METHOD: Get( )
    Ejecuta la consulta

    TODO: Optimizarlo para que lo haga de una sola pasada.

Devuelve:
    Array de Modelos
*/
METHOD Get( ) CLASS TORMDBFGet
    
    Local aReturn := Array( 0 )
    Local aRecnos := Array( 0 )
    Local nRecno := 0
    Local oModelPattern := Nil
    Local oError := Nil

    If TORMDBFTableExist():New( ::oTORMModel ):Exists( 'dbf' ):Fail()
        
        TORMDBFCreateTable():New( ::oTORMModel ):Create()
        
    Endif

    ::cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()
    
    If ::oTORMModel:Success()

        aRecnos := TORMDBFGetOrdCondSet():New( ::oTORMModel ):Get( ::cAlias )
        aRecnos:ArrayInsert( TORMDBFGetRecnosWhereIn():New( ::oTORMModel ):Get( ::cAlias ) )

        If ::oTORMModel:Success()

            try 

                oModelPattern := &( ::oTORMModel:ClassName )():New()  // Si ejecuto esto el ::oTORMModel se inicializa

                for each nRecno in aRecnos

                    If .Not. ::oTORMModel:Fail()

                        ( ::cAlias )->( DbGoTo( nRecno ) )

                        If ( ::cAlias )->( Recno() ) == nRecno

                            aAdD( aReturn, TORMDBFGetModelToCollection():New( ::oTORMModel ):Get( oModelPattern, ::cAlias ) )

                        Else

                            ::oTORMModel:__oReturn:Success := .F.
                            ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace(  TORM_ERROR_MESSAGE[21][1],TORM_ERROR_MESSAGE[21][2], { ::oTORMModel:__cName } ) )

                        Endif

                    Endif

                next

            catch oError

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace(  TORM_ERROR_MESSAGE[21][1],TORM_ERROR_MESSAGE[21][2], { TTryCatchShowerror():New( oError ):ToString() } ) )
                
            end
            
        Endif
        
        TORMDBFCloseTable():New( ::oTORMModel ):Close( ::cAlias )
        
    Endif

    aReturn := ::Order( aReturn )

Return ( aReturn )

// Group: PROTECTED METHODS

/* METHOD: Order( aData )
    Ordena los datos según __oQuery:oOrderby
    
    Parámetros:
        aData - Array de datos a ordenar

Devuelve:
    Array
*/
METHOD Order( aData ) CLASS TORMDBFGet
    
    If .Not. ::oTORMModel:__oQuery:oOrderby:cOrder:Empty()

        switch ::oTORMModel:__oQuery:oOrderby:cDirection
            case TORM_ASC
                
                aData := aData:Sort( {| x, y | x:&(::oTORMModel:__oQuery:oOrderby:cOrder) < y:&(::oTORMModel:__oQuery:oOrderby:cOrder) } )

            exit

            case TORM_DESC
                
                aData := aData:Sort( {| x, y | x:&(::oTORMModel:__oQuery:oOrderby:cOrder) > y:&(::oTORMModel:__oQuery:oOrderby:cOrder) } )

            exit
        endswitch

    Endif


Return ( aData )