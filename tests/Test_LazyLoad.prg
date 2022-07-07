/* CLASS: Test_ORM_LazyLoad
    
*/
#include 'hbclass.ch'
#include 'validation.ch'
#include 'TORM.ch'

CREATE CLASS Test_ORM_LazyLoad FROM TestCase

    EXPORTED:
        DATA aCategories AS ARRAY INIT {'TODOS'}

        METHOD Test_FindModel()
        METHOD Test_RecCount()
        METHOD Test_FindFirstBigger()
        METHOD Test_Reload()
        METHOD Test_Reload2()
        METHOD Test_FirstLoad()
        METHOD Test_Inject()
        METHOD Test_CanLazyShared()
        METHOD Test_LazyShared()
        METHOD Test_LazyShared2()
        METHOD Test_LazyShared_ChangeSource()
        METHOD Test_LazyShared_mulitple_ChangeSource()            
        METHOD Test_LazyLoadPesimist()
        METHOD Test_LazyLoadPesimist_Update()
        
ENDCLASS

METHOD Test_FindModel() CLASS Test_ORM_LazyLoad
    // Busca un modelo con la carga diferida

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:LazyLoad():All()

    ::Assert:False( oTestFicha:Find('111'):Success() )
    oTestFicha:End()

    TestFicha():New():Insert({;
                                {'CODIGO'=>'111',  'NOMBRE'=>'Jose'},;
                                {'CODIGO'=>'222',  'NOMBRE'=>'Maria'},;
                                {'CODIGO'=>'999',  'NOMBRE'=>'Juan',  'CASADO'=>.T.},;
                                {'CODIGO'=>'555',  'NOMBRE'=>'Pedro'},;
                                {'CODIGO'=>'otro', 'NOMBRE'=>'Luisa'},;
                                {'CODIGO'=>'000',  'NOMBRE'=>'Miguel'};
                            })
                            
    oTestFicha := TestFicha():New()
    oTestFicha:LazyLoad()
    ::Assert:True( oTestFicha:Find('111'):Success() )
    ::Assert:False( oTestFicha:Find('333'):Success() )
    ::Assert:True( oTestFicha:Find('222'):Success() )
    ::Assert:equals( 'Maria', oTestFicha:NOMBRE:Alltrim())
    ::Assert:True( oTestFicha:Find('111'):Success() )
    ::Assert:equals( 'Jose', oTestFicha:NOMBRE:Alltrim())
    ::Assert:True( oTestFicha:Find('000'):Success() )

    ::Assert:True( oTestFicha:Find( .T., 'CASADO' ):Success() )
    ::Assert:equals( 'Juan', oTestFicha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_RecCount() CLASS Test_ORM_LazyLoad
    // Cuenta los modelos con una carga diferida

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'};
                    })

    ::Assert:equals( 2, oTestFicha:LazyLoad():RecCount() )

Return ( Nil )

METHOD Test_FindFirstBigger() CLASS Test_ORM_LazyLoad
    // Localiza el primero más alto en una carga diferida

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    TestFicha():New():Insert({;
                                {'CODIGO'=>'111',  'PESO'=>11},;
                                {'CODIGO'=>'222',  'PESO'=>22},;
                                {'CODIGO'=>'999',  'PESO'=>99},;
                                {'CODIGO'=>'555',  'PESO'=>55},;
                                {'CODIGO'=>'otro', 'PESO'=>25},;
                                {'CODIGO'=>'000',  'PESO'=>70};
                            })


    oTestFicha:LazyLoad()    
    ::Assert:equals( 25, oTestFicha:FindFirstBigger( 30, 'PESO' ):PESO )

Return ( Nil )

METHOD Test_Reload() CLASS Test_ORM_LazyLoad
    // prueba el Reload de la carga diferida

    Local oTestFicha := TestFicha():New()
    Local oTestFicha2 := TestFicha():New()

    oTestFicha:DropTable()

    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'};
                    })

    ::Assert:equals( 2, oTestFicha:LazyLoad():RecCount() )

    oTestFicha2:Insert({;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Juan'};
                    })

    oTestFicha:__oLazyLoad:ReLoad()
    ::Assert:equals( 3, oTestFicha:RecCount() )

Return ( Nil )

