/* CLASS: TORMDBFCreateIndex
          Se encarga de crear los índices de los ficheros DBF
*/

#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFCreateIndex FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Create()
            DATA oTORMModel AS OBJECT Init Nil

    PROTECTED:

ENDCLASS

METHOD New( oTORMModel ) CLASS TORMDBFCreateIndex

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: Create()
    Crea el fichero de índices indicando si se ha creado correctamente o no
    
Devuelve:
    TReturn
*/
METHOD Create() CLASS TORMDBFCreateIndex

    Local oReturn := TReturn():New()
    Local oIndex  := Nil
    Local oError  := Nil
    Local cFile   := ::Path() + ::oTORMModel:TableName()

    for each oIndex in ::oTORMModel:__oIndexes:aIndex
        
        try 
            ::oTORMModel:LogWrite( hb_STrReplace( TORM_INFO_MESSAGE[05][1], TORM_INFO_MESSAGE[05][2], { cFile, oIndex:nNumeral:Str(), oIndex:cField } ) )
            ordCreate( cFile, oIndex:nNumeral:Str(), oIndex:cField )
            oReturn:Success := .T.

        catch oError
            oReturn:Success := .F.
            ::oTORMModel:LogWrite( oReturn:Log :=  hb_StrReplace( TORM_ERROR_MESSAGE[10][1], TORM_ERROR_MESSAGE[10][2], { ::oTORMModel:TableName() , TTryCatchShowerror():New( oError ):ToString() }))
            
        end

    next

Return ( oReturn )