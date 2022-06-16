/* CLASS: Scalar Numeric
    Clase que define los métodos para el tipo de dato numérico            
   
*/
#INCLUDE 'hbclass.ch'

CREATE CLASS Numeric INHERIT HBScalar FUNCTION HBNumeric

    EXPORTED:
        METHOD Int()
        METHOD Round( nDecimals )
        METHOD StrSql()
        METHOD StrInt()
        METHOD StrFloat( nDecimals )
        METHOD Str( nLength, nDecimals )
        METHOD StrRaw( nLength, nDecimals )
        METHOD Value()
        METHOD NotEmpty()
        METHOD Empty()

END CLASS

// Group: EXPORTED METHODS

/* METHOD: Int()
    Devuelve el valor entero de la variable 

Devuelve:
   Numeric
*/

METHOD Int()
Return Int ( Self )


/* METHOD: Round( nDecimals )
    Devuelve resultado del a nDecimals decimales

Parámetros:
    nDecimals - Número de decimales a redondear

Devuelve:
   Numérico redondeado
*/
METHOD Round( nDecimals ) CLASS Numeric

    hb_Default( @nDecimals, 0 )

Return Round( Self, nDecimals )


METHOD StrSql() CLASS Numeric
/* METHOD: StrSql()

    Devuelve el dato con el formato SQL, se utiliza para compatibilizarlo con el resto de métodos StrSql de los scalar

Devuelve: 
        string
*/

    If Self:Int() == Self

        Return ::StrInt()

    else

        Return ::StrFloat( 6 )

    Endif

Return ( Nil )

/* METHOD: StrInt()
    Devuelve el valor entero de la variable formato String

Devuelve:
   String
*/
METHOD StrInt() CLASS Numeric
Return Str( Self, 20, 0 ):Alltrim()

/* METHOD: StrFloat( nDecimals )
    Devuelve el valor con nDecimals de la variable formato String

Parámetros:
    nDecimals - Número de decimales a devolver

Devuelve:
   String del valor con nDecimals de la variable 
*/
METHOD StrFloat( nDecimals ) CLASS Numeric

    hb_Default( @nDecimals, 6 )

Return Str( Self, 20, nDecimals ):Alltrim()

/* METHOD: Str( nLength, nDecimals )
    Devuelve el valor en string del valor numérico sin espacios

Parámetros:
    nLength - Ancho del valor entero a devolver. Si se omite será el ancho del número entero
    nDecimals - Ancho del valor de los decimales. Si se omite se devolverá un entero

    
Devuelve:
    String
*/
METHOD Str( nLength, nDecimals ) CLASS Numeric
Return ( Self:StrRaw( nLength, nDecimals ):Alltrim() )



/* METHOD: StrRaw( nLength, nDecimals )
    Devuelve el valor en string del valor numérico con espacios

Parámetros:
    nLength - Ancho del valor entero a devolver. Si se omite será el ancho del número entero
    nDecimals - Ancho del valor de los decimales. Si se omite se devolverá un entero

    
Devuelve:
    String
*/
METHOD StrRaw( nLength, nDecimals ) CLASS Numeric

    hb_Default( @nLength, Str( Self ):Alltrim():Long() )
    hb_Default( @nDecimals, 0 )

Return Str( Self, nLength, nDecimals )



/* METHOD: Value()
    Devuelve el valor del dato, es útil para combinarlo con los valores NIL

    Devuelve:
        Numérico
*/
METHOD Value() CLASS Numeric
Return ( Self )


/* METHOD: Empty()
    Devuelve .T. si el valor del dato es 0
    
    Devuelve:
        Lógico
*/
METHOD Empty() CLASS Numeric
Return ( Self == 0)


/* METHOD: NotEmpty()
    Devuelve .T. si el valor del dato no es 0

    Devuelve :
        Lógico
*/
METHOD NotEmpty() CLASS Numeric
Return ( Self != 0 )