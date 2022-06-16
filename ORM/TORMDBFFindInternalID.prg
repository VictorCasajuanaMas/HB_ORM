/* CLASS: TORMDBFFindInternalID 
    Busca un registro por su internal ID y lo carga en el modelo
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFFindInternalID

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD FindInternalID( xInternalID )

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFFindInternalID

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: FindInternalID( xInternalID )
    Busca el registro en sí
    
    Parámetros:
        xInteralID - Recno a buscar

Devuelve:
    Objeto
*/
METHOD FindInternalID( xInternalID ) CLASS TORMDBFFindInternalID

    Local cAlias   := TORMDBFOpenTable():New( ::oTORMModel ):Open()
    Local lRecnoOk := .F.
    Local oError   := Nil

    If ::oTORMModel:Success()

        try 
            
            
            ( cAlias )->(DbGoTo( xInternalID ) )
            lRecnoOk :=  ( cAlias )->( Recno() ) == xInternalID

            If lRecnoOk

                ::oTORMModel:SetInternalDbId( xInternalID )

            Endif

        catch oError

            ::oTORMModel:__oReturn:Success := .F.
            ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[48][1], TORM_ERROR_MESSAGE[48][2], { xInternalID:Str(), ::oTORMModel:TableName(), TTryCatchShowerror():New( oError ):ToString() } ) )
            
        end

        If lRecnoOk

            ::oTORMModel:__oReturn := TORMDBFLoadFromAlias():New( ::oTORMModel ):Model( cAlias )

        else

            ::oTORMModel:__oReturn:Success := .F.
            ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[49][1], TORM_ERROR_MESSAGE[49][2], { xInternalID:Str(), ::oTORMModel:TableName() } ) )

        Endif

        TORMDBFCloseTable():New( ::oTORMModel ):Close( cAlias )

    Endif

Return ( ::oTORMModel )

// Group: PROTECTED METHODS