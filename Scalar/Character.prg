/* CLASS: Scalar Character
          Clase que define los métodos para el tipo de dato Character

*/
#INCLUDE 'hbclass.ch'

CREATE CLASS Character INHERIT HBScalar FUNCTION HBCharacter

    EXPORTED:
        METHOD Upper()
        METHOD Lower()
        METHOD Capitulate()
        METHOD Alltrim()
        METHOD Del(cString)
        METHOD ISEmpty()
        METHOD Empty() INLINE ::ISEmpty()
        METHOD IsJsonEmpty()
        METHOD NotEmpty()
        METHOD IsJsonValid()
        METHOD Long()
        METHOD Len() INLINE ::Long()
        METHOD Value()
        METHOD Str()
        METHOD StrSql()
        METHOD Val()
        METHOD Right( nLen )
        METHOD Left( nLen )
        METHOD Substr( nStart, nLen )
        METHOD At( cSearch ) 
        METHOD RAt( cSearch ) 
        METHOD StrTran( cSearch, cReplace)
        METHOD Has( cSearch )
        METHOD NotHas( cSearch )
        METHOD DelLast( cString )
        METHOD GetJson( )
        METHOD LeftDeleteUntil( cCharacter )
        METHOD Zeros( nLength, nDecimals )
        METHOD SpacesRight( nSpaces )
        

END CLASS

// Group: EXPORTED METHODS

/* METHOD: GetJson()
    Devuelve el dato en formato Array si el dato es un Json válido, de lo contrario devuelve Nil

    Devuelve
        Hash, Array o Nil
*/
METHOD GetJson() CLASS Character

    Local xReturn := hb_jsonDecode( Self )

    If !( ValType( xReturn ) $ 'HA' )

        xReturn := Nil

    Endif

Return ( xReturn )

/* METHOD: IsJsonValid()

    Devuelve .T. si el dato contiene un Json válido y .F. si no contiene un Json válido

    Devuelve:
    Lógico
*/
METHOD IsJsonValid() CLASS Character
Return ( Self:GetJson() != Nil .And.;
         Self:GetJson():Len() != 0 )

/* METHOD: Has( cSearch )
    Devuelve .T. si el Dato contiene cSearch

    Devuelve:
        Lógico
*/
METHOD Has( cSearch ) CLASS Character
Return ( Self:At( cSearch ) != 0 )

/* METHOD: NotHas( cSearch )
    Devuelve .T. si el Dato NO contiene cSearch

    Devuelve:
        Lógico
*/
METHOD NotHas( cSearch ) CLASS Character
Return ( !Self:Has( cSearch ) )


/* METHOD: StrTran( cSearch, cReplace )
    Sustituye los cSearch por cReplace del dato

    Devuelve:
     String
*/
METHOD StrTran( cSearch, cReplace ) CLASS Character
Return ( StrTran( Self, cSearch, cReplace ) )

/* METHOD: Upper()
    Devuelve el valor del dato en mayúsculas

Devuelve:
    String
*/
METHOD Upper() CLASS Character
Return Upper( Self )

/* METHOD: Lower()
    Devuelve el valor del dato en minúsculas

Devuelve:
    String    
*/
METHOD Lower() CLASS Character
Return Lower( Self )

/* METHOD: Alltrim()
    Devuelve el valor del dato sin espacios a la derecha e izquierda

Devuelve:
    String    
*/
METHOD Alltrim() CLASS Character
Return Alltrim( Self )

/* METHOD: Capitulate()
    Devuelve el valor del dato con la primera letra en mayúsculas y el resto en minúsculas

Devuelve:
    String    
*/
METHOD Capitulate() CLASS Character

    Local cStringCapitulate := ''

    If !Empty( Self )
        cStringCapitulate := Upper( Substr( Self, 1, 1 ) ) + ;
                             Lower( Substr( Self, 2, Len( Self:Alltrim() ) ) )
    Endif

Return ( cStringCapitulate )

/* METHOD: Del( cString )
    Elimina el cString del dato

Parámetros:
    cString - Cadena a eliminar del dato

Devuelve:
    String
*/
METHOD Del( cString ) CLASS Character

    hb_Default( @cString, '' )

Return ( StrTran( Self, cString, '' ) )

/* METHOD: DelLast( cString )
    Elimina el final del dato si coincide con cString

Parámetros: 
    cString - Cadena a eliminar del dato

Devuelve:
    String
*/
METHOD DelLast( cString ) CLASS Character

    Local cReturn := Self

    If Self:Alltrim():Right( cString:Len() ) == cString

        cReturn := Self:Alltrim():Substr( 1, Self:Len() - cString:Len() )

    Endif

Return ( cReturn )

/* METHOD: IsEmtpy()
    Devuelve .T. o .F. dependiendo si el valor contiene algo o no

Devuelve:
    Logical    
*/
METHOD IsEmpty()  CLASS Character
Return Empty( Self )


/* METHOD: IsJsonEmpty()

    Devuelve .T. si la cadena corresponde a un Json vacío : '{}' o está vacía y .F. si contiene algo aunque no sea un Json

Devuelve: 
    Logical
*/
METHOD IsJsonEmpty() CLASS Character
Return ( ::IsEmpty() .Or.;
         Self == '{}' )

