/* CLASS: TORMDBFWhere 
    Procesa las condiciones del where sobre el registro actual del alias
    TODO: Mejorar el rendimiento utilizando índices en la medida de lo posible
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFWhere FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel, cAlias ) CONSTRUCTOR

        METHOD Success() INLINE ::oReturn:Success()
        METHOD Fail() INLINE ::oReturn:Fail()

            DATA oTORMModel AS OBJECT       Init Nil
    PROTECTED:
        DATA oReturn    AS OBJECT       Init TReturn():New()
        DATA cAlias     AS CHARACTER    Init ''

        METHOD Run()
        METHOD Condition( oCondition )
        METHOD ObjectCondition( oCondition )
        METHOD StandardCondition( oCondition )
        METHOD OperatorCondition( oCondition )
        METHOD Like( oCondition )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel, cAlias )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo
     cAlias - Alias posicionado en el registro a revisar

Devuelve:
    Self
*/
METHOD New( oTORMModel, cAlias ) CLASS TORMDBFWhere

    ::Super:New()
    ::oTORMModel := oTORMModel
    ::cAlias := cAlias
    ::Run()

Return ( Self )


// Group: PROTECTED METHODS  

/* METHOD: Run()
    Procesa las condiciones del where sobre el registro actual del alias
*/
METHOD Run() CLASS TORMDBFWhere

    Local oCondition := Nil


    ::oReturn:Success := .T.  // Si no hay ninguna condición sería como un all()

    for each oCondition in ::oTORMMOdel:__oQuery:aWhereConditions

        If ::Condition( oCondition ):Fail()

            ::oReturn:Success := .F.

        Endif

    next

Return ( Nil )


METHOD Condition( oCondition ) CLASS TORMDBFWhere

    Local oReturn := TReturn():New( .F. )

    If HB_ISOBJECT( oCondition:xValue )

        oReturn := ::ObjectCondition( oCondition )

    Else

        oReturn := ::StandardCondition( oCondition )

    Endif

Return ( oReturn )

/* METHOD: ObjectCondition( oCondition )
    Procesa una condición cuyo xValue es un objeto de datos
    
    Parámetros:
        oCondition - Objeto mQuery

Devuelve:
    oReturn
*/
METHOD ObjectCondition( oCondition ) CLASS TORMDBFWhere

    Local oReturn := TReturn():New( .F. )
    Local xDataInDb := Eval( &( "{||{ " +  oCondition:cField + " } }" ) ):Get( 1 )  
    Local xDataToCompare := oCondition:xValue:ToSeek()

    oReturn:Success := ::OperatorCondition( xDataInDb, oCondition:cCondition, xDataToCompare )

Return ( oReturn )


/* METHOD: StandardCondition( oCondition )
    Procesa una condición cuyo xValue es un tipo de Dato Standard
    
    Parámetros:
        oCondition - Objeto mQuery

Devuelve:
    oReturn
*/
METHOD StandardCondition( oCondition ) CLASS TORMDBFWhere

    Local oReturn := TReturn():New( .F. )
    Local xField := Nil
    Local oError := Nil

    try 

        xField := &( ::cAlias + '->' + oCondition:cField )

    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[45][1], TORM_ERROR_MESSAGE[45][2], { TTryCatchShowerror():New( oError ):ToString()  } ) )
         
    end

    If HB_ISCHAR( xField )

        xField := Alltrim( xField )

    Endif
    
    If HB_ISCHAR( oCondition:xValue )

        oCondition:xValue := Alltrim( oCondition:xValue )

    Endif

    oReturn:Success := ::OperatorCondition( xField, oCondition:cCondition, oCondition:xValue )
        

Return ( oReturn )

/* METHOD: OperatorCondition( oCondition )
    Realiza la comparación en sí
    
    Parámetros:
        oCondition - Objeto mQuery

Devuelve:
    Lógico
*/
METHOD OperatorCondition( oCondition ) CLASS TORMDBFWhere

    Local lOk := .F.

    switch cOperator:Upper()

        case '='

            lOk := oCondition:cField = oCondition:xValue
            
        exit

        case '=='

            lOk := oCondition:cField == oCondition:xValue
            
        exit

        case '!='
        case '<>'
        case '.NOT.'

            lOk := oCondition:cField != oCondition:xValue
            
        exit

        case '>='

            lOk := oCondition:cField >= oCondition:xValue
            
        exit

        case '<='

            lOk := oCondition:cField <= oCondition:xValue
            
        exit

        case '>'

            lOk := oCondition:cField > oCondition:xValue
            
        exit

        case '<'

            lOk := oCondition:cField < oCondition:xValue
            
        exit

        case 'LIKE'

            lOk := ::Like( oCondition )

        case 'NOTLIKE'

            lOk := !::Like( oCondition )

    endswitch

    
Return ( lOk )

/* METHOD: Like( oCondition )
    Realiza la comprobación like
    
    Parámetros:
        oCondition - Objeto mQuery

Devuelve:
    Lógico
*/
METHOD Like( oCondition ) CLASS TORMDBFWhere

    Local lConditionOk := .F.

    do case

        Case oCondition:xValue:Right( 1 ) == '%' .And.;
             oCondition:xValue:Left( 1 ) == '%'
            
            lConditionOk := oCondition:xValue:Substr( 2, oCondition:xValue:Len() -2 ) $ oCondition:cField

        Case oCondition:xValue:Right( 1 ) == '%'

            lConditionOk := oCondition:xValue:Substr( 1, oCondition:xValue:Len() -1 ) == oCondition:cField:Substr( 1, oCondition:xValue:Len() -1 )

        Case oCondition:xValue:Left( 1 ) == '%'

            lConditionOk := oCondition:xValue:Substr( 2, oCondition:xValue:Len() ) == oCondition:cField:Substr( oCondition:cField:Len() - oCondition:xValue:Len() -1, oCondition:cField:Len() )
            
    endcase

Return ( lConditionOk )