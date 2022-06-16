/* CLASS: mQuery 
    Modelo que se encarga de almacenar un query del Where
*/
#include 'hbclass.ch'

CREATE CLASS mQuery

    EXPORTED:
        DATA cField     AS CHARACTER INIT ''
        DATA cCondition AS CHARACTER INIT ''
        DATA xValue     
        DATA lInitGroup AS LOGICAL   INIT .F.
        DATA lEndGroup  AS LOGICAL   INIT .F.
        DATA cUnion     AS CHARACTER INIT ''

        METHOD New(  ) CONSTRUCTOR

    PROTECTED:

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New(  )
    Constructor.  
Devuelve:
    Self
*/
METHOD New(  ) CLASS mQuery
Return ( Self )

// Group: PROTECTED METHODS