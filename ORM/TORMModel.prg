/* CLASS: TORMModel
          ORM para Harbour. Simulando Eloquent de Laravel

        Notas: Los data han de ir precedidos de __ para que no se mezclen con los datos del modelo

        Convenciones:
            - El nombre de la tabla será igual a el nombre del modelo + "s". Se puede modificar esta convención con la DATA __cName
            TODO: Revisar estos dos puntos:
            - Existe en las tablas una clave primaria definida en TORM_PRIMARYKEYDEFAULT, se puede modificar la clave primara automática para el modelo mediante la modificación de oIndexes:oPrimaryKey asignando como objeto TORMField
            - Se puede desactivar que el modelo no tenga clave primaria mediante oIndexes:lPrimaryKey := .F.
            
            - los métodos get() y all() cargan los datos en TCollection para poder iterarlos posteriormente.
    TODO: Probar con varios índices en el mismo modelo, a ver como se gestionan las búsquedas, mirar que sea lo más automático posible.
    TODO: Aplicar TStorage a los accesos a disco como ferase...
    TODO: Abstraer la TValidation
    TODO: Abstraer los métodos de Base de Datos a TDB (DropTable, etc...)
    
*/

#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'hboo.ch'
#include 'TORM.ch'


CREATE CLASS TORMModel FROM TCollection, TReturnState, TLog

    EXPORTED:
        DATA __DataSource          AS CHARACTER INIT TORM_DATASOURCEDEFAULT
        DATA __DataSource_Initial  AS CHARACTER INIT ''
        DATA __oSource             AS OBJECT    INIT Nil
        DATA __cName               AS CHARACTER INIT '' READONLY
        DATA __cDescription        AS CHARACTER INIT '' READONLY
        DATA __aFields             AS ARRAY     INIT Array( 0 )
        DATA __xFindValue      
        DATA __oReturn             AS OBJECT    INIT Nil
        DATA __oInitialBuffer      AS OBJECT    INIT Nil
        DATA __oIndexes            AS OBJECT    INIT Nil
        DATA __oForeignKeys        AS OBJECT    INIT Nil
        DATA __oRelations          AS OBJECT    INIT Nil
        DATA __oLazyLoad           AS OBJECT    INIT Nil
        DATA __oQuery              AS OBJECT    INIT Nil
        DATA __oPagination         AS OBJECT    INIT Nil
        DATA __lInEdition          AS LOGICAL   INIT .F.
        DATA __lWhereInitGroup     AS LOGICAL   INIT .T.     
        DATA __nWhereCounterGroup  AS NUMERIC   INIT 0       

        
        METHOD New( xFindValue ) CONSTRUCTOR
        METHOD Init()
        METHOD End()
        METHOD CreateStructure() VIRTUAL
        METHOD Save()
        METHOD SaveCollection( lNewData )
        METHOD SaveNewCollection( )
        METHOD Find( xFindValue, cOrder ) 
        METHOD FindInternalID( xInternalId )
        METHOD FindFirstBigger( xFindValue, cOrder )
        METHOD Insert( adata )
        METHOD Delete( xFindValue )
        METHOD DeleteandInsert( xFindValue, adata )
        METHOD TableName()
        METHOD DropTable()
        METHOD RecCount()
        METHOD Count()
        METHOD Valid( ... )
        METHOD All( cOutputFormat )
        METHOD Update( hData )
        METHOD Where( ... )
        METHOD OrWhere( ... )
        METHOD WhereBetween( cField, aRange )
        METHOD WhereIn( cField, aIn )
        METHOD Select( ... )
        METHOD First( cOrder )
        METHOD Last( cOrder )
        METHOD LoadLimits( cOrder)
        METHOD OrderBy( cOrder, cDirection )
        METHOD Take( nItems )
        METHOD OffSet( nOffSet )
        METHOD Get( cOutputFormat )
        METHOD HasField()
        METHOD GetORMFieldofDescription( cDescription )
        METHOD LazyLoad()
        METHOD LazyLoadShared()
        METHOD LazyLoadPessimist()
        METHOD LazyLoadSharedInit()
        METHOD LoadFromHash( hHash )
        METHOD LoadFromHashes( aHashes )
        METHOD LoadFromJson( jJson )
        METHOD LoadFromJsons( jJson )
        METHOD ToHash()
        METHOD ToJson()
        METHOD LoadFromSource( xSource )
        METHOD LoadMultipleFromSource( oFind )
        METHOD PutToSource( xSource )
        METHOD IsDirty( ... )
        METHOD WasDifferent( ... )
        METHOD CheckSource( xSource )
        
        METHOD GetFieldsStr()
        METHOD GetStructureStr( ... )
        METHOD GetStructure()

        METHOD SetInternalDbId( nId )
        METHOD InternalDbIdName()
        METHOD GetInternalDbId()

        METHOD SetDefaultData() VIRTUAL
        
        METHOD HasOne( oOriginalChildModel, xField, cAs )
        METHOD HasMany( oOriginalChildModel, xField, cAs )

        METHOD Pagination()
        METHOD Query()
        METHOD InitialBuffer()
        METHOD GetField()

    PROTECTED:

        METHOD oReturnInit()
        METHOD CreateInternalDbId()
        METHOD CreateLazyLoadShared(  )
        METHOD LazyLoadCheck()
        METHOD WhereMake()
        
ENDCLASS


// Group: EXPORTED METHODS

