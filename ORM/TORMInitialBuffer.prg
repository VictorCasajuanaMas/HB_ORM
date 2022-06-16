/* CLASS: TORMInitialBuffer
        Se encarga de almacenar los datos iniciales del Modelo y las operaciones que se pueden realizar con ellos

*/

#include 'hbclass.ch'

CREATE CLASS TORMInitialBuffer

    EXPORTED:
        METHOD New() CONSTRUCTOR

        METHOD SetInitialValue( cField, xValue )
        METHOD Get( cField )
        METHOD Update( oTORMModel )
        METHOD NoInitialBuffer(  )
        METHOD WithInitialBuffer()

    PROTECTED:
        DATA hBuffer            AS HASH    Init hb_Hash()
        DATA lWithInitialBuffer AS LOGICAL Init .T.

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New()
    Constructor

Devuelve:
    Self
*/
METHOD New() CLASS TORMInitialBuffer

    ::lWithInitialBuffer := .T.

Return ( Self )

/* METHOD: SetInitialValue( cField, xValue )
    Añade un valor inicial al buffer

        Parametros:
            cField - Campo a asignar el valor
            xValue - Valor a asignar
*/
METHOD SetInitialValue( cField, xValue ) CLASS TORMInitialBuffer

    ::hBuffer[ cField ] := xValue

Return ( Nil )

/* METHOD: Get( cField )
    Devuelve el valor del campo cField del buffer inicial
    
    Parámetros:
        cField - Campo a devolver

Devuelve:
    Cualquier Tipo
*/
METHOD Get( cField ) CLASS TORMInitialBuffer

Return ( ::hBuffer:ValueOfKey( cField ) )

/* METHOD: Update( oTORMModel )
    Actualiza los datos del buffer inicial según el modelo pasado
    
    Parámetros:
        oTORMModel - Modelo base para actualizar los datos

Devuelve:
    
*/
METHOD Update( oTORMModel ) CLASS TORMInitialBuffer

    Local oTORMField :=  Nil

    for each oTORMField in oTORMModel:__aFields

        ::SetInitialValue( oTORMField:cName, oTORMModel:&( oTORMField:cName ) )
        
    next

Return ( Nil )

/* METHOD: NoInitialBuffer(  )
    Indica que el modelo no tendrá buffer inicial
*/
METHOD NoInitialBuffer(  ) CLASS TORMInitialBuffer

    ::lWithInitialBuffer := .F.

Return ( Nil )

/* METHOD: WithInitialBuffer(  )
    Indica si el buffer inicial está activado en el modelo

Devuelve:
    Lógico
*/
METHOD WithInitialBuffer(  ) CLASS TORMInitialBuffer

Return ( ::lWithInitialBuffer )