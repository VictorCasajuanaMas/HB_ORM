#Include 'hbclass.ch'
#include 'hbcompat.ch'
/* CLASS: TCollection
    Gestiona las colecciones de la clase TORMModel
*/


// TODO: Testear
// TODO: Abstracción total de los modelos.

CREATE CLASS TCollection

    EXPORTED:
        METHOD GoTop()
        METHOD GoBottom()
        METHOD Len()
        METHOD Skip()
        METHOD Eof()
        METHOD Bof()
        METHOD Position()
        METHOD Empty()
        METHOD Refresh()
        METHOD GetCollection()
        METHOD __Find( xFindValue, cOrder )  // le pongo _ delante para distinguirlo del find() del modelo
        METHOD __FindFirstBigger( xFindValue, cOrder )  
        METHOD Inject( aDataToInject )
        METHOD Assign( aDataToAssign)
        METHOD HasCollection()
        METHOD SetCollectionLoaded( lValue )
        METHOD Sort( cOrder )
        METHOD Initialize()
        METHOD ToHashes()
        METHOD ToJsons()
        METHOD ToArray( cFields )
        METHOD SetItem( xItem, nPosition )
        METHOD Eval( bBlock )

            DATA __aCollection       AS ARRAY   INIT Array( 0 )
    PROTECTED:
        DATA __nRecPosition      AS INTEGER INIT 0
        DATA __Eof               AS LOGICAL INIT .F.
        DATA __lBof              AS LOGICAL INIT .F.
        DATA __lCollectionLoaded AS LOGICAL INIT .F.

        METHOD SetEof( __Eof )
        METHOD SetBof( __lBof )
        METHOD UpdateCollectionWithActualData()
        METHOD ChangenRecPosition( nNewRecPosition )
        METHOD SetnRecPosition( nNewRecPosition )
        METHOD GetFieldsofCollection()
        METHOD RefreshInternalDbId()

ENDCLASS

METHOD GoTop() CLASS TCollection

    If ::Empty()

        ::SetnRecPosition( 0 )

    Else

        ::SetnRecPosition( 1 )

    Endif

    ::SetBof( .F. )
    ::SetEof( .F. )
    ::Refresh()

Return ( Nil )

METHOD GoBottom() CLASS TCollection

    ::SetnRecPosition( ::__aCollection:Len() )
    ::SetBof( .F. )
    ::SetEof( .F. )
    ::Refresh()

Return ( Nil )

METHOD Len() CLASS TCollection
Return  ( ::__aCollection:Len() )

METHOD Skip( nJump ) CLASS TCollection

    hb_Default( @nJump, 1 )

    ::SetBof( .F. )
    ::SetEof( .F. )

    If !::Empty() .And.;
       (( nJump >0 .And. !::Eof() ) .Or.;
        ( nJump <0 .And. !::Bof() ) )

       ::SetnRecPosition( ::__nRecPosition + nJump )
       
       If ::__nRecPosition <= 0

        ::SetnRecPosition( 1 )
        ::SetBof( .T. )

       Endif

       If ::__nRecPosition > ::Len()

        ::SetnRecPosition( ::Len() )
        ::SetEof( .T. )

       Endif

    Endif

    ::Refresh()

Return ( Nil )

METHOD Eof() CLASS TCollection
Return ( ::__Eof )

METHOD Bof() CLASS TCollection
Return ( ::__lBof )

METHOD Position() CLASS TCollection
Return ( ::__nRecPosition )

METHOD Empty() CLASS TCollection
Return ( ::Len() == 0 )

METHOD Refresh() CLASS TCollection

    Local oField
    Local oRelation

    If ::Empty()

        ::SetEof( .T. )
        ::SetBof( .T. )

    Endif

    If ::__nRecPosition >= 1 .And.;
       ::__nRecPosition <= ::Len()

        for each oField in Self:__aFields()

            ::&( oField:cName ) := ::__aCollection[ ::__nRecPosition ]:&( oField:cName )

        Next

        If __objHasData( Self, '__OINITIALBUFFER')

            ::__oInitialBuffer := ::__aCollection[ ::__nRecPosition ]:__oInitialBuffer

        Endif

        // TODO: Intentar extraer esta lógica para que TCollection sea más abstracta a las relaciones
        for each oRelation in Self:__oRelations:GetRelations()

            ::&( oRelation:cName) := ::__aCollection[ ::__nRecPosition ]:&( oRelation:cName )

        next

        ::RefreshInternalDbId()
        
    Endif

Return ( Nil )


METHOD Getcollection() CLASS TCollection
Return ( ::__aCollection )

/* METHOD: __Find( xFindValue, cOrder )
    Busca el PRIMER registro en la colección

    Parámetros:
        cOrder - Campo del modelo a localizar

Devuelve:
    El item encontrado
*/
METHOD __Find( xFindValue, cOrder ) CLASS TCollection

    Local oRecord := Nil
    Local oItemFound := Nil
    
    for each oRecord in ::__aCollection

        If CleanData( oRecord:&( cOrder ) )  == CleanData( xFindValue ) .And.;
           oItemFound == Nil

            oItemFound := oRecord

        Endif
        
    next

