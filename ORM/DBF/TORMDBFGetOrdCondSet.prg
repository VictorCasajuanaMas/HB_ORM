/* CLASS: TORMDBFGetOrdCondSet 
    Analiza los recnos a devolver según el query del modelo mediante un índice condicional
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFGetOrdCondSet FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Get( cAlias )

            DATA oTORMModel AS OBJECT INIT Nil
    PROTECTED:
        DATA cAlias     AS CHARACTER INIT ''

        METHOD CheckValue( xValue )
        METHOD CheckField( xValue )
        METHOD MakeFilter()
        METHOD Like( oWhere )
        METHOD NotLike( oWhere )
        METHOD Union( oWhere )
    

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFGetOrdCondSet

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Get( cAlias )
    Devuelve los recnos según el query 
    
    Parámetros:
        cAlias - Alias activo del Modelo

Devuelve:
    Array
*/
METHOD Get( cAlias ) CLASS TORMDBFGetOrdCondSet

    Local aRecnos       := Array( 0 )
    Local cFilter       := ''
    Local oError        := Nil
    Local lIndexCreated := .F.


    ::cAlias := cAlias
    
    If .Not. ::oTORMModel:__oQuery:oWhereInConditions:lHasCondition

        cFilter := ::MakeFilter()

        try 
            
            //( ::cAlias )->(ordCondSet( cFilter, {|| &cFilter },,,,,,,,,,, .T.,,,,,,, ) )

            // Extraído del source de Harbour : OrdCondSet(,,,,,,0,,,,lDescend,nil,lAdditive,,,,,lMemory,,) // 2019-02-14
            ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[11][1], TORM_INFO_MESSAGE[11][2], { ::oTORMModel:TableName, cFilter} ) )
            ( ::cAlias )->(OrdCondSet( cFilter, {|| &cFilter },,,,,,,,,,nil,,,,,,.t.,,) )

            If ::oTORMModel:__oIndexes:lPrimaryKey

                ordCreate( 'mem:temp', , ::oTORMModel:__oIndexes:OrderDefault( ::oTORMModel:__oQuery:oOrderby:cOrder) )
                lIndexCreated := .T.

            Endif

            ( ::cAlias )->( DbGoTop() )
            ( ::cAlias )->( dbEval( {||.t.}, , , ::oTORMModel:__oQuery:nOffSet ))

            While .Not. ( ::cAlias )->( Eof() ) .And.;
                TORMDBFItemsToTake():New( ::oTORMModel):Get( aRecnos:Len() )

                aAdD( aRecnos, ( ::cAlias )->( Recno() ) )
                ( ::cAlias )->( DbSkip() )

            Enddo

        catch oError

            ::oTORMModel:__oReturn:Success := .F.
            ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[47][1], TORM_ERROR_MESSAGE[47][2], { cFilter, TTryCatchShowerror():New( oError ):ToString() } ) )
            
        end

        If lIndexCreated

            dbDrop( 'mem:temp' )

        Endif

    Endif

Return ( aRecnos )

// Group: PROTECTED METHODS
/* METHOD: MakeFilter(  )
    Crea la sentencia para el filtro del índice
    
Devuelve:
    Caracter
*/
METHOD MakeFilter(  ) CLASS TORMDBFGetOrdCondSet

    Local cWhere := ''
    Local oWhere := Nil

    If ::oTORMModel:__oQuery:HasWhere()
       
        for each oWhere in ::oTORMModel:__oQuery:aWhereConditions

            If oWhere:lInitGroup

                cWhere += '('

            Endif

            If oWhere:__enumindex > 1 .And.;
               .Not. oWhere:lInitGroup

                cWhere += ' .AND. '

            Endif

            If 'NOTLIKE' $ oWhere:cCondition:Upper()

                cWhere += ::NotLike( oWhere )

            ElseIf 'LIKE' $ oWhere:cCondition:Upper()

                cWhere += ::Like( oWhere )

            Else
            
                cWhere += ::CheckField( oWhere ) + oWhere:cCondition + ::CheckValue( oWhere:xValue )

            Endif

            If oWhere:lEndGroup

                cWhere += ')'
                cWhere += ::Union( oWhere:__enumindex, oWhere )

            Endif

        next

    else

        cWhere := '.T.'

    Endif

    
