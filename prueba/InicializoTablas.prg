Function InicializoTablas()

    Local oCliente := Cliente():New()
    Local oFormapago := Formapago():New()
    Local oFactura := Factura():New()
    Local oFacturaLinea := FacturaLinea():New()
    ?
    ?'Inicializo Tablas -------------------------------------------------'

    oCliente:DropTable()
    oFormapago:DropTable()
    oFActura:DropTable()
    oFacturaLinea:DropTable()

    oCliente:End()
    oFormapago:End()
    oFactura:End()
    oFacturaLinea:End()

Return ( Nil )