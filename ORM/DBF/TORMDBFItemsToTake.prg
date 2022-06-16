/* CLASS: TORMDBFItemsToTake 
    Gestiona el método Take del query
*/
#include 'hbclass.ch'

CREATE CLASS TORMDBFItemsToTake FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Get( nLenOfActualItems )

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
METHOD New( oTORMModel ) CLASS TORMDBFItemsToTake

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Get( nLenOfActualItems )
    Comprueba si se ha llegado al límite de los Items que se han de devolver en la consulta
    
    Parámetros:
        nLenOfActualItems - Nº de items que se han cargado hasta el momento en la consulta

Devuelve:
    Lógico
*/
METHOD Get( nLenOfActualItems ) CLASS TORMDBFItemsToTake

    Local lInRange := .F.

    If ::oTORMModel:__oQuery:nTake == 0

        lInRange := .T.

    Else

        lInRange := nLenofActualItems < ::oTORMModel:__oQuery:nTake

    Endif

Return ( lInRange )

// Group: PROTECTED METHODS