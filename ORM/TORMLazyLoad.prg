
/* CLASS: TORMLazyLoad 
    Gestiona el LazyLoad del modelo
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMLazyLoad

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Check()
        METHOD Reload()
        METHOD CanLazyShared()
        METHOD SetShared( lShared )
        METHOD SetPessimist( lPessimist )
        METHOD IsShared()
        METHOD IsPessimist()

        DATA lEnable AS LOGICAL INIT .F.
        
    PROTECTED:
        DATA oTORMModel       AS OBJECT Init Nil
        DATA aWhereConditions AS ARRAY  Init Array( 0 )
        DATA lShared          AS LOGICAL INIT .F.
        DATA lPessimist       AS LOGICAL INIT .F.

        METHOD SetWhereConditions()
        METHOD Load()
        METHOD AssignWhereConditionsToModel()
        METHOD ShareUpdate(  )
        METHOD CLoneSharedCollection(  )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMLazyLoad

    ::oTORMModel := oTORMModel
    
Return ( Self )



/* METHOD: Check()
    Se llama antes de cada acceso a la colección para comprobar si se ha realizado la primera carga de los datos o
    se trabaja con datos compartidos ( Shared )
*/
METHOD Check() CLASS TORMLazyLoad

    If ::lEnable

        If ::IsShared() .And.;
           ::oTORMModel:&(TORM_LAZYSHARED):HasCollection()

           ::CLoneSharedCollection()

        ElseIf .Not. ::oTORMModel:HasCollection()

            ::Load()

        Endif

    Endif

Return ( Nil )

/* METHOD: Reload(  )
    Recarga los datos de la persistencia con las mismas condiciones que la primera carga

Devuelve:
    Modelo
*/
METHOD Reload() CLASS TORMLazyLoad

    ::AssignWhereConditionsToModel()

    if ::isShared()
        
        ::oTORMModel:&(TORM_LAZYSHARED):InitCollection()

    Endif

Return ( ::Load() )

/* METHOD: CanLazyShared(  )
    Indica si el modelo puede activarse como LazyShared
Devuelve:
    Lógico
*/
METHOD CanLazyShared(  ) CLASS TORMLazyLoad
Return ( __objHasData( ::oTORMModel, TORM_LAZYSHARED ) ) 

/* METHOD: SetShared( lShared )
    Asigna le lazyLoad como compartido
    
    Parámetros:
        lShared - Para indicar si es compartido o no
*/
METHOD SetShared( lShared ) CLASS TORMLazyLoad

    ::lShared := lShared

Return ( Nil )

/* METHOD: IsShared(  )
    Indica si el lazyload es compartido

Devuelve:
    Lógico
*/
METHOD IsShared(  ) CLASS TORMLazyLoad
Return ( ::lShared )

/* METHOD: IsPessimist(  )
    Indica si el lazyload es Pesimista
Devuelve:
    Lógico
*/
METHOD IsPessimist(  ) CLASS TORMLazyLoad

Return ( ::lPessimist )

/* METHOD: SetPessimist( lPessimist )
    Indica si el lazyload es pesimista
    
    Parámetros:
        lPessimist - Para indicar si es pesimista o no
*/
METHOD SetPessimist( lPessimist ) CLASS TORMLazyLoad

    If HB_ISLOGICAL( lPessimist )

        ::lPessimist := lPessimist

    Endif

Return ( Nil )

// Group: PROTECTED METHODS 

/* METHOD: SetWhereConditions(  )
    Almacena las condiciones de la consulta para futuros reloads
*/
METHOD SetWhereConditions(  ) CLASS TORMLazyLoad

    If ::aWhereConditions:Empty()

        ::aWhereConditions := ::oTORMModel:__oQuery:aWhereConditions

    Endif

Return ( Nil )

/* METHOD: Load(  )
    Carga los datos a la colección

Devuelve:
    Modelo
*/
METHOD Load() CLASS TORMLazyLoad
    
    ::oTORMModel:__DataSource := ::oTORMModel:__DataSource_Initial
    ::SetWhereConditions()

    if ::IsSHared() .And. ::oTORMModel:&(TORM_LAZYSHARED):HasCollection()

        ::CLoneSharedCollection()
        
    Else
        
        ::oTORMModel:All()

    Endif

    ::oTORMModel:__DataSource := TORM_DATASOURCE_COLLECTION
    ::oTORMModel:SetCollectionLoaded( ::oTORMModel:Success() )
    ::ShareUpdate()

Return ( ::oTORMModel )

/* METHOD: AssignWhereConditionsToModel(  )
    Asigna las condicinoes del where de la carga inicial al modelo de nuevo
*/
METHOD AssignWhereConditionsToModel() CLASS TORMLazyLoad

    ::oTORMModel:__oQuery:aWhereConditions := ::aWhereConditions

Return ( Nil )

/* METHOD: ShareUpdate(  )
    Actualiza el lazyLoad shared en caso de que sea necesario
*/
METHOD ShareUpdate( ) CLASS TORMLazyLoad

    If ::CanLazyShared() .And.;
       ::IsShared()

        ::oTORMModel:&(TORM_LAZYSHARED):SetCollection( ::oTORMModel:GetCollection() )

    Endif

Return ( Nil )

/* METHOD: CLoneSharedCollection(  )
    Clona la colección compartida en la colección del modelo
*/
METHOD CLoneSharedCollection(  ) CLASS TORMLazyLoad

    ::oTORMModel:Initialize()
    ::oTORMMOdel:Assign( ::oTORMModel:&(TORM_LAZYSHARED):GetCollection() )

Return ( Nil )