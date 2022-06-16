/* CLASS: MWhereIn
    Modelo que contiene los datos del Querey Where In
*/
#include 'hbclass.ch'

CREATE CLASS MWhereIn

    EXPORTED:
        DATA cField         AS CHARACTER Init ''
        DATA aIn            AS ARRAY     Init Array( 0 )
        DATA lHasCondition  AS LOGICAL   Init .F.

ENDCLASS