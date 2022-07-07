/* CLASS: Test_ORM_DBF       
    
*/
#include 'hbclass.ch'
#include 'validation.ch'
#include 'TORM.ch'

CREATE CLASS Test_ORM_DBF FROM TestCase

    EXPORTED:
        DATA aCategories AS ARRAY INIT {'TODOS'}


        METHOD Test_AnadirRegistro()
        METHOD Test_Save_Fail()
        METHOD Test_EditarRegistro()
        METHOD Test_FindModel()
        METHOD Test_FindInternalID()
        METHOD Test_DropTable()
        METHOD Test_Insert()            
        METHOD Test_MultipleSave()
        METHOD Test_Delete()
        METHOD Test_Delete_InternalID()
        METHOD Test_Delete_ForeignKey_Simple()
        METHOD Test_Delete_ForeignKey_Compuesto()
        METHOD Test_Delete_Find()
        METHOD Test_Delete_Where()
        METHOD Test_Delete_Where2()
        METHOD Test_DeleteOrWhere()
        METHOD Test_ModelHasField()
        METHOD Test_HasIndexes()
        METHOD Test_All()
        METHOD Test_Locate()
        METHOD Test_AnadirDocumento()
        METHOD Test_AnadirVariosDocumentos()
        METHOD Test_BuscaDocumento() 
        METHOD Test_Where()
        METHOD Test_OrWhere()
        METHOD Test_WhereAndGoups()
        METHOD Test_Where2()
        METHOD Test_WhereBetWeen()
        METHOD Test_WhereIn()
        METHOD Test_Where_Like()
        METHOD Test_Where_NotLike()
        METHOD Test_Where_Fechas()
        METHOD Test_Select()
        METHOD Test_Select_Alias()
        METHOD Test_Select_InternalDbId()
        METHOD Test_LoadFromHash()
        METHOD Test_LoadFromHashes()
        METHOD Test_ToHash()
        METHOD Test_ToArray()
        METHOD Test_LoadFromJson()
        METHOD Test_LoadFromJsons()
        METHOD Test_ToJson()
        METHOD Test_NewParams()
        METHOD Test_LoadFromSource()
        METHOD Test_LoadMultipleFromSource()
        METHOD Test_PutToSource()
        METHOD Test_PutMultipleToSource()
        METHOD Test_SetDefaultData()  
        METHOD Test_OrderBy()
        METHOD Test_Take()
        METHOD Test_First_OneRecord()
        METHOD Test_First_MultiRecord()
        METHOD Test_First_MultiRecord_Order()
        METHOD Test_First_LazyLoad()

        METHOD Test_Last_OneRecord()
        METHOD Test_Last_MultiRecord()
        METHOD Test_Last_MultiRecord_Order()
        METHOD Test_Last_LazyLoad()

        METHOD Test_LoadLimits()

        METHOD Test_ForeignKey_Complex()  

        METHOD Test_HasOne()
        METHOD Test_HasOne_Select()
        METHOD Test_HasOne_doble()
        METHOD Test_HasOne_AllRelations()
        METHOD Test_HasOne_deep()
        METHOD Test_HasMany_Query() 
        METHOD Test_HasMany() 
        METHOD Test_HasMany_simpleindex1()
        METHOD Test_HasMany_simpleindex2()

        METHOD Test_Offset()

        METHOD Test_Pagination()
        METHOD Test_Pagination_Refresh()
        METHOD Test_Pagination_OrderBy_PrimaryKey()
        METHOD Test_Pagination_OrderBy_Other()
        METHOD Test_Pagination_Where()

        METHOD Test_Query_Persistent()

        METHOD Test_IsDirty()
        METHOD Test_WasDifferent()

        METHOD Test_Blank()

        METHOD Test_CheckSource()
        METHOD Test_Rendimiento()
        METHOD Test_GetFieldsStr()

        METHOD Test_DBFGetStructureStr()

        METHOD Test_ModeloSinIndices()
        METHOD Test_Autoincremental()

        METHOD Test_TORMDBF_SetPath()         
        METHOD Test_Valid_Message()
        METHOD Test_UpdateCollection()
        METHOD Test_Count()

        METHOD Test_Update()
        METHOD Test_UpdateOrWhere()
        METHOD Test_Update_WithField()
        METHOD Test_Update_Fail()


        METHOD Test_DeleteandInsert()

        METHOD Test_GetORMFieldofDescription()
        METHOD Test_GetStructure() 

ENDCLASS

METHOD Test_AnadirRegistro() CLASS Test_ORM_DBF
    // Añade un registro simple a la tabla

    
    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:CODIGO := '123'
    oTestFicha:NOMBRE := 'Jose'
    oTestFicha:PESO   := 50
    
    ::Assert:True( oTestFicha:Save():Success() )
    ::Assert:equals( 1, oTestFicha:RecCount() )

Return ( Nil )

METHOD Test_Save_Fail() CLASS Test_ORM_DBF
    // Añade un registro que no cumple con la validación

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:CODIGO := '123'
    oTestFicha:NOMBRE := 'Jose'
    oTestFicha:PESO   := 130

    ::Assert:False( oTestFicha:Save():Success() )
    ::Assert:equals( 0, oTestFicha:RecCount() )

Return ( Nil )

METHOD Test_Valid_Message() CLASS Test_ORM_DBF
    // Comprueba que cuando un modelo no es válido, haya mensaje de validación

    
    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:CODIGO := '123'
    oTestFicha:NOMBRE := 'Jose'
    oTestFicha:PESO   := 100

    oTestFicha:Valid()
    ::Assert:true( oTestFicha:__oReturn:LogToString():Len() == 0 )
    
    oTestFicha:PESO   := 200
    oTestFicha:Valid()
    ::Assert:false( oTestFicha:__oReturn:LogToString():Len() == 0 )

Return ( Nil )

METHOD Test_EditarRegistro() CLASS Test_ORM_DBF
    // Modifica un registro 

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    oTestFicha:CODIGO := '123'
    oTestFicha:NOMBRE := 'Jose'
    oTestFicha:PESO   := 50
    oTestFicha:Save()
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    oTestFicha:CODIGO := '456'
    oTestFicha:NOMBRE := 'Juan'
    oTestFicha:PESO   := 50
    oTestFicha:Save()
    oTestFicha:End()

    oTestFicha := TestFicha():New():Find( '123' )
    ::Assert:True( oTestFicha:Success() )
    ::Assert:equals( 'Jose', oTestFicha:NOMBRE:Alltrim() )

    oTestFicha:NOMBRE := 'Modificado'
    oTestFicha:Save()
    oTestFicha:End()

    oTestFicha := TestFicha():New():Find( '123' )
    ::Assert:equals( 'Modificado', oTestficha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_FindModel() CLASS Test_ORM_DBF
    // Busca un registro

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    ::Assert:False( oTestFicha:Find('111'):Success() )
    oTestFicha:End()

    oTestFicha := TestFicha():New():Insert({;
                                            {'CODIGO'=>'111'},;
                                            {'CODIGO'=>'222'}})


    oTestFicha := TestFicha():New()
    ::Assert:False( oTestFicha:Find( '333' ):Success() )
    ::Assert:True( oTestFicha:Find( '222' ):Success() )
    oTestFicha:End()

Return ( Nil )

METHOD Test_FindInternalID() CLASS Test_ORM_DBF
    // Busca un registro por su ID Interna, en caso de dbf's es el recno en caso de SQL puede ser el campo ID (es configurable)

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    ::Assert:False( oTestFicha:FindInternalID( 1 ):Success() )
    oTestFicha:End()

    oTestFicha := TestFicha():New():Insert({;
                                            {'CODIGO'=>'111'},;
                                            {'CODIGO'=>'222'},;
                                            {'CODIGO'=>'333'},;
                                            {'CODIGO'=>'444'},;
                                            {'CODIGO'=>'555'},;
                                            {'CODIGO'=>'666'};
                                            })

    oTestFicha := TestFicha():New()
    ::Assert:True( oTestFicha:FindInternalID( 2 ):Success() )
    ::Assert:True( oTestFicha:FindInternalID( 7 ):Success() )
    ::Assert:False( oTestFicha:FindInternalID( 8 ):Success() )
    ::Assert:False( oTestFicha:FindInternalID( 0 ):Success() )
    ::Assert:False( oTestFicha:FindInternalID( -1 ):Success() )
    oTestFicha:FindInternalID( 2 )
    ::assert:equals( '222', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:End()

Return ( Nil )


METHOD Test_DropTable() CLASS Test_ORM_DBF
    // Elimina la tabla. Esto no tendría que estar propiamente en el modelo ya que corresponde a la base de datos, pero de momento algunas interacciones las pongo en el modelo por comodidad con el fin de extraerlo en un futuro

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:CODIGO := '111'
    oTestFicha:PESO   := 50
    oTestFicha:Save()
    ::Assert:True( hb_FileExists( TORMDBF():New():Path() + oTestFicha:TableName + '.dbf' ) )
    ::Assert:True( hb_FileExists( TORMDBF():New():Path() + oTestFicha:TableName + '.cdx' ) )
    oTestFicha:DropTable()
    ::Assert:False( hb_FileExists( TORMDBF():New():Path() + oTestFicha:TableName + '.dbf' ) )
    ::Assert:False( hb_FileExists( TORMDBF():New():Path() + oTestFicha:TableName + '.cdx' ) )

Return ( Nil )

METHOD Test_Insert() CLASS Test_ORM_DBF
    // Inserta datos a partir de un array de Hash

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    ::Assert:equals( 2,oTestFicha:Insert({;
                                          {'CODIGO'=>'111', 'NOMBRE'=>'Juan', 'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                                          {'CODIGO'=>'222', 'NOMBRE'=>'Jose', 'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92}}) )
    ?oTestFicha:__oReturn:LogToString()
    oTestFicha:End()

Return ( Nil )

METHOD Test_MultipleSave() CLASS Test_ORM_DBF
    // Intenga guardar el mismo modelo varias veces pero solo se crea un registro

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:CODIGO := '123'
    oTestFicha:NOMBRE := 'Jose'
    oTestFicha:PESO   := 50

    ::Assert:True( oTestFicha:Save():Success() )
    ::Assert:equals( 1, oTestFicha:RecCount() )

    ::Assert:True( oTestFicha:Save():Success() )
    ::Assert:equals( 1, oTestFicha:RecCount() )

Return ( Nil )

METHOD Test_Delete_ForeignKey_Simple() CLASS Test_ORM_DBF

    Local oFicha := Ficha():New()
    Local oFichaDir := FichaDir():New()

    oFicha:DropTable()
    oFichaDir:DropTable()

    ::assert:equals(4,oFicha:Insert({;
                    {'CODIGO'=> 1, 'NOMBRE' => 'Julia'},;
                    {'CODIGO'=> 2, 'NOMBRE' => 'Pedro'},;
                    {'CODIGO'=> 3, 'NOMBRE' => 'Maria'},;
                    {'CODIGO'=> 4, 'NOMBRE' => 'Juan'};
                    }))

    ::assert:equals(10,oFichaDir:Insert({;
                    {'CODIGO'=> 1, 'DIRECCION' => 'Pamplona'},;
                    {'CODIGO'=> 1, 'DIRECCION' => 'Sevilla'},;
                    {'CODIGO'=> 1, 'DIRECCION' => 'Barclona'},;
                    {'CODIGO'=> 1, 'DIRECCION' => 'Madrid'},;
                    {'CODIGO'=> 2, 'DIRECCION' => 'Valencia'},;
                    {'CODIGO'=> 2, 'DIRECCION' => 'Murcia'},;
                    {'CODIGO'=> 2, 'DIRECCION' => 'Castellón'},;
                    {'CODIGO'=> 3, 'DIRECCION' => 'Galicia'},;
                    {'CODIGO'=> 3, 'DIRECCION' => 'Tarragona'},;
                    {'CODIGO'=> 4, 'DIRECCION' => 'San Sebastián'};
        }))

    ::assert:equals(  4, oFicha:RecCount())
    ::assert:equals( 10, oFichaDir:RecCount())

    oFicha := Ficha():New()
    oFicha:Delete(2)

    ::assert:equals( 3, oFicha:RecCount())
    ::assert:equals( 7, oFichaDir:RecCount())

    oFicha := Ficha():New()
    oFicha:Delete(1)

    ::assert:equals( 2, oFicha:RecCount())
    ::assert:equals( 3, oFichaDir:RecCount())

    oFicha := Ficha():New()
    oFicha:Delete(4)

    ::assert:equals( 1, oFicha:RecCount())
    ::assert:equals( 2, oFichaDir:RecCount())

    oFicha := Ficha():New()
    oFicha:Delete(3)

    ::assert:equals( 0, oFicha:RecCount())
    ::assert:equals( 0, oFichaDir:RecCount())

    oFicha:End()
    oFichaDir:End()

Return ( Nil )    

METHOD Test_Delete_ForeignKey_Compuesto() CLASS Test_ORM_DBF

    Local oTestDoc := TestDoc():New()
    Local oTestDocLin := TestDocLin():New()

    oTestDoc:DropTable()
    ::Assert:Equals( 5, oTestDoc:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'FECHA'=>d"2021/05/12"},;
                                            {'SERIE'=>1,'NUMERO'=>2,'FECHA'=>d"2021/05/13"},;
                                            {'SERIE'=>1,'NUMERO'=>3,'FECHA'=>d"2021/05/14"},;
                                            {'SERIE'=>1,'NUMERO'=>4,'FECHA'=>d"2021/05/15"},;
                                            {'SERIE'=>1,'NUMERO'=>5,'FECHA'=>d"2021/05/16"};
                                        }))
    
    ::Assert:equals( 5, oTestDoc:RecCount() )

    oTestDocLin:DropTable()
    ::Assert:Equals( 15, oTestDocLin:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>2,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>2,'ARTICULO'=>'ART2'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'ARTICULO'=>'ART2'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'ARTICULO'=>'ART3'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'ARTICULO'=>'ART2'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'ARTICULO'=>'ART3'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'ARTICULO'=>'ART4'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART2'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART3'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART4'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART5'};
                                        }))

    ::Assert:equals( 15, oTestDocLin:RecCount() )                                        

    ::Assert:True( oTestDoc:Find( { 'SERIE' => 1, 'NUMERO' => 3 } ):Success() )
    ::Assert:equals( 1, oTestDoc:Delete() )
    ::Assert:False( oTestDoc:Find( { 'SERIE' => 1 , 'NUMERO' => 3 } ):Success() )
    ::Assert:equals( 4, oTestDoc:RecCount() )
    ::Assert:equals( 12, oTestDocLin:RecCount() )                                        
    
Return  ( Nil )

