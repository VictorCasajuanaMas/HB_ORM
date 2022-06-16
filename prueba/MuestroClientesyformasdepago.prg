Function MuestroClientesyformasdepago()

    Local oCliente := Cliente():New():Formadepago()

    ?
    ?'Muestro Clientes y Formas de Pago -------------------------------------------------'

    oCliente:All() 

    oCliente:GoTop()

    ?'Clientes:'

    While !oCliente:Eof()

        ?oCliente:CODIGO:Str() + ' ' + oCliente:NOMBRE:Alltrim() + ' ' + oCliente:PESO:Str() + ' ' + oCliente:FORMAPAGO:Str() + ' ' + oCliente:oFormadepago:NOMBRE:Alltrim()
        oCliente:Skip()

    Enddo

    ocliente:End()

Return ( Nil )    