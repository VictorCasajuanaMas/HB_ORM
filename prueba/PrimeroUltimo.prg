Function PrimeroUltimo()

    Local oCliente := Cliente():New()

    ?
    ?'primer y ultimo registro--------------------------------'

    oCliente:First()
    ?oCliente:ToHash():Str()
    oCliente:Last()
    ?oCliente:ToHash():Str()

    oCliente:First('NOMBRE')
    ?oCliente:ToHash():Str()
    oCliente:Last('NOMBRE')
    ?oCliente:ToHash():Str()

    oCliente:End()

Return ( Nil )