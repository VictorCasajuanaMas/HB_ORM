/* CLASS: TORMDBFCreateTable
          Se encarga de crear los ficheros DBF
*/

#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFCreateTable FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Create()
        
    PROTECTED:
        DATA oTORMModel AS OBJECT Init Nil

ENDCLASS

METHOD New( oTORMModel ) CLASS TORMDBFCreateTable
    
    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Create()
    Crea el fichero .DBF en el storage indicando si se ha creado correctamente o no

Devuelve:
    TReturn
*/
METHOD Create() CLASS TORMDBFCreateTable

    Local cAlias := ::oTORMModel:TableName()
    Local cFile  := ::Path() + ::oTORMModel:TableName()
    
    try

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[3][1], TORM_INFO_MESSAGE[3][2], {cFile} ) )
        DbCreate( cFile, TORMDBFModelToStructure():New( ::oTORMModel ):Get() , 'DBFCDX', .t., cAlias )
        ::oTORMModel:__oReturn:Success := TORMDBFCreateIndex():New( ::oTORMModel ):Create():Success()
        ( cAlias )->(DbCloseArea() )

     catch oError

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_STrReplace(TORM_ERROR_MESSAGE[11][1], TORM_ERROR_MESSAGE[11][2], {cFile, TTryCatchShowerror():New( oError ):ToString()}) )

    end 

Return ( ::oTORMModel )