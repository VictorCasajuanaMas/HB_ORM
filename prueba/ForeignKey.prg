Function ForeignKey()

    Local oFactura := Factura():New(2)

    ?
    ?'Borrando factura y sus líneas --------------------'

    ?'Facturas Borradas:' + oFactura:Delete():Str()
    oFactura:End()

Return ( Nil )