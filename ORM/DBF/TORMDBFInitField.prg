/* CLASS: TORMDBFInitField
        Se encarga de los valores de inicialización en los campos de un DBF
*/

#include 'hbclass.ch'

CREATE CLASS TORMDBFInitField FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMField ) CONSTRUCTOR
        METHOD GetInit()

    PROTECTED:
        DATA oTORMField AS OBJECT INIT Nil

ENDCLASS

METHOD New( oTORMField ) CLASS TORMDBFInitField

    ::Super:New()
    ::oTORMField := oTORMField

Return ( Self )


/* METHOD: GetInit( )
    Devuelve el valor de inicailización de un tipo de dato en DBF

Devuelve:
    Undefined
*/
METHOD GetInit(  ) CLASS TORMDBFInitField

    Local xInitValue := Nil

    switch ::oTORMField:cType

        case 'C'
            xInitValue := Replicate( Space( 1 ), ::oTORMField:nLenght )
        exit

        case 'N'
            xInitValue := 0
        exit

        case 'L'
            xInitValue := .F.
        exit

        case 'D'
            xInitValue := 0d00000000
        exit

        case 'M'
            xInitValue := Replicate( Space( 1 ), ::oTORMField:nLenght )
        exit
            
        case 'T'
            xInitValue :=  hb_dtot( 0d00000000 )
        exit

        otherwise
            xInitValue := Nil
        exit

    endswitch

Return ( xInitValue )