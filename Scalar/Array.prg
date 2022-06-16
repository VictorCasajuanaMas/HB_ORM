/* CLASS: Scalar Array
          clase que define los métodos para los Array
*/
#include 'hbclass.ch'

CREATE CLASS Array INHERIT HBScalar FUNCTION HBArray

    EXPORTED:
        METHOD Scan( xSearch )
        METHOD Len()
        METHOD Exist( xSearch )
        METHOD NotExist( xSearch )
        METHOD Get( nPosition, xDefault )
        METHOD GetLast( xDefault )
        METHOD GetEqualorLess( xSearch )
        METHOD Value()
        METHOD AddIfNotExist( xAdd )
        METHOD ArrayInsert( aArray )
        METHOD Empty()
        METHOD NotEmpty()
        METHOD Equal ( aCompare, lSameSize )
        METHOD ArrayHashToArray()
        METHOD ToArrayHash()
        METHOD Str( cSeparator )
        METHOD Sort ( bCondition )
        METHOD ArrayAdd( aArray )
        METHOD Transpose()
        METHOD Str()
        METHOD Map( bBLock )

    PROTECTED:
        METHOD PositionCorrect( nPosition )

ENDCLASS


// Group: EXPORTED METHODS

/* METHOD: GetEqualorLess( xSearch )
    Devuelve el item igual o menor a xSearch.

Devuelve:
    Cualquier tipo
*/
METHOD GetEqualorLess( xSearch ) CLASS Array

    Local aArray    := ASort( Self, , , { | x, y | x > y } )
    Local xReturn   := Nil
    Local nPosition := 1

    If xSearch != Nil

        While xReturn == Nil .And.;
            nPosition <= aArray:Len()

            if aArray:Get( nPosition ) <= xSearch

                xReturn := aArray:Get( nPosition )

            Endif

            nPosition++

        Enddo

    Endif

Return ( xReturn )

/* METHOD: Str( cSeparator )
    Devuelve el array en formato string separado por cSeparator

Devuelve:

    String
*/

METHOD Str( cSeparator ) CLASS Array

    Local cString := ''
    Local xValue

    hb_default( @cSeparator, ',' )

    for each xvalue in Self

        if .Not. HB_ISOBJECT( xValue )

            cString += xValue:Str() + Iif( xValue:__enumindex < Self:Len(), cSeparator, '' )
            
            If HB_ISARRAY( xValue ) .Or.;
               HB_ISHASH( xValue )

               cString += hb_eol()

            Endif

        Endif
        
    next

Return ( cString )

/* METHOD: ToArrayHash()
    Convierte el contenido del array en un array de hash, de momento solo funciona si el array origen es de objetos
    
Devuelve:
    Array de Hashe's
*/
METHOD ToArrayHash(  ) CLASS Array

    Local aArray := Array( 0 )
    Local xItem := Nil
    Local aData := Array( 0 )
        
    for each xItem in Self

        if HB_ISOBJECT( xItem )

            for each aData in __objGetValueList( xItem )

                aAdD( aArray, { aData[ 1 ] => aData[ 2 ] } )
                
            next

        Endif

    next

    

Return ( aArray )



/* METHOD: ArrayHashToArray()

    Si el dato es un array de Hash, devuelve un array con la primera fila con las cabeceras de las keys encontradas en todos los hash y las siguientes filas con los valores en las columnas correspondientes

Devuelve:

    Array
*/
METHOD ArrayHashToArray() CLASS Array

    Local aReturn  := Array( 0 )
    Local hItems   := { => }
    Local hItem    := { => }
    Local aHeaders := Array( 0 )
    Local aRow     := Array( 0 )
    Local nPositon := 0

    for each hItems in Self

        for each hItem in hItems

            aHeaders:AddIfNotExist( hItem:__enumkey )
            
        next

    next

    aAdD( aReturn, aHeaders )

    for each hItems in Self

        aRow := Array( aHeaders:Len() )

        for each hItem in hItems

            aRow[ aHeaders:Scan( hItem:__enumkey ) ] := hItem:__enumvalue

        next

        aAdD( aReturn, aRow )

    next

Return ( aReturn )

/* METHOD: Scan( xSearch )
    Devuelve la posición de xSearch en Self

    devuelve:
        Numérico
*/
METHOD Scan( xSearch ) CLASS Array
Return ( aScan( Self, xSearch ) )

/* METHOD: Len( )
    Devuelve el tamaño del array

    devuelve:
        Numérico
*/
METHOD Len( ) CLASS Array
Return ( Len( Self ) )

/* METHOD: Exist( xSearch )
    Devuelve .T. si xSearch existe dentro del array
    
    devuelve:
        Lógico
*/
METHOD Exist( xSearch ) CLASS Array
Return ( Self:Scan( xSearch ) != 0 )



/* METHOD: NotExist( xSearch )
    Devuelve .T. si xSearch NO existe dentro del array
    
    devuelve:
        Lógico
*/
METHOD NotExist( xSearch ) CLASS Array
Return ( Self:Scan( xSearch ) == 0 )


/* METHOD: Get( nPosition, xDefault )
    Devuelve el valor de la posición nPosition. Si el tamaño del array es menor a nPosition, devuevle xDefault o en su defecto, Nil

    Parametros:
        nPosition - Posición del elemento a devolver
        xDefault - Valor por defecto a devolver en el caso de que el tamaño del array sea menor a nPosition

    Devuelve:
        Cualquier Tipo        
*/
METHOD Get( nPosition, xDefault ) CLASS Array

    Local xDev := Nil
    
    If ::PositionCorrect( nPosition )

        xDev := Self[ nPosition ]

    Elseif xDefault != Nil

        xDev := xDefault

    Endif

