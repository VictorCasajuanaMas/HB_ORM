Function Paginacion()

    Local oCliente := Cliente():New()
    Local nPagina  := 0
    Local oItem    := Nil

    ?
    ?'Paginacion -----------------------------------------------------------------'

    oCliente:DropTable()

    CreoClientes()
    CreoMasclientes()

    oCliente:All()
    oCliente:Pagination:SetRowsxPage( 5 )
    oCliente:Pagination:GoTop()

    For nPagina := 1 To oCliente:Pagination:GetLastPageNumber()

        ?'Página: ' + nPagina:Str() + ' ----------------------------- '

        for each oItem in oCliente:GetCollection()

            ?oItem:CODIGO:STr() + ' ' + oItem:NOMBRE:Alltrim()
            
        next

        oCliente:Pagination:NextPage()

    Next 

    oCliente:End()

Return ( Nil )