Function Buscosinindice()

    Local oCliente := Cliente():New()

    ?
    ?'Busco sin indice ----------------------------------------------------------'
    ?' Localizado:' + oCliente:Find( 49, 'PESO' ):Success():Str()
    ?oCliente:ToHash():Str()

Return ( Nil )