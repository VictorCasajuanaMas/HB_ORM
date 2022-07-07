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

    oCliente := Cliente():New( 7 )
    ?'Hay registro 7 :' + oCliente:Success():Str('SI','NO')
    ?'Borrando e insertando:' 
    oCliente:DeleteAndInsert( {'CODIGO', '=', 7}, {'CODIGO' => 24, 'NOMBRE' => 'El 24'})
    oCliente:End()

    oCliente := Cliente():New( 7 )
    ?'Hay registro 7 :' + oCliente:Success():Str('si','no')

    oCliente := Cliente():New( 24 )
    ?oCliente:ToHash():Str()

Return Nil 