METHOD Test_Delete() CLASS Test_ORM_DBF
    // Elimina datos

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        { 'CODIGO' => '111' },;
                        { 'CODIGO' => '222' },;
                        { 'CODIGO' => '333' },;
                        { 'CODIGO' => '444' }})
    
    ::Assert:equals( 4, oTestFicha:RecCount() )
    ::Assert:equals( 0, oTestFicha:Delete('555') )
    ::Assert:equals( 4, oTestFicha:RecCount() )
    ::Assert:equals( 1, oTestFicha:Delete('222') )
    ::Assert:equals( 3, oTestFicha:RecCount() )
    ::Assert:equals( 2, oTestFicha:Delete( { '111', '444' } ) )
    ::Assert:equals( 1, oTestFicha:RecCount() )
    ::Assert:equals( 1, oTestFicha:Delete( { '333' } ) )
    ::Assert:equals( 0, oTestFicha:RecCount() )
        
Return ( Nil )


METHOD Test_Delete_InternalID() CLASS Test_ORM_DBF
    // Elimina datos por la IdInterna

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        { 'CODIGO' => '111' },;
                        { 'CODIGO' => '222' },;
                        { 'CODIGO' => '333' },;
                        { 'CODIGO' => '444' }})
    
    ::Assert:equals( 4, oTestFicha:RecCount() )


    oTestFicha := TestFicha():New()
    ::assert:true( oTestFicha:FindInternalID( 2 ):Success ) // busco por recno
    ::assert:equals( 1, oTestFicha:Delete() )
    ::Assert:equals( 3, oTestFicha:RecCount() )

    oTestFicha := TestFicha():New('222')
    ::assert:true( oTestFicha:Fail )
        
Return ( Nil )


METHOD Test_Delete_Find() CLASS Test_ORM_DBF
    // Búsqueda de datos por el campo índice principal

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        { 'CODIGO' => '111' },;
                        { 'CODIGO' => '222' },;
                        { 'CODIGO' => '333' },;
                        { 'CODIGO' => '444' }})
    
    ::Assert:equals( 1, oTestFicha:Find( '222'):Delete() )
    ::Assert:False( oTestFicha:Find( '222' ):Success )
    oTestFicha:Find( '333')
    ::Assert:equals( 1, oTestFicha:Delete() )
    ::Assert:equals( 0, oTestFicha:Delete() )
    ::Assert:False( oTestFicha:Find( '333' ):Success )

Return ( Nil )

METHOD Test_Delete_Where() CLASS Test_ORM_DBF
    // Test Where

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        { 'CODIGO' => '111' },;
                        { 'CODIGO' => '222' },;
                        { 'CODIGO' => '333' },;
                        { 'CODIGO' => '444' },;
                        { 'CODIGO' => '555' },;
                        { 'CODIGO' => '666' },;
                        { 'CODIGO' => '777' },;
                        { 'CODIGO' => '888' },;
                        { 'CODIGO' => '999' }})
    
    ::Assert:equals( 9, oTestFicha:RecCount() )
    ::Assert:equals( 4, oTestFicha:Where( 'CODIGO', '>=', '666'):Delete())
    ::Assert:True( oTestficha:Find( '111' ):Success )
    ::Assert:True( oTestficha:Find( '222' ):Success )
    ::Assert:True( oTestficha:Find( '333' ):Success )
    ::Assert:True( oTestficha:Find( '444' ):Success )
    ::Assert:True( oTestficha:Find( '555' ):Success )
    ::Assert:False( oTestficha:Find( '666' ):Success )
    ::Assert:False( oTestficha:Find( '777' ):Success )
    ::Assert:False( oTestficha:Find( '888' ):Success )
    ::Assert:False( oTestficha:Find( '999' ):Success )
        
Return ( Nil )

METHOD Test_Delete_Where2() CLASS Test_ORM_DBF
    // Otras pruebas de Where

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        { 'CODIGO' => '111' },;
                        { 'CODIGO' => '222' },;
                        { 'CODIGO' => '333' },;
                        { 'CODIGO' => '444' },;
                        { 'CODIGO' => '555' },;
                        { 'CODIGO' => '666' },;
                        { 'CODIGO' => '777' },;
                        { 'CODIGO' => '888' },;
                        { 'CODIGO' => '999' }})
    
    ::Assert:equals( 9, oTestFicha:RecCount() )
    ::Assert:equals( 3, oTestFicha:Where( {;
                                            {'CODIGO', '>=', '444'},;
                                            {'CODIGO', '<=', '666'};
                                         }):Delete())
    ::Assert:True( oTestficha:Find( '111' ):Success )
    ::Assert:True( oTestficha:Find( '222' ):Success )
    ::Assert:True( oTestficha:Find( '333' ):Success )
    ::Assert:False( oTestficha:Find( '444' ):Success )
    ::Assert:False( oTestficha:Find( '555' ):Success )
    ::Assert:False( oTestficha:Find( '666' ):Success )
    ::Assert:True( oTestficha:Find( '777' ):Success )
    ::Assert:True( oTestficha:Find( '888' ):Success )
    ::Assert:True( oTestficha:Find( '999' ):Success )
        
Return ( Nil )



METHOD Test_ModelHasField() CLASS Test_ORM_DBF
    // Comprobación de la existencia de campos

    ::Assert:True( TestFicha():New():HasField('codigo') )
    ::Assert:True( TestFicha():New():HasField('Codigo') )
    ::Assert:True( TestFicha():New():HasField('CODIGO') )
    ::Assert:False( TestFicha():New():HasField('CampoInexistente') )

Return ( Nil )

METHOD Test_HasIndexes() CLASS Test_ORM_DBF
    // Comprobación de la existencia de índices

    ::Assert:True( TestFicha():New():__oIndexes:HasIndexes() )
    ::Assert:False( Modelosinindices():New():__oIndexes:HasIndexes() )

Return ( Nil )


METHOD Test_All() CLASS Test_ORM_DBF
    // Método All que recoje todos los registros

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })
    ::Assert:equals( 3, oTestFicha:All():Len() )

Return ( Nil )

METHOD Test_Locate() CLASS Test_ORM_DBF
    // Método locate para localizar registros por cualquier campo del modelo. 

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })

    ::Assert:True( oTestFicha:Find( 92, 'PESO' ):Success() )
    ::Assert:True( oTestFicha:Find( 41, 'PESO' ):Fail() )

Return ( Nil )


METHOD Test_AnadirDocumento() CLASS Test_ORM_DBF
    // Añadir un registro con índice compuesto

    Local oTestDoc := TestDoc():New()

    oTestDoc:DropTable()

    oTestDoc:SERIE  := 1 
    oTestDoc:NUMERO := 1
    oTestDoc:FECHA  := Date()
    ::Assert:True( oTestDoc:Save():Success(), oTestDoc:__oReturn:LogToString())
    ::Assert:equals( 1, oTestDoc:RecCount(), oTestDoc:__oReturn:LogToSTring() )

Return ( Nil )

METHOD Test_AnadirVariosDocumentos() CLASS Test_ORM_DBF
    // Insertar varios registros con índice compuesto en la tabla

    Local oTestDoc := TestDoc():New()

    oTestDoc:DropTable()

    ::Assert:Equals( 5, oTestDoc:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'FECHA'=>d"2021/05/12"},;
                                            {'SERIE'=>1,'NUMERO'=>2,'FECHA'=>d"2021/05/13"},;
                                            {'SERIE'=>1,'NUMERO'=>3,'FECHA'=>d"2021/05/14"},;
                                            {'SERIE'=>1,'NUMERO'=>4,'FECHA'=>d"2021/05/15"},;
                                            {'SERIE'=>1,'NUMERO'=>5,'FECHA'=>d"2021/05/16"};
                                        }))
    ::Assert:Equals(5, oTestDoc:RecCount() )

Return ( Nil )

METHOD Test_BuscaDocumento() CLASS Test_ORM_DBF
    // Localizar un modelo con índice compuesto

    Local oTestDoc := TestDoc():New()

    oTestDoc:DropTable()

    ::Assert:Equals( 5, oTestDoc:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'FECHA'=>d"2021/05/12"},;
                                            {'SERIE'=>1,'NUMERO'=>2,'FECHA'=>d"2021/05/13"},;
                                            {'SERIE'=>1,'NUMERO'=>3,'FECHA'=>d"2021/05/14"},;
                                            {'SERIE'=>1,'NUMERO'=>4,'FECHA'=>d"2021/05/15"},;
                                            {'SERIE'=>1,'NUMERO'=>5,'FECHA'=>d"2021/05/16"};
                                        }))

    ::Assert:True( oTestDoc:Find( { 'SERIE' => 1 , 'NUMERO'=> 3 } ):Success(), oTestDoc:__oReturn:LogToString() )
    ::Assert:True( oTestDoc:Find( { 'SERIE' => 0, 'NUMERO'=> 3 } ):Fail() )

Return ( Nil )

METHOD Test_Where_Fechas() CLASS Test_ORM_DBF
    
    // probar Where de fechas

    Local oTestPagos := TestPagos():New()

    oTestPagos:DropTable()
    ::assert:equals( 9, oTestPagos:Insert({;
                                          { 'SERIE'=>1, 'NUMERO'=>1, 'FECHA_VEN'=>d"2021/06/20",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>2, 'FECHA_VEN'=>d"2021/06/20",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>3, 'FECHA_VEN'=>d"2021/06/08",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>4, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>'S'},;
                                          { 'SERIE'=>1, 'NUMERO'=>5, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>'S'},;
                                          { 'SERIE'=>1, 'NUMERO'=>6, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>'S'},;
                                          { 'SERIE'=>1, 'NUMERO'=>7, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>8, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>9, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>''};
                                          }))

    ::assert:equals( 6, oTestPagos:Where( {;
                                            { 'FECHA_VEN', '>=', d"2021/06/12" },;
                                            { 'FECHA_VEN', '<=', d"2021/06/12" },;
                                            { 'CONTABI', '!=', "N" };
                                        }):Get():Len() )

    ::assert:equals( 6, oTestPagos:Where( 'FECHA_VEN', '>=', d"2021/06/12" );
                                  :Where( 'FECHA_VEN', '<=', d"2021/06/12" );
                                  :Where( 'CONTABI', '!=', "N"):Get():Len() )                                        

    ::assert:equals( 7, oTestPagos:Where( {;
                                            { 'FECHA_VEN', '>=', d"2021/06/01" },;
                                            { 'FECHA_VEN', '<=', d"2021/06/12" },;
                                            { 'CONTABI', '!=', "N" };
                                        }):Get():Len() )                                  

Return ( Nil )

METHOD Test_WhereBetWeen() CLASS Test_ORM_DBF
    // Probar Where Between

    Local oTestPagos := TestPagos():New()

    oTestPagos:DropTable()
    ::assert:equals( 9, oTestPagos:Insert({;
                                          { 'SERIE'=>1, 'NUMERO'=>1, 'FECHA_VEN'=>d"2021/06/20",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>2, 'FECHA_VEN'=>d"2021/06/20",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>3, 'FECHA_VEN'=>d"2021/06/08",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>4, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>'S'},;
                                          { 'SERIE'=>1, 'NUMERO'=>5, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>'S'},;
                                          { 'SERIE'=>1, 'NUMERO'=>6, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>'S'},;
                                          { 'SERIE'=>1, 'NUMERO'=>7, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>8, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>''},;
                                          { 'SERIE'=>1, 'NUMERO'=>9, 'FECHA_VEN'=>d"2021/06/12",  'CONTABI'=>''};
                                          }))

    ::assert:equals( 6, oTestPagos:WhereBetween( 'FECHA_VEN', { d"2021/06/12", d"2021/06/12" } );
                                  :Where( 'CONTABI', '!=', "N" );
                                  :Get():Len() )

    ::assert:equals( 7, oTestPagos:WhereBetween( 'FECHA_VEN', { d"2021/06/01", d"2021/06/12" } );
                                  :Where( 'CONTABI', '!=', "N" );
                                  :Get():Len() )             

Return ( Nil )

METHOD Test_Where() CLASS Test_ORM_DBF
    // Más pruebas de Where

    Local oTestFicha := TestFicha():New()
    
    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })

    ::Assert:equals( 1, oTestFicha:Where( 'CODIGO', '111'):Get():Len() )
    ::Assert:equals( 2, oTestFicha:Where( 'PESO', '>', 75 ):Get():Len() )
    ::Assert:equals( 2, oTestFicha:Where( 'CASADO', .F. ):Get():Len() )
    ::Assert:equals( 3, oTestFicha:Where( 'PESO', '>=', 75 ):Get():Len() )
    ::Assert:equals( 0, oTestFicha:Where( 'CODIGO', '555'):Get():Len() )
    ::Assert:equals( 1, oTestFicha:Where( 'CODIGO', '=', '111'):Get():Len() )
    ::Assert:equals( 2, oTestFicha:Where( 'CODIGO', '>=', '222'):Get():Len() )
    ::Assert:equals( 1, oTestFicha:Where( {'CODIGO', '222' }):Get():Len() )
    ::Assert:equals( 1, oTestFicha:Where( {'CODIGO', '==', '222' }):Get():Len() )
    ::Assert:equals( 1, oTestFicha:Where( {;
                                            {'CODIGO', '==', '333' },;
                                            {'PESO', '=', 75};
                                        }):Get():Len() )
    ::Assert:equals( 1, oTestFicha:Where( {;
                                        {'CODIGO', '==', '333' },;
                                        {'PESO', 75},;
                                        {'NOMBRE', 'Maria'},;
                                        {'CASADO', .f.},;
                                        {'NACIMIENTO', d"1995/01/15"};
                                    }):Get():Len() )

Return ( Nil )

METHOD Test_WhereAndGoups() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()
    
    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })



    ::Assert:equals( 1, oTestFicha:Where( {;
                                                {'CODIGO', '==', '333' },;
                                                {'PESO', 75};
                                          });
                                  :Where( {;
                                                {'NOMBRE', 'Maria'},;
                                                {'CASADO', .f.},;
                                                {'NACIMIENTO', d"1995/01/15"};
                                          });
                                  :Get():Len() )

Return ( Nil )

METHOD Test_OrWhere() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()
    
    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })



    ::Assert:equals( 2, oTestFicha:Where( {;
                                                {'CODIGO', '==', '333' },;
                                                {'PESO', 75};
                                          });
                                  :OrWhere( {;
                                                {'NOMBRE', 'Juan'},;
                                                {'CASADO', .T.};
                                          });
                                  :Get():Len() )
    

Return ( Nil )

METHOD Test_DeleteOrWhere() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()
    
    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })



    ::Assert:equals( 2, oTestFicha:Where( {;
                                                {'CODIGO', '==', '333' },;
                                                {'PESO', 75};
                                          });
                                  :OrWhere( {;
                                                {'NOMBRE', 'Juan'},;
                                                {'CASADO', .T.};
                                          });
                                  :Delete() )

