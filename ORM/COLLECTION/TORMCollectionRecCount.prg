/* CLASS: TORMCollectionRecCount 
    Devuelve el número de resgistros de la colección del modelo
*/
#include 'hbclass.ch'

CREATE CLASS TORMCollectionRecCount

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD RecCount()

            DATA oTORMModel AS OBJECT INIT Nil
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
METHOD New( oTORMModel ) CLASS TORMCollectionRecCount

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: RecCount()
    Devuelve el número de registros de la colección del modelo
    
Devuelve:
    TReturn
*/
METHOD RecCount() CLASS TORMCollectionRecCount

    Local oReturn := TReturn():New()

    oReturn:Success := .T.
    oReturn:Return := ::oTORMModel:Len()

Return ( oReturn )

// Group: PROTECTED METHODS