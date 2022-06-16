/* CLASS: TORMFieldInit
          Clase que se encarga de asignar los valores iniciales a los datos del modelo

*/

#include 'hbclass.ch'


CREATE CLASS TORMFieldInit
    
    EXPORTED:
        DATA oTORMField AS OBJECT Init Nil
        
        METHOD New( oTORMField ) CONSTRUCTOR
        METHOd Init()
        

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMField )
    Crea el objeto y le inyecta el campo

    Parámetros:
        oTORMField - Objeto TORMField a inicializar

Devuelve:
    Self
*/
METHOD New( oTORMField ) CLASS TORMFieldInit

    ::oTORMField := oTORMField

Return ( Self )

/* METHOD: Init( )
    Devuelve el valor inicial del campo

Devuelve:
    Undefined
*/
METHOD Init() CLASS TORMFieldInit

    Local xInit := TORMPersistence():New( ::oTORMField:oTORMModel ):InitField( ::oTORMField )

Return ( xInit )