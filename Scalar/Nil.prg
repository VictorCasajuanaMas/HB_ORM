/* CLASS: Scalar Nil
          clase que define los métodos para el tipo de dato Nil
*/
#INCLUDE 'hbclass.ch'

CREATE CLASS NIL INHERIT HBScalar FUNCTION HBNil

   METHOD Value( uValue )
   METHOD NotEmpty()
   METHOD Empty()
   METHOD Str()

ENDCLASS

/* METHOD: Value() Devuelve el valor de uValue, este método se utiliza en combinación con los Value del resto de datos Scalar

   Parámetros: 
      uValue - Valor a Devolver

   Devuelve:
      el tipo de valor de uValue
*/
METHOD Value ( uValue ) CLASS Nil
Return ( uValue )

/* METHOD: NotEmpty() Devuelve siempre false, ya que un dato Nil no contiene nada

   Devuelve:
      Lógico
*/
METHOD NotEmpty() CLASS Nil
Return ( .F. )


/* METHOD: Empty() Devuelve siempre true, ya que un dato nil siempre estará vacío.

   Devuelve:
      Lógico
*/
METHOD Empty() CLASS Nil
Return ( .T. )



/* METHOD: Str()
   Devuelve siempre Nil

   Devuelve: 
      String
*/
METHOD Str() CLASS NIL
Return ( 'Nil' )