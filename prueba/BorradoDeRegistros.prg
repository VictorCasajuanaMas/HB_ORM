Function BorradoDeRegistros()

    Local oCliente := Cliente():New()

    ?
    ?'Borrado de registros-------------------------------------'

    ?'Registros:' + oCliente:RecCount():Str()
    ?'Borrando 1 registros ' + oCliente:Delete(1):Str()
    ?'Registros:' + oCliente:RecCount():Str()
    ?'Borrando 2 registros ' + oCliente:Delete({2,3}):Str()
    ?'Registros:' + oCliente:RecCount():Str()

    oCliente:Find(4)
    ?'Borrando 1 registros ' + oCliente:Delete():Str()
    ?'Registros:' + oCliente:RecCount():Str()
    oCliente:End()

    oCliente := Cliente():New()
    ?'Borrando varios registros '+ oCliente:Where( 'CODIGO', '>=', 8):Delete():Str()
    ?'Registros:' + oCliente:RecCount():Str()
    oCliente:End()

    oCliente := Cliente():New()
    ?'Borrando e insertando:' 
    oCliente:DeleteAndInsert( {'CODIGO', '=', 7}, {'CODIGO' => 24, 'NOMBRE' => 'El 24'})
    oCliente:End()

    oCliente := Cliente():New( 12 )
    ?'Hay registro 12 :' + oCliente:Success():Str()

    oCliente := Cliente():New( 24 )
    ?oCliente:ToHash():Str()

Return Nil 