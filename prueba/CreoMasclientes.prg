Function CreoMasclientes()

    Local oCliente := Cliente():New()
    Local nCreados := 0

    nCreados := oCliente:Insert({;
        {'CODIGO' => 3, 'NOMBRE' => 'Lucia', 'PESO' => 45 },;
        {'CODIGO' => 4, 'NOMBRE' => 'Jose', 'PESO' => 46 },;
        {'CODIGO' => 5, 'NOMBRE' => 'Maria', 'PESO' => 47 },;
        {'CODIGO' => 6, 'NOMBRE' => 'Luz', 'PESO' => 48 },;
        {'CODIGO' => 7, 'NOMBRE' => 'Andreu', 'PESO' => 49 },;
        {'CODIGO' => 8, 'NOMBRE' => 'Miguel', 'PESO' => 50 },;
        {'CODIGO' => 9, 'NOMBRE' => 'Francisco', 'PESO' => 60 },;
        {'CODIGO' => 10, 'NOMBRE' => 'Rosa', 'PESO' => 61 },;
        {'CODIGO' => 11, 'NOMBRE' => 'Laura', 'PESO' => 70},;
        {'CODIGO' => 12, 'NOMBRE' => 'Ivan', 'PESO' => 58 };
    })

    ?
    ?'Creados ' + nCreados:Str() + ' clientes'

    ocliente:End()

Return (Nil)
