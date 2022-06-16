/* CLASS: Test_ORM_DBF       
    
*/
#include 'hbclass.ch'
#include 'validation.ch'

CREATE CLASS Test_ORM_DBF_Collection FROM TestCase

    EXPORTED:
        DATA aCategories AS ARRAY INIT {'TODOS'}

        METHOD Test_All()
        METHOD test_ToHashes()
        METHOD test_ToHashes_Select()
        METHOD test_ToJsons()
        METHOD Test_First()
        METHOD Test_Last()
        METHOD Test_Eval()
        METHOD BeforeClass()

ENDCLASS

METHOD BeforeClass() CLASS Test_ORM_DBF_Collection

    Local oTestFicha := TestFicha():New()

    oTestFicha:DropTable()
    oTestFicha:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Juan',   'NACIMIENTO'=>d"1985/12/24", 'CASADO'=>.T., 'PESO'=>85},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Jose',   'NACIMIENTO'=>d"1975/11/30", 'CASADO'=>.F., 'PESO'=>92},;
                        {'CODIGO'=>'333', 'NOMBRE'=>'Maria',  'NACIMIENTO'=>d"1995/01/15", 'CASADO'=>.T., 'PESO'=>75},;
                        {'CODIGO'=>'444', 'NOMBRE'=>'Pedro',  'NACIMIENTO'=>d"2001/01/05", 'CASADO'=>.F., 'PESO'=>25},;
                        {'CODIGO'=>'555', 'NOMBRE'=>'Laura',  'NACIMIENTO'=>d"2003/10/01", 'CASADO'=>.T., 'PESO'=>76},;
                        {'CODIGO'=>'666', 'NOMBRE'=>'Lucas',  'NACIMIENTO'=>d"2005/01/15", 'CASADO'=>.F., 'PESO'=>46},;
                        {'CODIGO'=>'777', 'NOMBRE'=>'Sofia',  'NACIMIENTO'=>d"2010/09/20", 'CASADO'=>.T., 'PESO'=>102},;
                        {'CODIGO'=>'888', 'NOMBRE'=>'Daniel', 'NACIMIENTO'=>d"1970/03/12", 'CASADO'=>.F., 'PESO'=>66},;
                        {'CODIGO'=>'999', 'NOMBRE'=>'Sonia',  'NACIMIENTO'=>d"1992/05/15", 'CASADO'=>.T., 'PESO'=>38},;
                        {'CODIGO'=>'000', 'NOMBRE'=>'Pablo',  'NACIMIENTO'=>d"1989/02/07", 'CASADO'=>.F., 'PESO'=>79};
                        })
    oTestFicha:End()

Return ( Nil )

METHOD Test_Eval()

    Local oTestFicha := TestFicha():New()

    oTestFicha:All()
    oTestFicha:Eval( {|oTestFicha| oTestFicha:NOMBRE := 'Modificado'})

    ::Assert:true( oTestFicha:Eval( {|oTestFicha| oTestFicha:NOMBRE := 'Modificado'}) )

    oTestFicha:GoTop()
    ::Assert:equals( 'Modificado', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( 'Modificado', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( 'Modificado', oTestFicha:NOMBRE:Alltrim() )

    oTestFicha:SaveCollection()
    oTestFicha:End()

    oTestFicha:All()

    oTestFicha:GoTop()
    ::Assert:equals( 'Modificado', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( 'Modificado', oTestFicha:NOMBRE:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( 'Modificado', oTestFicha:NOMBRE:Alltrim() )


Return ( Nil ) 

METHOD Test_First()

    Local oTestficha := TestFicha():New()

    ::Assert:equals( oTestFicha:All():Len(), 10 )
    oTestFicha:First()
    ::assert:equals( '000', oTestFicha:CODIGO:Alltrim() )

Return ( Nil )

METHOD Test_Last()

    Local oTestficha := TestFicha():New()

    ::Assert:equals( oTestFicha:All():Len(), 10 )
    oTestFicha:Last()
    ::assert:equals( '999', oTestFicha:CODIGO:Alltrim() )

Return ( Nil )

METHOD Test_All() CLASS Test_ORM_DBF_Collection
    // Testea los desplazamientos por la colección del modelo.

    Local oTestficha := TestFicha():New()

    ::Assert:true( oTestficha:Empty() )

    ::Assert:equals( oTestFicha:All():Len(), 10 )
    ::Assert:equals( oTestFicha:Len(), 10 )

    oTestFicha:GoTop()
    ::Assert:equals( '000', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:equals( '111', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:GoBottom()
    ::Assert:equals( '999', oTestFicha:CODIGO:Alltrim() )
    oTestFicha:Skip()
    ::Assert:True( oTestFicha:Eof() )
    oTestFicha:GoTop()
    oTestFicha:Skip( -1 )
    ::Assert:True( oTestFicha:Bof() )
    oTestFicha:GoTop()
    ::Assert:equals( 1, oTestFicha:Position() )
    oTestFicha:Skip()
    ::Assert:equals( 2, oTestFicha:Position() )

Return ( Nil )

METHOD Test_ToHashes() CLASS Test_ORM_DBF_Collection
    // testea la conversión de la colección del modelo a un array de hash

    Local oTestficha := TestFicha():New()

    oTestFicha:All()

    ::assert:equals( 10, oTestFicha:ToHashes():Len() )
    ::assert:equals( 76, otestficha:ToHashes():get(6)['PESO'])

Return ( Nil )

METHOD Test_ToJsons() CLASS Test_ORM_DBF_Collection
    // testea la conversión de la colección del modelo a un Json

    Local oTestficha := TestFicha():New()

    oTestFicha:All()

    ::assert:true( HB_ISCHAR( oTestFicha:ToJsons() ) )

Return ( Nil )



METHOD Test_ToHashes_sELECT() CLASS Test_ORM_DBF_Collection
    // testea la conversión de la colección del modelo a un array de hash con una selección

    Local oTestficha := TestFicha():New()

    oTestFicha:Select('CODIGO','NOMBRE'):All()

    ::assert:equals( 2, otestficha:ToHashes():get(1):Len())
    ::assert:equals( 10, oTestFicha:ToHashes():Len() )

Return ( Nil )