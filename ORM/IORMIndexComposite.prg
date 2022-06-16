/* CLASS: IORMIndexComposite
    Interface para los objetos que definen los índices compuestos formatos por varios datas
    TODO: Revisar y optimizar los métodos, falta el ToString() y Str() que hacen lo mismo que ToSeek(). Quizás en vez de un Interface se pueda convertir en una clase ya que hay métodos que pueden ser comunies para todas las implementaciones.
*/
#include 'hbclass.ch'

CREATE CLASS IORMIndexComposite

    EXPORTED:
        METHOD GetDatas() VIRTUAL
        METHOD GetDatasRaw() VIRTUAL
        METHOD ToSeek( oModel ) VIRTUAL
        METHOD Get( cData ) VIRTUAL
        METHOD Empty() VIRTUAL
        METHOD GetRaw() VIRTUAL

        // a efectos de compatibilidad
        METHOD Str()           INLINE ::ToSeek()
        METHOD ToString( ... ) INLINE ::ToSeek( ... )

ENDCLASS


/* METHOD: GetDatas(  )
    Devuelve un array con los datas que componen el índice compuesto

Devuelve:
    Array    
*/
METHOD GetDatas() CLASS IORMIndexComposite
Return ( {} )

/* METHOD:GetDatasRaw()
    Devuelve un array con los valores que general el índice compuesto

Devuelve:
    Array
*/
METHOD GetDatasRaw() CLASS IORMIndexComposite
Return ( {} )

/* METHOD: ToSeek
    Devuelve el dato compuesto para la búsqueda por el índice

Devuelve:
    Cualquier tipo
*/
METHOD ToSeek( oModel ) CLASS IORMIndexComposite
Return ( Nil )

/* METHOD: Get( cData )
    Devuelve el valor de cData en 
*/
METHOD Get( cData ) CLASS IORMIndexComposite
Return ( Nil )

/* METHOD: Empty()
    Devuelve .T. si todos los valores del indice están a Nil

Devuelve:
    Lógico
*/
METHOD Empty() CLASS IORMIndexComposite
Return ( Nil )

/* METHOD: GetRaw()
    Devuelve la cadena del índice

Devuelve:
Caracter    
*/
METHOD GetRaw() CLASS IORMIndexComposite
Return ( '' )