Return ( xDev )


/* METHOD: GetLast( xDefault )

    Devuelve el útlimo item del array

    Parámetros 
        xDefault - En el caso de que el array esté vacío, devolverá este dato

    Devuelve:
        cualquier tipo
*/
METHOD GetLast( xDefault )

    Local xReturn
    hb_default( @xDefault, Nil )

    If Self:Empty()

        xReturn := xDefault

    else

        xReturn := Self:Get( Self:Len() )

    Endif

Return xReturn



/* METHOD: Value()
    Devuelve el valor del dato, es útil para combinarlo con los valores NIL

    Devuelve:
        Array
*/
METHOD Value() CLASS Array
Return ( Self )



/* METHOD: AddIfNotExist( xValue )
    Añade xValue al array si no existe

    Parámetros:
        xValue - Elemento a añadir
*/
METHOD AddIfNotExist( xValue ) CLASS Array

    Local lAdded := .F.

    If Self:NotExist( xValue )

        aAdD( Self, xValue )
        lAdded := .T.

    Endif
    
Return ( lAdded )


/* METHOD: Empty()
    Indica si el array está vacío

    Devuelve:
        Lógico
*/
METHOD Empty() CLASS Array
Return ( Self:Len() == 0)


/* METHOD: NotEmpty()
    Indica si el array contiene algún item

    Devuelve:
        Lógico
*/
METHOD NotEmpty() CLASS Array
Return ( Self:Len() != 0 )


/* METHOD: Equal ( aCompare )
    Indica si el array es igual al que se le pasa
    Parámetros : 
        - aCompare . Array a comparar

    Devuelve:
        Lógico
*/
METHOD Equal ( aCompare ) CLASS Array

    Local lEqual := .t., nElement

    if valtype ( aCompare ) == 'A'

        If Self:Len() == aCompare:Len() 

            for nElement = 1 to aCompare:Len()
 
                if valtype ( Self [ nElement ] ) == 'A'

                    if ! Self [ nElement ]:Equal ( aCompare [ nElement ] )

                        lEqual := .f.
                        exit

                    endif
                    
                else
                
                    if Self [ nElement ] <> aCompare [ nElement ] 

                        lEqual := .f.
                        exit

                    endif

                endif

            next

        else

            lEqual := .f.
            
        endif

    else

        lEqual := .f.

    endif

return ( lEqual )


METHOD ArrayInsert( aArray ) CLASS Array
// TODO: comentar
    aEval( aArray, { | Item, n | self := hb_AIns( Self, n, item, .T.  ) } )
    
Return ( Nil )

/* METHOD: ArraytAdd( aArray )
Añade un array al final del array

Parámetros:
aArray . Array a añadir al final

*/
METHOD ArrayAdd( aArray ) CLASS Array

    aEval( aArray, { | aItem | aAdD( Self, aItem) } )

Return ( Nil )


METHOD Sort ( bCondition ) CLASS Array
// TODO: comentar 

    if HB_ISBLOCK ( bCondition )

        aSort ( Self, , , bCondition )

    endif

return ( Self )    

/* METHOD: Transpose( lSquare )
    Cambia las columnas X-Y del array y devuelve el resultado, no modifica el array. Función copiada de las funciones de FiveWin 19.06
    
    Parámetros:
        lSquare. "creo" que fuerza las columnas al ancho del primer registro del array

    Devuelve:
        Array
*/
METHOD Transpose( lSquare )

    local nRows, nCols, nRow, nCol, nWidth
    local aNew
 
    hb_Default( @lSquare, .f. )
 
    nRows          := Len( Self )
    if lSquare
       nCols       := Len( Self[ 1 ] )
    else
       nCols       := 1
       for nRow := 1 to nRows
          if ValType( Self[ nRow ] ) == 'A'
             nCols    := Max( nCols, Len( Self[ nRow ] ) )
          endif
       next
    endif
 
    aNew           := Array( nCols, nRows )
    for nRow := 1 to nRows
       if ValType( Self[ nRow ] ) == 'A'
          nWidth  := Len( Self[ nRow ] )
          for nCol := 1 to nWidth
             aNew[ nCol, nRow ]   := Self[ nRow, nCol ]
          next
       else
          aNew[ 1, nRow ]      := Self[ nRow ]
       endif
    next

 return ( aNew )

 /* METHOD: Map( bBlock )
     Recorre el array ejecutando bBlock y devolviendo un array con el resultado de bblock en cada item del array
     
     Parámetros:
         bBlock - Bloque de código a ejecutar
 
 Devuelve:
     Array
 */
 METHOD Map( bBlock ) CLASS Array

    Local aNewArray := Array ( 0 )
    Local xItem     := Nil

    for each xItem in Self

        aAdD( aNewArray, Eval ( bBlock, xItem ) )
        
    next
 
 Return ( aNewArray )

 
// Group: PROTECTED METHODS
/* METHOD: PositionCorrect( nPosition )
        Indica si la posición nPosition es correcta dentro del array

    Parámetros:
        nPosition - Posición del elemento
        
    Devuelve:
        Lógico
*/        
METHOD PositionCorrect ( nPosition ) CLASS Array

    Local lCorrect

    lCorrect := nPosition != Nil .And.;
                nPosition <= Self:Len() .And.;
                nPosition >= 1

Return ( lCorrect )