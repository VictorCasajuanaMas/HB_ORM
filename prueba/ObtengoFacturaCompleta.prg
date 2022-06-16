Function ObtengoFacturaCompleta()

    Local oFactura := Factura():New(2):Lineas():Cliente()
    ?oFactura

    ?
    ?'Obtengo Factura Completa -------------------------------------------------'

    ?"Factura N: " + oFactura:NUMERO:Str()
    ?"Fecha: " + oFactura:FECHA:Str()
    ?"Cliente: " + oFactura:oCliente:NOMBRE:Alltrim()
    ?"Forma de pago:" + oFactura:oCliente:oFormadepago:NOMBRE:Alltrim()
    ?"Total: " + oFactura:TOTAL:Str()

    oFactura:oLineas:GoTop()

    While !oFactura:oLineas:Eof()

        ?oFactura:oLineas:CONCEPTO:Alltrim() + ' ' + oFactura:oLineas:CANTIDAD:Str()
        oFactura:oLineas:Skip()

    Enddo


Return ( Nil )