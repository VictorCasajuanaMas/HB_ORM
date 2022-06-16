/* CLASS: Test_Modelos
    
*/
#include 'hbclass.ch'
#include 'validation.ch'
#include 'TORM.ch'

CREATE CLASS Test_Modelos FROM TestCase

    EXPORTED:
        DATA aCategories AS ARRAY INIT {'TODOS'}

        METHOD Test_Iva_Create()
        METHOD Test_OpenAll()
        METHOD Test_Albccab_Create()
        METHOD Test_Articulo_Create()
        METHOD Test_TipIng_Create()

ENDCLASS

METHOD Test_Iva_Create() CLASS Test_Modelos

    Local oIva := mIVA():New()

    oIva:DropTable()
    oIva:CODIGO := 1
    oIva:Save()

Return ( Nil )

METHOD Test_Albccab_Create() CLASS Test_Modelos

    Local oAlbcCab := mAlbcCab():New()

    oAlbcCab:DropTable()
    oAlbcCab:NOMBRE := 'nuevo registro'
    oAlbcCab:Save()
    oAlbcCab:End()

Return ( Nil )

METHOD Test_OpenAll() CLASS Test_Modelos

    Local aFile
    Local oModel
    Local cFileName

    for each aFile in hb_DirScan( ".\INC_Create\prg","*.prg" )


        if Left( aFile[1],1 ) != '.'
            ? aFile[1]
            oModel := &(hb_FNameName( aFile[1] ) )():New()
            oModel:DropTable()
            ::Assert:False( hb_FileExists( TORMDBF():New():Path() + oModel:TableName() + '.dbf' ) )
            ::Assert:False( hb_FileExists( TORMDBF():New():Path() + oModel:TableName() + '.cdx' ) )
            oModel:Save()
            oModel:End() 
            ::Assert:True( hb_FileExists( TORMDBF():New():Path() + oModel:TableName() + '.dbf' ) )

            if oModel:__oIndexes:HasIndexes()

                ::Assert:True( hb_FileExists( TORMDBF():New():Path() + oModel:TableName() + '.cdx' ) )

            Else

                ::Assert:False( hb_FileExists( TORMDBF():New():Path() + oModel:TableName() + '.cdx' ) )

            Endif
            oModel:DropTable()

        Endif

    next

Return ( Nil )

METHOD Test_Articulo_Create() CLASS Test_Modelos

    Local oArticulo := mArticulo():New()

    oArticulo:CODIGO := '123'
    oArticulo:Save() 

Return ( Nil )

METHOD Test_TipIng_Create() CLASS Test_Modelos

    Local oTipIng := mTipIng():New()

    oTipIng:CODIGO := 1
    oTipIng:NOMBRE := 'Nombre'
    ::assert:True( oTipIng:Save():Success() ,oTipIng:__oReturn:LogToString() )

Return ( Nil )