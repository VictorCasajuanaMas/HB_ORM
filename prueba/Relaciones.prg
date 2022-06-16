Function Relaciones()

    Local oCliente := Cliente():New()

    oCliente:DropTable()

    ?
    ?'Relaciones ----------------------------------------------------'

    CreoClientes()
    CreoMasclientes()
    CreoFormasdePago()
    AsignoFPagoaClientes()
    CreoFacturas()

Return ( Nil )