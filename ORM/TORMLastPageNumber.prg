/* CLASS: TORMLastPageNumber 
    Clase que controla el último número de página
*/
#include 'hbclass.ch'


CREATE CLASS TORMLastPageNumber

    DATA lDataLoaded     AS LOGICAL INIT .F.

    EXPORTED:
        METHOD New(  ) CONSTRUCTOR
        METHOD LastPageNumber( nPage ) SETGET
        METHOD IsLoaded() 
        METHOD Init()

    PROTECTED:
        DATA nLastPageNumber AS NUMERIC INIT 0
        

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New(  )
    Constructor. 

Devuelve:
    Self
*/
METHOD New(  ) CLASS TORMLastPageNumber
Return ( Self )

/* METHOD: LastPageNumber( nPage )
    SetGet de nLastPageNumber

Devuelve:
    Numérico
*/
METHOD LastPageNumber( nPage ) CLASS TORMLastPageNumber

    If nPage != Nil

        ::nLastPageNumber := nPage
        ::lDataLoaded     := .T.

    Endif

Return ( ::nLastPageNumber )

/* METHOD: IsLoaded(  )
    Devuelve si se ha cargado el valor o no
    
Devuelve:
    Lógico
*/
METHOD IsLoaded(  ) CLASS TORMLastPageNumber
Return ( ::lDataLoaded )

/* METHOD: Init(  )
    Inicializa los valores
*/
METHOD Init(  ) CLASS TORMLastPageNumber

    ::nLastPageNumber := 0
    ::lDataLoaded     := .F.

Return ( Nil )

// Group: PROTECTED METHODS