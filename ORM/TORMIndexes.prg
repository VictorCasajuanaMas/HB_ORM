/* CLASS: TORMIndexes 
    Se encarga de gestionar todo lo referente a los índices del modelo
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMIndexes

    EXPORTED:
        DATA lPrimaryKey      AS LOGICAL   INIT .F.
        DATA aIndex           AS ARRAY     INIT Array( 0 )
        DATA oPrimaryKey      AS OBJECT    INIT Nil
        
        METHOD New( oTORMModel ) CONSTRUCTOR

        METHOD HasIndexes()
        METHOD HasIndex( cField )
        METHOD IndexNumeral( cOrder )
        METHOD OrderDefault( cOrder )
        METHOD GetPrimaryKey(  )            

    PROTECTED:
        DATA oTORMModel       AS OBJECT    INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMIndexes

    ::oTORMModel  := oTORMModel
    ::oPrimaryKey := TORM_PRIMARYKEYDEFAULT

Return ( Self )

/* METHOD: HasIndexes(  )
    Devuelve .T. si el modelo tiene índices definidos

Devuelve:
    Lógico
*/
METHOD HasIndexes( ) CLASS TORMIndexes
Return ( ::aIndex:NotEmpty() )

/* METHOD: HasIndex( cField )
    Indica si el modelo tiene definido el índice correspondiente al campo cField
    
    Parámetros:
        cField - Nombre del campo a comprobar

Devuelve:
    Lógico
*/
METHOD HasIndex( cField ) CLASS TORMIndexes
Return ( aScan( ::aIndex, { | oTORMIndex | oTORMIndex:cField:Upper() == cField:Upper } ) != 0 )

/* METHOD: IndexNumeral( cOrder )
    Devuelve el numeral correspondiente a cOrder dentro de aIndex
    
    Parámetros:
        cOrder - Campo a localizar en los índices

Devuelve:
    Numérico
*/
METHOD IndexNumeral( cOrder ) CLASS TORMIndexes

    Local nNumeral := 0
    Local nIndexPosition := 0

    cOrder := ::OrderDefault( cOrder )
    
    nIndexPosition := aScan( ::aIndex, { | oTORMIndex | oTORMIndex:cField:Upper() == cOrder:Upper } )

    If nIndexPosition != 0

        nNumeral := ::aIndex[ nIndexPosition ]:nNumeral

    Endif

Return ( nNumeral )

/* METHOD: OrderDefault( cOrder )
    Ayuda a la gestión del orden por defecto en los métodos de búsqueda. Si se le pasa cOrder devuelve el mismo, de lo contrario devuelve el que ha de ser por defecto
    
    Parámetros:
        cOrder - Orden pasado

Devuelve:
    Character
*/
METHOD OrderDefault( cOrder ) CLASS TORMIndexes
    
    If cOrder == Nil  .Or.;
       cOrder:Empty()

       cOrder := ::oPrimaryKey:cName

    Endif

Return ( cOrder )

/* METHOD: GetPrimaryKey(  )
    Devuelve la primary key de los índices del modelo

        
Devuelve:
    TORMIndex
*/
METHOD GetPrimaryKey(  ) CLASS TORMIndexes

    Local oTORMIndexPrimaryKey := Nil
    Local oTORMIndex           := Nil

    for each oTORMIndex in ::aIndex

        If oTORMIndex:lIsPrimaryKey

            oTORMIndexPrimaryKey := oTORMIndex

        Endif
        
    next

Return ( oTORMIndexPrimaryKey )


// Group: PROTECTED METHODS