/* CLASS: TORMPersistence
          Capa de persistencia que se encarga de vifurcar los métodos a cada capa según el DATASOURCE que se utilice
          Cualquier DATASOURCE que se quiera gestionar ha de tener todos los métodos de esta clase

    TODO: Cuando se aplique la persistencia en SQL, intentar hacerlo mediante la inyección de dependencias y el principio de sustitución de liskov
*/

#include 'hbclass.ch'
#include 'TORM.ch'


CREATE CLASS TORMPersistence

    PROTECTED:
    
    EXPORTED:
    
    DATA oTORMModel AS OBJECT Init Nil
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD InitField( oTORMField )
        METHOD Save()
        METHOD SaveCollection( lNewData )
        METHOD Find( cOrder )
        METHOD FindInternalID( xInternalID )
        METHOD FindFirstBigger( cOrder )
        METHOD Delete( aRecordsToDelete )
        METHOD DropTable()
        METHOD RecCount()
        METHOD Count()
        METHOD Insert( aData )
        METHOD First( cOrder )
        METHOD Last( cOrder )
        METHOD LoadLimits( cOrder )
        METHOD Get( )
        METHOD LoadFromSource( xSource )
        METHOD LoadMultipleFromSource( oFind )
        METHOD PutToSource( xSource )
        METHOD LoadRelations()
        METHOD CheckSource( xSource )
        METHOD GetStructureStr( ... )
        METHOD LazyLoadCheck()
        METHOD Update( hData )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor, se le inyecta el modelo

    Parametros:
        - oTORMModel : objeto TORMModel

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMPersistence

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: InitField( oTORMField )
    Devuelve el valor de inicialización de un campo

    Parametros:
        - oTORMField : objeto tipo TORMField a inicializar

Devuelve:
    Undefined
*/
METHOD InitField( oTORMField ) CLASS TORMPersistence

    Local xInitValue := Nil

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_COLLECTION
        case TORM_DATASOURCE_ADODBF

            xInitvalue := TORMDBFInitField():New( oTORMField ):GetInit( )
            
        exit

    endswitch

Return ( xInitValue )

/* METHOD: Save( )
    comentado en TORMModel

*/
METHOD Save() CLASS TORMPersistence

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            TORMDBFSave():New( ::oTORMModel ):Save()
            
        exit

    endswitch

Return ( ::oTORMModel )

/* METHOD: SaveCollection( lNewData )
    comentado en TORMModel

*/
METHOD SaveCollection( lNewData ) CLASS TORMPersistence

    
    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            TORMDBFSaveCollection():New( ::oTORMModel ):Save( lNewData)
            
        exit

    endswitch

Return ( ::oTORMModel )



/* METHOD: Find()
    Comentado en TORMModel

*/

METHOD Find( cOrder ) CLASS TORMPersistence

    If .Not. Empty( ::oTORMModel:__xFindValue )

        switch ::oTORMModel:__DataSource

            case TORM_DATASOURCE_DBF
            case TORM_DATASOURCE_ADODBF

                TORMDBFFind():New( ::oTORMModel ):Find( cOrder )
                
            exit

            case TORM_DATASOURCE_COLLECTION

                TORMCollectionFind():New( ::oTORMModel ):Find( cOrder )

            exit

        endswitch

    Endif

Return ( ::oTORMModel )


/* METHOD: FindInternalID()
    Comentado en TORMModel
*/
METHOD FindInternalID( xInternalID ) CLASS TORMPersistence

    If .Not. Empty( xInternalID )

        switch ::oTORMMOdel:__DataSource

            case TORM_DATASOURCE_DBF
            case TORM_DATASOURCE_ADODBF

                TORMDBFFindInternalID():New( ::oTORMModel ):FindInternalID( xInternalID )
                
            exit
        endswitch

    Endif

Return ( ::oTORMModel )



/* METHOD: First( cOrder )
    Comentado en TORMModel

*/

METHOD First( cOrder ) CLASS TORMPersistence

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF

            TORMDBFFirst():New( ::oTORMModel ):First( cOrder )
            
        exit

        case TORM_DATASOURCE_COLLECTION

            TORMCollectionFirst():New( ::oTORMModel ):First()

        exit

    endswitch

Return ( ::oTORMModel )

/* METHOD: LoadLimits( cOrder )
    Comentado en TORMModel

*/

METHOD LoadLimits( cOrder ) CLASS TORMPersistence

    Local aReturn := Array( 0 )

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            aReturn := TORMDBFLoadLimits():New( ::oTORMModel ):Load( cOrder )
            
        exit

    endswitch

Return ( aReturn )

/* METHOD: Last( cOrder )
    Comentado en TORMModel

*/

METHOD Last( cOrder ) CLASS TORMPersistence

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF

            TORMDBFLast():New( ::oTORMModel ):Last( cOrder )
            
        exit

        case TORM_DATASOURCE_COLLECTION

            TORMCollectionLast():New( ::oTORMModel ):Last()

        exit

    endswitch

Return ( ::oTORMModel )


/* METHOD: FindFirstBigger()
    Comentado en TORMModel

*/

METHOD FindFirstBigger( cOrder ) CLASS TORMPersistence

    If .Not. Empty( ::oTORMModel:__xFindValue )

        switch ::oTORMModel:__DataSource

            case TORM_DATASOURCE_COLLECTION

                TORMCollectionFindFirstBigger():New( ::oTORMModel ):Find( cOrder )

            exit

        endswitch

    Endif

Return ( ::oTORMModel )

