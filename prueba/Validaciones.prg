Function Validaciones()

    Local oFicha := Ficha():New()

    ?
    ?' Validaciones -------------------------------------------'

    ?oFicha:Valid():Fail()
    ?oFicha:LogToString()

    oFicha:CODIGO := 10
    ?oFicha:Valid():Fail()
    ?oFicha:LogToString()

    oFicha:CODIGO := 0
    oFicha:PESO   := 25
    ?oFicha:Valid():Fail()
    ?oFicha:LogToString()

    oFicha:CODIGO := 10
    oFicha:PESO   := 25
    ?oFicha:Valid():Fail()
    ?oFicha:LogToString()

    oFicha:EMAIL := 'no es email'
    ?oFicha:Valid():Fail()
    ?oFicha:LogToString()

    ?oFicha:Valid('CODIGO','PESO'):Fail()

    oFicha:EMAIL := 'lolo@lolol.com'
    ?oFicha:Valid():Fail()
    ?oFicha:LogToString() 



Return ( Nil )