/* METHOD: New( xfindValue )
    Constructor, se encarga de crear la estructura. Si se le pasa xFindValue realiza un Find( xFindValue )

    Parámetros:
        xFindValue - Cualquier valor de búsqueda

Devuelve:
    Self
*/
METHOD New( xFindValue ) CLASS TORMModel

    ::__DataSource_Initial := ::__DataSource
    ::__oIndexes           := TORMIndexes():New( Self )
    ::__oForeignKeys       := TORMForeignKeys():New( Self )
    ::__oRelations         := TORMRelations():New( Self )
    ::CreateStructure()
    ::CreateInternalDbId()
    ::Init()
    

    If .Not. xFindValue:Empty()

        ::Find( xFindValue )

    Endif

Return ( Self )

/* METHOD: Init(  )
    Inicializa el modelo
*/
METHOD Init(  ) CLASS TORMModel

    ::oReturnInit()
    ::SetDefaultData()
    ::__oPagination        := TORMPagination():New( Self )
    ::__oInitialBuffer     := TORMInitialBuffer():New()
    ::__oLazyLoad          := TORMLazyLoad():New( Self )
    ::__oQuery             := TORMQuery():New( Self )
    ::__oSource            := MSource():New() 
    ::CreateLazyLoadShared()
    ::Initialize()

Return ( Nil )


/* METHOD: End(  )
    Destruye el modelo

*/
METHOD End() CLASS TORMModel

    ::oReturnInit()
    hb_gcAll()
    
Return ( Nil )

/* METHOD: Save( )
    Guarda el buffer actual en la tabla devolviendo .T. o .F. en caso de que se haya realizado el proceso correctamente

Devuelve:
    Objeto
*/
METHOD Save() CLASS TORMModel

    ::Valid()

    If ::Success()

        ::oReturnInit()
        TORMPersistence():New( Self ):Save()

        If ::__oReturn:Success()

            __lInEdition := .T.
            ::__oInitialBuffer:Update( Self )

        Endif

    Endif

Return ( Self )

/* METHOD: SaveNewCollection(  )
    Guarda la colección añadiendo los datos a la persistencia sin tener en cuenta su estado de modificación

Devuelve:
    Objeto
*/
METHOD SaveNewCollection(  ) CLASS TORMModel

    ::SaveCollection( .T. )

Return ( Self )

/* METHOD: SaveCollection( lNewData )
    Si el modelo tiene colección y hay modificaciones en los modelos de la colección, los guarda

    Parámetros:
        lNewData - Se activa cuando ha de añadir datos nuevos a la persistencia independientemente de si se están modificando o no

Devuelve:
    Objeto
*/
METHOD SaveCollection( lNewData ) CLASS TORMModel

    If ::HasCollection()

        ::oReturnInit()
        TORMPersistence():New( Self ):SaveCollection( lNewData )

    Endif

Return ( Self )


/* METHOD: Find( xFindValue, cOrder )
    Busca un registro y devuelve el modelo

    Parámetros:
        xFindValue - Valor a buscar
        cOrder     - Campo del Modelo a localizar, por defecto el definido en TORM_PRIMARYKEYDEFAULT

Devuelve:
    Objeto    
*/
METHOD Find( xFindValue, cOrder ) CLASS TORMModel

    cOrder := ::__oIndexes:OrderDefault( cOrder )
    ::oReturnInit()
    ::LazyLoadCheck(  )
    ::__xFindValue := TORMCheckFindValue():New( Self ):ConvertValue( xFindValue )
    TORMPersistence():New( Self ):Find( cOrder )

Return ( Self )

/* METHOD: FindInternalId( xInternalId )
    Busca un registro por su InternalId y devuelve el modelo
    
    Parámetros:
        xInternalId - InterlanId

Devuelve:
    Objeto
*/
METHOD FindInternalId( xInternalId ) CLASS TORMModel

    ::oReturnInit()
    ::LazyLoadCheck(  )
    TORMPersistence():New( Self ):FindInternalID( xInternalId )

Return ( Self )


/* METHOD: FindFirstBigger( xFindValue, cOrder )
    Busca la coincidencia mayor más cercana al valor buscado o el valor buscado si existe. Devuelve el modelo
    Por ejemplo, en un array : {1,3,5,7,9,11} si buscamos 4 devolverá 3
    
    Parámetros:
        cOrder - Campo sobre el que buscar
        xFind  - Valor a buscar

    Devuelve:
        Objeto
*/
METHOD FindFirstBigger( xFindValue, cOrder ) CLASS TORMModel

    ::oReturnInit()
    ::LazyLoadCheck(  )
    ::__xFindValue := xFindValue
    TORMPersistence():New( Self ):FindFirstBigger( cOrder )

Return ( Self )



/* METHOD: TableName( )
    Devuelve el nombre de la tabla que ha de tener en la base de datos o fichero de datos

Devuelve:
    Caracter
*/
METHOD TableName() CLASS TORMModel

    Local cTableName := ''

    If Empty( ::__cName )

        cTableName := Self:ClassName() + 's'

    Else

        cTableName := ::__cName

    Endif

Return ( Alltrim( cTableName ) )

/* METHOD: DropTable()
    Elimina la tabla correspondiente al modelo

    Devuelve:
        TReturn
*/
METHOD DropTable() CLASS TORMModel

    ::oReturnInit()
    ::__oReturn := TORMPersistence():New( Self ):DropTable()

Return ( ::__oReturn )


