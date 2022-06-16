/* CLASS: MOrderby
    Modelo que contiene los datos del Querey OrderBy
*/
#include 'hbclass.ch'

CREATE CLASS MOrderBy

    EXPORTED:
        DATA cOrder     AS CHARACTER Init ''
        DATA cDirection AS CHARACTER Init ''

        METHOD New() CONSTRUCTOR

ENDCLASS

/* METHOD: New(  ) 

Devuelve:
Self
*/
METHOD New() CLASS MOrderBy
Return ( Self )