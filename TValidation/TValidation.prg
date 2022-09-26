/* CLASS: TValidation
    Clase que se encarga de las validaciones de los objetos de datos
    Tipos de Validaciones Admitidas:

        Rangos    - { VALID_RANGE       => '1,10' }
        Mínimo    - { VALID_MIN         => 1 }
        Máximo    - { VALID_MAX         => 10 }
        Existe    - { VALID_EXISTS      => 'si' }
        Requerido - { VALID_REQUIRED    => 'si' }
        Email     - { VALID_EMAIL       => 'si' }
        Tamaño    - { VALID_LENGHT      => 100 }
        Custom    - { VALID_CUSTOM      => {||} }
        
*/

#include 'hbclass.ch'
#include 'validation.ch'

#DEFINE SI            'SI,S,YES,.T.,TRUE'
#DEFINE NO            'NO,N,NOT,.T.,FALSE'

CREATE CLASS TValidation

    EXPORTED:
        DATA lValid             AS LOGICAL   INIT .T. READONLY

        METHOD New( Value, hValid, cField ) CONSTRUCTOR
        METHOD IniTValidation()
        METHOD SeTValidation( hValid )
        METHOD GeTValidation(  )
        METHOD IsValid()
        METHOD Valid( )
        METHOD SofTValidation ( ... )
        METHOD ExplainValidation( hCondicion )
        METHOD ValidGetResultado()
        METHOD ValidAsignaResultado( cResultado )
        METHOD ValidaCondicion( cKey, uValue)
        METHOD ValidaCondicionRango( vValue )
        METHOD ValidaCondicionMin( uValue )
        METHOD ValidaCondicionMax( uValue )
        METHOD ValidaCondicionExiste( uValue )
        METHOD ValidaCondicionRequerido( uVAlue )
        METHOD ValidaCondicionEmail( uVAlue )
        METHOD ValidCondicionLenght( nMaxLenght )
        METHOD ValidConditionCustom( uValue )

        METHOD SoftLenghtString( lSoftLenghtString ) SETGET

            DATA Value              
            DATA hValid             AS HASH      Init hb_Hash()
            DATA cField             AS CHARACTER INIT ''
    PROTECTED:
        DATA cValidResultado    AS CHARACTER INIT ''
        DATA lSoftLenghtString  AS LOGICAL   INIT .T.
        
ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( Value, hValid, cField ) 
    Crea el objeto, solo a efectos de testing

    Parámetros:
        Value  - Valor a Validar
        hValid - Array Hash con las validaciones
        cField - Nombre del campo a validar

    Devuelve:
        Objeto creado
*/
METHOD New( Value, hValid, cField ) CLASS TValidation

    ::Value     := Value
    ::hValid    := hValid
    ::cField    := cField 
    
Return ( Self )



/* METHOD: IniTValidation() 
    Inicializa la validación del objeto. Si el objeto no tiene validación será válido

    Parémtros:

    Devuelve:
*/
METHOD IniTValidation() CLASS TValidation

    ::lValid := .T.
    ::cValidResultado := ''

Return ( Nil )



/* METHOD: SeTValidation( hValid )  
    Asigna la validacion

    Parámetros:
        hValid : Hash con la validación

    Devuelve:
        instancia del objeto
*/
METHOD SeTValidation( hValid ) CLASS TValidation

    ::hValid:=hValid

Return ( Self )



/* METHOD: GeTValidation()
    Devuelve el hash del valid actual

    Devuelve:
        Array Hash
*/
METHOD GeTValidation() CLASS TValidation
Return ( ::hValid )



/* METHOD: IsValid()
    Procesa la Validación y devuelve el valor de lValid

    Devuelve:
        Lógico
*/
METHOD IsValid() CLASS TValidation

    ::Valid( , .T. )

Return ( ::lValid )


