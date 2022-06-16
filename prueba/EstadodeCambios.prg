Function EstadodeCambios()

    Local oCliente := Cliente():New(1)

    ?
    ?'Estado de cambios -----------------------------------------------'

    ?'Modelo modificado: ' + oCliente:IsDirty():Str()
    oCliente:NOMBRE :='lolo'
    ?'Modelo modificado: ' + oCliente:IsDirty():Str()
    ?'Nombre modificado: ' + oCliente:IsDirty( 'NOMBRE' ):Str()
    ?'Peso modificado: ' + oCliente:IsDirty( 'PESO' ):Str()

    ?'Diferencias:' + oCliente:WasDifferent():LogToString()

    oCliente:End()


Return ( Nil )