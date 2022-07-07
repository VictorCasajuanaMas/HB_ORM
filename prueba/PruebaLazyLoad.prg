Function PruebaLazyLoad()

    Local oCliente := Cliente():New()

    oCliente:DropTable()

    CreoClientes()
    CreoMasclientes()

    oCliente := Cliente():New()
    oCliente:LazyLoad()

    ?
    ?'Prueba Lazy Load. Mirar el log.log !!!! --------------------------------------------------'

    oCliente:LogActivate()
    oCliente:LogDelete()
    ?'Lo cargo todo'

    ?oCliente:Find(10):Success()
    ?oCliente:Find(2):Success()
    ?oCliente:Find(12):Success()

    oCliente:End()

    oCliente := Cliente():New()
    

Return ( Nil )