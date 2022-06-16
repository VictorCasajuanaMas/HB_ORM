/* CLASS: TORMDBFGEtModelToCollection 
    Clase que se encarga de recuperar un modelo del alias ya posicionado y lo prepara para insertarlo en una colección
*/
#include 'hbclass.ch'

CREATE CLASS TORMDBFGEtModelToCollection

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Get( oModelPattern, cAlias )

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor.  
   Parametros:
     oTORMModel - Modelo a preparar para insertar en una colección

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFGEtModelToCollection

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Get( oModelPattern, cAlias )
    Se encarga de la recuperación en sí
    
    Parámetros:
        oModelPattern - Modelo del patrón para clonar
        cAlias - Alias del Fichero abierto

Devuelve:
    Objeto
*/
METHOD Get( oModelPattern, cAlias ) CLASS TORMDBFGETModelToCollection

    Local oNewModel := Nil

    oNewModel := __objClone( oModelPattern )  
    oNewModel:Init()
    oNewModel:__oQuery:oSelect := __objClone( ::oTORMModel:__oQuery:oSelect )  // Esto lo hago para que cuando recupere la información posteriormente de los modelos de la colección, lo haga solo de las columnas que se han pedido

    If .Not. ::oTORMModel:InitialBuffer:WithInitialBuffer()

        oNewmodel:InitialBuffer:NoInitialBuffer()
            
    Endif

    TORMDBFLoadfromAlias():New( oNewModel ):Model( cAlias )

Return ( oNewModel )

// Group: PROTECTED METHODS