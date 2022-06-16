/* CLASS: Scalar Logical
          clase que define los métodos para el tipo de dato lógico
*/
#INCLUDE 'hbclass.ch'

CREATE CLASS Logical INHERIT HBScalar FUNCTION HBLogical

   METHOD Str()
   METHOD StrSql()
   METHOD Value()
   METHOD NotEmpty()
   METHOD Empty()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: Str( cTrue, cFalse)
    Devuelve el literal cTrue o cFalse dependiente del valor lógico del dato, si no se le pasan utiliza .T. y .F.

    ejemplo de uso
    --- code
    lValor:Str( 'si', 'no' )
    ---          

Parámetros:
    cTrue - String a devolver en el caso de true
    cFalse - String a devolver en el caso de false

Devuelve:
    String
*/
METHOD Str( cTrue, cFalse) CLASS Logical

    hb_Default( @cTrue, '.T.' )
    hb_Default( @cFalse, '.F.' )
    
RETURN iif( Self, cTrue, cFalse )

/* METHOD: StrSql()

    Devuelve 1 si el valor del dato es .T. y string vacío si es .F. Se utiliza para compatibilizar con el resto de métodos StrSql de los scalar

    Devuelve:

    String

*/
METHOD StrSql() CLASS Logical
Return ::Str( '1','')

/* METHOD: Value()
    Devuelve el valor del dato, es útil para combinarlo con los valores NIL

    Devuelve:
        Lógico
*/
METHOD Value() CLASS Logical
Return ( Self )

/* METHOD: NotEmpty()
    Siempre devuelve .T. ya que está para compatibilizar con Nil:NotEmpty()

    Devuelve:
        Lógico
*/
METHOD NotEmpty() CLASS Logical
Return ( .T. )

/* METHOD: Empty()
    Siempre devuelve .F. ya que está para compatibilizar con Nil:Empty()

    Devuelve:
        Lógico
*/
METHOD Empty() CLASS Logical
Return ( .F. )