Return ( Nil )

METHOD Test_Where_Like() CLASS Test_ORM_DBF
    // Probar Where Like

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan Garcia Perez',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose Montesinos',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria Garcia Monasterio', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Jose Juan Gonzalez', 'NACIMIENTO'=>d"1998/02/15", 'CASADO'=>.F., 'PESO'=>72};
                        })

    ::assert:equals( 2, oTestFicha:Where( 'NOMBRE', 'Like', '%Garcia%' ):Get():Len() )                        
    ::assert:equals( 0, oTestFicha:Where( 'NOMBRE', 'Like', '%GARCIA%' ):Get():Len() )                        
    ::assert:equals( 2, oTestFicha:Where( 'NOMBRE', 'Like', 'Jose%' ):Get():Len() )
    ::assert:equals( 0, oTestFicha:Where( 'NOMBRE', 'Like', 'jose%' ):Get():Len() )
    ::assert:equals( 1, oTestFicha:Where( 'NOMBRE', 'Like', 'Juan%' ):Get():Len() )
    ::assert:equals( 0, oTestFicha:Where( 'NOMBRE', 'Like', '%Juan' ):Get():Len() )

Return ( Nil )                        

METHOD Test_Where_NotLike() CLASS Test_ORM_DBF
    // Probar Where NotLike

    Local oTestFicha := TestFicha():New()


    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan Garcia Perez',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose Montesinos',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria Garcia Monasterio', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Jose Juan Gonzalez', 'NACIMIENTO'=>d"1998/02/15", 'CASADO'=>.F., 'PESO'=>72};
                        })

    ::assert:equals( 3, oTestFicha:Where( 'NOMBRE', 'NotLike', 'M%' ):Get():Len() )  
    oTestFicha := TestFicha():New()
    ::assert:equals( 1, oTestFicha:Where( 'NOMBRE', 'NotLike', 'J%' ):Get():Len() )  
    oTestFicha := TestFicha():New()
    ::assert:equals( 2, oTestFicha:Where( 'NOMBRE', 'NotLike', 'Jose%' ):Get():Len() )   
    oTestFicha := TestFicha():New()
    ::assert:equals( 3, oTestFicha:Where( 'NOMBRE', 'NotLike', '%Perez' ):Get():Len() )  
    oTestFicha := TestFicha():New()
    ::assert:equals( 2, oTestFicha:Where( 'NOMBRE', 'NotLike', '%Garcia%' ):Get():Len() )  
    oTestFicha := TestFicha():New()

Return ( Nil )                        



METHOD Test_Where2() CLASS Test_ORM_DBF
    // Más pruebas de Where

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.T., 'PESO'=>75},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'David', 'NACIMIENTO'=>d"2001/10/15", 'CASADO'=>.F., 'PESO'=>40},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Pedro', 'NACIMIENTO'=>d"1991/01/20", 'CASADO'=>.T., 'PESO'=>105},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Ana',   'NACIMIENTO'=>d"2005/12/02", 'CASADO'=>.F., 'PESO'=>81};
                        })

    ::Assert:equals( 3, oTestFicha:Where( {;
                                           {'CODIGO', '>=', '222'},;
                                           {'CODIGO', '<=', '444'};
                                          }):Get():Len() )

    ::Assert:equals( 3, oTestFicha:Where( 'CODIGO', '>=', '222' ):Where( 'CODIGO', '<=', '444'):Get():Len() )                                          

    ::Assert:equals( 1, oTestFicha:Where( {;
                                           {'CODIGO', '>', '222'},;
                                           {'CODIGO', '<', '444'};
                                          }):Get():Len() )
    
    ::Assert:equals( 1, oTestFicha:Where( {;
                                           {'CODIGO', '>=', '222'},;
                                           {'CODIGO', '<=', '444'},;
                                           {'CASADO', .T.};
                                          }):Get():Len() )

Return ( Nil )                                          
                                          


METHOD Test_SelecT() CLASS Test_ORM_DBF
    // Probando el Select

    Local oTestFicha := TestFicha():New()


    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })
     
    ::Assert:equals( 2, oTestFicha:Select( 'CODIGO', 'NOMBRE' ):All( TORM_HASH ):Get( 1 ):Len(),oTestFicha:__oReturn:LogToString() )
    ::Assert:equals( 2, oTestFicha:Select( 'CODIGO', 'NOMBRE' ):Where('CASADO',.F.):Get( TORM_HASH ):Len() )
    ::Assert:equals( 1, oTestFicha:Select( 'CODIGO' ):Where('CASADO',.F.):Get( TORM_HASH ):Get(1):Len(), 'testea el select de 1 sola columna pasado por cadena' )
    ::Assert:equals( 1, oTestFicha:Select( { 'CODIGO' } ):Where('CASADO',.F.):Get( TORM_HASH ):Get(1):Len(), 'testea el select de 1 sola columna pasado por array' )
    ::Assert:equals( 26, oTestFicha:Select():Get( TORM_HASH ):Get( 1 ):Len() )
    ::Assert:equals( '111', oTestFicha:Select( 'CODIGO', 'NOMBRE' ):All( TORM_HASH ):Get( 1 )['CODIGO']:Alltrim() )
    ::Assert:Arrayequals( {'CODIGO','NOMBRE'}, hb_HKeys ( oTestFicha:Select( 'CODIGO', 'NOMBRE' ):All( TORM_HASH ):Get( 1 ) ))
    ::Assert:Arrayequals( {'NOMBRE','CODIGO'}, hb_HKeys ( oTestFicha:Select( 'NOMBRE', 'CODIGO' ):All( TORM_HASH ):Get( 1 ) ))

Return ( Nil )

METHOD Test_SelecT_Alias() CLASS Test_ORM_DBF
    // Probando el select asignando Alias a los campos devueltos

    Local oTestFicha := TestFicha():New()
    Local hTestFicha := hb_Hash()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.F., 'PESO'=>75};
                        })
     
    ::Assert:equals( '111', oTestFicha:Select( 'CODIGO AS COD', 'NOMBRE' ):All( TORM_HASH ):Get( 1 )['COD']:Alltrim() )
    ::Assert:equals( 2, oTestFicha:Select( 'CODIGO AS COD', 'NOMBRE' ):All( TORM_HASH ):Get( 1 ):Len() )
    ::Assert:equals( 2, oTestFicha:Select( 'CODIGO', 'NOMBRE AS NOM' ):Where('CASADO',.F.):Get( TORM_HASH ):Len() )
    ::Assert:equals( 1, oTestFicha:Select( 'CODIGO AS COD' ):Where('CASADO',.F.):Get( TORM_HASH ):Get(1):Len() )
    ::Assert:equals( 1, oTestFicha:Select( { 'CODIGO AS COD' } ):Where('CASADO',.F.):Get( TORM_HASH ):Get(1):Len() )

    hTestFicha := oTestFicha:Select( 'CODIGO AS COD', 'NOMBRE AS NOM' ):All( TORM_HASH )
    ::Assert:equals( '222', hTestFicha:Get( 2 )[ 'COD' ]:Alltrim())
    ::Assert:equals( 'Jose', hTestFicha:Get( 2 )[ 'NOM' ]:Alltrim())

Return ( Nil )

METHOD Test_Select_InternalDbId() CLASS Test_ORM_DBF
    // Obteniendo mediante select el campo correspondiente a la ID interna, en DBF's es el recno, en SQL puede ser el ID pero es configurable

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79};
                        })
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    oTestficha:Select( 'CODIGO', 'NOMBRE', TORM_SELECT_INTERNALDBID ):Get()
    ::assert:equals( 2, oTestFicha:ToHashes():Get(2)[ TORM_SELECT_INTERNALDBID ] )

Return ( Nil )

METHOD Test_WhereIn() CLASS Test_ORM_DBF
    // Testeando WhereIn

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79};
                        })

    ::Assert:equals( 3, oTestFicha:WhereIn( 'CODIGO', {'222','666','444' } ) :Get():Len() )

Return ( Nil )

METHOD Test_LoadFromHash() CLASS Test_ORM_DBF
    // Cargando los datos al modelo a partir de un hash

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    ::assert:True( oTestFicha:LoadFromHash( { 'CODIGO' => '000', 'NOMBRE' => 'Julian', 'PESO' => 87 } ):Success )
    ::assert:equals( 'Julian', oTestFicha:NOMBRE )
    ::assert:True( oTestFicha:Save():Success )
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::assert:False( oTestFicha:LoadFromHash( { 'CODIGO' => '000', 'NOMBREEE' => 'Julian', 'PESO' => 87 } ):Success )
    ::assert:False( oTestFicha:LoadFromHash( { 'NOMBREEE' => 'Julian', 'PESO' => 87 } ):Success, 'Intentando asignar registro sin campo obligatorio' )

    ::assert:False( oTestFicha:LoadFromHash( "Esto no es un hash" ):Success )
    ::assert:False( oTestFicha:LoadFromHash( { 1,2,3,4,5 } ):Success )

Return ( Nil )

METHOD Test_LoadFromJson() CLASS Test_ORM_DBF
    // Cargando los datos al modelo a partir de un Json

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    ::assert:True( oTestFicha:LoadFromJson( '{"CODIGO": "000","NOMBRE": "Julian","PESO": 87}' ):Success )
    ::assert:equals( 'Julian', oTestFicha:NOMBRE )
    ::assert:True( oTestFicha:Save():Success )
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::assert:False( oTestFicha:LoadFromHash( '{"CODIGO": "000","NOMBREEE": "Julian","PESO": 87}' ):Success )
    ::assert:False( oTestFicha:LoadFromHash( '{"NOMBREEE": "Julian","PESO": 87}' ):Success, 'Intentando asignar registro sin campo obligatorio' )

    ::assert:False( oTestFicha:LoadFromHash( "Esto no es un JSON" ):Success )
    ::assert:False( oTestFicha:LoadFromHash( { 1,2,3,4,5 } ):Success )

Return ( Nil )

METHOD Test_LoadFromHashes() CLASS Test_ORM_DBF
    // Cargando los datos a la colección del modelo mediante un array de hash

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    ::assert:True( oTestFicha:LoadFromHashes({;
                                                {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                                                {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                                                {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                                                {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102},;
                                                {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                                                {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79};
                                            }):Success() )
    ::assert:equals( 6, oTestFicha:Len() )                                            
    ::assert:equals( '111', oTestFicha:CODIGO )
    oTestFicha:GoBottom()
    ::assert:equals( '666', oTestFicha:CODIGO )

Return ( Nil )

METHOD Test_LoadFromJsons() CLASS Test_ORM_DBF
    // Cargando los datos a la colección del modelo mediante un Json que contiene un array


    Local oTestFicha := TestFicha():New()
    Local jJson := ''
    jJson += '['
    jJson += '{"CODIGO":"111", "NOMBRE":"Juan",  "NACIMIENTO":"1985/12/24", "CASADO":1, "PESO":85},'
    jJson += '{"CODIGO":"222", "NOMBRE":"Jose",  "NACIMIENTO":"1975/11/30", "CASADO":0, "PESO":92},'
    jJson += '{"CODIGO":"333", "NOMBRE":"Maria", "NACIMIENTO":"1965/01/15", "CASADO":1, "PESO":45},'
    jJson += '{"CODIGO":"444", "NOMBRE":"Pepe",  "NACIMIENTO":"1993/04/25", "CASADO":0, "PESO":102},'
    jJson += '{"CODIGO":"555", "NOMBRE":"Rosa",  "NACIMIENTO":"2005/01/05", "CASADO":1, "PESO":81},'
    jJson += '{"CODIGO":"666", "NOMBRE":"Julio", "NACIMIENTO":"1998/02/10", "CASADO":0, "PESO":79}'
    jJson += ']'

    oTestFicha:DropTable()
    ::assert:True( oTestFicha:LoadFromJsons( jJson ):Success() )
    ::assert:equals( 6, oTestFicha:Len() )                                            
    ::assert:equals( '111', oTestFicha:CODIGO )
    oTestFicha:GoBottom()
    ::assert:equals( '666', oTestFicha:CODIGO )

Return ( Nil )

METHOD Test_ToHash() CLASS Test_ORM_DBF
    // Devolviendo la info del modelo en un hash

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79};
                        })
    oTestFicha:End()
    
    ::assert:equals( 'Maria', TestFicha():New( '333' ):ToHash()['NOMBRE']:Alltrim() )

Return ( Nil )

METHOD Test_ToArray() CLASS Test_ORM_DBF
    // Devolviendo la info del modelo en un hash

    Local oTestFicha := TestFicha():New()
    Local aArray := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79};
                        })
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    oTestFicha:All()
    aArray := oTestFicha:ToArray()
    
    ::assert:equals( 6, aArray:Len() )
    ::assert:equals( '444',         aArray[4,1]:Alltrim() )
    ::assert:equals( 'Julio',       aArray[6,2]:Alltrim() )
    ::assert:equals( d"1985/12/24", aArray[1,3] )
    ::assert:equals( .T.,           aArray[3,4] )
    ::assert:equals( 81,            aArray[5,5] )


Return ( Nil )


METHOD Test_ToJson() CLASS Test_ORM_DBF
    // Devolviendo la info del modelo en un Json

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79};
                        })
    oTestFicha:End()
    
    ::assert:True( HB_ISCHAR( TestFicha():New( '333' ):ToJson():Alltrim() ) )

Return ( Nil )

METHOD Test_NewParams() CLASS Test_ORM_DBF
    // Probando el constructor con parámetros

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79};
                        })
    oTestFicha:End()
    
    ::assert:equals( 'Maria', TestFicha():New( '333' ):NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_LoadFromSource() CLASS Test_ORM_DBF
    // Cargando el modelo a partir de un origen de datos externo

    Local oTestFicha := TestFicha():New()
    Local cAlias     := 'TestFicha'
    Local cDbfFile   := '.\db\TestFichas'

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79};
                        })
    oTestFicha:End()

    dbUseArea( .t., 'DBFCDX', cDbfFile, cAlias, .t., .f. )
    ordListAdd( cDbfFile )

    (cAlias)->(DbSeek('333'))
    oTestFicha:LoadFromSource( cAlias )

    ::assert:equals( 'Maria', oTestFicha:NOMBRE:Alltrim() )
    (cAlias)->(DbCloseArea())

Return ( Nil )

