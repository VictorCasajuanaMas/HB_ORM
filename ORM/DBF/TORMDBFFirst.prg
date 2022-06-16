/* CLASS: TORMDBFFirst
    Devuelve el primer registro de la tabla 
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFFirst FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD First( cOrder )

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
METHOD New( oTORMModel ) CLASS TORMDBFFirst

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: First( cOrder )
    Busca el registro en el orden principal Devuelve el Modelo

    cOrder - Orden a tener en cuenta para obtener el primer modelo

Devuelve:
    Modelo
*/
METHOD First( cOrder ) CLASS TORMDBFFirst

    Local cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()
    Local nOrder := 0
    Local oError := Nil

    If ::oTORMModel:Success()

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[14][1], TORM_INFO_MESSAGE[14][2], { ::oTORMModel:TableName, cOrder } ) )

        If cOrder:NotEmpty()

            nOrder := ::oTORMModel:__oIndexes:IndexNumeral( cOrder )

            try 
                
                ( cAlias )->( DbSetOrder( nOrder ) )

            catch oError

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[74][1],TORM_ERROR_MESSAGE[74][2], { cOrder, ::oTORMModel:TableName() } ) )
                
            end

        Endif

        If ::oTORMModel:Success()

            try 

                ( cAlias )->( DbGoTop( ) )
                ::oTORMModel:__oReturn:Success := .T.
                
            catch oError

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log :=  hb_StrReplace( TORM_ERROR_MESSAGE[20][1],TORM_ERROR_MESSAGE[20][2], { ::oTORMModel:__xFindValue:Str() } ) )
                
            End

            If ::oTORMModel:__oReturn:Success

                ::oTORMModel:__oReturn := TORMDBFLoadFromAlias():New( ::oTORMModel ):Model( cAlias )

            Endif

        Endif

        TORMDBFCloseTable():New( ::oTORMModel ):Close( cAlias )
            
    Endif

Return ( ::oTORMModel )