/* CLASS: TORMDBFDelete 
    Elimina registros de la tabla DBF
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFDelete FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR

        METHOD Delete( aRecordsToDelete )

            DATA oTORMModel AS OBJECT INIT Nil
    PROTECTED:

        DATA cAlias          AS CHARACTER INIT ''

        METHOD DeleteCollection(  )
        METHOD DeleteForeignKeys( xDelete )
        METHOD DeleteRecno( xDelete )
        METHOD DeleteWithaRecords( aRecordsToDelete )
        METHOD DeleteWithInteralID( )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo 

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFDelete

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Delete( aRecordsToDelete )
    Elimina el registro de la base de datos
    
    Parámetros:
        aRecordsToDelete - Array con las claves primarias de los registros a borrar

Devuelve:
    Nº de registros eliminados
*/
METHOD Delete( aRecordsToDelete ) CLASS TORMDBFDelete

    Local xDelete
    Local rSeek           := Nil
    Local nRecordsDeleted := 0

    hb_default( @aRecordsToDelete, Array( 0 ) )

    If TORMDBFTableExist():New( ::oTORMModel ):Exists( 'dbf' ):Fail()
        
        TORMDBFCreateTable():New( ::oTORMModel ):Create()
        
    Endif
    
    ::cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()

    If aRecordsToDelete:Empty() .And.;
       .Not. ::oTORMModel:__xFindValue:Empty()

        aRecordsToDelete := { ::oTORMModel:__xFindValue }

    Endif
    
    If ::oTORMModel:Success()

        nRecordsDeleted += ::DeleteWithInteralID( aRecordsToDelete )
        nRecordsDeleted += ::DeleteWithaRecords( aRecordsToDelete )
        nRecordsDeleted += ::DeleteCollection()

    Endif

    TORMDBFCloseTable():New( ::oTORMModel ):Close( ::cAlias )

Return ( nRecordsDeleted )

/* METHOD: DeleteCollection(  )
    Método que elimina la colección de datos que contiene el modelo devolviendo el número de registros eliminados

Devuelve:
    Numérico
*/
METHOD DeleteCollection(  ) CLASS TORMDBFDelete

    Local nRecordsDeleted := 0
    Local oModel          := Nil

    If ::oTORMModel:__oQuery:aWhereConditions:Len() != 0 .And.;
       .Not. ::oTORMModel:HasCollection() // Esto ocurre cuando se hace un oModelo:Where( lo que sea ):Delete() ya que al no ejecutar el Get se ha cargado el query pero no hay colección aún

       ::oTORMModel:Get()

    Endif

    for each oModel in ::oTORMModel:GetCollection()
        
        nRecordsDeleted += oModel:Delete( oModel:&(oModel:__oIndexes:GetPrimaryKey():cField )) 

        If oModel:Fail

            ::oTORMModel:__oReturn:Success := .F.
            ::oTORMModel:__oReturn:Log     := oModel

        Endif

    next

Return ( nRecordsDeleted )

// Group: PROTECTED METHODS
/* METHOD: DeleteForeignKeys( xDelete )
    Elimina los registros de las tablas relacionadas
    
Devuelve:
    Modelo
*/
METHOD DeleteForeignKeys( xDelete ) CLASS TORMDBFDelete

    Local oForeignKey    := Nil
    Local oChilTORMModel := Nil

    If ::oTORMModel:Success .And.;
       ::oTORMModel:__oForeignKeys:HasForeignKeys()

        for each oForeignKey in ::oTORMModel:__oForeignKeys:aForeignKey

            oChilTORMModel := &( oForeignKey:cModel )():New( xDelete ):Delete()
           
        next

    Endif

Return ( ::oTORMModel )

/* METHOD: DeleteRecno( xDelete )
    Elimina el registro actual
    
    Parámetros:
        xDelete - Clave a borrar, solo a efectos de depuración

Devuelve:
    Lógico
*/
METHOD DeleteRecno( xDelete ) CLASS TORMDBFDelete

    Local rLock := Nil 

    rLock := TORMDBFRLock():New( ::oTORMModel ):Lock( ::cAlias )

    If rLock:Fail()

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[14][1], TORM_ERROR_MESSAGE[14][2], {xDelete:Str()} ))
            
    Else

        try 

            ::oTORMModel:LogWrite( hb_StrReplace( TORM_INFO_MESSAGE[08][1], TORM_INFO_MESSAGE[08][2], { ::oTORMModel:TableName(), ( ::cAlias )->( Recno() ):Str() } ) )
            ( ::cAlias )->( DbDelete() )
            ::oTORMModel:__oReturn:Success := .T.
            
        catch oError

            ::oTORMModel:__oReturn:Success := .F.
            ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[15][1], TORM_ERROR_MESSAGE[15][2], {TTryCatchShowerror():New( oError ):ToString()} ))
            
        end
        
    Endif

Return ( ::oTORMModel:__oReturn:Success )

/* METHOD: DeleteWithaRecords( aRecordsToDelete )
    Elimina según el array aRecordsToDelete
    
    Parámetros:
        aRecordsToDelete - Array a procesar los borrados

Devuelve:
    Numérico
    
*/
METHOD DeleteWithaRecords( aRecordsToDelete ) CLASS TORMDBFDelete

    Local xDelete         := Nil 
    Local rSeek           := Nil
    Local nRecordsDeleted := 0

    for each xDelete in aRecordsToDelete

        While ( rSeek := TORMDBFSeek():New( ::oTORMModel ):Seek( MDBFSEek():New( ::cAlias, xDelete ) ) ):Success

            If ::DeleteRecno( xDelete )

                nRecordsDeleted++
                ::DeleteForeignKeys( xDelete )

            Endif

        Enddo

        If nRecordsDeleted == 0
            
            ::oTORMModel:__oReturn:Success := .F.
            ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[16][1], TORM_ERROR_MESSAGE[16][2], {xDelete:Str()} ) )
            
        Endif
        
    next

Return ( nRecordsDeleted )

/* METHOD: DeleteWithInteralID( aRecordsToDelete )
    Elimina el registro según su InteralID
    
    Parámetros:
        aRecordsToDelete - Array a procesar los borrados

Devuelve:
    Numérico
*/
METHOD DeleteWithInteralID( aRecordsToDelete ) CLASS TORMDBFDelete

    Local nRecordsDeleted := 0

    If ( aRecordsToDelete == Nil .Or.;
         aRecordsToDelete:Len() == 0 ) .And.;
       .Not. ::oTORMModel:__oQuery:HasWhere() .And.;
       ::oTormModel:GetInternalDbId() != 0

        ( ::cAlias )->( DbGoTo( ::oTormModel:GetInternalDbId() ) )

        If ( ::cAlias )->( Recno() ) == ::oTORMModel:GetInternalDbId()

            If ::DeleteRecno()

                nRecordsDeleted++

            Endif

        Else

            ::oTORMModel:__oReturn:Success := .F.
            ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[73][1], TORM_ERROR_MESSAGE[73][2], {oTORMModel:GetInternalDbId():Str()}) )

       Endif

    Endif

Return ( nRecordsDeleted )