/* METHOD: Valid( )
    Realiza la validación en sí del objeto dato devolviendo .T. si es correcta y .F. si no es correcta

    Devuelve:        
        Valor Lógico
*/
METHOD Valid( ) CLASS TValidation

    Local lOk := .T.

    ::IniTValidation()

    If !( Empty( ::hValid ) ) 
        hb_HEval( ::hValid , { | cClave , uValor | lOk := Iif( ::ValidaCondicion( cClave , uValor ), lOk, .F. ) } )
        ::lValid := lOk
    else
        lOk := .T.
    Endif

Return ( lOk )



METHOD SofTValidation( ... ) CLASS TValidation 

    ::VAlid( ... )

Return ( .T. )



/* METHOD: ExplainValidation()
    Devuelve la explicación "legible" de todas las validaciónes que tiene configurada el objeto

    Devuelve:
        String
*/
METHOD ExplainValidation( ) CLASS TValidation

    Private cValidationExplained := ''

    If !( Empty( ::hValid ) ) 
        hb_HEval( ::hValid , { | cKey , uValue | cValidationExplained += Iif ( !cValidationExplained:IsEmpty(), ',', '' ) + ExplainValidations( cKey, uVAlue ) } )
    Endif

Return ( cValidationExplained )


/* METHOD: ExplainValidations( cKey, uValue) 
    Devuelve la explicación "legible" de una validación contenida en el objeto.

    Parámetros:
        cKey - Tipo de validación a comprobar
        uValue - Valor de la validación a comprobar

    Devuelve:
        String
*/
Static Function ExplainValidations( cKey, uVAlue )

    switch Lower( cKey )
        case VALID_RANGE
            cValidationExplained := ExplainValidationRange( uVAlue ):Alltrim():Capitulate()     
        exit

        case VALID_MIN
            cValidationExplained := ExplainValidationMin( uVAlue )
        exit            

        case VALID_MAX
            cValidationExplained := ExplainValidationMax( uVAlue )
        exit

        case VALID_EXISTS
            cValidationExplained := ExplainValidationExist( uVAlue )
        exit

        case VALID_REQUIRED
            cValidationExplained := ExplainValidationRequired( )
        exit

        case VALID_EMAIL
            cValidationExplained := ExplainValidationEmail( )
        exit

        case VALID_LENGHT
            cValidationExplained := ExplainValidationLenght( )
        exit

        case VALID_CUSTOM
            cValidationExplained := ExplainValidationCustom()
        exit 

    endswitch

Return ( cValidationExplained )



Static Function ExplainValidationRequired( )
Return ( ' campo requerido' )



Static Function ExplainValidationEmail( )
Return ( ' campo tipo Email' )



Static Function ExplainValidationExist( uValue )
Return ( ' existe '+ hb_ValToStr( uVAlue ):Alltrim() )

Static Function ExplainValidationMax( uValue )
Return ( ' valor máximo ' + hb_ValToStr( uValue ):Alltrim() )


Static Function ExplainValidationMin( uVAlue ) 
Return ( ' valor mínimo ' + hb_ValToStr( uValue ):Alltrim() )

Static Function ExplainValidationLenght( uVAlue ) 
Return ( ' Tamaño máximo ' + hb_ValToStr( uValue ):Alltrim() )

Static Function ExplainValidationCustom( uValue )
Return( ' Validación personalizada incorrecta '+ hb_ValToStr( uValue):Alltrim() )



Static Function ExplainValidationRange( uValue )

    Local cValidationExplained := ''
    Local aRango := Array( 0 ) 

    If ( Len( aRango := GetRange( uValue ) ) == 2 )

        cValidationExplained := 'rango válido desde ' + aRango[ 1 ] + ' hasta ' + aRango[ 2 ] 

    Endif


Return ( cValidationExplained )


