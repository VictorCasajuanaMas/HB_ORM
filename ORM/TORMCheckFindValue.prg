/* CLASS: TORMCheckFindValue 
    Clase que chequea el valor de búsqueda utilizado en los métodos del ORM para convertirlo a objeto en el caso de que sea un índice múltiple
*/
#include 'hbclass.ch'

CREATE CLASS TORMCheckFindValue

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD ConvertValue( xFindValue )

    PROTECTED:
        DATA oTORMModel AS OBJECT

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor.  
   Parametros:
     oTORMModel - Se le inyexta el modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMCheckFindValue

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: ConvertValue( xFindValue )

    Convierte el valor si es necesario
    
   Parametros:
     xFindValue - Valor a convertir

Devuelve:
    Cualquier valor
*/

METHOD ConvertValue( xFindValue ) CLASS TORMCheckFindValue

    Local xFindValueIterator := Array( 0 )
    Local oTORMField         := Nil
    Local hNewFindValue      := hb_Hash()
    Local xNewFindValue      := Nil

    If .Not. HB_ISHASH( xFindValue )

        Return ( xFindValue )

    Endif

    for each xFindValueIterator in xFindValue
            
        if HB_ISARRAY( xFindValueIterator )

                hNewFindValue[ xFindValueIterator:__enumkey ] := xFindValueIterator

        Else

            oTORMField := ::oTORMModel:GetField( xFindValueIterator:__enumkey)
            hNewFindValue[ xFindValueIterator:__enumkey ] := { xFindValueIterator, oTORMField:nLenght } 

        Endif

    next

    xNewFindValue := TIndexMultiple():New( hNewFindValue )

Return ( xNewFindValue )

// Group: PROTECTED METHODS