/* METHOD: RecCount(  )
    Devuelve el número de registros de la tabla
    
    Parámetros:
        

Devuelve:
    Entero
*/
METHOD RecCount() CLASS TORMModel

    ::oReturnInit()
    ::LazyLoadCheck()
    ::__oReturn := TORMPersistence():New( Self ):RecCount()

Return ( ::__oReturn:Return )

/* METHOD: Count(  )
    Cuenta el nº de registros de una tabla teniendo en cuenta los filtros Where y whereIn
Devuelve:
    Entero
*/
METHOD Count(  ) CLASS TORMModel

    ::oReturnInit()
    ::LazyLoadCheck()
    ::__oReturn := TORMPersistence():New( Self ):Count()

Return ( ::__oReturn:Return )

/* METHOD: Insert( aData )
    Añade registros a la tabla a partir de los datos recibidos por aData que es un array de Hashes
    
    Parámetros:
        udata - Datos en formato Hash o Json

Devuelve:
    Entero
*/
METHOD Insert( aData ) CLASS TORMModel

    Local nRecordsAdded := 0

    ::oReturnInit()

    If HB_ISHASH( aData )

        aData := { aData }

    Endif

    nRecordsAdded := TORMPersistence():New( Self ):Insert( aData )

Return ( nRecordsAdded )

/* METHOD: Delete( xFindvalue )
    Elimina un registro del modelo y devuelve el número de registros que se han eliminado
    
    Parámetros:
        xFindValue - Valor a buscar para eliminar, puede ser un array de valores

Devuelve:
    numérico
*/
METHOD Delete( xFindvalue ) CLASS TORMModel

    Local nRecordsDeleted := 0
    Local aRecordsToDelete := Array ( 0 )

    ::oReturnInit()

    if .Not. HB_ISARRAY( xFindvalue ) .And.;
       .Not. xFindvalue:Empty()

        aRecordsToDelete := { xFindvalue }

    Else

        aRecordsToDelete := xFindvalue

    Endif

    nRecordsDeleted := TORMPersistence():New( Self ):Delete ( aRecordsToDelete )

Return ( nRecordsDeleted )

/* METHOD: DeleteandInsert( xFindValue, aData )
    Elimina los registros según xFindValue y si el resultado es correcto inserta aData
    
    Parámetros:
        xFindValue - Valor a buscar para eliminar, puede ser un array de valores

Devuelve:
    Objeto
*/
METHOD DeleteandInsert( xFindValue, aData ) CLASS TORMModel

    ::oReturnInit()

    If HB_ISHASH( aData )

        aData := { aData }

    Endif

    TORMPersistence():New( Self ):Delete( xFindValue )

    If ::Success()

        TORMPersistence():New( Self ):Insert( aData )

    Endif

Return ( Self )

/* METHOD: HasField( cField )
    Indica si el modelo contiene el campo cField
    
    Parámetros:
        cField - Nombre del campo a comprobar

Devuelve:
    Lógico
*/
METHOD HasField( cField ) CLASS TORMModel
Return ( aScan( ::__aFields, { | oTORMField | oTORMField:cName:Upper() == cField:Upper } ) != 0 )

/* METHOD: GetORMFieldofDescription( cDescription )
    Devuelve el nombre del objeto TORMField que tiene la descripción cDescription
    
    Parámetros:
        cDescription - Descripción a devolver

Devuelve:
    Objeto
    
*/
METHOD GetORMFieldofDescription( cDescription ) CLASS TORMModel

    Local nPosition := 0

    nPosition := aScan( ::__aFields, { | oTORMField | oTORMField:cDescription:Alltrim() == cDescription:Alltrim() } )

Return ( ::__aFields:Get( nPosition, Nil ) )


/* METHOD: Valid( ... )
    Valida los Datas del modelo o los datas que se le pasen por parámetro. En el caso de que haya algún dato no válido, carga en el log del estado del modelo la información.

    Parámetros:
        ... - Datas a validar

Devuelve:
    Self
*/
METHOD Valid( ... ) CLASS TORMModel

    Local oField := Nil
    Local aFieldsToValidate := Array( 0 )
    Local cField := ''
    Local oValidation := Nil

    ::oReturnInit()
    ::__oReturn:Success := .T.

    If hb_aparams():Empty()

        aFieldsToValidate := ::__aFields

    Else

        for each cField in hb_aparams()

            If ::HasField( cField )

                aAdD( aFieldsToValidate, ::GetField( cField ) )

            Endif
            
        next

    Endif

    for each oField in aFieldsToValidate

        oValidation := TValidation():New( Self:&(oField:cName), oField:hValid, oField:cName )
        
        
        If .Not. oValidation:Valid()

            ::__oReturn:Success := .F.
            ::__oReturn:Log := oVAlidation:ValidGetResultado()

        Endif
        
    next

Return ( Self )

/* METHOD: All( cOutputFormat )
    Devuelve todos los registros del modelo en el formato especificado

Parámetros:
    cOutputFormat - Formato de los items del array devuelto

Devuelve:
    Array de Modelos
*/
METHOD All( cOutputFormat ) CLASS TORMModel


    ::__oQuery:InitWhere()

Return ( ::Get( cOutputFormat ) )

/* METHOD: Update( hData )
    Actualiza los datos del modelo con los datos recibidos por hData teniendo en cuenta la condición idicada en Where
    
    Parámetros:

        hData - Hash de los datos a reemplazar

Devuelve:
    Self
    
*/
METHOD Update( hData ) CLASS  TORMModel

    Local nRecordsUpdated := 0

    nRecordsUpdated := TORMPersistence():New( Self ):Update( hData )

