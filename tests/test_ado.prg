/* CLASS: Test_ORM_DBF       
    
*/
#include 'hbclass.ch'
#include 'validation.ch'
#include 'TORM.ch'

// Estos tests son lo mismo que en DBF pero mediante ADO, falta profundizar en la gestión ADO

CREATE CLASS Test_ORM_ADO FROM TestCase

    EXPORTED:
        DATA aCategories AS ARRAY INIT {'TODOS'}

        METHOD Test_AnadirRegistro()
        METHOD Test_Where()
        METHOD Test_Where2()
        METHOD Test_Where_Like()
        METHOD Test_Select()
        METHOD Test_Select_Alias()
        METHOD Test_Take()
        METHOD Test_orderBy()

ENDCLASS 

METHOD Test_AnadirRegistro() CLASS Test_ORM_ADO

    Local oFichaAdo := FichaAdo():New()

    oFichaAdo:DropTable()
    oFichaAdo:CODIGO := '123'
    oFichaAdo:NOMBRE := 'Jose'
    oFichaAdo:PESO   := 50
    
    ::Assert:True( oFichaAdo:Save():Success() )
    ::Assert:equals( 1, oFichaAdo:RecCount() )

Return ( Nil )

METHOD Test_Where() CLASS Test_ORM_ADO

    Local oFichaAdo := FichaAdo():New()

    oFichaAdo:DropTable()
    oFichaAdo:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })

    ::Assert:equals( 1, oFichaAdo:Where( 'CODIGO', '111'):Get():Len() )
    ::Assert:equals( 2, oFichaAdo:Where( 'PESO', '>', 75 ):Get():Len() )
    ::Assert:equals( 2, oFichaAdo:Where( 'CASADO', .f. ):Get():Len() )
    ::Assert:equals( 3, oFichaAdo:Where( 'PESO', '>=', 75 ):Get():Len() )
    ::Assert:equals( 0, oFichaAdo:Where( 'CODIGO', '555'):Get():Len() )
    ::Assert:equals( 1, oFichaAdo:Where( 'CODIGO', '=', '111'):Get():Len() )
    ::Assert:equals( 2, oFichaAdo:Where( 'CODIGO', '>=', '222'):Get():Len() )
    ::Assert:equals( 1, oFichaAdo:Where( {'CODIGO', '222' }):Get():Len() )
    ::Assert:equals( 1, oFichaAdo:Where( {'CODIGO', '==', '222' }):Get():Len() )
    ::Assert:equals( 1, oFichaAdo:Where( {;
                                            {'CODIGO', '==', '333' },;
                                            {'PESO', '=', 75};
                                        }):Get():Len() )
    ::Assert:equals( 1, oFichaAdo:Where( {;
                                        {'CODIGO', '==', '333' },;
                                        {'PESO', 75},;
                                        {'NOMBRE', 'Maria'},;
                                        {'CASADO', .f.},;
                                        {'NACIMIENTO', d"1995/01/15"};
                                    }):Get():Len() )

Return ( Nil )

METHOD Test_Where2() CLASS Test_ORM_ADO

    Local oFichaAdo := FichaAdo():New()

    oFichaAdo:DropTable()
    oFichaAdo:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.T., 'PESO'=>75},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'David', 'NACIMIENTO'=>d"2001/10/15", 'CASADO'=>.F., 'PESO'=>40},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Pedro', 'NACIMIENTO'=>d"1991/01/20", 'CASADO'=>.T., 'PESO'=>105},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Ana',   'NACIMIENTO'=>d"2005/12/02", 'CASADO'=>.F., 'PESO'=>81};
                        })

    ::Assert:equals( 3, oFichaAdo:Where( {;
                                           {'CODIGO', '>=', '222'},;
                                           {'CODIGO', '<=', '444'};
                                          }):Get():Len() )

    ::Assert:equals( 3, oFichaAdo:Where( 'CODIGO', '>=', '222' ):Where( 'CODIGO', '<=', '444'):Get():Len() )                                          

    ::Assert:equals( 1, oFichaAdo:Where( {;
                                           {'CODIGO', '>', '222'},;
                                           {'CODIGO', '<', '444'};
                                          }):Get():Len() )
    
    ::Assert:equals( 1, oFichaAdo:Where( {;
                                           {'CODIGO', '>=', '222'},;
                                           {'CODIGO', '<=', '444'},;
                                           {'CASADO', .t.};
                                          }):Get():Len() )

