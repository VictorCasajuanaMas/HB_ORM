Function ForeignKey()

    Local oFactura := Factura():New(2)

    ?
    ?'Borrando factura y sus l�neas --------------------'

    ?'Facturas Borradas:' + oFactura:Delete():Str()
    oFactura:End()

Return ( Nil )