Return ( nRecordsUpdated )

/* METHOD: Where( ... )
    Llama al WhereMake como un And. No se hace como AndWhere ya que el Where por defecto siempre es And

Devuelve:
    Self
*/
METHOD Where( ... ) CLASS TORMModel

    ::__nWhereCounterGroup++
    
    If ::__oQuery:HasWhere()

        ::__oQuery:aWhereConditions:GetLast():cUnion    := TORM_AND

    Endif

    ::WhereMake( ... )    

    ::__nWhereCounterGroup--

    If ::__nWhereCounterGroup == 0

        ::__lWhereInitGroup := .T.
        ::__oQuery:aWhereConditions:GetLast():lEndGroup := .T.

    Endif

Return ( Self )

/* METHOD: OrWhere( ... )
    Llama al WhereMake como un Or

Devuelve:
    Self
*/
METHOD OrWhere( ... ) CLASS TORMModel

    ::__nWhereCounterGroup++

    If ::__oQuery:HasWhere()

        ::__oQuery:aWhereConditions:GetLast():cUnion    := TORM_OR

    Endif

    ::WhereMake( ... )    

    ::__nWhereCounterGroup--

    If ::__nWhereCounterGroup == 0

        ::__lWhereInitGroup := .T.
        ::__oQuery:aWhereConditions:GetLast():lEndGroup := .T.

    Endif


Return ( Self )

/* METHOD: WhereBetween( cField, aRange )
    Ayuda para crear condiciones where más rápido
    
    Parámetros:
        cField - Campo a filtrar
        aRange - Rango, Array de 2 ítem

Devuelve:
    Self
*/
METHOD WhereBetween( cField, aRange ) CLASS TORMModel


    If HB_ISARRAY( aRange ) .And.;
       cField != Nil

        ::Where( cField, '>=', aRange:Get( 1 ) )
        ::Where( cField, '<=', aRange:Get( 2 ) )

    Endif

Return ( Self )

/* METHOD: WhereIn( cField, aIn )
    Filtro los valores de aIn que coinciden en cField dentro de la tabla
    
    Parámetros:
        cField - Campo a comparar
        aIn - Array de valores

Devuelve:
    Self
*/
METHOD WhereIn( cField, aIn ) CLASS TORMModel

    if ::HasField( cField ) .And.;
        HB_ISARRAY( aIn )

        ::__oQuery:oWhereInConditions:cField        := cField
        ::__oQuery:oWhereInConditions:aIn           := aIn
        ::__oQuery:oWhereInConditions:lHasCondition := .T.

    else

        ::__oReturn:Success := .F.
        ::LogWrite( ::__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[1][1], TORM_ERROR_MESSAGE[1][2], { ::TableName() } ) )

    Endif

Return ( Self )

/* METHOD: Select( ... )
    Configura las columnas que se devolverán en la consulta
    
    Parámetros:
        ... - Se le puede pasar un array con los nombres de columnas o en varios parámetros

Devuelve:
    Self
*/
METHOD Select( ... ) CLASS TORMModel

    ::__oQuery:oSelect:Add( ... )

Return ( Self )

/* METHOD: Get( cOutputFormat )
    Ejecuta la consulta con los parámetros where, select, orderby, etc... y devuelve un array de items cOutputFormat

Parámetros:
    cOutputFormat - Formato del Item del array
   
Devuelve:
    Array de cOutputFormat
*/
METHOD Get( cOutputFormat ) CLASS TORMModel

    Local aCollectionReturn := Array( 0 )

    hb_default( @cOutputFormat, TORM_MODEL)

    ::oReturnInit()
    ::__aCollection := TORMPersistence():New( Self ):Get( )
    ::SetCollectionLoaded( .T. )
    ::Refresh()
    TORMPersistence():New( Self ):LoadRelations()
    ::GoTop()

    switch cOutputformat

        case TORM_MODEL

            aCollectionReturn := ::__aCollection
            
        exit

        case TORM_HASH

            aCollectionReturn := ::ToHashes()
            
        exit

    endswitch
    
    If .Not. ::__oQuery:Persistent()

        ::__oQuery:InitAll()

    Endif

Return ( aCollectionReturn )


/* METHOD: LazyLoad(  )
    Activa lLazyLoad para la carga diferida bajo demanda

Devuelve:
    Self
*/
METHOD LazyLoad(  ) CLASS TORMModel

    ::__DataSource := TORM_DATASOURCE_COLLECTION
    ::__oLazyLoad:lEnable := .T.

Return ( Self )

/* METHOD: LazyLoadShared(  )
    Activa el LazyLoad al modelo en modo compartido.

Devuelve:
    Objeto
*/
METHOD LazyLoadShared(  ) CLASS TORMModel

    If ::__oLazyLoad:CanLazyShared()

        ::LazyLoad()
        ::__oLazyLoad:SetShared( .T. )

    Else

        ::__oReturn:Success := .F.
        ::__oReturn:Log := 'El modelo no cumple los requisitos para LazyLoadShared'

    Endif

Return ( Self )

/* METHOD: LazyLoadSharedInit(  )
    Inicializa el LazyLoad compartido como si no se hubiese cargado nada
Devuelve:
    Objeto
*/
METHOD LazyLoadSharedInit(  ) CLASS TORMModel

    ::&(TORM_LAZYSHARED):InitCollection()

Return ( Self )

