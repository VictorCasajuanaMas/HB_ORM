Function ModificoClientes()

    Local oCliente := Cliente():New(1)
    
    ?
    ?'Modifico Clientes ------------------------------------------------------'

    ?'Cargado:' + oCliente:LoadFromHash({'NOMBRE' => 'Modificado', 'PESO' => 80 }):Success():Str()
    ?'Modificado:' + oCliente:Save():Success():Str()
    oCliente:End()

    oCliente := Cliente():New(1)
    ?oCliente:ToHash():Str()

Return ( Nil )