METHOD Test_FirstLoad() CLASS Test_ORM_LazyLoad
    // prueba una búsqueda con carga diferida

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'};
                    })

    ::Assert:equals( 0, oTestFicha:Len() )
    oTestFicha:LazyLoad()
    ::Assert:True( oTestFicha:Find('222'):Success() )

Return ( Nil )

METHOD Test_Inject() CLASS Test_ORM_LazyLoad

    Local oTestFicha := TestFicha():New()
    Local aDataToInject := Array( 3 )
    Local nCount := 0

    For nCount := 1 To aDataToInJect:Len()

        aDataToInject[ nCount ] := TestFicha():New()

    Next
    oTestFicha:DropTable()

    oTestFicha:Inject( aDataToInject )
    oTestFicha:__oLazyLoad:lEnable := .T.
    oTestFicha:__DataSource := TORM_DATASOURCE_COLLECTION
    ::Assert:equals( 3, oTestFicha:RecCount() )

Return ( Nil )

METHOD Test_Reload2() CLASS Test_ORM_LazyLoad
    // prueba el Reload de la carga diferida

    Local oTestFicha := TestFicha():New()
    Local oTestFicha2 := TestFicha():New()

    oTestFicha:DropTable()

    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'};
                    })

    ::Assert:equals( 2, oTestFicha:LazyLoad():RecCount() )

    oTestFicha2:Insert({;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Juan'};
                    })

    ::assert:false( oTestFicha:Find('333'):Success() )
    oTestFicha:__oLazyLoad:Reload()
    ::assert:true( oTestFicha:Find('333'):Success() )

Return ( Nil )

METHOD Test_CanLazyShared() CLASS Test_ORM_LazyLoad

    Local oTestFichaLazy := TestFichaLazy():New()
    Local oTestFicha := TestFicha():New()

    ::assert:true( oTestFichaLazy:__oLazyLoad:CanLazyShared() )
    ::assert:false( oTestFicha:__oLazyLoad:CanLazyShared() )


Return ( Nil )

METHOD Test_LazyShared() CLASS Test_ORM_LazyLoad
    // En este test utilizo muevefichero y recuperafichero para asegurarme de que no accede al dbf cuando no debe acceder ya que trabaja en caché

    Local oTestFichaLazy1  := TestFichaLazy():New()
    Local oTestFichaLazy2 := Nil 
    Local oTestFichaLazy3 := Nil 

    oTestFichaLazy1:DropTable()
    fErase( TORMDBF():Path() + '_TestFichaLazys.dbf')
    fErase( TORMDBF():Path() + '_TestFichaLazys2.dbf')
    fErase( TORMDBF():Path() + '_TestFichaLazys3.dbf')
    fErase( TORMDBF():Path() + '_TestFichaLazys4.dbf')

    oTestFichaLazy1:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'};
                    })

    oTestFichaLazy1 := TestFichaLazy():New()
    oTestFichaLazy1:LazyLoadShared()
    ::assert:equals( 2, oTestFichaLazy1:RecCount() )
    MueveFichero( oTestFichaLazy1 )
    ::assert:true(oTestFichaLazy1:&(TORM_LAZYSHARED):HasCollection())

    oTestFichaLazy1:GoTop()
    ::assert:equals( 'Jose', oTestFichaLazy1:NOMBRE:Alltrim() )
    oTestFichaLazy1:GoBottom()
    ::assert:equals( 'Maria', oTestFichaLazy1:NOMBRE:Alltrim() )

    ::Assert:false( hb_FileExists( TORMDBF():Path() + oTestFichaLazy1:TableName + '.dbf' ) )
    RecuperaFichero( oTestFichaLazy1 )

    oTestFichaLazy2 := TestFichaLazy():New()
    oTestFichaLazy2:LazyLoadShared()
    ::assert:equals(2, oTestFichaLazy2:Insert({;
                            {'CODIGO'=>'333', 'NOMBRE'=>'Pepe'},;
                            {'CODIGO'=>'444', 'NOMBRE'=>'Ana'};
                        }))


    MueveFichero( oTestFichaLazy1 )
    // después de insertar 2 más a la tabla, los reccount devuelven igualmente lo que hay en caché en ambos modcelos
    ::assert:equals( 2, oTestFichaLazy1:RecCount() )                        
    ::assert:equals( 2, oTestFichaLazy2:RecCount() )
    ::Assert:false( hb_FileExists( TORMDBF():Path() + oTestFichaLazy1:TableName + '.dbf' ) )
    RecuperaFichero( oTestFichaLazy1 )

    // hago un reload a un modelo y se actualiza la caché de ambos
    oTestFichaLazy1:__oLazyLoad:Reload()
    MueveFichero( oTestFichaLazy1 )
    ::assert:equals( 4, oTestFichaLazy1:RecCount() )                        
    ::assert:equals( 4, oTestFichaLazy2:RecCount() )
    ::assert:true(oTestFichaLazy1:&(TORM_LAZYSHARED):HasCollection())
    ::assert:true(oTestFichaLazy2:&(TORM_LAZYSHARED):HasCollection())
    ::Assert:false( hb_FileExists( TORMDBF():Path() + oTestFichaLazy1:TableName + '.dbf' ) )
    RecuperaFichero( oTestFichaLazy1 )

    // Creo un tercer modelo y mantiene la caché general aunque se elimine la tabla por completo
    oTestFichaLazy3 := TestFichaLazy():New():LazyLoadShared()
    oTestFichaLazy3:DropTable()
    ::assert:equals( 4, oTestFichaLazy3:RecCount() )

