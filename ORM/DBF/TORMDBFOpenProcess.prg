/* CLASS: TORMDBFOpenProcess 
    Realiza todo el proceso de apertura y comprobación de un fichero DBF.
*/
#include 'hbclass.ch'

CREATE CLASS TORMDBFOpenProcess

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD OpenProcess()

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor.  
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFOpenProcess

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: OpenProcess(  )
    Realiza las comprobaciones y el proceso de apertura en sí devolviendo el alias
    
Devuelve:
    String
*/
METHOD OpenProcess(  ) CLASS TORMDBFOpenProcess

    Local cAlias := Nil

    If TORMDBFTableExist():New( ::oTORMModel ):Exists( 'dbf' ):Fail()
        
        TORMDBFCreateTable():New( ::oTORMModel ):Create()
        
    Endif
    
    cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()
    
Return ( cAlias )

// Group: PROTECTED METHODS 