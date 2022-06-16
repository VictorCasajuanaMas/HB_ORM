/* CLASS: TORMDBFAppend
    Crea registros en blanco en el fichero .DBF
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFDbAppend FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Append( cAlias )

    PROTECTED:
        DATA cAlias AS CHARACTER Init ''
        DATA oTORMModel AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor, se le pasa el Alias sobre el fichero .DBF que ha de trabajar

Parámetros:
    oTORMModel: Objeto de tipo TORMModel    

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFDbAppend

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: Append( cAlias )
    Agrega un registro en blanco en el fichero DBF

Parámetros:
        - cAlias : Alias del fichero a procesasr    
    
Devuelve:
    TReturn
    
*/
METHOD Append( cAlias ) CLASS TORMDBFDbAppend

    Local oReturn := TReturn():New()
    Local oError  := Nil

    ::cAlias := cAlias

    try 

        ::oTORMModel:LogWrite( hb_StrReplace( TORM_INFO_MESSAGE[06][1], TORM_INFO_MESSAGE[06][2] , { cAlias, ::oTORMModel:TableName() } ) )
        ( ::cAlias )->( DbAppend() )
        oReturn:Success := .T.
        
    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_strReplace( TORM_ERROR_MESSAGE[12][1],TORM_ERROR_MESSAGE[12][2], {TTryCatchShowerror():New( oError ):ToString()} ))
        
    end

Return ( oReturn )