/* METHOD: ValidaCondicion( cKey, uValue )
    Valida una condición dade devolviendo .T. o .F. según se pase la validación o no

    Parámetros:
        cKey - Tipo de validación a comprobar
        uValue - Valor de la validación a comprobar

    Devuelve:
        Lógico

*/
METHOD ValidaCondicion( cKey, uValue ) CLASS TValidation

    Local lOk := .F.

    switch Lower( cKey )
        case VALID_RANGE
            lOk := ::ValidaCondicionRango( uVAlue )
        exit

        case VALID_MIN
            lOk := ::ValidaCondicionmin( uVAlue )
        exit            

        case VALID_MAX
            lOk := ::ValidaCondicionmax( uVAlue )
        exit

        case VALID_EXISTS
            lOk := ::ValidaCondicionExiste( uVAlue )
        exit

        case VALID_REQUIRED
            lOk := ::ValidaCondicionRequerido( uVAlue )
        exit

        case VALID_EMAIL
            lOk := ::ValidaCondicionEmail( uVAlue )
        exit

        case VALID_LENGHT
            lOk := ::ValidCondicionLenght( uVAlue )
        exit

        case VALID_CUSTOM
            lOk := ::ValidConditionCustom( uValue )
        exit

    endswitch

Return ( lOk )



/* METHOD: ValidaCondicionRango( uValue )
    Realiza la validación del valor sobre el rango uValue. Devuelve .T. o .F. dependiendo su el valor está dentro del rango o no

    Parámetros:
        uValue - Rango a validar

    Devuelve:
        Lógico
*/
METHOD ValidaCondicionRango( uValue ) CLASS TValidation

    Local lOk := .F.
    Local aRango := Array(0)

    If ( Len( aRango := GetRange( uValue ) ) == 2 )

        switch ValType( ::Value )

            case 'N'

                aRango[ 1 ] := Val( aRango[ 1 ] )
                aRango[ 2 ] := Val( aRango[ 2 ] )    

            exit

            case 'D'

                aRango[ 1 ] := cTod( aRango[ 1 ] )
                aRango[ 2 ] := cTod( aRango[ 2 ] )    

            exit 
        endswitch

        If !( lOk := ( ::Value >= aRango[ 1 ] .And. ::Value <= aRango[ 2 ] ) )

            ::ValidAsignaResultado( 'campo [' + ::cField +'] valor (' + hb_ValToExp( ::Value ) + ') fuera de rango: ' + hb_ValToExp( aRango[ 1 ] ) + '-' + hb_ValToExp( aRango[2] ) )

        Endif
        
    Else

        lOk := .F.
        ::ValidAsignaResultado( 'error de parámetros en el rango' )

    Endif
    
Return ( lOk )



Static Function GetRange( uValue )
Return ( hb_ATokens( uValue, ',' ) )


/* METHOD: ValidaCondicionMin( uValue )
    Realiza la validación sobre el valor y el mínimo permitido devolviendo .T. o .F. dependiendo si el valor es superior a uValue o NO

    Parámetros:
        uValue - Valor mínimo
    
    Devuelve:
        Lógicoh
*/
METHOD ValidaCondicionMin( uValue ) CLASS TValidation

    hb_default( @uValue, 0 )

    If !( lOk := ::Value >= uValue )

        ::ValidAsignaResultado( 'campo [' + ::cField +'] valor (' + hb_ValToExp( ::Value ) + ') inferior a lo esperado: ' + hb_ValToExp( uValue ) )

    Endif

Return ( lOk )



/* METHOD: ValidaCondicionMax( uValue )
    Realiza la validación sobre el valor y el máximo permitido devolviendo .T. o .F. dependiendo si el valor es inferior a uValue o no

    Parámetros:
        uValue - Valor máximo

    Devuelve:
        Lógico
*/
METHOD ValidaCondicionMax( uValue ) CLASS TValidation

    hb_default( @uValue, 0 )

    If !( lOk := ::Value <= uValue )

        ::ValidAsignaResultado( 'campo [' + ::cField +'] valor (' + hb_ValToExp( ::Value ) + ') superior a lo esperado: ' + hb_ValToExp( uValue ) )

    Endif

Return ( lOk )



/* METHOD: ValidaCondicionExiste( uVAlue )
    Realiza la validación si el valor del dato existe en el fichero uValue devolviendo .T. o .F. dependiendo si existe o no.

    Parámetros : 
        uValue - Nombre del fichero donde se buscará la existencia del valor del dato

    Devuelve:
        Lógico
*/
METHOD ValidaCondicionExiste( uVAlue ) CLASS TValidation

    // TODO: Hay que hacerlo

