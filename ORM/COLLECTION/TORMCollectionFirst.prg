/* CLASS: TORMCollectionFirst 
    Busca un rergistro en la colección del modelo
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMCollectionFirst 

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD First( )

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
METHOD New( oTORMModel ) CLASS TORMCollectionFirst

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: First( )
    Busca el PRIMER registro en la colección
    
Devuelve:
    Modelo
*/
METHOD First( ) CLASS TORMCollectionFirst


    If ::oTORMModel:HasCollection() .And.;
       ::oTORMModel:Len() > 0

        TORMCollectionLoadFromCollection():New( ::oTORMModel ):Load( ::oTORMModel:__aCollection:Get( 1 ) )
        ::oTORMModel:__oReturn:Success := .T.

    Else

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_WARNING_MESSAGE[3][1], TORM_WARNING_MESSAGE[3][2], { ::oTORMModel:TableName() } ) )

    Endif

Return ( ::oTORMModel )