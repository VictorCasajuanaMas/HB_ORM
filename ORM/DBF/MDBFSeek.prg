/* CLASS: MDBFSeek 
    Modelo de datos uitlizado para las búsquedas en los DBF
*/
#include 'hbclass.ch'

CREATE CLASS MDBFSeek

    EXPORTED:
        DATA cAlias         AS CHARACTER INIT ''
        DATA cOrder         AS CHARACTER INIT ''
        DATA xFindValue
        DATA oModelAuxiliar AS OBJECT    INIT Nil

        METHOD New( cAlias, xFindValue, cOrder, oModelAuxiliar ) CONSTRUCTOR


    PROTECTED:

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( cAlias, cOrder, xFindValue, oModeloAuxiliar )
    Constructor. Se le inyectan los datos necesarios 

Parametros:
     cAlias - Alias del fichero a buscar
     cOrder - Campo orden a localizar
     xFindValue - Valor a localizar
     oModelAuxiliar - Se utiliza para tener datos de otros modelos a la hora de realizar la búsqueda

Devuelve:
    Self
*/
METHOD New( cAlias, xFindValue, cOrder, oModelAuxiliar ) CLASS MDBFSeek

    ::cAlias     := cAlias
    ::xFindValue := xFindValue

    If .Not. cOrder:Empty()

        ::cOrder     := cOrder

    Endif

    ::oModelAuxiliar := oModelAuxiliar

Return ( Self )

// Group: PROTECTED METHODS