METHOD Test_LoadMultipleFromSource() CLASS Test_ORM_DBF
    // Cargando la colección del modelo a partir de un origen externo de datos

    Local oTestDocLin := TestDocLin():New()
    Local cAlias     := 'TestDocLin'
    Local cDbfFile   := '.\db\TestDocLins'

    oTestDocLin:DropTable()
    oTestDocLin:Insert({;
                        {'SERIE'=>1, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART1'},;
                        {'SERIE'=>2, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART2'},;
                        {'SERIE'=>1, 'NUMERO'=>2, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART3'},;
                        {'SERIE'=>2, 'NUMERO'=>2, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART4'},;
                        {'SERIE'=>1, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART5'};
    })
    oTestdocLin:End()

    oTestDocLin := TestDocLin():New()
    dbUseArea( .t., 'DBFCDX', cDbfFile, cAlias, .t., .f. )
    ordListAdd( cDbfFile )

    oTestDocLin:LoadMultipleFromSource( MDBFSEek():New( cAlias, TIndexMultiple():New( { 'SERIE' => { 1, 4 }, 'NUMERO' => { 1, 6 } }), 'Str(SERIE,4)+Str(NUMERO,6)' ) )
    ::assert:equals( 2, oTestDocLin:Len() )

    oTestDocLin:LoadMultipleFromSource( MDBFSEek():New( cAlias, TIndexMultiple():New( { 'SERIE' => { 2, 4 }, 'NUMERO' => { 1, 6 } }), 'Str(SERIE,4)+Str(NUMERO,6)' ) )
    ::assert:equals( 1, oTestDocLin:Len() )

    oTestDocLin:LoadMultipleFromSource( MDBFSEek():New( cAlias, TIndexMultiple():New( { 'SERIE' => { 3, 4 }, 'NUMERO' => { 1, 6 } }), 'Str(SERIE,4)+Str(NUMERO,6)' ) )
    ::assert:equals( 0, oTestDocLin:Len() )

    (cAlias)->(DbCloseArea())

Return ( Nil )

METHOD Test_PutToSource() CLASS Test_ORM_DBF
    // Guarda la información de un modelo en un origen externo de datos

    Local oTestFicha := TestFicha():New()
    Local cAlias     := 'TestFicha'
    Local cDbfFile   := '.\db\TestFichas'

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79};
                        })
    oTestFicha:End()

    dbUseArea( .t., 'DBFCDX', cDbfFile, cAlias, .t., .f. )
    ordListAdd( cDbfFile )

    oTestFicha := TestFicha():New()
    (cAlias)->(DbSeek('333'))
    oTestFicha:LoadFromSource( cAlias )
    oTestFicha:NOMBRE := 'MariaModificada'
    oTestFicha:PutToSource( cAlias )
    (cAlias)->(DbCloseArea())
    oTestFicha:End()

    oTestFicha := TestFicha():New( '333' )
    ::assert:equals( 'MariaModificada', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:End()

Return ( Nil )

METHOD Test_PutMultipleToSource() CLASS Test_ORM_DBF
    // Guarda la información que contiene la colección del modelo en un origen externo de datos.


    Local oTestDocLin := TestDocLin():New()
    Local cAlias     := 'TestDocLin'
    Local cDbfFile   := '.\db\TestDocLins'

    oTestDocLin:DropTable()
    oTestDocLin:Insert({;
                        {'SERIE'=>1, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART1'},;
                        {'SERIE'=>2, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART2'},;
                        {'SERIE'=>1, 'NUMERO'=>2, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART3'},;
                        {'SERIE'=>2, 'NUMERO'=>2, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART4'},;
                        {'SERIE'=>1, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART5'},;
                        {'SERIE'=>1, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART6'};
    })
    oTestdocLin:End()

    oTestDocLin := TestDocLin():New()
    dbUseArea( .t., 'DBFCDX', cDbfFile, cAlias, .t., .f. )
    ordListAdd( cDbfFile )

    oTestDocLin:LoadMultipleFromSource( MDBFSEek():New( cAlias, TIndexMultiple():New( { 'SERIE' => { 1, 4 }, 'NUMERO' => { 1, 6 } }), 'Str(SERIE,4)+Str(NUMERO,6)' ) )
    ::Assert:equals( 3, oTestDocLin:Len() )

    oTestDocLin:GoTop()
    oTestDocLin:Skip()
    oTestDocLin:ARTICULO := 'ARTMODIFICADO'
    oTestDocLin:PutToSource( cAlias )
    oTestDocLin:End()
    (cAlias)->(DbCloseArea())

    oTestDocLin := TestDocLin():New()
    oTestDocLin:Where( 'STR(SERIE,4)+STR(NUMERO,6)', { 'SERIE' => 1, 'NUMERO' => 1 } ):Get()
    ::Assert:equals( 3, oTestDocLin:Len() )
    oTestDocLin:GoTop()
    ::assert:equals( 'ART1', oTestDocLin:ARTICULO:Alltrim() )
    oTestDocLin:Skip()
    ::assert:equals( 'ARTMODIFICADO', oTestDocLin:ARTICULO:Alltrim() )
    oTestDocLin:End()

Return ( Nil )

METHOD Test_OrderBy() CLASS Test_ORM_DBF
    // Probando las colecciones ordenadas

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                        })
    oTestFicha:End()

    
    oTestFicha := TestFicha():New()
    aCollection:=oTestFicha:OrderBy( 'CODIGO' ):All( TORM_HASH )
    ::Assert:Equals( 6, aCollection:Len() )
    ::assert:equals( '111', aCollection:Get(1)['CODIGO']:Alltrim() )
    ::assert:equals( '666', aCollection:GetLast()['CODIGO']:Alltrim() )

    oTestFicha := TestFicha():New()
    aCollection:=oTestFicha:OrderBy( 'CODIGO' ):All( TORM_MODEL )
    ::Assert:Equals( 6, aCollection:Len() )
    ::assert:equals( '111', aCollection:Get(1):CODIGO:Alltrim() )
    ::assert:equals( '666', aCollection:GetLast():CODIGO:Alltrim() )

    oTestFicha := TestFicha():New()
    aCollection:=oTestFicha:OrderBy( 'CODIGO', TORM_DESC ):All( TORM_HASH )
    ::Assert:Equals( 6, aCollection:Len() )
    ::assert:equals( '666', aCollection:Get(1)['CODIGO']:Alltrim() )
    ::assert:equals( '111', aCollection:GetLast()['CODIGO']:Alltrim() )

Return ( Nil )

METHOD Test_Take() CLASS Test_ORM_DBF
    // Probando la limitación de registros al hacer un get

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                        })
    oTestFicha:End()

    oTestficha := TestFicha():New()

    ::assert:equals( 3, oTestFicha:Take( 3 ):Get():Len() )
    ::assert:equals( 6, oTestFicha:Take( 0 ):Get():Len() )
    ::assert:equals( 6, oTestFicha:Take( 10 ):Get():Len() )
    ::assert:equals( 0, oTestFicha:Take( -10 ):Get():Len() )
    ::assert:equals( 6, oTestFicha:Take( ):Get():Len() )
    ::assert:equals( 1, oTestFicha:Take( 1 ):Get():Len() )

    ::assert:equals( 1, oTestFicha:Where( 'CODIGO', '==', '111' ):Take( 2 ):Get():Len() )
    ::assert:equals( 2, oTestFicha:Where( 'PESO', '>=', 50 ):Take( 2 ):Get():Len() )
    ::assert:equals( 2, oTestFicha:Where( 'CODIGO', '>=', '111' ):Take( 2 ):Get():Len() )
    ::assert:equals( 2, oTestFicha:WhereIn( 'CODIGO', {'111','222','333','444' } ):Take( 2 ):Get():Len() )
    ::assert:equals( 4, oTestFicha:WhereIn( 'CODIGO', {'111','222','333','444' } ):Take( 4 ):Get():Len() )

Return ( Nil )    

METHOD Test_SetDefaultData() CLASS Test_ORM_DBF
    // Comprobar la asignación de los datos por defecto al crear un modelo nuevo

    Local oTestFichaDefault := TestFichaDefault():New()

    ::Assert:equals( 1, oTestFichaDefault:CODIGO )
    ::Assert:equals( 'por defecto', oTestFichaDefault:NOMBRE )

Return ( Nil )

METHOD Test_First_OneRecord() CLASS Test_ORM_DBF
    // Probar el método First en un origen con un solo registro

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92};
                      })
    oTestFicha:End()

    oTestficha := TestFicha():New()
    ::Assert:True( oTestFicha:First():Success )
    ::assert:equals( '222', oTestficha:CODIGO:alltrim() )
    oTestFicha:NOMBRE := 'modificado'
    oTestficha:Save()
    oTestficha:End()

    oTestficha := TestFicha():New('222')
    ::assert:equals( 'modificado', oTestficha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_Last_OneRecord() CLASS Test_ORM_DBF
    // Probar el método Last en un origen con un solo registro

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92};
                      })
    oTestFicha:End()

    oTestficha := TestFicha():New()
    ::Assert:True( oTestFicha:Last():Success )
    ::assert:equals( '222', oTestficha:CODIGO:alltrim() )
    oTestFicha:NOMBRE := 'modificado'
    oTestficha:Save()
    oTestficha:End()

    oTestficha := TestFicha():New('222')
    ::assert:equals( 'modificado', oTestficha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_First_MultiRecord() CLASS Test_ORM_DBF
    // Probar el método First en un origen con varios registros

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()

    oTestficha := TestFicha():New()
    ::Assert:True( oTestFicha:First():Success )
    ::assert:equals( '111', oTestficha:CODIGO:alltrim() )
    oTestFicha:NOMBRE := 'modificado'
    oTestficha:Save()
    oTestficha:End()

    oTestficha := TestFicha():New('111')
    ::assert:equals( 'modificado', oTestficha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_LoadLimits() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()

    oTestficha := TestFicha():New()
    ::Assert:True( oTestFicha:LoadLimits():Success )
    ::Assert:equals( 2, oTestFicha:Len() )
    oTestFicha:GoTop()
    ::assert:equals( '111', oTestficha:CODIGO:alltrim() )
    oTestFicha:GoBottom()
    ::assert:equals( '666', oTestficha:CODIGO:alltrim() )
    oTestFicha:End()


    oTestficha := TestFicha():New()
    ::Assert:True( oTestFicha:LoadLimits( 'NOMBRE' ):Success )
    oTestFicha:GoTop()
    ::assert:equals( '222', oTestficha:CODIGO:alltrim() )
    oTestFicha:GoBottom()
    ::assert:equals( '555', oTestficha:CODIGO:alltrim() )
    oTestFicha:End()

Return ( Nil )

METHOD Test_Last_MultiRecord() CLASS Test_ORM_DBF
    // Probar el método Last en un origen con varios registros

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()

    oTestficha := TestFicha():New()
    ::Assert:True( oTestFicha:Last():Success )
    ::assert:equals( '666', oTestficha:CODIGO:alltrim() )
    oTestFicha:NOMBRE := 'modificado'
    oTestficha:Save()
    oTestficha:End()

    oTestficha := TestFicha():New('666')
    ::assert:equals( 'modificado', oTestficha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_First_MultiRecord_Order() CLASS Test_ORM_DBF
    // Probar el método First en un origen con varios registros por un índice

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()

    oTestficha := TestFicha():New()
    ::Assert:True( oTestFicha:First( 'NOMBRE' ):Success )
    ::assert:equals( '222', oTestficha:CODIGO:alltrim() )
    oTestFicha:NOMBRE := 'modificado'
    oTestficha:Save()
    oTestficha:End()

    oTestficha := TestFicha():New('222')
    ::assert:equals( 'modificado', oTestficha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_Last_MultiRecord_Order() CLASS Test_ORM_DBF
    // Probar el método Last en un origen con varios registros por un índice

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()

    oTestficha := TestFicha():New()
    ::Assert:True( oTestFicha:Last( 'NOMBRE' ):Success )
    ::assert:equals( '555', oTestficha:CODIGO:alltrim() )
    oTestFicha:NOMBRE := 'modificado'
    oTestficha:Save()
    oTestficha:End()

    oTestficha := TestFicha():New('555')
    ::assert:equals( 'modificado', oTestficha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_First_LazyLoad() CLASS Test_ORM_DBF
    // Probar el lazyload

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92};
                      })
    oTestFicha:End()

    oTestficha := TestFicha():New():LazyLoad()

    ::Assert:True( oTestFicha:First():Success )
    ::assert:equals( '222', oTestficha:CODIGO:alltrim() )

Return ( Nil )

METHOD Test_Last_LazyLoad() CLASS Test_ORM_DBF
    // Probar el lazyload

    Local oTestFicha := TestFicha():New()
    Local aCollection := Array( 0 )

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92};
                      })
    oTestFicha:End()

    oTestficha := TestFicha():New():LazyLoad()

    ::Assert:True( oTestFicha:Last():Success )
    ::assert:equals( '222', oTestficha:CODIGO:alltrim() )

Return ( Nil )

METHOD Test_ForeignKey_Complex() CLASS Test_ORM_DBF
    // Probar el borrado de un modelo y que elimina el modelo relacionado con foreignkey

    Local oTestDoc := TestDoc():New()
    Local oTestDocLin := TestDocLin():New()

    oTestDoc:DropTable()
    ::Assert:Equals( 5, oTestDoc:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'FECHA'=>d"2021/05/12"},;
                                            {'SERIE'=>1,'NUMERO'=>2,'FECHA'=>d"2021/05/13"},;
                                            {'SERIE'=>1,'NUMERO'=>3,'FECHA'=>d"2021/05/14"},;
                                            {'SERIE'=>1,'NUMERO'=>4,'FECHA'=>d"2021/05/15"},;
                                            {'SERIE'=>1,'NUMERO'=>5,'FECHA'=>d"2021/05/16"};
                                        }))
    
    ::Assert:equals( 5, oTestDoc:RecCount() )

    oTestDocLin:DropTable()
    ::Assert:Equals( 15, oTestDocLin:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>2,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>2,'ARTICULO'=>'ART2'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'ARTICULO'=>'ART2'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'ARTICULO'=>'ART3'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'ARTICULO'=>'ART2'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'ARTICULO'=>'ART3'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'ARTICULO'=>'ART4'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART2'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART3'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART4'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'ARTICULO'=>'ART5'};
                                        }))

    ::Assert:equals( 15, oTestDocLin:RecCount() )                                        

    ::Assert:True( oTestDoc:Find( { 'SERIE' => 1, 'NUMERO' => 3 } ):Success() )
    ::Assert:equals( 1, oTestDoc:Delete() )
    ::Assert:False( oTestDoc:Find( { 'SERIE' => 1 , 'NUMERO' => 3 } ):Success() )
    ::Assert:equals( 4, oTestDoc:RecCount() )
    ::Assert:equals( 12, oTestDocLin:RecCount() )                                        

Return ( Nil )