Return ( Nil )                                          

METHOD Test_Where_Like() CLASS Test_ORM_ADO

    Local oFichaAdo := FichaAdo():New()

    oFichaAdo:DropTable()
    oFichaAdo:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan Garcia Perez',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose Montesinos',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria Garcia Monasterio', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Jose Juan Gonzalez', 'NACIMIENTO'=>d"1998/02/15", 'CASADO'=>.F., 'PESO'=>72};
                        })


    ::assert:equals( 2, oFichaAdo:Where( 'NOMBRE', 'Like', '%Garcia%' ):Get():Len() )                        
    ::assert:equals( 0, oFichaAdo:Where( 'NOMBRE', 'Like', '%GARCIA%' ):Get():Len() )                        
    ::assert:equals( 2, oFichaAdo:Where( 'NOMBRE', 'Like', 'Jose%' ):Get():Len() )
    ::assert:equals( 0, oFichaAdo:Where( 'NOMBRE', 'Like', 'jose%' ):Get():Len() )
    ::assert:equals( 1, oFichaAdo:Where( 'NOMBRE', 'Like', 'Juan%' ):Get():Len() )
    ::assert:equals( 0, oFichaAdo:Where( 'NOMBRE', 'Like', '%Juan' ):Get():Len() )


Return ( Nil )



METHOD Test_SelecT() CLASS Test_ORM_ADO

    Local oFichaAdo := FichaAdo():New()

    oFichaAdo:DropTable()
    oFichaAdo:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })
                        
    ::Assert:equals( 2, oFichaAdo:Select( 'CODIGO', 'NOMBRE' ):All( TORM_HASH ):Get( 1 ):Len() )
    ::Assert:equals( 2, oFichaAdo:Select( 'CODIGO', 'NOMBRE' ):Where('CASADO',.F.):Get( TORM_HASH ):Len() )
    ::Assert:equals( 1, oFichaAdo:Select( 'CODIGO' ):Where('CASADO',.F.):Get( TORM_HASH ):Get(1):Len(), 'testea el select de 1 sola columna pasado por cadena' )
    ::Assert:equals( 1, oFichaAdo:Select( { 'CODIGO' } ):Where('CASADO',.F.):Get( TORM_HASH ):Get(1):Len(), 'testea el select de 1 sola columna pasado por array' )
    ::Assert:equals( 5, oFichaAdo:Select():Get( TORM_HASH ):Get( 1 ):Len() )
    ::Assert:equals( '111', oFichaAdo:Select( 'CODIGO', 'NOMBRE' ):All( TORM_HASH ):Get( 1 )['CODIGO']:Alltrim() )
    ::Assert:Arrayequals( {'CODIGO','NOMBRE'}, hb_HKeys ( oFichaAdo:Select( 'CODIGO', 'NOMBRE' ):All( TORM_HASH ):Get( 1 ) ))
    ::Assert:Arrayequals( {'NOMBRE','CODIGO'}, hb_HKeys ( oFichaAdo:Select( 'NOMBRE', 'CODIGO' ):All( TORM_HASH ):Get( 1 ) ))

Return ( Nil )

