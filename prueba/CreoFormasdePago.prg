Function CreoFormasdePago()

    Local oFormapago := Formapago():New()

    ?
    ?'Creo Formas de Pago -------------------------------------------------'

    oFormapago:CODIGO := 1
    oformapago:NOMBRE := 'Contado'
    If oFormapago:Save():Success
        ?'Forma de pago guardada correctamente ' + oFormapago:NOMBRE
    Else
        ?'Error al guardar la forma de pago ' + oFormapago:__oReturn:LogToString()
    Endif
    oFormapago:End()

    oFormapago := Formapago():New()
    oFormapago:CODIGO := 2
    oformapago:NOMBRE := 'Tarjeta'
    If oFormapago:Save():Success
        ?'Forma de pago guardada correctamente ' + oFormapago:NOMBRE
    Else
        ?'Error al guardar la forma de pago ' + oFormapago:__oReturn:LogToString()
    Endif

    oFormapago:End()
Return ( Nil )