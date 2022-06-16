Function PruebaLazyLoad()

    Local oCliente := Cliente():New()

    oCliente:DropTable()

    CreoClientes()
    CreoMasclientes()

    oCliente := Cliente():New()

    ?
    ?'Prueba Lazy Load. Mirar el log.log !!!! --------------------------------------------------'

    oCliente:LogActivate()
    oCliente:LogDelete()
    ?'Lo cargo todo'
    
    oCliente:LazyLoadPessimist()


    ?oCliente:Find(10):Success()
    ?oCliente:Find(2):Success()
    ?oCliente:Find(12):Success()
    oCliente:LogWrite('hola')

    oCliente:End()

Return ( Nil )