Return ( Nil )

METHOD Test_LazyShared2() CLASS Test_ORM_LazyLoad

    // Test que comprueba que pueden haber instancias del mismo modelo con lazyloadcache compartido y instancias sin el LazyLoadCaché activado

    Local oTestFichaLazy1  := TestFichaLazy():New()
    Local oTestFichaLazy2  := TestFichaLazy():New()
    Local oTestFichaLazy3  := TestFichaLazy():New()

    oTestFichaLazy1:DropTable()
    oTestFichaLazy1:LazyLoadSharedInit()
    oTestFichaLazy1:LazyLoadShared()
    oTestFichaLazy2:LazyLoadShared()

    oTestFichaLazy1:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'};
                    })
    
    ::assert:equals( 2, oTestFichaLazy1:RecCount() )
    ::assert:equals( 2, oTestFichaLazy2:RecCount() )

    ::assert:equals(2, oTestFichaLazy1:Insert({;
                            {'CODIGO'=>'333', 'NOMBRE'=>'Pepe'},;
                            {'CODIGO'=>'444', 'NOMBRE'=>'Ana'};
                        }))

    ::assert:equals( 2, oTestFichaLazy1:RecCount() )
    ::assert:equals( 2, oTestFichaLazy2:RecCount() )
    ::assert:equals( 4, oTestFichaLazy3:RecCount() )

Return ( Nil )

