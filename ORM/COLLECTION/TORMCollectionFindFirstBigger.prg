/* CLASS: TORMCollectionFindFirstBigger 
    Busca la coincidencia mayor más cercana al valor buscado o el valor buscado si existe
    Por ejemplo, en un array : {1,3,5,7,9,11} si buscamos 4 devolverá 3
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMCollectionFindFirstBigger 

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Find( cOrder )

    PROTECTED:
        DATA oTORMModel AS OBJECT Init Nil


ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMCollectionFindFirstBigger

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Find()
    Busca la coincidencia mayor más cercana al valor buscado o el valor buscado si existe
    Por ejemplo, en un array : {1,3,5,7,9,11} si buscamos 4 devolverá 3
    
Devuelve:
    Modelo
*/
METHOD Find( cOrder ) CLASS TORMCollectionFindFirstBigger

    Local oRecord := ::oTORMModel:__FindFirstBigger( ::oTORMModel:__xFindValue, cOrder )

    If oRecord != Nil

        TORMCollectionLoadFromCollection():New( ::oTORMModel ):Load( oRecord )
        ::oTORMModel:__oReturn:Success := .T.

    Else

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_WARNING_MESSAGE[2][1], TORM_WARNING_MESSAGE[2][2], { ::oTORMModel:__xFindValue:Str(), ::oTORMModel:TableName() } ) )

    Endif

Return ( ::oTORMModel )

// Group: PROTECTED METHODS