/* CLASS: TORMDBFDropTble 
    Se encarga de el borrado del fichero .DBF correspondiente al modelo
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFDropTble FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD DropTable()

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil

        METHOD DeleteFile() 

ENDCLASS


// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. se le inyecta el modelo
    
    Parámetros:
        oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFDropTble

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: DropTable(  )
    Elimina el fichero .DBF correspondiente al modelo

    TODO: falla la asignación del oReturn:Log := rDbf:log cuando no puede borrar el fichero.

Devuelve:
    TReturn
*/
METHOD DropTable( ) CLASS TORMDBFDropTble

    Local oReturn := TReturn():New()
    Local rDbf
    Local rCdx
    Local rFpt

    rDbf := ::DeleteFile( ::Path() + ::oTORMModel:TableName() + '.dbf')
    
    If rDbf:Fail()

        oReturn:Success := .F.
        oReturn:Log     := rDbf

    Endif
    
    rCdx := ::DeleteFile( ::Path() + ::oTORMModel:TableName() + '.Cdx')
    
    If  rCdx:Fail()

        oReturn:Success := .F.
        oReturn:Log     := rCdx

    Endif

    rFpt := ::DeleteFile( ::Path() + ::oTORMModel:TableName() + '.Fpt')
    
    If rFpt:Fail()

        oReturn:Success := .F.
        oReturn:Log     := rFpt

    Endif
    
Return ( oReturn )

/* METHOD: DeleteFile( cFile )
Elimina el fichero físicamente
    
Parámetros:
        nombre del fichero a eliminar
        
Devuelve:
oReturn
*/
METHOD DeleteFile( cFile ) CLASS TORMDBFDropTble

    Local oReturn := TReturn():New()

    try 
    
        if hb_FileExists( cFile )
    
            ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[10][1], TORM_INFO_MESSAGE[10][2], {cFile} ) )
            oReturn:Success := fErase( cFile ) == 0
    
        Else
    
            oReturn:Success := .T.
            ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[17][1], TORM_ERROR_MESSAGE[17][2], { cFile} ))
    
        Endif
        
        
    catch oError
    
        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[18][1], TORM_ERROR_MESSAGE[18][2], { cFile , TTryCatchShowerror():New( oError ):ToString() }) )
        
    end
    
Return ( oReturn )