/* METHOD: LazyLoadPessimist(  )
    Activa la carga diferida pesimista, esto provocará que en cada consulta se mire si el origen de datos ha sido modificado
Devuelve:
    Objeto
*/
METHOD LazyLoadPessimist(  ) CLASS TORMModel

    ::LazyLoad()
    ::__oLazyLoad:SetPessimist( .T. )

Return ( Self )

/* METHOD: LoadFromHash( hHash )
    Carga los datos de un Hash al modelo
    
    Parámetros:
        hHash - Hash origen de los datos

Devuelve:
    oReturn
*/
METHOD LoadFromHash( hHash ) CLASS TORMModel

    Local hData 
    Local oError := Nil

    ::oReturnInit()

    If HB_ISHASH( hHash )
       
        ::__oReturn:Success := .T.

        for each hData in hHash

            try 
                

                ::&( hData:__enumkey) := hData:__enumvalue
                ::__oInitialBuffer:SetInitialValue( hData:__enumkey, hData:__enumvalue )

            catch oError

                ::__oReturn:Success := .F.
                ::LogWrite( ::__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[2][1], TORM_ERROR_MESSAGE[2][2], { ::TableName(), TTryCatchShowerror():New( oError ):ToString() } ) )
                
            end
            
        next

        If ::Success()

            ::Valid()

        Endif

    else

        ::__oReturn:Success := .F.
        ::LogWrite( ::__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[3][1], TORM_ERROR_MESSAGE[3][2], { ::TableName() } ) )

    Endif


Return ( ::__oReturn )

/* METHOD: LoadFromHashes( aHashes )
    Carga en la colección del modelo la información de aHashes y asigna el primer Hash al modelo
    
    Parámetros:
        aHashes - Array de Hash

Devuelve:
    oReturn
*/
METHOD LoadFromHashes( aHashes ) CLASS TORMModel

    Local hHash := hb_hash()
    Local oNewModel := Nil

    ::oReturnInit()

    If HB_ISARRAY( aHashes )

        ::__oReturn:Success := .T.
        ::Initialize()

        for each hHash in aHashes

            oNewModel := &(Self:ClassName())():New()

            If oNewModel:LoadFromHash( hHash ):Success()

                aAdD( ::__aCollection, oNewModel )

            else

                ::__oReturn:Success := .F.
                ::LogWrite( ::__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[4][1], TORM_ERROR_MESSAGE[4][2], { ::TableName() } ) )

            Endif
            
        next

        If ::__oReturn:Success()

            ::GoTop()
            ::SetCollectionLoaded( .t. )

        Endif

    Else

        ::__oReturn:Success := .F.
        ::LogWrite( ::__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[5][1], TORM_ERROR_MESSAGE[5][2], { ::TableName() } ) )

    Endif

Return ( ::__oReturn )

/* METHOD: ToHash(  )
    Devuelve todos los DATA del modelo en un hash

Devuelve:
    Hash
*/
METHOD ToHash(  ) CLASS TORMModel
Return ( TORMModelToHash():New( Self ):ToHash() )

/* METHOD: LoadFromJson( jJson )
    Carga los datos de un Json al modelo
    
    Parámetros:
        jJson - Json origen de los datos

Devuelve:
    oReturn
*/
METHOD LoadFromJson( jJson ) CLASS TORMModel

    Local hData 
    Local hHash := hb_Hash()

    ::oReturnInit()

    If HB_ISCHAR( jJson ) 
       
        hHash := hb_jsonDecode( jJson )

        ::LoadFromHash( hHash )

    else

        ::__oReturn:Success := .F.
        ::LogWrite( ::__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[64][1], TORM_ERROR_MESSAGE[64][2], { ::TableName() } ) )


    Endif

Return ( ::__oReturn )

/* METHOD: LoadFromJsons( jJson )
    Carga en la colección del modelo la información de un Json y asigna el primer item del array jSon al modelo.
    El json ha de contener una estructura de array json:
    ejemplo:
    '[{"dato":1},{"dato":2}]'
    
    Parámetros:
        jJson - Json origen de los datos

Devuelve:
    oReturn
*/
METHOD LoadFromJsons( jJson ) CLASS TORMModel

    Local hHash := hb_hash()
    Local oNewModel := Nil
    Local aHashes := Array( 0 )

    ::oReturnInit()

    aHashes := hb_jsonDecode( jJson )

    If HB_ISARRAY( aHashes )

        ::LoadFromHashes( aHashes )

    Else

        ::__oReturn:Success := .F.
        ::LogWrite( ::__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[67][1], TORM_ERROR_MESSAGE[67][2], { ::TableName() } ) )

    Endif

Return ( ::__oReturn )

/* METHOD: ToJson(  )
    Devuelve todos los DATA del modelo en un Json

Devuelve:
    Caracter
*/
METHOD ToJson(  ) CLASS TORMModel
Return ( hb_JsonEncode( TORMModelToHash():New( Self ):ToHash() ) )

/* METHOD: SetInternalDbId( nId )
    Asigna el valor del registro interno de la tabla referente al modelo
    
    Parámetros:
        nId - Nº de registro interno de la tabla

Devuelve:
    
*/
METHOD SetInternalDbId( nId ) CLASS TORMModel

    __objSetValueList( Self, { { ::InternalDbIdName, nId } } )

Return ( Nil )

/* METHOD: GetInternalDbId(  )
    Devuelve el valor del registro interno de la tabla referente al modelo
    
    Parámetros:
        

Devuelve:
    Cualquier valor
*/
METHOD GetInternalDbId(  ) CLASS TORMModel
Return ( ::&( '__' + TORM_INTERNALDBID ) )

