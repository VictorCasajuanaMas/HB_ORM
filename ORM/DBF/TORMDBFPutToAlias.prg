/* CLASS: TORMDBFPutToAlias
    Vuelca los datos del modelo en el registro actual del alias
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFPutToAlias FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Put( cAlias )

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMMOdel )
    Constructor, se le inyecta el modelo

    Parámetros:
        - oTORMModel : objeto TORMModel
        
Devuelve:
    Self        
*/
METHOD New( oTORMModel ) CLASS TORMDBFPutToAlias

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Put( cAlias )
    Vuelca los datos del modelo al registro actual del alias devolviendo .T. si la operación se ha realizado con éxito

    Parámetros:
        cAlias : Alias con el recno posicionado y bloqueado

Devuelve:
    TReturn
*/
METHOD Put( cAlias ) CLASS TORMDBFPutToAlias

    Local oField := Nil
    Local oError := Nil

    try 

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[23][1], TORM_INFO_MESSAGE[23][2], { ::oTORMModel:TableName(), cAlias } ) )
        for each oField in ::oTORMModel:__aFields

            If oField:ReadyToSave()

                &( cAlias + '->' + oField:cName ) := ::oTORMModel:&( oField:cName )

            Endif
            
        next
        ::oTORMModel:__oReturn:Success := .T.

        
    catch oError

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[33][1], TORM_ERROR_MESSAGE[33][2], { ::oTORMModel:TableName(), cAlias, TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( ::oTORMModel )