/* METHOD: DropTable() 
    Comentado en TORMModel

*/
METHOD DropTable() CLASS TORMPersistence

    Local oReturn := TREturn():New()

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            oReturn := TORMDBFDropTble():New( ::oTORMModel ):DropTable()
            
        exit

    endswitch

Return ( oReturn )

/* METHOD: RecCount( )
    Comentado en TORMModel
    
*/
METHOD RecCount( ) CLASS TORMPersistence

    
    Local oReturn := TReturn():New()

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF

            oReturn := TORMDBFRecCount():New( ::oTORMModel ):RecCount()
            
        exit

        case TORM_DATASOURCE_COLLECTION

            oReturn := TORMCollectionRecCount():New( ::oTORMModel ):RecCount()

        exit

    endswitch

Return ( oReturn )

/* METHOD: Count( )
    Comentado en TORMModel
*/
METHOD Count( ) CLASS TORMPersistence
    
    Local oReturn := TReturn():New()

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            oReturn := TORMDBFCount():New( ::oTORMModel ):Count()
            
        exit

    endswitch

Return ( oReturn )


/* METHOD: Insert( aData )
    Comentado en TORMModel
    
*/
METHOD Insert( aData ) CLASS TORMPersistence

    Local nRecordsAdded := 0

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            nRecordsAdded := TORMDBFInsert():New( ::otORMModel ):Insert( aData )
            
        exit

    endswitch

Return ( nRecordsAdded )


/* METHOD: Delete( aRecordsToDelete )
    Comtanda en TORMModel

Devuelve:
    
*/
METHOD Delete( aRecordsToDelete ) CLASS TORMPersistence

    Local nRecordsDeleted := 0

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            nRecordsDeleted := TORMDBFDelete():New( ::oTORMModel ):Delete( aRecordsToDelete )
            
        exit

    endswitch

Return ( nRecordsDeleted )


/* METHOD: Get( ) 
    Comentado en TORMModel

Devuelve:
    Array de Modelos
    
*/
METHOD Get( ) CLASS TORMPersistence

    Local aReturn := Array( 0 )

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
            
            aReturn := TORMDBFGet():New( ::oTORMModel ):Get( )

        exit

        case TORM_DATASOURCE_ADODBF

            aReturn := TORMADOGet():New( ::oTORMModel ):Get( )
            
        exit

    endswitch

Return ( aReturn )

/* METHOD: LoadFromSource( xSource )
    Comentado en TORMModel
    
    Parámetros:
        xSource

Devuelve:
    oReturn
*/
METHOD LoadFromSource( xSource ) CLASS TORMPersistence

    Local oReturn := TReturn():New( .F.)

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            oReturn := TORMDBFLoadfromAlias():New( ::oTORMModel ):Model( xSource )
            
        exit

    endswitch

Return ( oReturn )

/* METHOD: LoadMultipleFromSource( oFind )
    Comentado en TORMModel
    
    Parámetros:
        Dependiendo del source

Devuelve:
    oReturn
*/
METHOD LoadMultipleFromSource( oFind ) CLASS TORMPersistence

    Local oReturn := TReturn():New( .F. )

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            oReturn := TORMDBFLoadMultipleFromAlias():New( ::oTORMModel ):Model( oFind )
            
        exit

    endswitch

Return ( oReturn )


/* METHOD: PutToSource( xSource )
    Comentado en TORMModel
    
    Parámetros:
        Dependiendo del source

Devuelve:
    oReturn
*/
METHOD PutToSource( xSource ) CLASS TORMPersistence

    Local oReturn := TReturn():New( .F. )

    switch ::oTORMModel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            oReturn := TORMDBFPutToSource():New( ::oTORMModel ):Put( xSource )
            
        exit

    endswitch

Return ( oReturn )

/* METHOD: LoadRelations(  )
    Carga las relaciones en la colección de modelos
    
Devuelve:
    oReturn
*/
METHOD LoadRelations(  ) CLASS TORMPersistence

    Local oReturn := TReturn():New()

    switch ::oTORMMOdel:__DataSource

        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION
        
            oReturn := TORMDBFLoadRelations():New( ::oTORMModel ):Load()

        exit

    endswitch

Return ( oReturn )

/* METHOD: CheckSource( xSource )
    comentado en TORMModel
*/
METHOD CheckSource( xSource ) CLASS TORMPersistence

    switch ::oTORMModel:__DataSource
        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            TORMDBFCheck():New( ::oTORMModel ):Check( xSource )
            
        exit
    endswitch

Return ( Nil )

/* METHOD: GetStructureStr( ... )
    Comentado en TORMModel
*/
METHOD GetStructureStr( ... ) CLASS TORMPersistence

    Local aStruct := Array( 0 )

    switch ::oTORMModel:__DataSource
        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            aStruct := TORMGetStructureStr():New( ::oTORMModel ):Get( ... )
            
        exit
    endswitch

Return ( aStruct )

/* METHOD: LazyLoadCheck()
    Comentado en TORMModel
*/
METHOD LazyLoadCheck() CLASS TORMPersistence

    switch ::oTORMModel:__DataSource
        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            TORMDBFLazyLoadCheck():New( ::oTORMModel ):Check()
            
        exit
    endswitch

Return ( Nil)

/* METHOD: Update( hData )
    comentado en TORMModel
*/
METHOD Update( hData ) CLASS TORMPersistence

    Local nRecordsUpdated := 0

    switch ::oTORMModel:__DataSource
        case TORM_DATASOURCE_DBF
        case TORM_DATASOURCE_ADODBF
        case TORM_DATASOURCE_COLLECTION

            nRecordsUpdated := TORMDBFUpdate():New( ::oTORMModel ):Update( hData )
            
        exit
    endswitch

Return ( nRecordsUpdated )
