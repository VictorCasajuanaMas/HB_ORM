/* CLASS: TORMForeignKeys 
    Gestiona las llaves foráneas del modelo.

    *Nota*: Se configuran de Padre a hijo al contrario que las definiciones del SQL para poder compatibilizarlas con DBF, de lo contrario habría que crear una tabla que tuviese la información de las relaciones de las llaves foráneas y cada vez que se realiza un operacion con tablas que tienen llaves foráneas habría que consultarla y bajaría el rendimiento
*/
#include 'hbclass.ch'

CREATE CLASS TORMForeignKeys

    EXPORTED:
        DATA aForeignKey AS ARRAY INIT Array( 0 )

        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD AddForeignKeyToModel( oTORMForeignKey ) 
        METHOD HasForeignKeys() 

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMForeignKeys

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: AddForeignKeyToModel( oTORMForeignKey )
    Añade una llave foránea al modelo y le indica al modelo padre de su existencia

Parámetros:
    oTORMForeignKey - Llame foránea a agregar    
*/
METHOD AddForeignKeyToModel( oTORMForeignKey ) CLASS TORMForeignKeys

    aAdD( ::oTORMModel:__oForeignKeys:aForeignKey, oTORMForeignKey )

Return ( Nil )

/* METHOD: HasForeignKeys(  )
    Indica si el modelo contiene llaves foráneas
    
Devuelve:
    Lógico
*/
METHOD HasForeignKeys(  ) CLASS TORMForeignKeys
Return ( ::aForeignKey:NotEmpty() )