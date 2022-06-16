/* CLASS: TORMDBFRecno 
    Gestiona la posición y reposición del recno en el alias
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFRecno FROM TORMDBF, TReturnState

    EXPORTED:
        METHOD New( cAlias, oTORMModel ) CONSTRUCTOR
        METHOD Set( nRecno )
        METHOD Get()
        METHOD go() 
        DATA __oReturn   AS OBJECT    INIT TReturn():New()

    PROTECTED:
        DATA oTORMModel AS OBJECT    INIT Nil
        DATA cAlias     AS CHARACTER INIT ''
        DATA nRecno     AS NUMERIC   INIT 0

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( cAlias, oTORMModel )
    Constructor. Se le inyecta el alias 
    
   Parametros:
     cAlias - Alias a procesar
     oTORMModel - Modelo a procesar

Devuelve:
    Self
*/
METHOD New( cAlias, oTORMModel ) CLASS TORMDBFRecno

    ::Super:New()
    ::cAlias     := cAlias
    ::oTORMModel := oTORMModel
    ::Set( )

Return ( Self )

/* METHOD: Set( nRecno )
    Asigna el recno
    
    Parámetros:
        nRecno - Recno a asignar

    Devuelve:
        oReturn
*/
METHOD Set( nRecno ) CLASS TORMDBFRecno

    Local oError := Nil

    If nRecno:NotEmpty()

        ::nRecno := nRecno
        ::__oReturn:Success := .T.

    Else

        try 

            ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[26][1], TORM_INFO_MESSAGE[26][2], { ::oTORMModel:TableName(), ::cAlias} ) )
            ::nRecno := ( ::cAlias )->( Recno() )
            ::__oReturn:Success := .T.
            
        catch oError

            ::__oReturn:Success := .F.
            ::oTORMModel:LogWrite( ::__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[18][1], TORM_ERROR_MESSAGE[18][2], { ::cAlias, ::oTORMModel:TableName(), TTryCatchShowerror():New( oError ):ToString() } ) )
            
        end

    Endif

Return ( ::__oReturn )

/* METHOD: Get(  )
    Devuelve el recno

Devuelve:
    TReturn
*/
METHOD Get(  ) CLASS TORMDBFRecno

Return ( ::nRecno )

/* METHOD: Go(  )
    Situa el alias en la posición del recno
    
Devuelve:
    oReturn
*/
METHOD Go(  ) CLASS TORMDBFRecno

    try 
        
        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[27][1], TORM_INFO_MESSAGE[27][2], {::nRecno:Str, ::cAlias, ::oTORMModel:TableName()} ) )
        ( ::cAlias )->( DbGoTo( ::nRecno ) )
        ::__oReturn:Success := .T.

    catch oError

        ::__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[38][1], TORM_ERROR_MESSAGE[38][2], { ::nRecno:Str, ::cAlias, ::oTORMModel:TableName(), TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( ::__oReturn )


// Group: PROTECTED METHODS