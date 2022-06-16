/* CLASS: TORMForeignKey 
    Gestiona las llaves foráneas de los modelos
*/
#include 'hbclass.ch'

CREATE CLASS TORMForeignKey

    EXPORTED:
        DATA cModel     AS CHARACTER INIT ''
        DATA cField     AS CHARACTER INIT ''

        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD AddForeignKeyToModel() 

    PROTECTED:
        DATA oTORMModel AS OBJECT    INIT Nil


ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMForeignKey

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: AddForeignKeyToModel(  )
    Añade la llave foránea al modelo
*/
METHOD AddForeignKeyToModel(  ) CLASS TORMForeignKey

    ::oTORMModel:__oForeignKeys:AddForeignKeyToModel( Self )

Return ( Nil )

// Group: PROTECTED METHODS