/* METHOD: NotEmtpy()
    Devuelve .T. si el valor no contiene nada y .F. si contiene algo

Devuelve:
    Logical    
*/
METHOD NotEmpty()  CLASS Character
Return !Empty( Self )

/* METHOD: Long()
    Devuelve el ancho de la cadena sin espacios

Devuelve:
    Numeric    
*/
METHOD Long()  CLASS Character
Return Len ( Alltrim ( Self ) ) 



/* METHOD: Value()
    Devuelve el valor del dato, es útil para combinarlo con los valores NIL

    Devuelve:
        String
*/
METHOD Value() CLASS Character
Return ( Self )



/* METHOD: Str()
    Devuelve el mismo string, se introduce para compatibilizar con varios tipos de datos que llaman a Str 
    
    Devuelve:
        String
*/
METHOD Str() CLASS Character
Return ( Self )


/* METHOD: StrSql()
    Devuelve el mismo string, se introduce para compatibilizar con varios tipos de datos que llaman a StrSql 
    
    Devuelve:
        String
*/
METHOD StrSql() CLASS Character
Return ( Self )



/* METHOD: Val()
    Devuelve el valor entero del dato
    
    Devuelve:
        Number
*/
METHOD Val() CLASS Character
Return ( Val( Self ) )


/* METHOD: Right( nLen )
    Devuelve nLen caracteres desde la derecha del dato

    Parámetros:
        nLen - número caracteres a devolver

    Devuelve:
        String
*/
METHOD Right( nLen ) CLASS Character
    If nLen != Nil
        Return ( Right( Self, nLen ) )
    Else
        Return ( '' )
    Endif
Return ( Nil )


/* METHOD: Left( nLen )
    Devuelve nLen caracteres desde la izquierda del dato

    Parámetros:
        nLen - número caracteres a devolver

    Devuelve:
        String
*/
METHOD Left( nLen ) CLASS Character
    If nLen != Nil
        Return ( Left( Self, nLen ) )
    else
        Return ( '' )
    Endif
Return ( Nil )


/* METHOD: Substr( nStart, nLen )
    Devuelve los caracteres del valor desde nstart, si se le pasa nLen hasta el tamaño nLen

    Parámetros:
        nStart - Posición a partir se devolverán los caracteres
        nLen   - Números de caracter a devolver, si se omite devuelve hasta el final del valor

    Devuelve:
        String
*/
// TODO: Testear
METHOD Substr( nStart, nLen ) CLASS Character
Return ( Substr( Self, nStart, nLen ) )


METHOD At( cSearch ) CLASS Character
/* METHOD: At ( cSearch )
    Devuelve la primera posición de cSearch dentro del dato

    Parámetros:
        cSearch - cadena a buscar

    Devuelve:
        Entero        
*/    
// TODO: Testear    
Return ( hb_At( cSearch, Self ) )


METHOD RAt( cSearch ) CLASS Character
    /* METHOD: At ( cSearch )
        Devuelve la última posición de cSearch dentro del dato
    
        Parámetros:
            cSearch - cadena a buscar
            
        Devuelve:
            Entero        
    */    
    // TODO: Testear    
Return ( hb_RAt( cSearch, Self ) ) 

/* METHOD: LeftDeleteUntil( cCharacter )
    Elimina los cString de la izquierda hasta que el primer caracter que no sea cCharacter
    
    Parámetros:
        cCharacter - Caracter a eliminar

Devuelve:
    Self
*/
METHOD LeftDeleteUntil( cString ) CLASS Character

    Local nCount     := 0
    Local nPositionOfFirstDifference := 0

    For nCount := 1 To Self:Len()

        If nPositionOfFirstDifference == 0

            If Self:Substr( nCount, 1 ) != cString

                nPositionOfFirstDifference := nCount

            Endif

        Endif

    Next

    Self := Self:Substr( nPositionOfFirstDifference, Self:Len() )

Return ( Self )

/* METHOD: Zeros( nLen )
    Rellena con ceros por la izquierda la cadena
    
    Parámetros:
        nLen - Tamaño que ha de tener la cadena con los ceros incluidos
Devuelve:
    Character    
*/
METHOD Zeros( nLen ) CLASS  CHARACTER

    Local cCharacter := ''

    If nLen != Nil

        cCharacter := Replicate( '0', nLen - ::Len() ) + Self:Alltrim()

    Else

        cCharacter := Self

    Endif
    
Return ( cCharacter )


/* METHOD: SpacesRight( nLength )
    Devuelve el string con un tamaño de nLength rellenando los espacios que faltan por la derecha
    
    Parámetros:
        nLength - Ancho total del string a devolver 

Devuelve:
    Character
*/
METHOD SpacesRight( nLenght ) CLASS Character

    Local cReturn := ''

    If Self:Len() > nLenght

        cReturn := Self:Alltrim():Substr( 1, nLenght )

    Else

        cReturn := Self:Alltrim() + Replicate( Space( 1 ), nLenght - Self:Len() )

    Endif

Return ( cReturn )