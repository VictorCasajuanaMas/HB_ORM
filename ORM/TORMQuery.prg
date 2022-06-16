/* CLASS: TORMQuery 
    Gestiona las datas del query del Modelo
*/
#include 'hbclass.ch'
#include 'TORM.ch'

#DEFINE FIELD_TO_FIND 1
#DEFINE OPERATOR      2
#DEFINE DATA_TO_FIND  3

CREATE CLASS TORMQuery

    EXPORTED:
        DATA aWhereConditions   AS ARRAY     INIT Array( 0 )
        DATA oWhereInConditions AS OBJECT    INIT MWhereIn():New()
        DATA oSelect            AS OBJECT    INIT Nil
        DATA oOrderby           AS OBJECT    INIT Nil
        DATA nTake              AS NUMERIC   INIT 0
        DATA nOffSet            AS NUMERIC   INIT 0

        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD InitAll()
        METHOD InitWhere()
        METHOD HasWhere()
        METHOD PersistentOn()
        METHOD PersistentOff()
        METHOD Persistent()
        METHOD AddCondition( aCondition )

            DATA oTORMModel  AS OBJECT INIT Nil
    PROTECTED:
        DATA lPersistent AS LOGICAL INIT .f.

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMQuery

    ::oTORMModel := oTORMModel
    ::InitAll()

Return ( Self )

/* METHOD: Init(  )
    Inicializa todos los datos del Query
*/
METHOD InitAll() CLASS TORMQuery

    ::InitWhere()
    ::oOrderby    := MOrderby():New()
    ::oSelect     := TORMSelect():New()
    ::nTake       := 0
    ::nOffSet     := 0
    
Return ( Nil )

/* METHOD: InitWhere(  )
Inicializa los datos correspondientes a Where

Devuelve:
    Modelo
*/
METHOD InitWhere(  ) CLASS TORMQuery

    ::aWhereConditions      := Array( 0 )
    ::oWhereInConditions    := MWhereIn():New()

Return ( ::oTORMModel )

/* METHOD: HasWhere(  )
    Devuelve .T. si el query tiene Where's

Devuelve:
    Lógico
*/
METHOD HasWhere(  ) CLASS TORMQuery

Return ( ::aWhereConditions:NotEmpty() )

/* METHOD: PersistentOn(  )
    Activa la query como persistente hasta que se destruya el modelo

Devuelve:
    TORMModel
*/
METHOD PersistentOn(  ) CLASS TORMQuery

    ::lPersistent := .T.

Return ( ::oTORMModel )

/* METHOD: PersistentOff(  )
    Desactiva la query como persistente

Devuelve:
    TORMModel
*/
METHOD PersistentOff(  ) CLASS TORMQuery

    ::lPersistent := .F.

Return ( ::oTORMModel )

/* METHOD: Persistent(  )
    Devuelve si el query es persistente o no
    
Devuelve:
    Lógico
*/
METHOD Persistent(  ) CLASS TORMQuery

Return ( ::lPersistent )

/* METHOD: AddCondition( aCondition )
    Añade una condición al arary de condiciones
    
    Parámetros:
        aCondition
*/

METHOD AddCondition( aCondition ) CLASS TORMQuery

    Local oCondition := mQuery():New()

    If HB_ISHASH( aCondition[ DATA_TO_FIND ] )

        aCondition[ DATA_TO_FIND ] := TIndexMultiple():New( aCondition[ DATA_TO_FIND ] )

    Endif

    oCondition:cField     := aCondition[ TORM_WHERE_FIELD ]
    oCondition:cCondition := aCondition[ TORM_WHERE_CONDITION ]
    oCondition:xValue     := aCondition[ TORM_WHERE_VALUE ]

    If ::oTORMModel:__lWhereInitGroup

        oCondition:lInitGroup := .T.
        ::oTORMModel:__lWhereInitGroup := .F.

    Endif

    aAdD( ::aWhereConditions, oCondition )

Return ( Nil )