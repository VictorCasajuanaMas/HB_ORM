 Function CreoClientes()

    Local oCliente:= Cliente():New()

    ?
    ?'Creo Clientes -------------------------------------------------'

    oCliente:CODIGO := 1
    oCliente:NOMBRE := "Juan"
    oCliente:APELLIDO := "Garcia"
    oCliente:PESO   := 50
    If oCliente:Save():Success()
        ?'Cliente guardado correctamente ' + oCliente:NOMBRE
    Else
        ?'Error al guardar el cliente ' + oCliente:__oReturn:LogToString()
    EndIf

    oCliente:= Cliente():New(1)
    ?oCliente:NOMBRE

    oCliente:= Cliente():New()
    oCliente:CODIGO := 2
    oCliente:NOMBRE := "Pedro"
    oCliente:PESO   := 60
    If oCliente:Save():Success()
        ?'Cliente guardado correctamente ' + oCliente:NOMBRE 
    Else
        ?'Error al guardar el cliente ' + oCliente:__oReturn:LogToString()
    EndIf
    oCliente:End()

    oCliente:= Cliente():New()
    ?'N. de registros ' + oCliente:All():Len():Str()


    oCliente:End()
Return ( Nil )