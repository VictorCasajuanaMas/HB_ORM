/* CLASS: TORMDBFDBUnlock 
    Desbloquea el registro actual del alias del fichero DBF
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFDBUnlock FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD RUnlock( cAlias)
        

    PROTECTED:
        DATA cAlias AS CHARACTER INIT ''
        DATA oTORMModel AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el alias 

Parámetros:
    oTORMModel - Modelo de datos

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFDBUnlock

    ::Super:New()
    ::oTORMModel = oTORMModel

Return ( Self )

/* METHOD: RDbUnlock( cAlias )
    Debloquea el registro actual del alias

Parametros:
     cAlias - Alias posicionado en el registro a desbloquear    

Devuelve:
    TReturn
*/
METHOD RUnlock( cAlias ) CLASS TORMDBFDBUnlock

    Local oReturn := TReturn():New()
    Local oError := Nil 

    ::cAlias := cAlias

    try 

        ::oTORMModel:LogWrite( hb_StrReplace( TORM_INFO_MESSAGE[07][1],TORM_INFO_MESSAGE[07][2], {::oTORMModel:TableName(), cAlias} ))
        ( ::cAlias )->( DbRUnlock() )
        oReturn:Success := .T.
        
    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[13][1], TORM_ERROR_MESSAGE[13][2], { ::oTORMModel:TableName(), cAlias, TTryCatchShowerror():New( oError ):ToString() }) )
        
    end

Return ( oReturn )

// Group: PROTECTED METHODS  