Return ( oItemFound )


/* METHOD: Find()
    Busca la coincidencia mayor más cercana al valor buscado o el valor buscado si existe
    Por ejemplo, en un array : {1,3,5,7,9,11} si buscamos 4 devolverá 3

Devuelve:
    Modelo
*/
METHOD __FindFirstBigger( xfindValue, cOrder ) CLASS TCollection

    Local oRecord := Nil
    Local oItemFound := Nil
    Local lFirst  := .F.

    ::Sort( cOrder )

    for each oRecord in ::__aCollection

        If .Not. lFirst

            oItemFound := oRecord
            lFirst := .T.

        Endif

        If .Not. lFirst .Or.;
            (;
                oRecord:&(cOrder) < xFindValue;
            )

            oItemFound := oRecord 

        Endif

    Next

Return ( oItemFound )

/* METHOD: Inject( aDataToInject )
    Inyecta datos a la colección
    
    Parámetros:
        aDataToInject - Array de datos a inyectar
*/
METHOD Inject( aDataToInject ) CLASS TCollection

    If .Not. HB_ISARRAY( aDataToInject )

        aDataToInject := { aDataToInject }

    Endif

    ::__aCollection:ArrayAdd( aDataToInject )
    ::__lCollectionLoaded := .T.

Return ( Nil )

/* METHOD: Assign( aDataToAssign )
    Asigna directamente un array a la colección eliminando el contenido del existente
    
    Parámetros:
        aDataToAssig : Array a asignar
*/
METHOD Assign( aDataToAssign ) CLASS TCollection

    If HB_ISARRAY( aDataToAssign )

        ::__aCollection := aDataToAssign
        ::__lCollectionLoaded := .T.

    Endif

Return ( Nil )

/* METHOD: HasCollection(  )
    Devuelve .T. o .F. según se haya insertado una colección. Puede que el Len() sea 0 pero se haya intentado volcar una colección vacía, entonces devolverá .T.

Devuelve:
Lógico
    
*/
METHOD HasCollection() CLASS TCollection
Return ( ::__lCollectionLoaded )

/* METHOD: SetCollectionLoaded( lValue )
    Asigna el valor a __lCollectionLoaded
    
    Parámetros:
        lValue - Valor a asignar

Devuelve:
    
*/
METHOD SetCollectionLoaded( lValue ) CLASS TCOllection

    If HB_ISLOGICAL( lValue )

        ::__lCollectionLoaded := lValue

    Endif

Return ( Nil )

/* METHOD: Sort( cOrder )
    Ordena la colección por cOrder
    
    Parámetros:
        cOrder - Campor a ordenar
Devuelve
    Self
*/
METHOD Sort( cOrder, cTypeOrder ) CLASS TCollection

    hb_Default( @cTypeOrder, 'ASC' )

    switch cTypeOrder:Upper()

        case 'ASC'

            ::__aCollection := aSort( ::__aCollection,,,{ | x, y | x:&(cOrder) < y:&(cOrder) } )
            
        exit

        case 'DESC'

            ::__aCollection := aSort( ::__aCollection,,,{ | x, y | x:&(cOrder) > y:&(cOrder) } )
            
        exit

    endswitch

Return ( Self )

/* METHOD: Initialize(  )
    Inicializa la colección 
*/
METHOD Initialize() CLASS TCOllection

    ::__aCollection       := Array( 0 )
    ::__nRecPosition      := 0
    ::__Eof               := .F.
    ::__lBof              := .F.
    ::__lCollectionLoaded := .F.

Return ( Nil )

/* METHOD: ToJsons(  )
    Devuelve un Json con los datos de la colección. Válido solo para colecciones de objetos que disponen el método ToHash()

Devuelve:
    Caracter
*/
METHOD ToJsons() CLASS TCollection
Return ( hb_JsonEncode( ::ToHashes ) )

/* METHOD: ToHashes(  )
    Devuelve un array de hashes con los datos de la colección. Válido solo para colecciones de objetos que disponen el método ToHash()

Devuelve:
    Array
*/
METHOD ToHashes(  ) CLASS TCollection

    Local aHashes   := Array( 0 )
    Local oObject   := Nil
    Local oRelation := Nil
    Local hHash     := hb_Hash()

    for each oObject in ::__aCollection

        If HB_ISOBJECT( oObject ) .And.;
           __objHasMethod( oObject, 'ToHash' )

           hHash := oObject:ToHash()
           
           //TODO: Solucionar esto para abstraer completamente TCollection de las relaciones, quizás almacenando un hashes en el array de colecciones en vez del modelo?
           for each oRelation in Self:__oRelations:GetRelations()
            
                hHash := hb_HMerge( hHash, oObject:&( oRelation:cName ):ToHash() )
            
            next

            aAdD( aHashes, hHash )

        Endif

    next