METHOD Test_LazyShared_ChangeSource() CLASS Test_ORM_LazyLoad

    // Detecta el cambio de path y entonces actualiza el lazyshared
    Local oTestFichaLazy  := TestFichaLazy():New():LazyLoadShared()
    Local cOtherFullSource := hb_cwd() + 'db\otropath\' + oTestFichaLazy:TableName + '.dbf'
    
    oTestFichaLazy:&(TORM_LAZYSHARED):InitCollection()

    oTestFichaLazy:DropTable()

    oTestFichaLazy:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Pepe'},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Ana'};
                    })

    fErase( cOtherFullSource )                    
    ::assert:false( File( cOtherFullSource ) )

    ::assert:equals( 4, oTestFichaLazy:RecCount() )   

    TORMDBF():SetPath( hb_cwd() + 'db\otropath\' )
    ::assert:equals( 0, oTestFichaLazy:RecCount() )    
    ::assert:true( File( cOtherFullSource ) )
    TORMDBF():SetPath( '.\db\' )
    
Return ( Nil )

METHOD Test_LazyShared_mulitple_ChangeSource() CLASS Test_ORM_LazyLoad

    // Detecta el cambio de path y entonces actualiza el lazyshared

    Local oTestFichaLazy1  := TestFichaLazy():New()
    Local oTestFichaLazy2  := TestFichaLazy():New()
    Local oTestFichaLazy3  := TestFichaLazy():New()
    Local cOtherFullSource := hb_cwd() + 'db\otropath\' + oTestFichaLazy1:TableName + '.dbf'

    oTestFichaLazy1:&(TORM_LAZYSHARED):InitCollection()

    oTestFichaLazy1:DropTable()

    oTestFichaLazy1:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Pepe'},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Ana'};
                    })

    fErase( cOtherFullSource )                                        
    ::assert:false( File( cOtherFullSource ) )

    ::assert:equals( 4, oTestFichaLazy1:RecCount() )    
    ::assert:equals( 4, oTestFichaLazy2:RecCount() )    
    ::assert:equals( 4, oTestFichaLazy3:RecCount() )    

    TORMDBF():SetPath( hb_cwd() + 'db\otropath\' )
    ::assert:equals( 0, oTestFichaLazy1:RecCount(), oTestFichaLazy1:__oReturn:LogToString() )    
    ::assert:true( File( cOtherFullSource ) )
    ::assert:equals( 0, oTestFichaLazy2:RecCount() )    
    ::assert:equals( 0, oTestFichaLazy3:RecCount() )    
    TORMDBF():SetPath( '.\db\' )
    
Return ( Nil )

METHOD Test_LazyLoadPesimist() CLASS Test_ORM_LazyLoad

    Local oTestFicha1 := TestFicha():New()
    Local oTestFicha2 := TestFicha():New()

    oTestFicha1:LazyLoad()
    oTestFicha2:LazyLoad()

    oTestFicha1:DropTable()

    oTestFicha1:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'};
                    })

    ::Assert:equals( 2, oTestFicha1:LazyLoad():RecCount() )

    ::assert:equals( 2, oTestFicha2:Insert({;
                            {'CODIGO'=>'333', 'NOMBRE'=>'Pepe'},;
                            {'CODIGO'=>'444', 'NOMBRE'=>'Ana'};
                        }))


    ::Assert:equals( 4, oTestFicha2:LazyLoad():RecCount() )
    ::Assert:equals( 2, oTestFicha1:LazyLoad():RecCount() )

    // Cuando le activo el pesimist, la próxima vez comprobará si se han echo cambios y entonces verá que sí y hará un reload()
    oTestFicha1:LazyLoadPessimist()
    ::Assert:equals( 4, oTestFicha1:LazyLoad():RecCount() )

Return ( Nil )

METHOD Test_LazyLoadPesimist_Update() CLASS Test_ORM_LazyLoad

    Local oTestFicha1 := TestFicha():New()
    Local oTestFicha2 := TestFicha():New()

    oTestFicha2:LazyLoad() 

    oTestFicha1:DropTable()

    oTestFicha1:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'};
                    })

    ::Assert:equals( 2, oTestFicha1:RecCount() )

    oTestFicha1:Find( '111' )
    ::assert:equals( 'Jose', oTestFicha1:NOMBRE():Alltrim() )

    oTestFicha2:Find( '111' )  // Hago ahora el Find para que haga la primera carga de la colección como lazyload
    ::assert:equals( 'Jose', oTestFicha2:NOMBRE():Alltrim() )

    oTestFicha1:NOMBRE := 'Pepito'
    oTestFicha1:PESO   := 50

    ::assert:true( oTestFicha1:Save():Success() )


    oTestFicha2:Find( '111' )  // Al estar el lazyload normal, no ha recargado ya que no detecta modificación en el source
    ::assert:equals( 'Jose', oTestFicha2:NOMBRE():Alltrim() )
    
    oTestFicha2:LazyLoadPessimist() // Cuando le activo el pesimist, la próxima vez comprobará si se han echo cambios y entonces verá que sí y hará un reload()
    oTestFicha2:Find( '111' )  
    ::assert:equals( 'Pepito', oTestFicha2:NOMBRE():Alltrim() )

Return ( Nil )

Static Function MueveFichero( oModel )
Return ( fRename( TORMDBF():Path() + oModel:TableName + '.dbf', TORMDBF():Path() + '_' + oModel:TableName + '.dbf'))

Static Function RecuperaFichero( oModel )
Return ( fRename( TORMDBF():Path() + '_' + oModel:TableName + '.dbf', TORMDBF():Path() + oModel:TableName + '.dbf'))

