/* CLASS: TORMCollectionLast 
    Devuelve el último registro de la colección
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMCollectionLast 

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Last( )

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
METHOD New( oTORMModel ) CLASS TORMCollectionLast

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Last( )
    Busca el ÚLTIMO registro en la colección
    
Devuelve:
    Modelo
*/
METHOD Last( ) CLASS TORMCollectionLast


    If ::oTORMModel:HasCollection() .And.;
       ::oTORMModel:Len() > 0

        TORMCollectionLoadFromCollection():New( ::oTORMModel ):Load( ::oTORMModel:__aCollection:Get( ::oTORMModel:__aCollection:Len() ) )
        ::oTORMModel:__oReturn:Success := .T.

    Else

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[4][1], TORM_ERROR_MESSAGE[4][2], { ::oTORMModel:TableName() } ) )

    Endif

Return ( ::oTORMModel )