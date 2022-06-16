/* CLASS: TORMRelations 
    Se encarga de gestionar las relaciones entre modelos
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMRelations

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD HasRelations()
        METHOD GetRelations()

        METHOD HasOne( oRelation )
        METHOD HasMany( oRelation )
        METHOD RefreshRelations(  )

            DATA oTORMModel AS OBJECT INIT Nil
            DATA aRelations AS ARRAY  INIT Array( 0 )
    PROTECTED:

        METHOD Add()
        METHOD AddRelation()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMRelations

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: HasRelations(  )
    Devuelve si hay relaciones en el modelo o no

Devuelve:
    Lógico
*/
METHOD HasRelations(  ) CLASS TORMRelations
Return ( ::aRelations:Len() != 0 )


/* METHOD: GetRelations(  )
    Devuelve el array de las relaciones

Devuelve:
    Array
*/
METHOD GetRelations(  ) CLASS TORMRelations
Return ( ::aRelations )

/* METHOD: HasOne( oRelation )
    Comentado en el modelo

Devuelve:
    Modelo
*/
METHOD HasOne( oRelation ) CLASS TORMRelations

    oRelation:cType := TORM_RELATION_HASONE
    ::AddRelation( oRelation )

Return ( ::oTORMModel )

/* METHOD: HasMany( oRelation )
    Comentado en el modelo
    
Devuelve:
    Modelo
*/
METHOD HasMany( oRelation ) CLASS TORMRelations

    oRelation:cType := TORM_RELATION_HASMANY
    ::AddRelation( oRelation )

Return ( ::oTORMModel )

// Group: PROTECTED METHODS
/* METHOD: Add( oRelation )
    Añade una relación al modelo
    
    Parámetros:
        oRelation - objeto TRelation

Devuelve:
    
*/
METHOD Add( oRelation ) CLASS TORMRelations

    aAdD( ::aRelations, oRelation )

Return ( Nil )



/* METHOD: AddRelation( oRelation )
    Añade la relación en sí
    
    Parámetros:
        oRelation - MRelation
*/
METHOD AddRelation( oRelation ) CLASS TORMRelations

    Local oChildModel  := Nil

    
    If oRelation:cAliasObject:empty()

        oRelation:cName := TORM_PREFIX_RELATION + ProcName( 3 ):Right( ProcName( 3 ):Len() - Rat( ':', ProcName( 2 ) ) )    // Nombre del Método que llama a HasOne, Has... dentro de la clase, de este modo el nombre de la relación es el nombre del método que la llama
        oRelation:cName := oRelation:cName:Upper()

    Else

        oRelation:cName := oRelation:cAliasObject

    Endif

    switch oRelation:cType

        case TORM_RELATION_HASONE

            oChildmodel := __objClone( oRelation:oOriginalChildModel )

            If .Not. HB_ISOBJECT( oRelation:xField ) // Instancio el objeto que contendrá el modelo relacionado

                oChildModel:Find( ::oTORMModel:&( oRelation:xField ) )
        
            Else
        
                oChildModel:Find( oRelation:xField )
        
            Endif
            
        exit

        
        case TORM_RELATION_HASMANY

            oChildmodel := __objClone( oRelation:oOriginalChildModel )
            oChildModel:Query:PersistentOn()

            If .Not. HB_ISOBJECT( oRelation:xField ) // Instancio el objeto que contendrá el modelo relacionado

                oChildModel:Where( oChildModel:__oIndexes:GetPrimaryKey():cField, ::oTormModel:&(oRelation:xField) ):Get()
        
            Else
        
                oChildModel:Where( oRelation:xField:GetRaw(), oRelation:xField ):Get()
        
            Endif
            
        exit

    endswitch
    
    __objAddData( ::oTORMModel, oRelation:cName )                                  // Añado al modelo Padre, el DATA que instancia al modelo Hijo
    __objSetValueList( ::oTORMModel, { { oRelation:cName, oChildModel } } )        // Asigno al DATA del modelo padre el objeto del modelo hijo instanciado
    oRelation:oChildModel := __objClone( oChildModel )
    ::Add( oRelation )

Return ( Nil )

/* METHOD: RefreshRelations( oRelation )
    Refresca el contenido de la relación
    
    Parámetros:
        oRelation - Objeto relación mRelation a refrescar

Devuelve:
    
*/
METHOD RefreshRelations(  ) CLASS TORMRelations

    Local oRelation := Nil

    for each oRelation in ::GetRelations()

        If ::oTORMModel:&( oRelation:xField ):NotEmpty()

            ::oTORMModel:&( oRelation:cName):Find( ::oTORMModel:&( oRelation:xField ) )
            ::oTORMModel:&( oRelation:cName):__oRelations:RefreshRelations()

        Endif
        
    next

Return ( Nil )

