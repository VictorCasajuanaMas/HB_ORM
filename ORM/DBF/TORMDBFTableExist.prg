/* CLASS: TORMDBFTableExist
          Se encarga de gestionar la existencia del fichero .cExtension
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFTableExist FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) Constructor
        METHOD Exists()

    PROTECTED:
        DATA oTORMModel AS OBJECT Init Nil

ENDCLASS

METHOD New( oTORMModel ) CLASS TORMDBFTableExist

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: Exists( cExtension )
    Indica si el fichero con cExtension existe en el storage

Devuelve:
    Model
*/
METHOD Exists( cExtension ) CLASS TORMDBFTableExist

    Local cFile := ::Path() + ::oTORMModel:TableName() + '.' + cExtension

    
    try 

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[33][1], TORM_INFO_MESSAGE[33][2], {cFile} ) )
        ::oTORMModel:__oReturn:Success := hb_FileExists( cFile )
        
    catch oError

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTOMRModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[44][1], TORM_ERROR_MESSAGE[44][2], { cFile, TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( ::oTORMModel )