/* METHOD: LoadFromSource( xSource )
    Carga los datos del source actual en el registro actual al modelo
    
    Parámetros:
        xSource - Contiene el acceso al registro actual del source. Puede ser un Alias si es DBF o un query? en caso de SQL

Devuelve:
    Self
*/
METHOD LoadFromSource( xSource ) CLASS TORMModel

    ::oReturnInit()
    ::__oReturn := TORMPersistence():New( Self ):LoadFromSource( xSource )

Return ( Self )

/* METHOD: LoadMultipleFromSource( oFind )
    Carga los datos del source según la condición pasada en la colección
    
    Parámetros:
        oFind - Objeto de búsqueda. El tipo de objeto depende del source

Devuelve:
Self
    
*/
METHOD LoadMultipleFromSource( oFind ) CLASS TORMModel

    ::oReturnInit()
    ::__oReturn := TORMPersistence():New( Self ):LoadMultipleFromSource( oFind )

Return ( Self )

/* METHOD: InternalDbIdName(  )
    Devuelve el nombre del InterlDbId
*/
METHOD InternalDbIdName(  ) CLASS TORMModel
Return ( '__' + TORM_INTERNALDBID )

/* METHOD: PutToSource( xSource )
    Persiste los datos del modelo al Source actual
    
    Parámetros:
        xSource - Contiene el acceso al registro del source actual. Puede ser un Alias si es DBF o un query? en caso de SQL

Devuelve:
    Self
*/
METHOD PutToSource( xSource ) CLASS TORMModel

    ::oReturnInit()
    ::__oReturn := TORMPersistence():New( Self ):PutToSource( xSource )

Return ( Self )

/* METHOD: OrderBy( cOrder, cDirection )
    Asigna el orden que deberá tener la colección al recuperarla
    
    Parámetros:
        cOrder     - Campo del orden
        cDirection - ASC o DESC

Devuelve:
    Self
*/
METHOD OrderBy( cOrder, cDirection ) CLASS TORMModel

    
    ::__oQuery:oOrderby:cOrder     := cOrder

    If cDirection == TORM_ASC .Or.;
       cDirection == TORM_DESC

        ::__oQuery:oOrderby:cDirection := cDirection

    Else

        ::__oQuery:oOrderby:cDirection := TORM_ASC

    Endif

Return ( Self )

/* METHOD: Take( nItems )
    Indica el número de items que debe devolver la consulta
    
    Parámetros:
        nItems - Número de items a devolver

Devuelve:
    Self
*/
METHOD Take( nItems ) CLASS TORMModel

    ::__oQuery:nTake := nItems:Value( 0 )

Return ( Self )

/* METHOD: OffSet( nOffSet )
    Indica a partir de que fila a ha iniciarse la consulta
    
    Parámetros:
        nRow - Nº de fila a iniciar la consulta

Devuelve:
    Self
*/
METHOD OffSet( nOffSet ) CLASS TORMModel

    ::__oQuery:nOffSet := nOffset:Value( 0 )

Return ( Self )

/* METHOD: First( cOrder )
    Devuelve el primer modelo de una consulta

    Parámetros:
        cOrder - Campo del orden a tener en cuenta para posicionarse en el primer registro  
Devuelve:
    Self
*/
METHOD First( cOrder ) CLASS TORMModel

    ::oReturnInit()
    ::LazyLoadCheck()
    TORMPersistence():New( Self ):First( cOrder )

Return ( Self )


/* METHOD: LoadLimits( cOrder )
    Carga en la colección el primer y último registro de la tabla

    Parámetros:
        cOrder - Campo del orden a tener en cuenta para posicionarse en los registros
Devuelve:
    Self
*/
METHOD LoadLimits( cOrder ) CLASS TORMModel

    Local aCollectionReturn := Array( 0 )

    ::oReturnInit()
    ::__aCollection := TORMPersistence():New( Self ):LoadLimits( cOrder )
    ::SetCollectionLoaded( .T. )
    ::Refresh()
    TORMPersistence():New( Self ):LoadRelations()
    ::GoTop()

Return ( Self )

/* METHOD: Last( cOrder )
    Devuelve el último modelo de una consulta

    Parámetros:
        cOrder - Campo del orden a tener en cuenta para posicionarse en el último registro  
Devuelve:
    Self
*/
METHOD Last( cOrder ) CLASS TORMModel

    ::oReturnInit()
    ::LazyLoadCheck()
    TORMPersistence():New( Self ):Last( cOrder )

Return ( Self )


/* METHOD: HasOne( oOriginalChildModel, xField, cAs )
    Crea el la relación en el modelo 1 a 1
    
    Parámetros:
        oOriginalChildModel - Modelo hijo origianl en la relación
        xField - Campo del modelo hijo PrimaryKey para hacer la relación
        cAs - Alias que se le dará al nombre de la relación en el modelo padre

Devuelve:
    Self
*/
METHOD HasOne( oOriginalChildModel, xField, cAs ) CLASS TORMModel

    ::__oRelations:HasOne( MRelation():New( oOriginalChildModel, xField, cAs ) )

Return ( Self )

