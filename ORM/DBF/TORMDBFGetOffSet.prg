/* CLASS: TORMDBFGetOffSet 
    Avanza los registros según el offset del query del modelo
*/
#include 'hbclass.ch'

CREATE CLASS TORMDBFGetOffSet FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Jump( cAlmas )

    PROTECTED:
        DATA oTORMModel AS OBJECT    INIT Nil
        DATA cAlias     AS CHARACTER INIT ''

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFGetOffSet

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Jump( cAlias  )
    Posiciona el registro en el Offset

    Parámetros:
        cAlias - Alias a procesar
*/
METHOD Jump( cAlias ) CLASS TORMDBFGetOffSet

    Local nOffSet := 0

    ::cAlias := cAlias

    If ::oTORMModel:__oQuery:nOffSet != 0

        If ::oTORMModel:__oQuery:HasWhere()

            ( ::cAlias )->( dbEval( { | | nOffSet++ } , { | | TORMDBFWhere():New( ::oTORMModel, ::cAlias ):Success() } , , ::oTORMModel:__oQuery:nOffSet ) )
            ( ::cAlias )->( DbSkip( nOffSet -1 ) )

        Else

            ( ::cAlias )->( dbEval( {||.t.}, , , ::oTORMModel:__oQuery:nOffSet ))

        Endif

    Endif

Return ( Nil )

// Group: PROTECTED METHODS