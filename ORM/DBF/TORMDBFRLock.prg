/*  CLASS: TORMDBFRLock
        BLoquea el registro actual de cAlias
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFRLock FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Lock( cAlias )

    PROTECTED:
        DATA oTORMModel AS OBJECT    INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor, se le pasa el alias

    Parámetros:
        - oTORMModel : Modelo a bloquear

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFRLock

    ::Super:New()
    ::oTORMModel := oTORMModel

Return  ( Self )

/* METHOD: Lock( cAlias )
    Bloquea el registro actual de cAlias devolviendo .T. si lo ha bloqueado

- cAlias : Alias a aplicar el bloqueo    

    Devuelve:
        TReturn
*/
METHOD Lock( cAlias ) CLASS TORMDBFRLock

    Local oReturn := TReturn():New()
    Local oError  := Nil

    try 

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[28][1], TORM_INFO_MESSAGE[28][2], { (cAlias)->(Recno()):Str(), cAlias, ::oTORMModel:TableName() } ) )
        oReturn:Success := ( cAlias )->( RLock() )
        
    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[41][1], TORM_ERROR_MESSAGE[41][2], { ::oTORMModel:TableName(), cAlias,  TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

    
Return ( oReturn )