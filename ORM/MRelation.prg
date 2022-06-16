/* CLASS: MRelation 
    Modelo que define una relación
*/
#include 'hbclass.ch'

CREATE CLASS MRelation

    EXPORTED:
        DATA cName               AS CHARACTER INIT ''
        DATA oOriginalChildModel AS OBJECT    INIT Nil
        DATA xField        
        DATA oChildModel         AS OBJECT    INIT Nil  // Aquí se almacenará el modelo cuando se instancie la relación
        DATA cType               AS CHARACTER INIT ''   // Indica el tipo de relación HasOne o HasMany
        DATA cAliasObject        AS CHARACTER INIT ''

        METHOD New( oOriginalChildModel, xField, cAs ) CONSTRUCTOR
        METHOD As( cAliasObject )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oOriginalChildModel, xField, cAs )
    Constructor
    
    Parámetros:
        oOriginalChildModel - Modelo hijo origianl en la relación
        xField - Campo del modelo hijo PrimaryKey para hacer la relación
        cAs - Alias que se le dará al nombre de la relación en el modelo padre

Devuelve:
    Self
*/
METHOD New( oOriginalChildModel, xField, cAs ) CLASS MRelation

    ::oOriginalChildModel := oOriginalChildModel

    If .Not. HB_ISOBJECT( xField )

        ::xField := xField:Value( '' )

    Else

        ::xField := xField

    Endif

    ::As( cAs )

Return ( Self )

/* METHOD: As( cAliasObject )
    Asigna el alias
    
    Parámetros:
        cAliasObject - Alias a asignar

Devuelve:
    Self
*/
METHOD As( cAliasObject ) CLASS MRelation

    If HB_ISCHAR( cAliasObject )

        ::cAliasObject := cAliasObject

    Endif

Return ( Self )