/* METHOD: HasMany( oOriginalChildModel, xField, cAs )
    Crea la relación en el modelo 1 a N
    
    Parámetros:
        oOriginalChildModel - Modelo hijo origianl en la relación
        xField - Campo del modelo hijo PrimaryKey para hacer la relación
        cAs - Alias que se le dará al nombre de la relación en el modelo padre

Devuelve:
    Self
*/
METHOD HasMany( oOriginalChildModel, xField, cAs ) CLASS TORMModel

    ::__oRelations:HasMany( MRelation():New( oOriginalChildModel, xField, cAs ) )

Return ( Self )

/* METHOD: Pagination(  )
    Devuelve el objeto __oPagination, a fectos de dar mejor semántica al código
Devuelve:
    Objeto
*/
METHOD Pagination(  ) CLASS TORMModel
Return ( ::__oPagination )

/* METHOD: Query(  )
    Devuelve el objeto __oQuery, a efectos de dar mejor semántica al código

Devuelve:
    Objeto
*/
METHOD Query(  ) CLASS TORMModel
Return ( ::__oQuery )

/* METHOD: InitialBuffer() CLASS TORMModel
    Devuelve el objeto __oInitialBuffer, a efectos de dar mejor semántica al código

Devuelve 
    Objeto
*/
METHOD InitialBuffer() CLASS TORMModel
Return ( ::__oInitialBuffer )

/* METHOD: IsDirty( ... )
    Indica si el modelo ha cambiado desde que se recuperó. Si se le pasan campos, solo comprueba dichos campos
    
    Parámetros:
        ... - Campos a procesar

Devuelve:
    Lógico
    
*/
METHOD IsDirty( ... ) CLASS TORMModel

    Local lIsDirty      := .F.
    Local oTORMField    := Nil
    Local aFieldsToTest := Array( 0 )
    Local cField        := ''

    If hb_aparams():Empty()

        aFieldsToTest := ::__aFields

    Else

        for each cField in hb_aparams()

            If ::HasField( cField )

                aAdD( aFieldsToTest, ::GetField( cField ) )

            Endif
            
        next

    Endif

    for each oTORMField in aFieldsToTest

        If Self:&( oTORMField:cName ) != ::__oInitialBuffer:Get( oTORMField:cName )

            lIsDirty := .T.

        Endif
        
    next

Return ( lIsDirty )

/* METHOD: WasDifferent( ... )
    Indica si el modelo ha sido cambiado por otro usuario en la base de datos después de haberlo cargado. Si se le pasan campos, solo comprueba dichos campos
    
    Parámetros:
        ... - Campos a procesar

Devuelve:
    Return. No devuelve un lógico ya que así se puede saber el motivo de la modificación, aunque sea menos legible posteriormente el código
*/
METHOD WasDifferent( ... ) CLASS TORMModel

    Local oReturn             := TReturn():New( .F. )
    Local oModelInPersistence := Nil
    Local aFieldsToCompare    := Array( 0 )
    Local oTORMField          := Nil
    Local cField              := ''

    oReturn:Success := .F.

    If ::__lInEdition

        oModelInPersistence := &( Self:ClassName() )():New( ::__xFindValue )

        If oModelInPersistence:Fail()

            oReturn:Success := .T.
            oReturn:Log := 'El registro ' + ::__xFindValue +' ha sido eliminado de la tabla ' + ::TableName()

        else

            If hb_aparams():Empty()

                aFieldsToCompare := ::__aFields
        
            Else
        
                for each cField in hb_aparams()
        
                    If ::HasField( cField )
        
                        aAdD( aFieldsToCompare, ::GetField( cField ) )
        
                    Endif
                    
                next
        
            Endif

            for each oTORMField in aFieldsToCompare

                If Self:&( oTORMField:cName ) != oModelInPersistence:&( oTORMField:cName )

                    oReturn:Success := .T.
                    oReturn:Log     := oTORMField:cName + ' antes => ' + oModelInPersistence:&( oTORMField:cName ):Str() + ' actual => ' + Self:&( oTORMField:cName ):Str()

                Endif
                
            next

        Endif

    else
        
        oReturn:Success := .F.
        oReturn:Log     := 'El registro es nuevo y no tiene información anterior'

    Endif

Return ( oReturn )

/* METHOD: CheckSource( xSource )
    Revisa que el source del modelo sea correcto, tenga todos sus datas con los tipos y longitudes correspondientes e indices correctos.

    Parámetros:
        xSource - Vínculo del source, se pasa para que no tenga que abrirlo y el acceso sea más rápido
        
Devuelve:
    Self
*/
METHOD CheckSource( xSource ) CLASS TORMModel

    ::oReturnInit()
    TORMPersistence():New( Self ):CheckSource( xSource )

Return ( Self )

/* METHOD: GetFieldsStr(  )
    Devuelve los campos del modelo en una cadena separada por coma

Devuelve:
    String
*/
METHOD GetFieldsStr(  ) CLASS TORMModel

    Local cFields    := ''
    Local oTORMField := Nil

    for each oTORMField in ::__afields
        
        if .Not. cFields:Empty

            cFields += ','

        Endif

        cFields += oTORMField:cName

    next

Return ( cFields )

/* METHOD: GetStructureStr( ... )
    Devuelve un array de cadenas separadas por comas con la estructura del modelo.

    Parámetros:
        ... - campos que se incluirán en la estructura, ejemplo:

--- Code
GetStructureStr( 'Name','Type','Description' )
---
Devolvería
--- Code
{ 'CODIGO,C,Código de la ficha','NOMBRE,C,Nombre de la ficha', ... }
---

Devuelve:
    Array
*/
METHOD GetStructureStr( ... ) CLASS TORMModel

    ::oReturnInit()

