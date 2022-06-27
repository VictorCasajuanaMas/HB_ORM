Function Estadoylogdelmodelo()

    Local oCliente := Cliente():New(1)

    oCliente:Peso := 80
    oCliente:Save()
    ?
    ?'Intentando guardar modelo no valido---------------------------------------------------'
    ?'Estado:' + oCliente:Success:Str()
    ?oCliente:LogToString()

    oCliente:End()

Return Nil