Return ( aHashes )

/* METHOD: ToArray( cfields )
    Devuelve un array con los datos de la colección y los campos indicados en cFields
    
    Parámetros:
        cFields - Campos a devolver separados por comas, si no se pasa o se pasa * los devuelve todos.

Devuelve:
    Array
*/
METHOD ToArray( cfields ) CLASS TCOllection

    Local aArray  := Array( 0 )
    Local aData   := Array( 0 )
    Local cField  := ''
    Local aFields := Array( 0 )
    Local xItem   := Nil

    hb_Default( @cFields, '*' )

    If cfields == '*'

        aFields := ::GetFieldsofCollection()

    Else

        aFields := hb_ATokens( cFields:Upper(), ',' )

    Endif

    for each xItem in ::__aCollection

        do case

            case HB_ISOBJECT( xItem)

                If aFields:Len() == 1

                    aAdD( aArray, xItem:&( aFields:Get( 1 ) ) )

                Else

                    aData := Array( 0 )

                    for each cfield in aFields

                        aAdD( aData, xItem:&( cfield ) )
                        
                    next

                    aAdD( aArray, adata )

                Endif

            case HB_ISHASH( xItem)

                // TODO: Pendiente de hacer con Hash
                
        endcase
        
    next

Return ( aArray )


Static Function CleanData( uData ) 

    switch ValType( uData )

        case 'C'

            uData := uData:Alltrim()
            
        exit

    endswitch

Return ( uData )

/* METHOD: Eval( bBlock )
    Evalúa bBlock por cada item de la colección devolviendo .T. si no ha fallado
    
    Parámetros:
        bBlock - Codeblock a evaluar. Al codeblock se le pasa el item de la colección como parámetro

Devuelve:
    Lógico
*/
METHOD Eval( bBlock ) CLASS TCollection

    Local xItem   := Nil
    Local lEvalOk := .T.
    Local oError  := Nil 

    for each xItem in ::__aCollection

        If HB_ISOBJECT( xItem )

            try 
                
                Eval( bBlock, xItem)

            catch oError

                lEvalOk := .F.
                
            end

        Endif

    next

    ::Refresh()

Return ( lEvalOk )

// ---------------------------------------------------------------------------------------------------------------
// Group: PROTECTED METHODS
METHOD RefreshInternalDbId() CLASS TCollection

    ::&( ::InternalDbIdName() ) := ::__aCollection[ ::__nRecPosition ]:&( ::InternalDbIdName() )

Return Nil 

METHOD SetEof( __Eof ) CLASS TCollection

    If ::Empty()

        ::__Eof := .T.

    Else

        ::__Eof := __Eof
        
    Endif

Return ( Nil )

METHOD SetBof( __lBof ) CLASS TCollection

    If ::Empty()

        ::__lBof := .T.

    Else

        ::__lBof := __lBof
        
    Endif

Return ( Nil )

METHOD UpdateCollectionWithActualData() CLASS TCollection

    Local oField 

    If ::__nRecPosition >= 1 .And.;
        ::__nRecPosition <= ::Len()
 
         for each oField in Self:__aFields()
 
            ::__aCollection[ ::__nRecPosition ]:&( oField:cName ) := ::&( oField:cName )
 
         Next
 
     Endif

Return ( Nil )

METHOD ChangenRecPosition( nNewRecPosition ) CLASS TCollection

    If !::Empty() 

        ::UpdateCollectionWithActualData()

    Endif

Return ( Nil )

METHOD SetnRecPosition( nNewRecPosition ) CLASS TCollection

    ::ChangenRecPosition( nNewRecPosition )
    ::__nRecPosition := nNewRecPosition

Return ( Nil )

/* METHOD: GetFieldsofCollection(  )
    Devuelve un array con el nombre de los campos que hay en la colección, solo procesa los items object y hash
    
Devuelve:
    Array
*/
METHOD GetFieldsofCollection(  ) CLASS TCollection

    Local xItem   := Nil
    Local aFields := Array( 0 )
    Local cKey    := ''
    Local cData   := ''

    for each xItem in ::__aCollection

        do case
            
            case HB_ISOBJECT( xItem )

                for each cData in __objGetMsgList( xItem, .T. )

                    aFields:AddIfNotExist( cData )
                    
                next

            case HB_ISHASH( xItem )

                for each cKey in hb_hKeys( xItem)
                    
                    aFields:AddIfNotExist( cKey )

                next
                
        endcase

    next

Return ( aFields )

/* METHOD: SetItem( xItem, nPosition ) 
    Asigna un item a la posición nPosition
    
    Parámetros:
        xItem - Item a asignar
        nPosition - Posicion a asignar

Devuelve:
    
*/
METHOD SetItem( xItem, nPosition ) CLASS TCollection

    If nPosition != 0 .And.;
       ::Len() <= nPosition

       ::__aCollection[ nPosition ] := xItem

    Endif

Return ( Nil )