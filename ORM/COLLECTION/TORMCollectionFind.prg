/* CLASS: TORMCollectionFind 
    Busca un rergistro en la colección del modelo
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMCollectionFind 

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Find( cOrder )

            DATA oTORMModel AS OBJECT Init Nil
    PROTECTED:

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMCollectionFind

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Find( cOrder )
    Busca el PRIMER registro en la colección

    Parámetros:
        cOrder - Campo del modelo a localizar
        
Devuelve:
    Modelo
*/
METHOD Find( cOrder ) CLASS TORMCollectionFind

    Local oRecord := ::oTORMModel:__Find( ::oTORMModel:__xFindValue, cOrder )

    If oRecord != Nil

        TORMCollectionLoadFromCollection():New( ::oTORMModel ):Load( oRecord )
        ::oTORMModel:__oReturn:Success := .T.

    Else

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_WARNING_MESSAGE[1][1], TORM_WARNING_MESSAGE[1][2], { ::oTORMModel:__xFindValue:Str(), ::oTORMModel:TableName() } ) )

    Endif

Return ( ::oTORMModel )