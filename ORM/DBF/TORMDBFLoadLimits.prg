/* CLASS: TORMDBFLoadLimits
    Devuelve el primer registro de la tabla 
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFLoadLimits FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Load( cOrder )

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
METHOD New( oTORMModel ) CLASS TORMDBFLoadLimits

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: Load( cOrder )
    Busca el registro en el orden principal Devuelve el Modelo

    cOrder - Orden a tener en cuenta para obtener el primer modelo

Devuelve:
    Array de modelos
*/
METHOD Load( cOrder ) CLASS TORMDBFLoadLimits

    Local cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()
    Local nOrder := 0
    Local oError := Nil
    Local oModelPattern := Nil
    Local aReturn := Array( 0 )


    If ::oTORMModel:Success()

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[18][1], TORM_INFO_MESSAGE[18][2], {::oTORMModel:TableName, cOrder} ) )

        If cOrder:NotEmpty()

            nOrder := ::oTORMModel:__oIndexes:IndexNumeral( cOrder )

            try 
                
                ( cAlias )->( DbSetOrder( nOrder ) )

            catch oError

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[71][1], TORM_ERROR_MESSAGE[71][2], { cOrder, ::oTORMModel:TableName(),TTryCatchShowerror():New( oError ):ToString() } ))
                
            end

        Endif

        If ::oTORMModel:Success()

            oModelPattern := &( ::oTORMModel:ClassName )():New()  // Si ejecuto esto el ::oTORMModel se inicializa

            try 

                ( cAlias )->( DbGoTop( ) )
                aAdD( aReturn, TORMDBFGetModelToCollection():New( ::oTORMModel ):Get( oModelPattern, cAlias ) )
                ( cAlias )->( DbGoBottom( ) )
                aAdD( aReturn, TORMDBFGetModelToCollection():New( ::oTORMModel ):Get( oModelPattern, cAlias ) )
                ::oTORMModel:__oReturn:Success := .T.
                
            catch oError

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[72][1], TORM_ERROR_MESSAGE[72][2], { ::oTORMModel:__xFindValue:Str(), cOrder,TTryCatchShowerror():New( oError ):ToString() } ) )
                
            End

            If ::oTORMModel:__oReturn:Success

                ::oTORMModel:__oReturn := TORMDBFLoadFromAlias():New( ::oTORMModel ):Model( cAlias )

            Endif

        Endif

        TORMDBFCloseTable():New( ::oTORMModel ):Close( cAlias )
            
    Endif

Return ( aReturn )