Return ( lOk )



/* METHOD: ValidaCondicionRequerido( uValue )
    Realiza la validación si el Valor del dato es requerido. 
    Devuelve .T. si el valor es requerido, hay algún valor en el dato y uValue forma parte de la constante SI 
    Devuelve .F. si el valor es requerido, no hay ningún valor en el dato y uValue forma parte de la constante SI
    Los valores devueltos serán a la inversa si uValue forma parte de la constante NO y el valor del dato es el mismo 

    Parámetros:
        uValue - Valor de requerido o no dependiendo de las constantes SI y NO

    Devuelve:
        Lógico
*/
METHOD ValidaCondicionRequerido( uValue ) CLASS TValidation

    Local lOk := .T.    
    
    hb_default( @uValue, '' )

    If hb_At( Upper( uValue ), SI ) <> 0

        if !( lOk := !Empty( ::Value ) )

            ::ValidAsignaResultado( 'campo [' + ::cField +'] valor requerido' )

        Endif

    else

        lOk := .T.        

    Endif        

Return ( lOk )



METHOD ValidaCondicionEmail( uValue ) CLASS TValidation
// TODO: Comentar
// TODO: Testear

    Local lOk := .T.    
        
    hb_default( @uValue, '' )

    If hb_At( Upper( uValue ), SI ) <> 0

        if ::Value:NotEmpty() //.And.;
            // TODO: Incluir la clase TRegExString
           //!hb_regexLike ( TRegExString():New():Email(), ::Value:Alltrim() ) 

            ::ValidAsignaResultado( 'campo [' + ::cField +'] email incorrecto' )
            lOk := .F.

        Endif

    Endif        

Return ( lOk )

/* METHOD: ValidCondicionLenght( nMaxLenght )
    Valida la condición del tamaño, válido para strings
    
    Parámetros:
        nMaxLenght - Tamaño máximo

Devuelve:
    Lógico
*/
METHOD ValidCondicionLenght( nMaxLenght ) CLASS TValidation

    Local lOk := .T.

    hb_default( @nMaxLenght, 0 )

    If ::lSoftLenghtString

        Return ( .T. )

    Endif

    If  ::Value:NotEmpty() .And.;
        HB_ISSTRING( ::Value ) .And.;
       .Not. ( lOk := ::Value:Len() <= nMaxLenght )

        ::ValidAsignaResultado( 'campo [' + ::cField +'] valor (' + ::Value:Len():str() + ')  supera el tamaño máximo de ' + nMaxLenght:Str() )

    Endif

Return ( lOk )

/* METHOD: ValidConditionCustom( uValue )
    Valida un codeblock

    Parámetros:
        uValue - Codeblock a evaluar

Devuelve:
    Lógico
*/
METHOD ValidConditionCustom( uValue ) CLASS TValidation

    Local lOk As Logical := .T.

    if HB_ISBLOCK( uValue )

        lOk := Eval( uValue, ::Value )

    Else

        lOk := .F.

    Endif

Return ( lOk )

/* METHOD: ValidAsignaResultado( cResultado )
    Asigna un resultado "Legible" que contiene cResultado al dato cValidResultado

    Parámetros:
        cResultado - Resultado a añadir
*/
METHOD ValidAsignaResultado( cResultado ) CLASS TValidation

    ::cValidResultado += cResultado + Chr(10)

Return ( Nil )

/* METHOD: ValidGetResultado()
    Devuelve la cadena "Legible" de la Validación después de ser procesada

    Devuele:
        String
*/
METHOD ValidGetResultado() CLASS TValidation
Return ( ::cValidResultado )

/* METHOD: SoftLenghtString( lSoftLenghtString )
    SetGet de lSoftLenghtString
    
    Parámetros:
        lSoftLenghtString - Valor a asignar

Devuelve:
    Lógico
*/
METHOD SoftLenghtString( lSoftLenghtString ) CLASS TValidation

    If HB_ISLOGICAL( lSoftLenghtString )

        ::lSoftLenghtString := lSoftLenghtString 

    Endif

Return ( ::lSoftLenghtString )