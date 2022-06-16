Function CreoFacturas()

    Local oFactura := Factura():New()
    Local oFacturaLineas := FacturaLinea():New()

    ?
    ?'Creo Facturas -------------------------------------------------'

    ?oFActura:Insert({;
        {'NUMERO'=>1,'FECHA'=>d"2022/04/29",'TOTAL'=>123,'CODCLI'=>1},;
        {'NUMERO'=>2,'FECHA'=>d"2022/04/29",'TOTAL'=>223,'CODCLI'=>2},;
        {'NUMERO'=>3,'FECHA'=>d"2022/04/29",'TOTAL'=>323,'CODCLI'=>3},;
        {'NUMERO'=>4,'FECHA'=>d"2022/04/29",'TOTAL'=>423,'CODCLI'=>2},;
        {'NUMERO'=>5,'FECHA'=>d"2022/04/29",'TOTAL'=>523,'CODCLI'=>1};
    }):Str() + ' Facturas insertadas'

    oFactura:End()

    ?oFacturaLineas:Insert({;
        {'NUMERO'=>1,'CONCEPTO'=>'Producto ASDASD',      'CANTIDAD'=>110},;
        {'NUMERO'=>1,'CONCEPTO'=>'Producto 51R2D342T',   'CANTIDAD'=>120},;
        {'NUMERO'=>1,'CONCEPTO'=>'Producto ASASD',       'CANTIDAD'=>130},;
        {'NUMERO'=>2,'CONCEPTO'=>'Producto 245FF4',      'CANTIDAD'=>140},;
        {'NUMERO'=>2,'CONCEPTO'=>'Producto ASDF2342',    'CANTIDAD'=>150},;
        {'NUMERO'=>2,'CONCEPTO'=>'Producto VRF234G',     'CANTIDAD'=>160},;
        {'NUMERO'=>3,'CONCEPTO'=>'Producto VWE2435',     'CANTIDAD'=>170},;
        {'NUMERO'=>3,'CONCEPTO'=>'Producto GV2G3245G2',  'CANTIDAD'=>180},;
        {'NUMERO'=>3,'CONCEPTO'=>'Producto V5342FV243',  'CANTIDAD'=>110},;
        {'NUMERO'=>4,'CONCEPTO'=>'Producto VQEWV5H',     'CANTIDAD'=>210},;
        {'NUMERO'=>4,'CONCEPTO'=>'Producto 536J45',      'CANTIDAD'=>310},;
        {'NUMERO'=>4,'CONCEPTO'=>'Producto VQ234FV312',  'CANTIDAD'=>410},;
        {'NUMERO'=>5,'CONCEPTO'=>'Producto VWEJTY',      'CANTIDAD'=>510},;
        {'NUMERO'=>5,'CONCEPTO'=>'Producto VQAFDGVWEDG', 'CANTIDAD'=>610},;
        {'NUMERO'=>5,'CONCEPTO'=>'Producto WERFGWE',     'CANTIDAD'=>710};
    }):Str() + ' Facturas Lineas insertadas'

    oFactura := Factura():New(2):Lineas()

    ?oFactura:NUMERO:Str() + ' ' + oFactura:FECHA:Str() + ' ' + oFactura:TOTAL:Str() + ' ' + oFactura:CODCLI:Str()

    oFactura:oLineas:GoTop()

    While !oFactura:oLineas:Eof()

        ?oFactura:oLineas:CONCEPTO:Alltrim() + ' ' + oFactura:oLineas:CANTIDAD:Str()
        oFactura:oLineas:Skip()

    Enddo

    oFactura:Skip()

    oFactura:End()

Return ( Nil )