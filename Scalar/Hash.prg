/* CLASS: Scalar Hash
          clase que define los métodos para los Hash
*/
#include 'hbclass.ch'

CREATE CLASS Hash INHERIT HBScalar FUNCTION HBHash

    EXPORTED:
        METHOD UpperKeys() 
        METHOD ValueOfKey( cKey, xDefault )
        METHOD HasKey( cKey )
        METHOD NotHasKey( cKey )
        METHOD HasKeys( ... )
        METHOD Empty()
        METHOD NotEmpty()
        METHOD Len()
        METHOD Value()
        METHOD Str() 

END CLASS


/* METHOD: Value()
    Devuelve el propio valor, se utiliza para compatiblizarla con la Nil:Value()

    Devuelve:
        Hash
*/
METHOD Value() CLASS Hash
Return ( Self )


/* METHOD: upper()
        Devuelve el hash con las Keys convertidas a mayúsculas

    Devuelve:
        Hash        
*/
METHOD UpperKeys() CLASS Hash

    Local hDev := {=>}

    hb_hEval( Self, {| cKey, uValue | hDev[ cKey:Upper() ] := uValue } ) 

Return ( hDev ) 


/* METHOD: ValueOfKey( cKey, xDefault )
        Devuelve el valor de cKey en el Hash,si no existe devuelve xDefault

        Parámetros:
            cKey     - Key a devolver
            xDefault - Valor por defecto 

    Devuelve:
        Cualquier Valor        
*/
METHOD ValueOfKey( cKey, xDefault ) CLASS Hash

    Local uValue := Nil

    If cKey<>Nil .And.;
       hb_HHasKey ( Self, cKey )

        uVAlue := Self[ cKey ]

    Else

        uValue := xDefault

    Endif

Return ( uValue )



/* METHOD: HasKey( cKey ) 

    Indica si el hash contiene cKey como índice, independientemente de su valor

    Parámetros:
        cKey - Clave a comprobar su existencia

    Devuelve:
        Lógico
*/
METHOD HasKey( cKey ) CLASS Hash
Return ( hb_HHasKey ( Self, cKey ) )




/* METHOD: NotHasKey( cKey ) 

    Indica si el hash NO contiene cKey como índice, independientemente de su valor

    Parámetros:
        cKey - Clave a comprobar su NO existencia

    Devuelve:
        Lógico
*/
METHOD NotHasKey( cKey ) CLASS Hash
Return ( !hb_HHasKey ( Self, cKey ) )



/* METHOD: HasKeys( ... )
    Indica si el hash contiene todas las keys pasadas como índice, independientemente de su valor

    Parámetros:
        ... - Todas las keys a revisar

    Devuelve:
        Lógico        
*/
METHOD HasKeys( ... ) CLASS Hash

    Local lHasKeys := PCount() != 0
    Local nCount   := 0

    for nCount := 1 To Pcount()

        lHasKeys := Iif( Self:HasKey( hb_pvalue( nCount ) ), lHasKeys, .F. )

    next

Return ( lHasKeys )


/* METHOD: Empty

    Indica si el hash está vacío

    Devuelve:
        Lógico
*/
METHOD Empty() CLASS Hash
Return ( hb_hkeys( Self ):Empty() )



/* METHOD: NotEmpty

    Indica si el hasi contiene algo

    Devuelve:
        Lógico
*/
METHOD NotEmpty() CLASS Hash
Return ( hb_hkeys( Self ):NotEmpty() )


/* METHOD: Len()

    Devuelve el número de items del valor

    Devuelve:
        Numérico
*/
//TODO: Testear
METHOD Len() CLASS Hash
Return ( Len( Self ) )

/* METHOD: Str(  )
    Devuelve un string, a efectos de compatibilidad

    Devuelve:
    String
*/
METHOD Str(  ) CLASS Hash

    Local aValue  := Array( 0 )
    Local cString := ''

    for each aValue in Self

        cString += '[' + aValue:__enumkey:Alltrim() + '] ' + aValue:__enumvalue:Str():Alltrim() + ','

    next 

    cString := cString:DelLast( ',' )

Return ( cString )