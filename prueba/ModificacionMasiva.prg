Function ModificacionMasiva()

    Local oCliente := Cliente():New()

    ?
    ?'Modificacion masiva con savecollection --------------------------------------'

    oCliente:Where('CODIGO','<=',5):Get()
    oCliente:GoTop()

    While .Not. oCliente:Eof()

        oCliente:PESO := 58
        oCliente:Skip()

    Enddo

    oCliente:SaveCollection()
    oCliente:End()

    oCliente := Cliente():New()
    oCliente:All()
    oCliente:GoTop()
    While .Not. oCliente:Eof()
        ?oCliente:PESO
        oCliente:Skip()
    Enddo
    oCliente:End()
    

    ?'Modificación masiva con update ---------------------------------------'
    oCliente := Cliente():New()
    oCliente:Where('PESO', 58):Update( {'PESO' => 85} )

   /*  oCliente := Cliente():New()
    oCliente:All()
    oCliente:GoTop()
    While .Not. oCliente:Eof()
        ?oCliente:PESO
        oCliente:Skip()
    Enddo
    oCliente:End() */
    
Return Nil 