Return ( TORMPersistence():New( Self ):GetStructureStr( ... ) )

/* METHOD: GetStructure(  )
    Devuelve la estructura de los campos del modelo
Devuelve:
    Array
*/
METHOD GetStructure(  ) CLASS TORMModel
Return ( ::__aFields )

/* METHOD: GetField( cField )
    Devuelve el objeto TORMField dentro de __aFields de cField
    
    Parámetros:
        cField - Campo a devolver

Devuelve:
    TORMField
*/
METHOD GetField( cField ) CLASS TORMModel

    Local oTORMField := Nil
    Local nPosition := 0

    If ::HasField( cField )

        nPosition := aScan( ::__aFields, { | oTORMField | oTORMField:cName:Upper() == cField:Upper() } )
        oTORMField := ::__aFields[ nPosition ]

    Endif

Return ( oTORMField )

/* METHOD: SetRegistrationLog( oRegistrationLog )
    Asigna el objeto que se encargará de gestionar el log de registro del modelo
    
    Parámetros:
        oRegistrationLog - Objeto log que debe tener el método Write( cMessage ) para escribir el log
*/
METHOD SetRegistrationLog( oRegistrationLog ) CLASS TORMModel

    If HB_ISOBJECT( oRegistrationLog )

        ::__oRegistrationLog := oRegistrationLog

    Endif

Return ( Nil )

/* METHOD: RegistrationLog( cText )
    Escribe el texto en el log de registro correspondiente
    
    Parámetros:
        cText - Texto a escribir
*/
METHOD RegistrationLog( cText ) CLASS TORMModel

    If ::__oRegistrationLog != Nil

        ::__oRegistrationLog:Write( cText )

    Endif

Return ( Nil )

/* METHOD: GetRegistrationLog(  )
    Devuelve el objeto Registrationlog
Devuelve:
    Objeto
*/
METHOD GetRegistrationLog(  ) CLASS TORMModel
Return ( ::__oRegistrationLog )


// ---------------------------------------------------------------------------------------------------------------------
// Group: PROTECTED METHODS 

/* METHOD: oReturnInit(  )
    Inicializa __oRetunr
*/
METHOD oReturnInit() CLASS  TORMModel

    ::__oReturn := TReturn():New()

Return ( Nil )


/* METHOD: InternalDbId()
    Crea la DATA para vincular el Modelo con el registro en la tabla de la DB en caso de pertenecer a una tabla
*/
METHOD CreateInternalDbId(  ) CLASS TORMModel

    __objAddData( Self, ::InternalDbIdName() )

Return ( Nil )

/* METHOD: CreateLazyLoadShared(  )
    Crea el objeto que gestiona el lazyLoad si el modelo tiene dicha propiedad
*/
METHOD CreateLazyLoadShared(  ) CLASS TORMModel

    if __objHasData( Self, TORM_LAZYSHARED )

        If ::&(TORM_LAZYSHARED) == Nil

            ::&(TORM_LAZYSHARED) := TORMLazyLoadShared():New()

        Else

            ::__oSource:cOrigin := ::&(TORM_LAZYSHARED):cSource

        Endif

    Endif

Return ( Nil )

/* METHOD: LazyLoadCheck(  )
    Se encarga de chequear el lazy load y si hay agún cambio en la ruta de la carga inicial, se carga el modelo
*/
METHOD LazyLoadCheck(  ) CLASS TORMModel

    TORMPersistence():New( Self ):LazyLoadCheck()
    ::__oLazyLoad:Check()

Return ( Nil )

/* METHOD: WhereMake( ... )
    Asigna las condiciones del where para un posterior get(). Simula un método sobrecargado ya que realiza diferentes operaciones en función del número de parámetros pasado
    
    Parámetros:
        1 parámetro - Array con arrays de 2 o 3 parámetros para tener más condicionales
        2 parámetros - campo y valor a igualar al campo para cumplir la condición
        3 parámetros - campo, operador de comparación y valor a igualar con el campo mediante el operador de comparación

Devuelve:
    Self
*/
METHOD WhereMake( ... ) CLASS TORMModel

    Local aParameters := hb_aParams() 
    Local aParameter

    switch PCount()

        case 1

            if HB_ISARRAY( aParameters[ 1 ] )

                If HB_ISARRAY( aParameters[ 1, 1 ] )

                    for each aParameter in aParameters[ 1 ]

                        ::WhereMake( aParameter )
                    
                    next

                Else

                    switch aParameters[ 1 ]:Len()

                        case 2

                            ::__oQuery:AddCondition( { aParameters[ 1, 1 ], '==', TORMCheckFindValue():New( Self ):ConvertValue( aParameters[ 1, 2] ) } )
                            
                        exit
                
                        case 3
                
                            ::__oQuery:AddCondition( { aParameters[ 1, 1 ], aParameters[ 1, 2 ], TORMCheckFindValue():New( Self ):ConvertValue( aParameters[ 1, 3 ] ) } )
                            
                        exit
                    endswitch

                Endif

            Endif
            
        exit

        case 2

            ::__oQuery:AddCondition( { aParameters:Get( 1 ), '==', TORMCheckFindValue():New( Self ):ConvertValue( aParameters:Get( 2 ) ) } )
            
        exit

        case 3

            ::__oQuery:AddCondition( { aParameters:Get( 1 ), aParameters:Get( 2 ), TORMCheckFindValue():New( Self ):ConvertValue( aParameters:Get( 3 ) ) } )
            
        exit

    endswitch

Return ( Self )