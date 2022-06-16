/*  CLASS: TORMDBFCLoseTable
        Se encarga de cerrar el fichero .DBF
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFCloseTable FROM TORMDBF

    EXPORTED:
        METHOD New( oTormModel ) CONSTRUCTOR
        METHOD Close( cAlias )

    PROTECTED:
        DATA oTORMModel AS OBJECT Init Nil

ENDCLASS


// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Crea el objeto

Devuelve: 
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFCloseTable

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Close( cAlias )
    Cierra el fichero .DBF correspondiente al alias cAlias

    Parámetros:
        cAlias - Alias del fichero a cerrar

    Devuelve:
        TReturn
*/
METHOD Close( cAlias ) CLASS TORMDBFCloseTable


    Local oReturn := TReturn():New()
    Local oError := Nil
    
    try 

        ::oTORMModel:LogWrite( hb_StrReplace( TORM_INFO_MESSAGE[04][1], TORM_INFO_MESSAGE[04][2], {cAlias} ) )
        ( cAlias )->( DbCloseArea() )
        oReturn:Success := .T.
        
    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[09][1], TORM_ERROR_MESSAGE[09][2], {TTryCatchShowerror():New( oError ):ToString()} ) )
        
    end

Return ( oReturn )