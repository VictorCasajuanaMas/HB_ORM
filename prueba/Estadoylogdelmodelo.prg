Function Estadoylogdelmodelo()

    Local oCliente := Cliente():New(1)

    oCliente:Peso := 200
    oCliente:Save()
    ?
    ?'Intentando guardar modelo no valido---------------------------------------------------'
    ?'Estado:' + oCliente:Success:Str()
    ?oCliente:LogToString()
    ?'Estado:' + oCliente:Success:Str()

    oCliente:End()

Return Nil