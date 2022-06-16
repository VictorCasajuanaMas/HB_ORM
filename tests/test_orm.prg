/* CLASS: Test_ORM       
    
*/
#include 'hbclass.ch'

CREATE CLASS Test_ORM FROM TestCase

    EXPORTED:
        DATA aCategories AS ARRAY INIT {'TODOS'}

        METHOD Test_Indexes_Numeral()

ENDCLASS

METHOD Test_Indexes_Numeral() CLASS Test_ORM
    // Testea el nº de orden devuelto del índice correspondiente al modelo.

    Local oTestFicha := TestFicha():New()

    ::Assert:equals( 1, oTestFicha:__oIndexes:IndexNumeral( 'codigo' ) )
    ::Assert:equals( 2, oTestFicha:__oIndexes:IndexNumeral( 'nombre' ) )

Return ( Nil )
