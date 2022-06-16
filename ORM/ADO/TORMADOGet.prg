/* CLASS: TORMADOGet 
    Ejecuta una consulta con los parámetros de los métodos where, orderby, select, etc...
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMADOGet

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Get( )

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil
        DATA oADO       AS OBJECT INIT Nil

        METHOD MakeQuery()
        METHOD MakeSelect()
        METHOD MakeTake()
        METHOD MakeFrom()
        METHOD MakeWhere()
        METHOD MakeOrderBy()

        METHOD CheckOperator()
        METHOD CheckValue()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMADOGet

    ::oTORMModel := oTORMModel
    ::oADO       := TORMADO():New( oTORMModel )

Return ( Self )

/* METHOD: Get( )
    Ejecuta la consulta

    TODO: Optimizarlo para que lo haga de una sola pasada.

Devuelve:
    Array de Modelos
*/
METHOD Get() CLASS TORMADOGet

    Local aReturn       := Array( 0 )
    Local cQuery        := ''
    Local nCount        := 0
    Local xValueofField := Nil
    Local cNameOfField  := ''
    Local oNewModel     := Nil


    TORMADOCreateTableifNotExist():New( ::oTORMModel ):Create()
    
    cQuery := ::MakeQuery()


    If ::oADO:Connect():Success()

        ::oADO:Open( cQuery )

        If ::oTORMModel:Success

            While .Not. ::oADO:GetRecordSet():Eof()

                oNewModel := &( ::oTORMModel:ClassName )():New()  // Si ejecuto esto el ::oTORMModel se inicializa
                oNewModel:__oQuery:oSelect := __objClone( ::oTORMModel:__oQuery:oSelect )  // Esto lo hago para que cuando recupere la información posteriormente de los modelos de la colección, lo haga solo de las columnas que se han pedido

                For nCount := 1 To ::oADO:GetRecordSet():Fields():Count()

                    xValueofField := ::oADO:GetRecordSet():Fields( nCount -1 ):Value
                    cNameOfField  := ::oADO:GetRecordSet():Fields( nCount -1 ):Name
                    __objSetValueList( oNewModel, {{ cNameOfField, xValueofField } } )
                    oNewModel:__oInitialBuffer:SetInitialValue( cNameOfField, xValueofField )

                next

                aAdD( aReturn, oNewModel )
                ::oADO:GetRecordSet():MoveNext()
                
            Enddo

        Endif

        ::oADO:End()

    Endif

Return ( aReturn )

// Group: PROTECTED METHODS

/* METHOD: MakeQuery(  )
    Monta el Query

Devuelve:
    Caracter
*/
METHOD MakeQuery(  ) CLASS TORMADOGet

    Local cQuery := ''

    cQuery += ::MakeSelect()
    cQuery += ::MakeFrom()
    cQuery += ::MakeWhere()
    cQuery += ::MakeOrderBy()

Return ( cQuery )

/* METHOD: MakeSelect(  )
    Monta el Select del query

Devuelve:
    Caracter
*/
METHOD MakeSelect(  ) CLASS TORMADOGet

    Local cSelect := 'SELECT '
    Local oSelect := Nil

    cSelect += ::MakeTake()

    If ::oTORMModel:__oQuery:oSelect:Empty()

        cSelect += '*'

    Else

        for each oSelect in ::oTORMModel:__oQuery:oSelect:Get()

            If oSelect:__enumindex > 1

                cSelect += ', '

            Endif

            If oSelect:cField != oSelect:cAlias

                cSelect += oSelect:cField + ' AS ' + oSelect:cAlias

            Else

                cSelect += oSelect:cField

            Endif

        next

    Endif

    cSelect += ' '

Return ( cSelect )

/* METHOD: MakeTake(  )
    Crea la sentencia TOP del query

Devuelve:
    Caracter
*/
METHOD MakeTake(  ) CLASS TORMADOGet

    Local cTake := ''

    If ::oTORMModel:__oQuery:nTake != 0

        cTake := 'TOP ' + ::oTORMModel:__oQuery:nTake:Str() + ' '

    Endif

Return ( cTake )

/* METHOD: MakeFrom(  )
    Crea la sentencia FROM del query

Devuelve:
    Caracter
*/
METHOD MakeFrom(  ) CLASS TORMADOGet

    Local cFrom := 'FROM '

    cFrom += ::oTORMModel:TableName() + ' '

Return ( cFrom )

/* METHOD: MakeWhere(  )
    Crea la sentencia SQL Where con todos los parámetros del query

Devuelve:
    Caracter
*/
METHOD MakeWhere(  ) CLASS TORMADOGet

    Local cWhere := ''
    Local oWhere := Nil
    
    If ::oTORMModel:__oQuery:HasWhere()

        cWhere += 'WHERE '

        for each oWhere in ::oTORMModel:__oQuery:aWhereConditions

            If oWhere:__enumindex > 1

                cWhere += ' AND '

            Endif
            
            cWhere += oWhere:cField + ::CheckOperator( oWhere:cCondition ) + ::CheckValue( oWhere:xValue )

        next

    Endif

Return ( cWhere )

/* METHOD: CheckOperator(  )
    Chequea que el operador sea correcto y en caso contrario lo convierte al correcto
    
    Parámetros:
        cOperator - Operador a chequear

Devuelve:
    Caracter
*/
METHOD CheckOperator( cOperator ) CLASS TORMADOGet

    switch cOperator:Upper()

        case '=='

            cOperator := '='
            
        exit

        case 'LIKE'

            cOperator := ' ' + cOperator + ' '

        exit

    endswitch

Return ( cOperator )

/* METHOD: checkValue( xValue )
    Devuelve el valor correcto del xValue para la sentencia SQL en ADO
    
    Parámetros:
        xValue - Valor a chequear

Devuelve:
    Caracter
*/
METHOD checkValue( xValue ) CLASS TORMADOGet

    Local cValueADOSQL := ''

    switch ValType( xValue )

        case 'N'

            cValueADOSQL := xValue:StrSql()
            
        exit

        case 'C'

            cValueADOSQL := '"' + xValue:StrSql() + '"'

        exit

        case 'D'

            cValueADOSQL := '#' + xValue:Str() + '#'

        exit

        case 'L'

            cValueADOSQL += xValue:Str( 'true', 'false' )

        exit

    endswitch

Return ( cValueADOSQL )

/* METHOD: OrderBy(  )
    Crea la sentencia SQL del order by
    
Devuelve:
    Caracter
*/
METHOD MakeOrderBy(  ) CLASS TORMADOGet

    Local cOrderBy := ''

    If ::oTORMModel:__oQuery:oOrderby:cOrder:NotEmpty()

        cOrderBy += 'ORDER BY ' + ::oTORMModel:__oQuery:oOrderby:cOrder:Upper() + ' '

        switch ::oTORMModel:__oQuery:oOrderby:cDirection

            case TORM_DESC

                cOrderBy += 'DESC'
                
            exit

            case TORM_ASC

                cOrderBy += 'ASC'
                
            exit

        endswitch

    Endif

Return ( cOrderBy )