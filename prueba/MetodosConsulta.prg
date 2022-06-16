Function MetodosConsulta()

    Local oCliente := Cliente():New()

    oCliente:DropTable()

    CreoClientes()
    CreoMasclientes()

    ?
    // ----------------------------
    ?'Where array condition --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:Where({;
                        {'CODIGO', '>=', 1},;
                        {'CODIGO', '<=', 5};
                    });
            :Select('CODIGO');
            :Get()
    ?ocliente:ToHashes():Str()
    oCliente:End()

    // ----------------------------
    ?'OrWhere array condition --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:Where({;
                        {'CODIGO', '>=', 1},;
                        {'CODIGO', '<=', 5};
                });
            :OrWhere('CODIGO', 12);
            :Select('CODIGO');
            :Get()
    ?ocliente:ToHashes():Str()
    oCliente:End()

    // ----------------------------
    ?'Where Like array condition --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:Where('NOMBRE', 'Like', '%a');
            :OrWhere('CODIGO', 12);
            :Select('CODIGO','NOMBRE');
            :Get()
    ?ocliente:LogToString()    
    ?ocliente:ToHashes():Str()
    oCliente:End()

    // ----------------------------
    ?'WhereBetween array condition --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:WhereBetween( 'CODIGO', {1,5} );
            :Select('CODIGO','NOMBRE');
            :Get()
    ?ocliente:LogToString()    
    ?ocliente:ToHashes():Str()
    oCliente:End()

    // ----------------------------
    ?'Where IN array condition --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:WhereIN( 'CODIGO', {1,3,5,7,9,11} );
            :Select('CODIGO','NOMBRE');
            :Get()
    ?ocliente:LogToString()    
    ?ocliente:ToHashes():Str()
    oCliente:End()

    // ----------------------------
    ?'Select AS array condition --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:WhereIN( 'CODIGO', {1,3,5,7,9,11} );
            :Select('CODIGO AS COD','NOMBRE AS NOM');
            :Get()
    ?ocliente:LogToString()    
    ?ocliente:ToHashes():Str()
    oCliente:End()

    // ----------------------------
    ?'LoadLimits --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:LoadLimits()
    oCliente:GoTop()
    ?ocliente:CODIGO
    oCliente:GoBottom()
    ?ocliente:CODIGO
    oCliente:End()

    // ----------------------------
    ?'LoadLimits Nombre --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:LoadLimits( 'NOMBRE' )
    oCliente:GoTop()
    ?ocliente:NOMBRE:Alltrim()
    oCliente:GoBottom()
    ?ocliente:NOMBRE:Alltrim()
    oCliente:End()

    ?'Order By condition --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:Where('CODIGO', '>=', 5);
            :Select('CODIGO', 'NOMBRE');
            :OrderBy('NOMBRE', 'DESC');
            :Get()
    ?ocliente:ToHashes():Str()
    oCliente:End()

    ?'Take --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:Where('CODIGO', '>=', 5);
            :Select('CODIGO', 'NOMBRE');
            :Take(2);
            :Get()
    ?ocliente:ToHashes():Str()
    oCliente:End()

    ?'Offset --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:Where('CODIGO', '>=', 5);
            :Select('CODIGO', 'NOMBRE');
            :Offset(3);
            :Get()
    ?ocliente:ToHashes():Str()
    oCliente:End()

    ?'Persistent --------------------------------------------------------'
    oCliente := Cliente():New()
    oCliente:Query:PersistentOn()
    oCliente:Where('CODIGO', '>=', 5);
            :Select('CODIGO', 'NOMBRE');
            :Get()
    oCliente:Where('CODIGO', '<=', 7);
        :Select('CODIGO', 'NOMBRE');
        :Get()
    ?ocliente:ToHashes():Str()
    oCliente:End()



Return ( Nil )