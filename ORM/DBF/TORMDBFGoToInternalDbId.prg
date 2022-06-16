/* CLASS: TORMDBFGoToInternalDbId 
    Posiciona el registro del alias en la llave InternalDbId
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFGoToInternalDbId FROM TORMDBF

    EXPORTED:
        DATA oTORMModel AS OBJECT INIT Nil

        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Position( cAlias )

    PROTECTED:

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFGoToInternalDbId

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Position( cAlias )
    Realiza el posicionamiento en sí
    
    Parámetros:
        cAlias - Alias a procesar

Devuelve:
    oReturn
*/
METHOD Position( cAlias ) CLASS TORMDBFGoToInternalDbId

    Local oReturn := TReturn():New()
    Local oError  := Nil 

    If ::oTORMModel:GetInternalDbId() != Nil

        try 

            ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[13][1], TORM_INFO_MESSAGE[13][2], {::oTORMModel:GetInternalDbId():Str(), ::oTORMModel:TableName()} ) )
            ( cAlias )->( DbGoTo( ::oTORMModel:GetInternalDbId() ) )
            oReturn:Success := ( cAlias )->( Recno() ) == ::oTORMModel:GetInternalDbId()

            If oReturn:Fail

                ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[25][1], TORM_ERROR_MESSAGE[25][2], { ::oTORMModel:TableName() } ) )

            Endif
            
        catch oError

            oReturn:Success := .F.
            ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[26][1], TORM_ERROR_MESSAGE[26][2], { ::oTORMModel:TableName() , TTryCatchShowerror():New( oError ):ToString() } ) )
            
        end

    Else

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[27][1], TORM_ERROR_MESSAGE[27][2], { ::oTORMModel:TableName() } ) )

    Endif

Return ( oReturn )

// Group: PROTECTED METHODS