METHOD Test_HasOne() CLASS Test_ORM_DBF
    // Probar la relación HasOne

    Local oTestFicha := TestFicha():New()
    Public oTestDoc := TestDoc():New()

    oTestDoc:DropTable()
    ::Assert:Equals( 5, oTestDoc:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'FECHA'=>d"2021/05/12",'TESTFICHA'=>'111'},;
                                            {'SERIE'=>1,'NUMERO'=>2,'FECHA'=>d"2021/05/13",'TESTFICHA'=>'222'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'FECHA'=>d"2021/05/14",'TESTFICHA'=>'333'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'FECHA'=>d"2021/05/15",'TESTFICHA'=>'444'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'FECHA'=>d"2021/05/16",'TESTFICHA'=>'555'};
                                        }))

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()

    ::Assert:True( ( oTestDoc := TestDoc():New( { 'SERIE' => 1, 'NUMERO' => 3 } ):Ficha() ):Success )
    ::Assert:equals( 'Maria', oTestDoc:oFicha:NOMBRE:Alltrim() )

    ::Assert:True( ( oTestDoc := TestDoc():New( { 'SERIE' => 1, 'NUMERO' => 5 } ):Ficha() ):Success )
    ::Assert:equals( 'Rosa', oTestDoc:oFicha:NOMBRE:Alltrim() )

    oTestDoc := TestDoc():New():Ficha()
    oTestDoc:All()
    
    ::Assert:equals( 5, oTestDoc:Len() )
    ::Assert:equals( 'Juan', oTestDoc:oFicha:NOMBRE:Alltrim() )
    oTestDoc:GoTop()
    ::Assert:equals( 'Juan', oTestDoc:oFicha:NOMBRE:Alltrim() )
    oTestDoc:Skip()
    ::Assert:equals( 'Jose', oTestDoc:oFicha:NOMBRE:Alltrim() )
    oTestDoc:Skip( 2 )
    ::Assert:equals( 'Pepe', oTestDoc:oFicha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_HasOne_deep() CLASS Test_ORM_DBF
    // Probar la relación HasOne con profundidad de más de una relación

    Local oCliente := Cliente():New()
    Local oFormaPAgo := FormaPago():New()
    Local oTipoPago := TipoPago():New()

    oCliente:DropTable()
    oFormaPAgo:DropTable()
    oTipoPago:DropTable()

    ::assert:equals(6,oCliente:Insert({;
        {'CODIGO'=>'01','CODFPAG'=>1},;
        {'CODIGO'=>'02','CODFPAG'=>2},;
        {'CODIGO'=>'03','CODFPAG'=>3},;
        {'CODIGO'=>'04','CODFPAG'=>1},;
        {'CODIGO'=>'05','CODFPAG'=>2},;
        {'CODIGO'=>'06','CODFPAG'=>3};
    }))
    ::assert:true(oCliente:Success)

    ::assert:equals(3,oFormaPAgo:Insert({;
        {'CODIGO'=>1,'NOMBRE'=>'Efectivo','CODTPAG'=>1},;
        {'CODIGO'=>2,'NOMBRE'=>'Tarjeta','CODTPAG'=>2},;
        {'CODIGO'=>3,'NOMBRE'=>'transferencia','CODTPAG'=>2};
    }))
    ::assert:true(oFormaPAgo:Success)

    ::assert:equals(2,oTipoPago:Insert({;
        {'CODIGO'=>1,'NOMBRE'=>'metalico'},;
        {'CODIGO'=>2,'NOMBRE'=>'NO metalico'};
    }))
    ::assert:true(oTipoPago:Success)

    oCliente:End()
    oFormaPAgo:End()
    oTipoPago:End()
   
    oCliente := Cliente():New('03'):Formapago()

    ::assert:equals(3,oCliente:CODFPAG)
    ::assert:equals(3,oCliente:oFormapago:CODIGO)
    ::assert:equals(2,oCliente:oFormapago:oTipoPago:CODIGO)

Return ( Nil )


METHOD Test_HasOne_Select() CLASS Test_ORM_DBF
    //Probar HasOne con métodos que incluyen un select de campos en la relación y que se le pueden pasar por parámetro al método de la relación también.

    Local oTestDoc := TestDoc():New()
    Local oTestFicha := TestFicha():New()

    oTestDoc:DropTable()
    ::Assert:Equals( 5, oTestDoc:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'FECHA'=>d"2021/05/12",'TESTFICHA'=>'111'},;
                                            {'SERIE'=>1,'NUMERO'=>2,'FECHA'=>d"2021/05/13",'TESTFICHA'=>'222'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'FECHA'=>d"2021/05/14",'TESTFICHA'=>'333'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'FECHA'=>d"2021/05/15",'TESTFICHA'=>'444'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'FECHA'=>d"2021/05/16",'TESTFICHA'=>'555'};
                                        }))

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()

    ::Assert:True( ( oTestDoc := TestDoc():New( { 'SERIE' => 1, 'NUMERO' => 3 } ):Ficha_Nombre() ):Success )
    ::Assert:Arrayequals( {;
                            'SERIE'=>1,;
                            'NUMERO'=>3,;
                            'FECHA'=>d"2021/05/14",;
                            'TESTFICHA'=>'333       ',;
                            'TESTFICHA2'=>'          ',;
                            'NOMBRE'=>'Maria' + Space( 95 );
                          }, oTestDoc:ToHash() )                          

    ::Assert:True( ( oTestDoc := TestDoc():New( { 'SERIE' => 1, 'NUMERO' => 3 } ):Ficha() ):Success )
    ::Assert:Arrayequals( {;
                            'SERIE'=>1,;
                            'NUMERO'=>3,;
                            'FECHA'=>d"2021/05/14",;
                            'TESTFICHA'=>'333       ',;
                            'TESTFICHA2'=>'          ',;
                            'CODIGO'=>'333       ',;
                            'NOMBRE'=>'Maria' + Space( 95 ),;
                            'NACIMIENTO'=>d"1965/01/15",;
                            'CASADO'=>.T.,;
                            'PESO'=>45,;
                            'NOMBRE1'=>Space(100),;
                            'NOMBRE2'=>Space(100),;
                            'NOMBRE3'=>Space(100),;
                            'NOMBRE4'=>Space(100),;
                            'NOMBRE5'=>Space(100),;
                            'NOMBRE6'=>Space(100),;
                            'NOMBRE7'=>Space(100),;
                            'NOMBRE8'=>Space(100),;
                            'NOMBRE9'=>Space(100),;
                            'NOMBRE10'=>Space(100),;
                            'NOMBRE11'=>Space(100),;
                            'NOMBRE12'=>Space(100),;
                            'NOMBRE13'=>Space(100),;
                            'NOMBRE14'=>Space(100),;
                            'NOMBRE15'=>Space(100),;
                            'NOMBRE16'=>Space(100),;
                            'NOMBRE17'=>Space(100),;
                            'NOMBRE18'=>Space(100),;
                            'NOMBRE19'=>Space(100),;
                            'NOMBRE20'=>Space(100),;
                            'NOMBRE21'=>Space(100);
                            }, oTestDoc:ToHash() )

    ::Assert:True( ( oTestDoc := TestDoc():New( { 'SERIE' => 1, 'NUMERO' => 3 } ):Ficha( 'NOMBRE','PESO') ):Success )
    ::Assert:Arrayequals( {;
                            'SERIE'=>1,;
                            'NUMERO'=>3,;
                            'FECHA'=>d"2021/05/14",;
                            'TESTFICHA'=>'333       ',;
                            'TESTFICHA2'=>'          ',;
                            'NOMBRE'=>'Maria' + Space( 95 ),;
                            'PESO'=>45;
                          }, oTestDoc:ToHash() )


Return ( Nil )


