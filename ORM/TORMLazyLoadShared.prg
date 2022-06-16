/* CLASS: TORMLazyLoadShared 
    Clase que se encarga de gestionar la carga diferida compartida de los modelos
*/
#include 'hbclass.ch'

CREATE CLASS TORMLazyLoadShared

    EXPORTED:
        METHOD New(  ) CONSTRUCTOR
        METHOD SetCollection( aCollection )
        METHOD GetCollection()
        METHOD HasCollection()
        METHOD InitCollection()

            DATA cSource           AS CHARACTER INIT ''
    PROTECTED:
        DATA lCollectionLoaded AS LOGICAL   INIT .F.
        DATA aCollection       AS ARRAY     INIT Array( 0 )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New(  )
    Constructor.  
Devuelve:
    Self
*/
METHOD New(  ) CLASS TORMLazyLoadShared
Return ( Self )

/* METHOD: SetCollection( aCollection )
    Asigna los datos a la colección.
    
    Parámetros:
        aCollection - Colección de datos a asignar

Devuelve:
    
*/
METHOD SetCollection( aCollection ) CLASS TORMLazyLoadShared

    If HB_ISARRAY( aCollection )

        ::aCollection       := aCollection
        ::lCollectionLoaded := .T.

    Endif

Return ( Nil )

/* METHOD: GetCollection(  )
    Devuelve la colección cargada.
Devuelve:
    Array
*/
METHOD GetCollection(  ) CLASS TORMLazyLoadShared
Return ( ::aCollection )

/* METHOD: HasCollection(  )
    Indica si hay colección cargada
Devuelve:
    Lógico
*/
METHOD HasCollection(  ) CLASS TORMLazyLoadShared
Return ( ::lCollectionLoaded )

/* METHOD: InitCollection(  )
    Inicializa la colección al estado de no cargada.
*/
METHOD InitCollection(  ) CLASS TORMLazyLoadShared
    
    ::SetCollection( Array( 0 ) )
    ::lCollectionLoaded := .F.

Return ( Nil )

// Group: PROTECTED METHODS