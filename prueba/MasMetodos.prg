Function MasMetodos()

    Local oCliente as Object := ClientePlus():New(1)
    Local oFormapago as Object := Formapago():New()

    ?'Nombre completo del cliente ' + oCliente:NombreCompleto()
    ?'Tiene emitidas ' + oCliente:NumeroFacturas():Str() + ' facturas'
    ?'Forma de pago por defecto : ' + oFormapago:DameDefecto():Str()

Return ( Nil )