Function AsignoFPagoaClientes()

    Local oCliente := Cliente():New( 1 )

    ?
    ?'Asigno Formas de Pago a Clientes -------------------------------------------------'

    oCliente:FORMAPAGO := 1
    oCliente:Save()
    oCliente:End()

    oCliente := Cliente():New( 2 )
    oCliente:FORMAPAGO := 2
    oCliente:Save()
    oCliente:End()

    oCliente := Cliente():New()
    oCliente:All() 

    oCliente:GoTop()

    ?'Clientes:'

    While !oCliente:Eof()

        ?oCliente:CODIGO:Str() + ' ' + oCliente:NOMBRE:Alltrim() + ' ' + oCliente:PESO:Str() + ' ' + oCliente:FORMAPAGO:Str()
        oCliente:Skip()

    Enddo

    ocliente:End()

Return ( Nil )