Return ( cWhere )

/* METHOD: Union( nPosition, oWhere )
    Crea la unión entre grupos dentro de una condición
    
    Parámetros:
        nPosition - Posición de oWhere dentro de aWhereConditions
        oWhere - Objeto mQuery  

Devuelve:
    Caracter
*/
METHOD Union( nPosition, oWhere ) CLASS TORMDBFGetOrdCondSet

    Local cUnion := ''

    If oWhere:lEndGroup .And.;
       nPosition != ::oTORMModel:__oQuery:aWhereConditions:Len()

       switch oWhere:cUnion
            case TORM_OR

                cUnion := ' .OR. '
               
            exit

            case TORM_AND
                
                cUnion := ' .AND. '

            exit

       endswitch

    Endif

Return ( cUnion )


/* METHOD: checkValue( xValue )
    Devuelve el valor correcto del xValue para el filtro
    
    Parámetros:
        xValue - Valor a chequear

Devuelve:
    Caracter
*/
METHOD checkValue( xValue ) CLASS TORMDBFGetOrdCondSet

    Local cValueFilter := ''

    switch ValType( xValue )

        case 'N'

            cValueFilter := xValue:Str()
            
        exit

        case 'C'

            cValueFilter := '"' + xValue:Alltrim() + '"'

        exit

        case 'D'

            cValueFilter := 'cTod("' + xValue:Str() + '")'

        exit

        case 'L'

            cValueFilter += xValue:Str()

        exit

        case 'O'

            cValueFilter += '"' + xValue:ToSeek() + '"'

        exit

    endswitch

Return ( cValueFilter )

/* METHOD: NotLike( oWhere )
    Monta el filtro del condicional NOTLIKE
    
    Parámetros:
        oWhere - Objeto mQuery

Devuelve:
    Caracter
*/
METHOD NotLike( oWhere ) CLASS TORMDBFGetOrdCondSet

    Local cNotLike := '! (' + ::Like( oWhere ) + ')'

Return ( cNotLike )


/* METHOD: Like( oWhere )
    Monta el filtro del condicional like
    
    Parámetros:
        oWhere - Objeto mQuery

Devuelve:
    Caracter
*/
METHOD Like( oWhere ) CLASS TORMDBFGetOrdCondSet

    Local cLike := ''

    do case

        Case oWhere:xValue:Right( 1 ) == '%' .And.;
             oWhere:xValue:Left( 1 ) == '%'
            
            cLike := '"' + oWhere:xVAlue:StrTran( '%', '' ) + '" $ ' + oWhere:cField

        Case oWhere:xVAlue:Right( 1 ) == '%'

            cLike := 'Left( ' + oWhere:cField + ', ' + ( oWhere:xVAlue:Len() -1 ):Str() + ' ) = Left( "' + oWhere:xVAlue + '", LEN( "' + oWhere:xVAlue + '" ) - 1 )'

        Case oWhere:xVAlue:Left( 1 ) == '%'

            cLike := 'Right( rTrim(' + oWhere:cField + '), ' + ( oWhere:xVAlue:Len() -1 ):Str() + ' ) = Right( "' + oWhere:xVAlue + '", LEN( "' + oWhere:xValue + '" ) - 1 )'
            
    endcase

Return ( cLike )

/* METHOD: CheckField( oWhere )
    Devuelve el Field para su correcta comparación
    
    Parámetros:
        oWhere - Array que contiene los valores de la condición

Devuelve:
    Caracter
*/
METHOD CheckField( oWhere ) CLASS TORMDBFGetOrdCondSet

    Local cField := oWhere:cField

    switch ValType( oWhere:xValue )

        case 'C'

            cField := 'Alltrim( ' + oWhere:cField + ' ) '
            
        exit

    endswitch

Return ( cField )