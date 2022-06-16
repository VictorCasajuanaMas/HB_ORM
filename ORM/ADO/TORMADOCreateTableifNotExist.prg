/* CLASS: TORMADOCreateTableifNotExist 
    Crea la tabla si no existe
*/
#include 'hbclass.ch'

CREATE CLASS TORMADOCreateTableifNotExist

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Create()

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMADOCreateTableifNotExist

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Create(  )
    Chequea si existe la tabla y de lo contrario la crea
*/
METHOD Create(  ) CLASS TORMADOCreateTableifNotExist

    If TORMDBFTableExist():New( ::oTORMModel ):Exists( 'dbf' ):Fail()
        
        TORMDBFCreateTable():New( ::oTORMModel ):Create()
        
    Endif

Return ( Nil )

// Group: PROTECTED METHODS