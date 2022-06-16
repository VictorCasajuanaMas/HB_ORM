/* CLASS: MSelect 
    Estructura para almacenar el select del query
*/
#include 'hbclass.ch'

CREATE CLASS MSelect

    EXPORTED:
        METHOD New( cField, cAlias ) CONSTRUCTOR
            
        DATA cField AS CHARACTER INIT ''
        DATA cAlias AS CHARACTER INIT ''

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( cField, cAlias )
    Constructor. Se le inyectan los valores 
    
   Parametros:
     cField - Nombre del campo
     cAlias - Alias del campo

Devuelve:
    Self
*/
METHOD New( cField, cAlias ) CLASS MSelect

    ::cField := cField
    ::cAlias := cAlias:Value( cField )

Return ( Self )

// Group: PROTECTED METHODS