METHOD Test_HasOne_Doble() CLASS Test_ORM_DBF
    // Probar el método hasone encadenado con más hasone

    Local oTestDoc := TestDoc():New()
    Local oTestFicha := TestFicha():New()
    Local oTestFicha2 := TestFicha2():New()

    oTestDoc:DropTable()
    ::Assert:Equals( 5, oTestDoc:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'FECHA'=>d"2021/05/12",'TESTFICHA'=>'111','TESTFICHA2'=>'R'},;
                                            {'SERIE'=>1,'NUMERO'=>2,'FECHA'=>d"2021/05/13",'TESTFICHA'=>'222','TESTFICHA2'=>'V'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'FECHA'=>d"2021/05/14",'TESTFICHA'=>'333','TESTFICHA2'=>'A'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'FECHA'=>d"2021/05/15",'TESTFICHA'=>'444','TESTFICHA2'=>'V'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'FECHA'=>d"2021/05/16",'TESTFICHA'=>'555','TESTFICHA2'=>'R'};
                                        }))

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()

    oTestFicha2:DropTable()
    oTestFicha2:Insert({;
                        {'CODIGO'=>'R','NOMBRE'=>'Rojo'},;
                        {'CODIGO'=>'A','NOMBRE'=>'Azul'},;
                        {'CODIGO'=>'V','NOMBRE'=>'Verde'};
                        })

    ::Assert:True( ( oTestDoc := TestDoc():New( { 'SERIE' =>  1, 'NUMERO' => 3 } ):Ficha():Ficha2() ):Success )
    ::Assert:equals( 'Maria', oTestDoc:oFicha:NOMBRE:Alltrim() )
    ::Assert:equals( 'Azul', oTestDoc:oFicha2:NOMBRE:Alltrim() )

    ::Assert:True( ( oTestDoc := TestDoc():New( { 'SERIE' => 1, 'NUMERO' => 5 } ):Ficha2() ):Success )
    ::Assert:equals( 'Rojo', oTestDoc:oFicha2:NOMBRE:Alltrim() )

    oTestDoc := TestDoc():New():Ficha():Ficha2()
    oTestDoc:All()
    ::Assert:equals( 5, oTestDoc:Len() )
    oTestDoc:GoTop()
    ::Assert:equals( 'Juan', oTestDoc:oFicha:NOMBRE:Alltrim() )
    ::Assert:equals( 'Rojo', oTestDoc:oFicha2:NOMBRE:Alltrim() )
    oTestDoc:Skip()
    ::Assert:equals( 'Jose', oTestDoc:oFicha:NOMBRE:Alltrim() )
    ::Assert:equals( 'Verde', oTestDoc:oFicha2:NOMBRE:Alltrim() )
    oTestDoc:Skip( 2 )
    ::Assert:equals( 'Pepe', oTestDoc:oFicha:NOMBRE:Alltrim() )
    ::Assert:equals( 'Verde', oTestDoc:oFicha2:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_HasOne_AllRelations() CLASS Test_ORM_DBF
    // Probar hasone con un método que incluye todas las relaciones hasone del modelo

    Local oTestDoc := TestDoc():New()
    Local oTestFicha := TestFicha():New()
    Local oTestFicha2 := TestFicha2():New()

    oTestDoc:DropTable()
    ::Assert:Equals( 5, oTestDoc:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'FECHA'=>d"2021/05/12",'TESTFICHA'=>'111','TESTFICHA2'=>'R'},;
                                            {'SERIE'=>1,'NUMERO'=>2,'FECHA'=>d"2021/05/13",'TESTFICHA'=>'222','TESTFICHA2'=>'V'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'FECHA'=>d"2021/05/14",'TESTFICHA'=>'333','TESTFICHA2'=>'A'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'FECHA'=>d"2021/05/15",'TESTFICHA'=>'444','TESTFICHA2'=>'V'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'FECHA'=>d"2021/05/16",'TESTFICHA'=>'555','TESTFICHA2'=>'R'};
                                        }))

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()

    oTestFicha2:DropTable()
    oTestFicha2:Insert({;
                        {'CODIGO'=>'R','NOMBRE'=>'Rojo'},;
                        {'CODIGO'=>'A','NOMBRE'=>'Azul'},;
                        {'CODIGO'=>'V','NOMBRE'=>'Verde'};
                        })

    ::Assert:True( ( oTestDoc := TestDoc():New( { 'SERIE' => 1, 'NUMERO' => 3 } ):AllRelations() ):Success )
    ::Assert:equals( 'Maria', oTestDoc:oFicha:NOMBRE:Alltrim() )
    ::Assert:equals( 'Azul', oTestDoc:oFicha2:NOMBRE:Alltrim() )

    oTestDoc := TestDoc():New():AllRelations()
    oTestDoc:All()
    ::Assert:equals( 5, oTestDoc:Len() )
    oTestDoc:GoTop()
    ::Assert:equals( 'Juan', oTestDoc:oFicha:NOMBRE:Alltrim() )
    ::Assert:equals( 'Rojo', oTestDoc:oFicha2:NOMBRE:Alltrim() )
    oTestDoc:Skip()
    ::Assert:equals( 'Jose', oTestDoc:oFicha:NOMBRE:Alltrim() )
    ::Assert:equals( 'Verde', oTestDoc:oFicha2:NOMBRE:Alltrim() )
    oTestDoc:Skip( 2 )
    ::Assert:equals( 'Pepe', oTestDoc:oFicha:NOMBRE:Alltrim() )
    ::Assert:equals( 'Verde', oTestDoc:oFicha2:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_HasMany_simpleindex1() CLASS Test_ORM_DBF

    Local oArticulo := Articulo():New()
    Local oTarifa := Tarifa():New()

    oArticulo:DropTable()

    ::assert:equals(15,oArticulo:Insert({;
        {'CODIGO'=>'A1','NOMBRE'=>'Articulo 1'},;
        {'CODIGO'=>'A2','NOMBRE'=>'Articulo 2'},;
        {'CODIGO'=>'A3','NOMBRE'=>'Articulo 3'},;
        {'CODIGO'=>'A4','NOMBRE'=>'Articulo 4'},;
        {'CODIGO'=>'A5','NOMBRE'=>'Articulo 5'},;
        {'CODIGO'=>'A6','NOMBRE'=>'Articulo 6'},;
        {'CODIGO'=>'A7','NOMBRE'=>'Articulo 7'},;
        {'CODIGO'=>'A8','NOMBRE'=>'Articulo 8'},;
        {'CODIGO'=>'A9','NOMBRE'=>'Articulo 9'},;
        {'CODIGO'=>'A10','NOMBRE'=>'Articulo 10'},;
        {'CODIGO'=>'A11','NOMBRE'=>'Articulo 11'},;
        {'CODIGO'=>'A12','NOMBRE'=>'Articulo 12'},;
        {'CODIGO'=>'A13','NOMBRE'=>'Articulo 13'},;
        {'CODIGO'=>'A14','NOMBRE'=>'Articulo 14'},;
        {'CODIGO'=>'A15','NOMBRE'=>'Articulo 15'};
    }))

    oArticulo:End()

    oTarifa:DropTable()

    ::assert:equals(15,oTarifa:Insert({;
        {'ARTICULO'=>'A1', 'PRECIO'=>11},;
        {'ARTICULO'=>'A1', 'PRECIO'=>12},;
        {'ARTICULO'=>'A1', 'PRECIO'=>13},;
        {'ARTICULO'=>'A1', 'PRECIO'=>14},;
        {'ARTICULO'=>'A2', 'PRECIO'=>21},;
        {'ARTICULO'=>'A2', 'PRECIO'=>22},;
        {'ARTICULO'=>'A2', 'PRECIO'=>23},;
        {'ARTICULO'=>'A2', 'PRECIO'=>24},;
        {'ARTICULO'=>'A3', 'PRECIO'=>31},;
        {'ARTICULO'=>'A3', 'PRECIO'=>32},;
        {'ARTICULO'=>'A3', 'PRECIO'=>33},;
        {'ARTICULO'=>'A3', 'PRECIO'=>34},;
        {'ARTICULO'=>'A1', 'PRECIO'=>15},;
        {'ARTICULO'=>'A2', 'PRECIO'=>25},;
        {'ARTICULO'=>'A3', 'PRECIO'=>35};
    }))

    oTarifa:End()

    oArticulo := Articulo():New('A2'):Tarifa()

    ::Assert:equals(5,oArticulo:oTarifa:Len())

    oArticulo:oTarifa:GoTop()
    ::Assert:equals( 21, oArticulo:oTarifa:PRECIO )
    oArticulo:oTarifa:Skip()
    ::Assert:equals( 22, oArticulo:oTarifa:PRECIO )
    oArticulo:oTarifa:Skip()
    ::Assert:equals( 23, oArticulo:oTarifa:PRECIO )
    oArticulo:oTarifa:Skip()
    ::Assert:equals( 24, oArticulo:oTarifa:PRECIO )
    oArticulo:oTarifa:Skip()
    ::Assert:equals( 25, oArticulo:oTarifa:PRECIO )

    oArticulo:oTarifa:Skip()
    ::Assert:True( oArticulo:oTarifa:Eof() )

    oArticulo:End()

Return ( Nil )    

METHOD Test_HasMany_simpleindex2() CLASS Test_ORM_DBF

    // TODO: Cuando se solucione la actualización de las relaciones hasmany en la iteración de la colección, este test tendría que funcionar

    /* Local oArticulo := Articulo():New()
    Local oTarifa := Tarifa():New()

    oArticulo:DropTable()

    ::assert:equals(15,oArticulo:Insert({;
        {'CODIGO'=>'A1','NOMBRE'=>'Articulo 1'},;
        {'CODIGO'=>'A2','NOMBRE'=>'Articulo 2'},;
        {'CODIGO'=>'A3','NOMBRE'=>'Articulo 3'},;
        {'CODIGO'=>'A4','NOMBRE'=>'Articulo 4'},;
        {'CODIGO'=>'A5','NOMBRE'=>'Articulo 5'},;
        {'CODIGO'=>'A6','NOMBRE'=>'Articulo 6'},;
        {'CODIGO'=>'A7','NOMBRE'=>'Articulo 7'},;
        {'CODIGO'=>'A8','NOMBRE'=>'Articulo 8'},;
        {'CODIGO'=>'A9','NOMBRE'=>'Articulo 9'},;
        {'CODIGO'=>'A10','NOMBRE'=>'Articulo 10'},;
        {'CODIGO'=>'A11','NOMBRE'=>'Articulo 11'},;
        {'CODIGO'=>'A12','NOMBRE'=>'Articulo 12'},;
        {'CODIGO'=>'A13','NOMBRE'=>'Articulo 13'},;
        {'CODIGO'=>'A14','NOMBRE'=>'Articulo 14'},;
        {'CODIGO'=>'A15','NOMBRE'=>'Articulo 15'};
    }))

    oArticulo:End()

    oTarifa:DropTable()

    ::assert:equals(15,oTarifa:Insert({;
        {'ARTICULO'=>'A1', 'PRECIO'=>11},;
        {'ARTICULO'=>'A1', 'PRECIO'=>12},;
        {'ARTICULO'=>'A1', 'PRECIO'=>13},;
        {'ARTICULO'=>'A1', 'PRECIO'=>14},;
        {'ARTICULO'=>'A2', 'PRECIO'=>21},;
        {'ARTICULO'=>'A2', 'PRECIO'=>22},;
        {'ARTICULO'=>'A2', 'PRECIO'=>23},;
        {'ARTICULO'=>'A2', 'PRECIO'=>24},;
        {'ARTICULO'=>'A3', 'PRECIO'=>31},;
        {'ARTICULO'=>'A3', 'PRECIO'=>32},;
        {'ARTICULO'=>'A3', 'PRECIO'=>33},;
        {'ARTICULO'=>'A3', 'PRECIO'=>34},;
        {'ARTICULO'=>'A1', 'PRECIO'=>15},;
        {'ARTICULO'=>'A2', 'PRECIO'=>25},;
        {'ARTICULO'=>'A3', 'PRECIO'=>35};
    }))

    oTarifa:End()
    
    oArticulo:=Articulo():New():Tarifa()

    oArticulo:All()

    ::Assert:equals(15,oArticulo:Len())

    oArticulo:GoTop()
    ::Assert:equals( 'A1', oArticulo:CODIGO:Alltrim() )

    ::assert:equals(  5, oArticulo:oTarifa:Len() ) */

Return ( Nil )

METHOD Test_HasMany() CLASS Test_ORM_DBF
    // Probar relación hasmany

    Local oTestDoc    := TestDoc():New()
    Local oTestDocLin := TestDocLin():New()
    Local oTestFicha  := TestFicha():New()


    oTestDoc:DropTable()
    ::Assert:Equals( 5, oTestDoc:Insert( {;
                                            {'SERIE'=>1,'NUMERO'=>1,'FECHA'=>d"2021/05/12",'TESTFICHA'=>'111'},;
                                            {'SERIE'=>1,'NUMERO'=>2,'FECHA'=>d"2021/05/13",'TESTFICHA'=>'222'},;
                                            {'SERIE'=>1,'NUMERO'=>3,'FECHA'=>d"2021/05/14",'TESTFICHA'=>'333'},;
                                            {'SERIE'=>1,'NUMERO'=>4,'FECHA'=>d"2021/05/15",'TESTFICHA'=>'444'},;
                                            {'SERIE'=>1,'NUMERO'=>5,'FECHA'=>d"2021/05/16",'TESTFICHA'=>'555'};
                                        }))

    oTestDocLin:DropTable()
    ::Assert:Equals( 8, oTestDocLin:Insert({;
                                            {'SERIE'=>1, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART1'},;
                                            {'SERIE'=>2, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART2'},;
                                            {'SERIE'=>1, 'NUMERO'=>2, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART3'},;
                                            {'SERIE'=>2, 'NUMERO'=>2, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART4'},;
                                            {'SERIE'=>1, 'NUMERO'=>1, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART5'},;
                                            {'SERIE'=>1, 'NUMERO'=>2, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART6'},;
                                            {'SERIE'=>1, 'NUMERO'=>2, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART7'},;
                                            {'SERIE'=>1, 'NUMERO'=>2, 'FECHA'=>d"2021/05/23", 'ARTICULO'=>'ART8'};
                                        }))

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio', 'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',  'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',  'NACIMIENTO'=>d"1993/04/25", 'CASADO'=>.F., 'PESO'=>102};
                      })
    oTestFicha:End()                                        

                                   
    oTestDoc := TestDoc():New( { 'SERIE' => 1, 'NUMERO' => 2 } ):Lineas(  )
    ::Assert:True( oTestdoc:Success() )
    ::assert:equals( 1, oTestDoc:SERIE )
    ::assert:equals( 2, oTestDoc:NUMERO )
    ::assert:equals( 4, oTestDoc:oLineas:Len() )
    oTestDoc:oLineas:GoTop()
    ::assert:equals( 'ART3', oTestDoc:oLineas:ARTICULO:Alltrim() )
    oTestDoc:oLineas:Skip()
    ::assert:equals( 'ART6', oTestDoc:oLineas:ARTICULO:Alltrim() )
    oTestDoc:oLineas:GoBottom()
    ::assert:equals( 'ART8', oTestDoc:oLineas:ARTICULO:Alltrim() )

    oTestDoc := TestDoc():New( { 'SERIE' => 1, 'NUMERO' => 2 } ):Lineas():Ficha()
    ::Assert:True( oTestdoc:Success() )
    ::assert:equals( 'Jose', oTestDoc:oFicha:NOMBRE:Alltrim() )
    oTestDoc:oLineas:GoTop()
    ::assert:equals( 'ART3', oTestDoc:oLineas:ARTICULO:Alltrim() )
    oTestDoc:oLineas:Skip()
    ::assert:equals( 'ART6', oTestDoc:oLineas:ARTICULO:Alltrim() )
    oTestDoc:oLineas:GoBottom()
    ::assert:equals( 'ART8', oTestDoc:oLineas:ARTICULO:Alltrim() )

Return ( Nil )                                        

METHOD Test_HasMany_Query() CLASS Test_ORM_DBF
    // Probar relación hasmany compleja mediante un query en el método hasmany

    Local oArticulo   := Articulo():New()
    Local oStock      := Stock():New()
    Local aArticulo   := Array( 0 )

    oArticulo:DropTable()
    ::Assert:equals( 6, oArticulo:Insert({;
                                            {'CODIGO'=>'ART1', 'NOMBRE'=>'Artículo 1' },;
                                            {'CODIGO'=>'ART2', 'NOMBRE'=>'Artículo 2' },;
                                            {'CODIGO'=>'ART3', 'NOMBRE'=>'Artículo 3' },;
                                            {'CODIGO'=>'ART4', 'NOMBRE'=>'Artículo 4' },;
                                            {'CODIGO'=>'ART5', 'NOMBRE'=>'Artículo 5' },;
                                            {'CODIGO'=>'ART6', 'NOMBRE'=>'Artículo 6' };
                                        }))
    oArticulo:End()                                        

    oStock:DropTable()
    ::assert:equals( 10, oStock:Insert({;
                                        { 'CODIGO' => 'ART1', 'ALMACEN' => '001', 'CANTIDAD' => 11},;
                                        { 'CODIGO' => 'ART1', 'ALMACEN' => '002', 'CANTIDAD' => 12},;
                                        { 'CODIGO' => 'ART1', 'ALMACEN' => '003', 'CANTIDAD' => 13},;
                                        { 'CODIGO' => 'ART2', 'ALMACEN' => '003', 'CANTIDAD' => 23},;
                                        { 'CODIGO' => 'ART2', 'ALMACEN' => '002', 'CANTIDAD' => 22},;
                                        { 'CODIGO' => 'ART2', 'ALMACEN' => '001', 'CANTIDAD' => 21},;
                                        { 'CODIGO' => 'ART4', 'ALMACEN' => '002', 'CANTIDAD' => 42},;
                                        { 'CODIGO' => 'ART5', 'ALMACEN' => '001', 'CANTIDAD' => 51},;
                                        { 'CODIGO' => 'ART5', 'ALMACEN' => '003', 'CANTIDAD' => 53},;
                                        { 'CODIGO' => 'ART5', 'ALMACEN' => '004', 'CANTIDAD' => 54};
                                    }), oStock:__oReturn:LogToString())
    oStock:End()

    ::assert:equals( 6, oArticulo := Articulo():New( ):StockAlmacen( '001' ):All( ):Len() )


    aArticulo := Articulo():New( ):Select('CODIGO AS COD','NOMBRE'):StockAlmacen( '001' ):StockAlmacen( '002' ):StockAlmacen( '003' ):All( TORM_HASH )
    ::assert:equals( 6, aArticulo:Len() )
    ::assert:equals( 'ART1', aArticulo:Get( 1 ):ValueOfKey( 'COD' ):Alltrim() )
    ::assert:equals( 'ART6', aArticulo:Get( 6 ):ValueOfKey( 'COD' ):Alltrim() )
    ::assert:equals( 13, aArticulo:Get( 1 ):ValueOfKey( 'STK003' ) )
    ::assert:equals( 53, aArticulo:Get( 5 ):ValueOfKey( 'STK003' ) )
    ::assert:equals( 22, aArticulo:Get( 2 ):ValueOfKey( 'STK002' ) )
    ::assert:equals( '002', aArticulo:Get( 2 ):ValueOfKey( 'ALM002' ):Alltrim() )

Return ( Nil )



METHOD Test_Offset() CLASS Test_ORM_DBF
    // probar offset en la carga de la colección

    Local oTestFicha := TestFicha():New()
    Local aDatas := Array( 0 )

    for nC := 1 to 10

        aAdD( aDatas, { 'CODIGO' => nC:Str():Zeros( 3 ) } )

    Next

    oTestFicha:DropTable()
    oTestFicha:Insert(aDatas)
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::Assert:equals( 10, oTestFicha:RecCount() )
    ::Assert:equals( 5, oTestFicha:OffSet(6):Get():Len() )
    ::Assert:equals( 0, oTestFicha:OffSet(20):Get():Len() )
    ::Assert:equals( 10, oTestFicha:OffSet(0):Get():Len() )
    ::Assert:equals( 10, oTestFicha:OffSet(1):Get():Len() )

Return ( Nil )

METHOD Test_Pagination() CLASS Test_ORM_DBF
    // probar la paginación de la colección

    Local oTestFicha := TestFicha():New()
    Local aDatas     := Array( 0 )
    Local nC         := 0

    for nC := 1 to 100

        aAdD( aDatas, { 'CODIGO' => nC:Str():Zeros( 3 ) } )

    Next

    
    oTestFicha:DropTable()
    oTestFicha:Insert(aDatas)
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::Assert:equals( 100, oTestFicha:RecCount() )

    oTestFicha:Pagination():SetRowsxPage( 10 )
    ::Assert:equals( 10, oTestFicha:Pagination():GetLastPageNumber() )

    oTestFicha:Pagination():Gotop()
    ::Assert:equals( 1, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( 10, oTestFicha:Len() )
    ::Assert:equals( '001', oTestFicha:CODIGO:Alltrim() )
    oTestficha:Skip()
    ::Assert:equals( '002', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '010', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():GoBottom()
    ::Assert:equals( 10, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '091', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '092', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '100', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():Gotop()
    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 2, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '011', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '012', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip(2)
    ::Assert:equals( '014', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '020', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 3, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '021', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip(5)
    ::Assert:equals( '026', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():PrevPage()
    ::Assert:equals( 2, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '011', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip(4)
    ::Assert:equals( '015', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '020', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():GoTop()
    ::Assert:equals( 1, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '001', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '010', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Pagination():PrevPage()
    ::Assert:equals( 1, oTestFicha:Pagination():GetActualPageNumber() )
    oTestFicha:GoTop()
    ::Assert:equals( '001', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '010', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():GoBottom()
    ::Assert:equals( 10, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '091', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 10, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '091', oTestFicha:CODIGO:Alltrim() )

Return ( Nil )

METHOD Test_Pagination_Refresh() CLASS Test_ORM_DBF
    // Probando la paginación refrescando los datos del origen solo de la página actual.

    Local oTestFicha := TestFicha():New()
    Local aDatas     := Array( 0 )
    Local nC         := 0

    for nC := 1 to 100

        aAdD( aDatas, { 'CODIGO' => nC:Str():Zeros( 3 ) } )

    Next

    
    oTestFicha:DropTable()
    oTestFicha:Insert(aDatas)
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::Assert:equals( 100, oTestFicha:RecCount() )

    oTestFicha:Pagination():SetRowsxPage( 10 )
    ::Assert:equals( 10, oTestFicha:Pagination():GetLastPageNumber() )

    oTestFicha:Pagination():Gotop()
    oTestFicha:Pagination():Refresh()
    ::Assert:equals( 1, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( 10, oTestFicha:Len() )
    ::Assert:equals( '001', oTestFicha:CODIGO:Alltrim() )
    oTestficha:Skip()
    ::Assert:equals( '002', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '010', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():GoBottom()
    oTestFicha:Pagination():Refresh()
    ::Assert:equals( 10, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '091', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '092', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '100', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():Gotop()
    oTestFicha:Pagination():NextPage()
    oTestFicha:Pagination():Refresh()
    ::Assert:equals( 2, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '011', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '012', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip(2)
    ::Assert:equals( '014', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '020', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():NextPage()
    oTestFicha:Pagination():Refresh()
    ::Assert:equals( 3, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '021', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip(5)
    ::Assert:equals( '026', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():PrevPage()
    oTestFicha:Pagination():Refresh()
    ::Assert:equals( 2, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '011', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip(4)
    ::Assert:equals( '015', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '020', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():GoTop()
    oTestFicha:Pagination():Refresh()
    ::Assert:equals( 1, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '001', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '010', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Pagination():PrevPage()
    oTestFicha:Pagination():Refresh()
    ::Assert:equals( 1, oTestFicha:Pagination():GetActualPageNumber() )
    oTestFicha:GoTop()
    ::Assert:equals( '001', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '010', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():GoBottom()
    oTestFicha:Pagination():Refresh()
    ::Assert:equals( 10, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '091', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Pagination():NextPage()
    oTestFicha:Pagination():Refresh()
    ::Assert:equals( 10, oTestFicha:Pagination():GetActualPageNumber() )
    ::Assert:equals( '091', oTestFicha:CODIGO:Alltrim() )


Return ( Nil )

METHOD Test_Pagination_OrderBy_PrimaryKey() CLASS Test_ORM_DBF
    // probando la paginación con un orden, en este caso la llave primaria

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio',   'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69},;
                        {'CODIGO'=>'000', 'NOMBRE'=>'David',   'NACIMIENTO'=>d"1994/05/22", 'CASADO'=>.T., 'PESO'=>72},;
                        {'CODIGO'=>'888', 'NOMBRE'=>'Elena',   'NACIMIENTO'=>d"1995/06/23", 'CASADO'=>.F., 'PESO'=>48},;
                        {'CODIGO'=>'999', 'NOMBRE'=>'Karina',  'NACIMIENTO'=>d"1996/07/24", 'CASADO'=>.F., 'PESO'=>110},;
                        {'CODIGO'=>'777', 'NOMBRE'=>'Antonia', 'NACIMIENTO'=>d"1997/08/25", 'CASADO'=>.T., 'PESO'=>78},;
                      })
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::Assert:equals( 10, oTestFicha:RecCount() )

    oTestFicha:OrderBy( 'CODIGO' )

    oTestFicha:Pagination():SetRowsxPage( 3 )
    ::Assert:equals( 4, oTestFicha:Pagination():GetLastPageNumber() )

    oTestFicha:Pagination():Gotop()
    ::Assert:equals( 3, oTestFicha:Len() )
    ::Assert:equals( '000', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '111', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '222', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 3, oTestFicha:Len() )
    ::Assert:equals( '333', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '444', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '555', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 3, oTestFicha:Len() )
    ::Assert:equals( '666', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '777', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '888', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 1, oTestFicha:Len() )
    ::Assert:equals( '999', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():GoBottom()
    ::Assert:equals( 1, oTestFicha:Len() )
    ::Assert:equals( '999', oTestFicha:CODIGO:Alltrim() )

Return ( Nil )


METHOD Test_Pagination_OrderBy_Other() CLASS Test_ORM_DBF
    // Probando la paginación con un orden diferente al primary key

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   // 4
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   // 5
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   // 8
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio',   'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;   // 6
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   // 10
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69},;   // 9
                        {'CODIGO'=>'000', 'NOMBRE'=>'David',   'NACIMIENTO'=>d"1994/05/22", 'CASADO'=>.T., 'PESO'=>72},;   // 2
                        {'CODIGO'=>'888', 'NOMBRE'=>'Elena',   'NACIMIENTO'=>d"1995/06/23", 'CASADO'=>.F., 'PESO'=>48},;   // 3
                        {'CODIGO'=>'999', 'NOMBRE'=>'Karina',  'NACIMIENTO'=>d"1996/07/24", 'CASADO'=>.F., 'PESO'=>110},;  // 7
                        {'CODIGO'=>'777', 'NOMBRE'=>'Antonia', 'NACIMIENTO'=>d"1997/08/25", 'CASADO'=>.T., 'PESO'=>78},;   // 1
                      })
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::Assert:equals( 10, oTestFicha:RecCount() )

    oTestFicha:OrderBy( 'NOMBRE' )

    oTestFicha:Pagination():SetRowsxPage( 3 )
    ::Assert:equals( 4, oTestFicha:Pagination():GetLastPageNumber() )

    oTestFicha:Pagination():Gotop()
    ::Assert:equals( 3, oTestFicha:Len() )
    ::Assert:equals( 'Antonia', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( 'David', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( 'Elena', oTestFicha:NOMBRE:Alltrim() )

    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 3, oTestFicha:Len() )
    ::Assert:equals( 'Jose', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( 'Juan', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( 'Julio', oTestFicha:NOMBRE:Alltrim() )

    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 3, oTestFicha:Len() )
    ::Assert:equals( 'Karina', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( 'Maria', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( 'Pepe', oTestFicha:NOMBRE:Alltrim() )

    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 1, oTestFicha:Len() )
    ::Assert:equals( 'Rosa', oTestFicha:NOMBRE:Alltrim() )

    oTestFicha:Pagination():GoBottom()
    ::Assert:equals( 1, oTestFicha:Len() )
    ::Assert:equals( 'Rosa', oTestFicha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_Pagination_Where() CLASS Test_ORM_DBF
    // Probando la paginación con una condición where

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   // ---------
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   // 2
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   // 3
                        {'CODIGO'=>'666', 'NOMBRE'=>'Julio',   'NACIMIENTO'=>d"1998/02/10", 'CASADO'=>.F., 'PESO'=>79},;   // ---------
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   // 4
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69},;   // ---------
                        {'CODIGO'=>'000', 'NOMBRE'=>'David',   'NACIMIENTO'=>d"1994/05/22", 'CASADO'=>.T., 'PESO'=>72},;   // 1
                        {'CODIGO'=>'888', 'NOMBRE'=>'Elena',   'NACIMIENTO'=>d"1995/06/23", 'CASADO'=>.F., 'PESO'=>48},;   // ---------
                        {'CODIGO'=>'999', 'NOMBRE'=>'Karina',  'NACIMIENTO'=>d"1996/07/24", 'CASADO'=>.F., 'PESO'=>110},;  // ---------
                        {'CODIGO'=>'777', 'NOMBRE'=>'Antonia', 'NACIMIENTO'=>d"1997/08/25", 'CASADO'=>.T., 'PESO'=>78},;   // 5
                      })    
                      
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::Assert:equals( 10, oTestFicha:RecCount() )

    oTestFicha:Where( 'CASADO', .T. )

    oTestFicha:Pagination():SetRowsxPage( 3 )
    ::Assert:equals( 2, oTestFicha:Pagination():GetLastPageNumber() )

    oTestFicha:Pagination():Gotop()
    ::Assert:equals( 3, oTestFicha:Len() )
    ::Assert:equals( '000', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '111', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '333', oTestFicha:CODIGO:Alltrim() )

    oTestFicha:Pagination():NextPage()
    ::Assert:equals( 2, oTestFicha:Len() )
    ::Assert:equals( '555', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '777', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:True( oTestFicha:Eof() )

Return ( Nil )

METHOD Test_Query_Persistent() CLASS Test_ORM_DBF
    // Probando la persistencia del query en diferentes consultas

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69};   
                      })    
                      
    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::Assert:equals( 5, oTestFicha:RecCount() )
    
    oTestFicha:Where( 'CASADO', .T.):Get()
    ::Assert:equals( 3, oTestFicha:Len() )
    oTestFicha:Where( 'CASADO', .F.):Get()
    ::Assert:equals( 2, oTestFicha:Len() )

    oTestFicha := TestFicha():New()
    oTestFicha:Where( 'CASADO', .T.):Query():PersistentOn():Get()
    ::Assert:equals( 3, oTestFicha:Len() )
    oTestFicha:Where( 'CASADO', .F.):Get()
    ::Assert:equals( 0, oTestFicha:Len() )

    oTestFicha := TestFicha():New()
    oTestFicha:Where( 'CASADO', .T.):Query():PersistentOn():Get()
    ::Assert:equals( 3, oTestFicha:Len() )
    oTestFicha:Where( 'CODIGO', '>=', '222' ):Get()
    ::Assert:equals( 2, oTestFicha:Len() )

Return ( Nil )

METHOD Test_ModeloSinIndices() CLASS Test_ORM_DBF
    // Probando la carga del primer registro en un modelo sin índices
    
    Local oModeloSinIndices := ModeloSinIndices():New()

    oModeloSinIndices:DropTable()
    
    oModeloSinIndices:NOMBRE := 'Nombre'
    ::assert:True( oModeloSinIndices:Save():Success, oModeloSinIndices:__oReturn:LogToString() )
    ::assert:equals( 1, oModeloSinIndices:RecCount() )
    oModeloSinIndices:End()

    oModeloSinIndices := ModeloSinIndices():New():First()
    ::assert:equals( 'Nombre', oModeloSinIndices:NOMBRE:Alltrim() )

    oModeloSinIndices:All()

Return ( Nil )

METHOD Test_IsDirty() CLASS Test_ORM_DBF
    // Probando el estado de la modificación de los datos del modelo según su estado inicial

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69};   
                      })    
                      
    oTestFicha:End()

    oTestFicha := TestFicha():New( '222' )
    ::assert:false( oTestFicha:IsDirty( )) 
    oTestFicha:NOMBRE := 'Modificado'
    ::assert:True( oTestFicha:IsDirty( )) 

    oTestFicha := TestFicha():New()
    ::assert:True( oTestFicha:IsDirty( ) ) // La lógica es que devuelve .T. ya que el modelo no coincide con el existente en la persistencia ya que no existe

    oTestFicha:CODIGO := '666'
    oTestFicha:PESO   := 50
    oTestFicha:Save()
    ::assert:False( oTestFicha:IsDirty( ) )

    oTestFicha := TestFicha():New( '222' )
    ::assert:false( oTestFicha:IsDirty( 'CODIGO' ) )
    ::assert:false( oTestFicha:IsDirty( 'CODIGO', 'NOMBRE' ) )
    oTestFicha:NOMBRE := 'Modificado'
    ::assert:True( oTestFicha:IsDirty( 'CODIGO', 'NOMBRE' ) )
    oTestFicha:Save()
    ::assert:False( oTestFicha:IsDirty( 'CODIGO', 'NOMBRE' ) )

    oTestFicha := TestFicha():New( '222' )


Return ( Nil )

METHOD Test_WasDifferent() CLASS Test_ORM_DBF
    // Probando el estado de la modificación de los datos del modelo cargado según el origen de datos

    Local oTestFicha := TestFicha():New()
    Local oTestFicha2

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69};   
                      })    
                      
    oTestFicha:End()

    oTestFicha := TestFicha():New( '222' )
    ::Assert:False( oTestFicha:WasDifferent():Success() )

    oTestFicha:NOMBRE := 'Modificado'
    ::Assert:True( oTestFicha:WasDifferent():Success() )
    ::Assert:False( oTestFicha:WasDifferent( 'CODIGO' ):Success() )

    oTestFicha  := TestFicha():New( '444' )
    oTestFicha2 := TestFicha():New( '444' )
    oTestFicha2:NOMBRE := 'Modificado'
    ::Assert:False( oTestFicha:WasDifferent():Success() )
    oTestFicha2:Save()
    ::Assert:True( oTestFicha:WasDifferent():Success() )
    ::Assert:False( oTestFicha:WasDifferent( 'CODIGO' ):Success() )
    ::Assert:True( oTestFicha:WasDifferent( 'NOMBRE' ):Success() )
    ::Assert:True( oTestFicha:WasDifferent( 'CODIGO', 'NOMBRE' ):Success() )

Return ( Nil )

METHOD Test_Blank() CLASS Test_ORM_DBF
    // Probando la respuesta de un modelo en blanco

    ::Assert:Arrayequals( {;
                            'CODIGO' => Space(10),;
                            'NOMBRE' => Space(100),;
                            'NACIMIENTO' => d"0000/00/00",;
                            'CASADO' => .F.,;
                            'PESO' => 0,;
                            'NOMBRE1' => Space(100),;
                            'NOMBRE2' => Space(100),;
                            'NOMBRE3' => Space(100),;
                            'NOMBRE4' => Space(100),;
                            'NOMBRE5' => Space(100),;
                            'NOMBRE6' => Space(100),;
                            'NOMBRE7' => Space(100),;
                            'NOMBRE8' => Space(100),;
                            'NOMBRE9' => Space(100),;
                            'NOMBRE10' => Space(100),;
                            'NOMBRE11' => Space(100),;
                            'NOMBRE12' => Space(100),;
                            'NOMBRE13' => Space(100),;
                            'NOMBRE14' => Space(100),;
                            'NOMBRE15' => Space(100),;
                            'NOMBRE16' => Space(100),;
                            'NOMBRE17' => Space(100),;
                            'NOMBRE18' => Space(100),;
                            'NOMBRE19' => Space(100),;
                            'NOMBRE20' => Space(100),;
                            'NOMBRE21' => Space(100);
                          }, TestFicha():New():ToHash() )

    ::Assert:Arrayequals( {;
                            'SERIE'      => 0,;
                            'NUMERO'     => 0,;
                            'NOMBRE'     => Space(100),;
                            'PESO'       => 0;
                        },TestDoc():New():Select('SERIE','NUMERO'):Ficha( 'NOMBRE','PESO'):ToHash() )

Return ( Nil )

METHOD Test_CheckSource() CLASS Test_ORM_DBF
    // Testeando la integridad del origen de datos, esto al igual que droptable en un futuro puede ir en otra clase inyectando el modelo

    Local oTestFicha := TestFicha():New()
    Local xTemp      := Nil

    oTestFicha:DropTable()

    ::Assert:True( oTestFicha:CheckSource():Fail(), oTestFicha:__oReturn:LogToString() )

    xTemp := oTestFicha:__aFields[ 1 ]:nLenght
    oTestFicha:__aFields[ 1 ]:nLenght := 123
    ::Assert:False( oTestFicha:CheckSource():Success(), oTestFicha:__oReturn:LogToString() )
    oTestFicha:__aFields[ 1 ]:nLenght := xTemp

    xTemp := oTestFicha:__aFields[ 1 ]:nDecimals
    oTestFicha:__aFields[ 1 ]:nDecimals := 123
    ::Assert:False( oTestFicha:CheckSource():Success(), oTestFicha:__oReturn:LogToString() )
    oTestFicha:__aFields[ 1 ]:nDecimals := xTemp

    xTemp := oTestFicha:__aFields[ 1 ]:cType
    oTestFicha:__aFields[ 1 ]:cType := 'X'
    ::Assert:False( oTestFicha:CheckSource():Success(), oTestFicha:__oReturn:LogToString() )
    oTestFicha:__aFields[ 1 ]:cType := xTemp


Return ( Nil )

METHOD Test_Rendimiento() CLASS Test_ORM_DBF
    // Prueba de rendimiento con muchos registros

    Local oTestFicha := TestFicha():New()
    Local aDatas     := Array( 0 )
    Local nInit      := 0
    Local nEnd       := 0

    for nC := 1 to 10000

        aAdD( aDatas, { ;
                            'CODIGO' => nC:Str():Zeros( 5 ),;
                            'NOMBRE' => 'Nombre ' + nC:Str():Zeros( 5 ),;
                            'NACIMIENTO' => d"1970/01/01" + nC,;
                            'CASADO' => Iif( nC%2 = 0, .T., .F. ),;
                            'PESO' => 89;
                     } )

    Next

    oTestFicha:DropTable()
    oTestFicha:Insert(aDatas)
    oTestFicha:End()
    otestficha := TestFicha():New()
    oTestFicha:InitialBuffer:NoInitialBuffer()
    nInit := TimeToSec()
    ::assert:equals( 10000, oTestFicha:Select('CODIGO','NOMBRE'):All():Len() )
    nEnd := TimeToSec()
    ::assert:minor( 0.89, nEnd-nInit, 'All() de 10000 fichas' ) 

Return ( Nil )

METHOD Test_GetFieldsStr() CLASS Test_ORM_DBF
    // probar el método que devuelve los campos del modelo en un string separado por comas

    Local oTestFicha := TestFicha():New()

    ::assert:equals( 'CODIGO,NOMBRE,NACIMIENTO,CASADO,PESO,NOMBRE1,NOMBRE2,NOMBRE3,NOMBRE4,NOMBRE5,NOMBRE6,NOMBRE7,NOMBRE8,NOMBRE9,NOMBRE10,NOMBRE11,NOMBRE12,NOMBRE13,NOMBRE14,NOMBRE15,NOMBRE16,NOMBRE17,NOMBRE18,NOMBRE19,NOMBRE20,NOMBRE21', oTestFicha:GetFieldsStr())

Return ( Nil )

METHOD Test_DBFGetStructureStr() CLASS Test_ORM_DBF
    // probar el método que devuelve la configuración del modelo en un string

    Local oTestFicha := TestFicha():New()

    ::assert:equals( 'Código de la ficha,C,10,0',   oTestFicha:GetStructureStr( 'cDescription', 'cType', 'nLenght', 'nDecimals' ):Get( 1 ) )
    ::assert:equals( 'Nombre de la ficha,C,100,0',  oTestFicha:GetStructureStr( 'cDescription', 'cType', 'nLenght', 'nDecimals' ):Get( 2 ) )
    ::assert:equals( 'Fecha de nacimiento,D,8,0',   oTestFicha:GetStructureStr( 'cDescription', 'cType', 'nLenght', 'nDecimals' ):Get( 3 ) )
    ::assert:equals( 'Casado,L,1,0',                oTestFicha:GetStructureStr( 'cDescription', 'cType', 'nLenght', 'nDecimals' ):Get( 4 ) )
    ::assert:equals( 'Peso en Kg.,N,3,0',           oTestFicha:GetStructureStr( 'cDescription', 'cType', 'nLenght', 'nDecimals' ):Get( 5 ) )
    ::assert:equals( 'CODIGO,C,10,0,Código de la ficha,          ,[valid_required] si,[valid_lenght] 10',   oTestFicha:GetStructureStr():Get( 1 ) )

Return ( Nil )

METHOD Test_Autoincremental() CLASS Test_ORM_DBF

    Local oAutoInc := AutoInc():New():DropTable()
    
    oAutoInc := AutoInc():New()
    oAutoInc:Save()

    oAutoInc := AutoInc():New()
    oAutoInc:Save()

    oAutoInc := AutoInc():New()
    oAutoInc:Save()

    oAutoInc := AutoInc():New()
    oAutoInc:All()
    oAutoInc:GoTop()
    ::assert:equals( 1, oAutoInc:ID )
    oAutoInc:GoBottom()
    ::assert:equals( 3, oAutoInc:ID )

Return ( Nil )

METHOD Test_TORMDBF_SetPath() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()
    Local cOriginPath := TORMDBF():Path()

    oTestFicha:DropTable()
    ::Assert:False( hb_FileExists( TORMDBF():Path() + oTestFicha:TableName + '.dbf' ) )

    oTestFicha := TestFicha():New()
    oTestficha:CODIGO := '1'
    oTestFicha:PESO   := 20
    oTestFicha:Save()
    ::Assert:True( hb_FileExists( TORMDBF():Path() + oTestFicha:TableName + '.dbf' ) )

    FErase( oTestFicha:TableName + '.dbf' )
    ::Assert:False( hb_FileExists( '.\' + oTestFicha:TableName + '.dbf' ) )


    TORMDBF():SetPath( '.\' )
    oTestFicha := TestFicha():New()
    oTestficha:CODIGO := '1'
    oTestFicha:PESO   := 20
    oTestFicha:Save()
    ::Assert:True( hb_FileExists( '.\' + oTestFicha:TableName + '.dbf' ) )
    TORMDBF():SetPath( cOriginPath )

    oTestFicha := TestFicha():New()
    oTestFicha:DropTable()
    ::Assert:False( hb_FileExists( TORMDBF():Path() + oTestFicha:TableName + '.dbf' ) )

    oTestFicha := TestFicha():New()
    oTestficha:CODIGO := '1'
    oTestFicha:PESO   := 20
    oTestFicha:Save()
    ::Assert:True( hb_FileExists( TORMDBF():Path() + oTestFicha:TableName + '.dbf' ) )

Return ( Nil )

METHOD Test_UpdateCollection() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69};   
                      })    
                      
    oTestFicha:All()

    oTestFicha:GoTop()

    While !oTestFicha:Eof()

        oTestFicha:PESO := 100
        oTestFicha:Skip()

    Enddo

    oTestFicha:SaveCollection()

    oTestFicha:End()

    oTestFicha:New():All()

    oTestFicha:GoTop()
    ::assert:equals( '111', oTestFicha:CODIGO:Alltrim())
    ::assert:equals(   100, oTestFicha:PESO )

    oTestFicha:Skip()
    ::assert:equals( '222', oTestFicha:CODIGO:Alltrim() )
    ::assert:equals(   100, oTestFicha:PESO )

    oTestFicha:Skip()
    ::assert:equals( '333', oTestFicha:CODIGO:Alltrim() )
    ::assert:equals(   100, oTestFicha:PESO )

    oTestFicha:Skip()
    ::assert:equals( '444', oTestFicha:CODIGO:Alltrim() )
    ::assert:equals(   100, oTestFicha:PESO )

    oTestFicha:Skip()
    ::assert:equals( '555', oTestFicha:CODIGO:Alltrim() )
    ::assert:equals(   100, oTestFicha:PESO )

    oTestFicha:End()

Return ( Nil )

METHOD Test_Update() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69};   
                      })  

    oTestFicha:Update('noesunhash')
    ::assert:false( oTestFicha:Success )

    ::assert:equals( 5, oTestFicha:Update( { 'PESO' => 11 } ) )
    ::assert:equals( 1, oTestFicha:Where( 'CODIGO', '>=', '555'):Update( { 'PESO' => 10 } ) )
    oTestFicha:Find('555')
    ::assert:equals( 10, oTestFicha:PESO )
    oTestFicha:Find('444')
    ::assert:equals( 11, oTestFicha:PESO )

    oTestFicha := TestFicha():New()
    ::assert:equals( 1, oTestFicha:Where( 'CODIGO', '222'):Update( { 'PESO' => 22 } ) )
    oTestFicha:Find('222')
    ::assert:equals( 22, oTestFicha:PESO )

    oTestFicha := TestFicha():New()
    ::assert:equals( 1, oTestFicha:Where( {;
                                            {'CODIGO', '>=', '333' },;
                                            {'CASADO', .F. };
                                          });
                                   :Update( {;
                                             'PESO' => 99,;
                                             'NOMBRE' =>'lolo';
                                            } ) )
    oTestFicha:Find('444')
    ::assert:equals( 99, oTestFicha:PESO )
    ::assert:equals( 'lolo', oTestFicha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_UpdateOrWhere() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69};   
                      })  

    oTestFicha:Update('noesunhash')
    ::assert:false( oTestFicha:Success )

    ::assert:equals( 3, oTestFicha:Where( 'CODIGO', '>=', '555');
                                  :OrWhere( 'CASADO', .F.);
                                  :Update( { 'PESO' => 10 } ) )
    oTestFicha:Find('555')
    ::assert:equals( 10, oTestFicha:PESO )
    oTestFicha:Find('444')
    ::assert:equals( 10, oTestFicha:PESO )
    oTestFicha:Find('222')
    ::assert:equals( 10, oTestFicha:PESO )
    oTestFicha:Find('333')
    ::assert:equals( 45, oTestFicha:PESO )

    oTestFicha := TestFicha():New()
    ::assert:equals( 2, oTestFicha:Where( {;
                                            {'CODIGO', '>=', '333' },;
                                            {'CASADO', .F. };
                                          });
                                   :OrWhere( 'CODIGO', '111');
                                   :Update( {;
                                             'PESO' => 99,;
                                             'NOMBRE' =>'lolo';
                                            } ) )
    oTestFicha:Find('444')
    ::assert:equals( 99, oTestFicha:PESO )
    ::assert:equals( 'lolo', oTestFicha:NOMBRE:Alltrim() )

    oTestFicha:Find('111')
    ::assert:equals( 99, oTestFicha:PESO )
    ::assert:equals( 'lolo', oTestFicha:NOMBRE:Alltrim() )

Return ( Nil )

METHOD Test_Update_WithField() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69};   
                      })  

    oTestFicha:Update({ 'CODIGO' => { | | '0' + Alltrim( CODIGO ) } } )
    ::assert:true(oTestFicha:Find('0333'):Success)

Return ( Nil )

METHOD Test_Update_Fail() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()
    Local cAlias     := 'TestFicha'
    Local cDbfFile   := '.\db\TestFichas'

    oTestFicha:DropTable()

    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69};   
                      })  

    dbUseArea( .t., 'DBFCDX', cDbfFile, cAlias, .t., .f. )
    ordListAdd( cDbfFile )

    (cAlias)->(DbSeek('333'))
    (cAlias)->(dBRLock())
    ::assert:equals( 0, oTestFicha:Where( 'CODIGO','333'):Update( { 'PESO' => 11 } ) )
    ::assert:true ( oTestficha:fail )
    (cAlias)->(DbCloseArea())

Return ( Nil )

METHOD Test_Count() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()

    oTestFicha:Insert({;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',    'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;   
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',    'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;   
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',   'NACIMIENTO'=>d"1965/01/15", 'CASADO'=>.T., 'PESO'=>45},;   
                        {'CODIGO'=>'555', 'NOMBRE'=>'Rosa',    'NACIMIENTO'=>d"2005/01/05", 'CASADO'=>.T., 'PESO'=>81},;   
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pepe',    'NACIMIENTO'=>d"1993/04/21", 'CASADO'=>.F., 'PESO'=>69};   
                      })  

    ::assert:equals( 5, oTestFicha:Count() )

    oTestFicha:End()

    oTestFicha := TestFicha():New()
    ::assert:equals( 1, oTestFicha:Where( 'CODIGO', '>=', '555'):Count() )
    oTestFicha := TestFicha():New()
    ::assert:equals( 4, oTestFicha:Where( 'CODIGO', '<', '555'):Count() )
    oTestFicha := TestFicha():New()
    ::assert:equals( 5, oTestFicha:Where( 'CODIGO', '<=', '555'):Count() )
    oTestFicha := TestFicha():New()
    ::assert:equals( 0, oTestFicha:Where( 'CODIGO', '>', '555'):Count() )
    oTestFicha := TestFicha():New()
    ::assert:equals( 1, oTestFicha:Where( { ;
                                            { 'CODIGO', '555'},;
                                            { 'NOMBRE', 'Rosa'},;
                                            { 'CASADO', .T.};
                                            }):Count() )

Return ( Nil )

METHOD Test_DeleteandInsert() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    ::Assert:equals( 2,oTestFicha:Insert({;
                                          {'CODIGO'=>'111', 'NOMBRE'=>'Juan', 'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                                          {'CODIGO'=>'222', 'NOMBRE'=>'Jose', 'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92}}) )
    oTestFicha:End()

    oTestFicha := TestFicha():New()

    ::Assert:True( oTestFicha:DeleteandInsert( {'CODIGO','111'}, {'CODIGO'=>'555', 'NOMBRE'=>'Juan', 'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85} ):Success() )

    oTestFicha := TestFicha():New()
    ::assert:False( oTestFicha:Find('111'):Success())
    ::assert:True( oTestFicha:Find('222'):Success())
    ::assert:True( oTestFicha:Find('555'):Success())
    ::assert:equals( 2, oTestFicha:Count() )

Return ( Nil )

METHOD Test_GetORMFieldofDescription() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()

    ::assert:null( oTestFicha:GetORMFieldofDescription( 'noexiste' ))
    ::assert:equals( oTestFicha:GetORMFieldofDescription( 'Nombre de la ficha' ):cName , 'NOMBRE')

Return ( Nil )

METHOD Test_GetStructure() CLASS Test_ORM_DBF

    Local oTestFicha := TestFicha():New()

    ::assert:true( HB_ISARRAY( oTestFicha:GetStructure() ))

Return ( Nil )
