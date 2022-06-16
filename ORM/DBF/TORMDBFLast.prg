/* CLASS: TORMDBFLast
Devuelve el modelo del último registro de la tabla
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFLast FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Last( cOrder )

    PROTECTED:
        DATA oTORMModel AS OBJECT Init Nil

ENDCLASS


// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor, se le inyecta el modelo

    Parámetros:
        - oTORMModel : objeto TORMModel
        
Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFLast

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: Last( cOrder )
    Devuelve el último registro de la tabla

    cOrder - Orden a tener en cuenta para obtener el último modelo

Devuelve:
    Modelo
*/
METHOD Last( cOrder ) CLASS TORMDBFLast

    Local cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()
    Local nOrder := 0
    Local oError := Nil

    If ::oTORMModel:Success()

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[15][1], TORM_INFO_MESSAGE[15][2], { ::oTORMModel:TableName, cOrder } ) )

        If cOrder:NotEmpty()

            nOrder := ::oTORMModel:__oIndexes:IndexNumeral( cOrder )

            try 
                
                ( cAlias )->( DbSetOrder( nOrder ) )

            catch oError

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[69][1], TORM_ERROR_MESSAGE[69][2], { cOrder, ::oTORMModel:TableName(),TTryCatchShowerror():New( oError ):ToString() } ) )
                
            end

        Endif

        If ::oTORMModel:Success()

            try 

                ( cAlias )->( DbGoBottom( ) )
                ::oTORMModel:__oReturn:Success := .T.
                
            catch oError

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[70][1], TORM_ERROR_MESSAGE[70][2], { ::oTORMModel:TableName, ::oTORMModel:__xFindValue:Str() } ) )
                
            End

            If ::oTORMModel:__oReturn:Success

                ::oTORMModel:__oReturn := TORMDBFLoadFromAlias():New( ::oTORMModel ):Model( cAlias )

            Endif

        Endif

        TORMDBFCloseTable():New( ::oTORMModel ):Close( cAlias )
            
    Endif

Return ( ::oTORMModel )