METHOD Test_SelecT_Alias() CLASS Test_ORM_ADO

    Local oFichaAdo := FichaAdo():New()
    Local hFichaAdo := hb_Hash()

    oFichaAdo:DropTable()
    oFichaAdo:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })
     
                        
    ::Assert:equals( '111', oFichaAdo:Select( 'CODIGO AS COD', 'NOMBRE' ):All( TORM_HASH ):Get( 1 )['COD']:Alltrim() )
    ::Assert:equals( 2, oFichaAdo:Select( 'CODIGO AS COD', 'NOMBRE' ):All( TORM_HASH ):Get( 1 ):Len() )
    ::Assert:equals( 2, oFichaAdo:Select( 'CODIGO', 'NOMBRE AS NOM' ):Where('CASADO',.F.):Get( TORM_HASH ):Len() )
    ::Assert:equals( 1, oFichaAdo:Select( 'CODIGO AS COD' ):Where('CASADO',.F.):Get( TORM_HASH ):Get(1):Len() )
    ::Assert:equals( 1, oFichaAdo:Select( { 'CODIGO AS COD' } ):Where('CASADO',.F.):Get( TORM_HASH ):Get(1):Len() )

    hFichaAdo := oFichaAdo:Select( 'CODIGO AS COD', 'NOMBRE AS NOM' ):All( TORM_HASH )
    ::Assert:equals( '222', hFichaAdo:Get( 2 )[ 'COD' ]:Alltrim())
    ::Assert:equals( 'Jose', hFichaAdo:Get( 2 )[ 'NOM' ]:Alltrim())

Return ( Nil )

METHOD Test_Take() CLASS Test_ORM_ADO

    Local oFichaAdo := FichaAdo():New()
    Local aCollection := Array( 0 )

    oFichaAdo:DropTable()
    oFichaAdo:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                        })
    oFichaAdo:End()

    oFichaAdo := FichaAdo():New()

    ::assert:equals( 3, oFichaAdo:Take( 3 ):Get():Len() )
    ::assert:equals( 6, oFichaAdo:Take( 0 ):Get():Len() )
    ::assert:equals( 6, oFichaAdo:Take( 10 ):Get():Len() )
    ::assert:equals( 0, oFichaAdo:Take( -10 ):Get():Len() )
    ::assert:equals( 6, oFichaAdo:Take( ):Get():Len() )
    ::assert:equals( 1, oFichaAdo:Take( 1 ):Get():Len() )

    ::assert:equals( 1, oFichaAdo:Where( 'CODIGO', '==', '111' ):Take( 2 ):Get():Len() )
    ::assert:equals( 2, oFichaAdo:Where( 'PESO', '>=', 50 ):Take( 2 ):Get():Len() )
    ::assert:equals( 2, oFichaAdo:Where( 'CODIGO', '>=', '111' ):Take( 2 ):Get():Len() )
    ::assert:equals( 2, oFichaAdo:WhereIn( 'CODIGO', {'111','222','333','444' } ):Take( 2 ):Get():Len() )
    ::assert:equals( 4, oFichaAdo:WhereIn( 'CODIGO', {'111','222','333','444' } ):Take( 4 ):Get():Len() )

Return ( nil )

METHOD Test_OrderBy() CLASS Test_ORM_ADO

    Local oFichaAdo := FichaAdo():New()
    Local aCollection := Array( 0 )

    oFichaAdo:DropTable()
    oFichaAdo:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                        })
    oFichaAdo:End()

    
    oFichaAdo := FichaAdo():New()
    aCollection:=oFichaAdo:OrderBy( 'CODIGO' ):All( TORM_HASH )
    ::Assert:Equals( 6, aCollection:Len() )
    ::assert:equals( '111', aCollection:Get(1)['CODIGO']:Alltrim() )
    ::assert:equals( '666', aCollection:GetLast()['CODIGO']:Alltrim() )

    oFichaAdo := FichaAdo():New()
    aCollection:=oFichaAdo:OrderBy( 'CODIGO' ):All( TORM_MODEL )
    ::Assert:Equals( 6, aCollection:Len() )
    ::assert:equals( '111', aCollection:Get(1):CODIGO:Alltrim() )
    ::assert:equals( '666', aCollection:GetLast():CODIGO:Alltrim() )

    oFichaAdo := FichaAdo():New()
    aCollection:=oFichaAdo:OrderBy( 'CODIGO', TORM_DESC ):All( TORM_HASH )
    ::Assert:Equals( 6, aCollection:Len() )
    ::assert:equals( '666', aCollection:Get(1)['CODIGO']:Alltrim() )
    ::assert:equals( '111', aCollection:GetLast()['CODIGO']:Alltrim() )

Return ( Nil )