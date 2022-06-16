/* CLASS: TORMDBFModelToStructure
          Se encarga de devolver la estructura de un dbf en base a un modelo de datos

*/

#include 'hbclass.ch'

CREATE CLASS TORMDBFModelToStructure FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) Constructor
        METHOD Get()

    PROTECTED:
        DATA oTORMModel AS OBJECT Init Nil

ENDCLASS


METHOD New( oTORMModel ) CLASS TORMDBFModelToStructure

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Get( )
    Devuelve la estructura que debe tener un fichero .DBF según los datos del modelo

Devuelve:
    Array
*/
METHOD Get() CLASS TORMDBFModelToStructure

    Local aDbfStructure := Array( 0 )
    Local aField := Nil

    for each aField in ::oTORMModel:__aFields

        aAdD( aDbfStructure, { aField:cName, aField:cType, aField:nLenght, aField:nDecimals})
        
    next

Return ( aDbfStructure )