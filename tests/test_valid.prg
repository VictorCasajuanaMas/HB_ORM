#include 'hbclass.ch'
#include 'validation.ch'

CREATE CLASS Test_Valid FROM TestCase

    EXPORTED:
    
    DATA aCategories AS ARRAY INIT {'TODOS'}
        
        METHOD Test_Valid_Success()
        METHOD Test_Valid_Fail()
        METHOD Test_Valid_Range_Success()
        METHOD Test_Valid_Range_Fail()
        METHOD Test_Valid_Selective_True_Success()
        METHOD Test_Valid_Selective_True_Fail()
        METHOD Test_Valid_Automatic_Success()
        METHOD Test_Valid_Automatic_Fail()

END CLASS

METHOD Test_Valid_Success() CLASS  Test_Valid
    // Comprueba una validación correcta

    Local oTestFicha := TestFicha():New()

    oTestFicha:CODIGO := '123'
    oTestFicha:NOMBRE := 'Jose'
    oTestFicha:PESO   := 30
    ::Assert:True( oTestFicha:Valid():Success() )

Return ( Nil )

METHOD Test_Valid_Fail() CLASS Test_Valid
    // Comprueba una validación incorrecta

    Local oTestFicha := TestFicha():New()

    oTestFicha:NOMBRE := 'Jose'
    oTestFicha:PESO   := 30

    ::Assert:True( oTestFicha:Valid():Fail() )

Return ( Nil )

METHOD Test_Valid_Range_Success() CLASS Test_Valid
    // Comprueba una validación correcta de rango

    Local oTestFicha := TestFicha():New()

    oTestFicha:CODIGO := '123'
    oTestFicha:PESO   := 25
    ::Assert:True( oTestFicha:Valid():Success() )


Return ( Nil )    

METHOD Test_Valid_Range_Fail() CLASS Test_Valid
    // Comprueba una validación incorrecta de rango

    Local oTestFicha := TestFicha():New()

    oTestFicha:CODIGO := '123'
    oTestFicha:PESO   := 150
    ::Assert:True( oTestFicha:Valid():Fail() )

Return ( Nil )

METHOD Test_Valid_Selective_True_Success() CLASS Test_Valid
    // comprueba una validación correcta solamente de algunos campos

    Local oTestFicha := TestFicha():New()

    oTestFicha:CODIGO := '123'
    oTestFicha:NOMBRE := 'Jose'
    oTestFicha:PESO   := 150

    ::Assert:True( oTestFicha:Valid( 'nombre', 'codigo' ):Success() )

Return ( Nil )

METHOD Test_Valid_Selective_True_Fail() CLASS Test_Valid
    // comprueba una validación incorrecta solamente de algunos campos

    Local oTestFicha := TestFicha():New()

    oTestFicha:CODIGO := '123'
    oTestFicha:NOMBRE := 'Jose'
    oTestFicha:PESO   := 150

    ::Assert:True( oTestFicha:Valid( 'nombre', 'codigo', 'peso' ):Fail() )

Return ( Nil )

METHOD Test_Valid_Automatic_Success() CLASS Test_Valid
    // comprueba una validación correcta directa

    Local oTestFicha := TestFicha():New()

    oTestFicha:CODIGO := '123'
    oTestFicha:PESO   := 80

    ::Assert:True( oTestFicha:Valid():Success() )

Return ( Nil )

METHOD Test_Valid_Automatic_Fail() CLASS Test_Valid
    // comprueba una validación incorrecta directa

    Local oTestFicha := TestFicha():New()

    oTestFicha:CODIGO := '12345678901'

    ::Assert:True( oTestFicha:Valid():Fail() )

Return ( Nil )