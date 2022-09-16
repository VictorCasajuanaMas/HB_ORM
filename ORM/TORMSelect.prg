/* CLASS: TORMSelect 
    Gestiona el select individual del query
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMSelect

    EXPORTED:
        METHOD New( ) CONSTRUCTOR
        METHOD Add( ... )
        METHOD Empty()
        METHOD Exist( cField )
        METHOD GetAlias( cField )
        METHOD Get()
        METHOD GetStr()

    PROTECTED:
        DATA aSelect AS ARRAY INIT Array( 0 )

        METHOD Check( xSelect )
        METHOD Position( cField )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( )
    Constructor.  

Devuelve:
    Self
*/
METHOD New( ) CLASS TORMSelect

Return ( Self )

/* METHOD: Add( ... )
    Configura las columnas que se devolverán en la consulta
    
    Parámetros:
        ... - Se le puede pasar un array con los nombres de columnas o en varios parámetros

Devuelve:
    Self
*/
METHOD Add( ... ) CLASS TORMSelect

    Local aParameters := hb_aParams()
    Local aParameter
    Local aArrayParameters := Array( 0 )
    Local lAsterisk := .F.

    If pCount() == 1 .And.;
        HB_ISARRAY( aParameters:Get( 1 ) )

        ::Check( aParameters:Get( 1 ) )

    ElseIf pCount() == 1 .And.;
        HB_ISCHAR( aParameters:Get( 1 ) )
        
        ::Check( { aParameters:Get( 1 ) } )

    ElseIf pCount() > 1

        lAsterisk := aParameters:Exist( '*' )

        If lAsterisk

            ::aSelect := Array( 0 )

        Else

            for each aParameter in aParameters

                aAdD( aArrayParameters, aParameter )
                
            next

            ::Add( aArrayParameters )

        Endif

    Endif

Return ( Self )

/* METHOD: Empty(  )
    Devuelve si hay campos en el select
    
Devuelve:
    Lógico
*/
METHOD Empty( ) CLASS TORMSelect
Return ( ::aSelect:Empty() )

/* METHOD: Exist( cField )
    Comprueba si cField existe en el aSelect
    
    Parámetros:
        

Devuelve:
    Lógico
*/
METHOD Exist( cField ) CLASS TORMSelect
Return ( ::Position( cField ) != 0 )

/* METHOD: GetAlias( cField )
    Devuelve el alias del cField
    
    Parámetros:
        cField - Campo a buscar su alias

Devuelve:
    Caracter
*/
METHOD GetAlias( cField ) CLASS TORMSelect
Return ( ::aSelect:Get( ::Position( cField ) ):cAlias )

/* METHOD: Get(  )
    Devuelve el Array aSelect

    Devuelve:
    Array
*/
METHOD Get(  ) CLASS TORMSelect
Return ( ::aSelect )

/* METHOD: GetStr(  )
    Devuelve los campos del select en formato cadena separado por comas

Devuelve:
    String
*/
METHOD GetStr(  ) CLASS TORMSelect

    Local cSelect := ''
    Local oSelect := Nil

    for each oSelect in ::aSelect

        If .Not. cSelect:Empty()

            cSelect += ','

        Endif

        cSelect += oSelect:cField

    next

Return ( cSelect )

// Group: PROTECTED METHODS

/* METHOD: Check( xSelect )
    Chequea el select para añadirl correctamente al array
    
    Parámetros:
        xSelect - Valor Select

Devuelve:
    
*/
METHOD Check( xSelect ) CLASS TORMSelect

    Local aSelecttoAdd := Array( 0 )
    Local xValue       := Nil
    Local cField       := ''
    Local cAlias       := ''


    If HB_ISARRAY( xSelect )

        aSelecttoAdd := xSelect
        
    Else
        
        aSelecttoAdd := { xSelect }

    Endif

    for each xValue in aSelecttoAdd

        If xValue:ClassName() == 'MSELECT'

            aAdD( ::aSelect, xValue )

        Elseif HB_ISCHAR( xValue )

            xValue := xValue:Upper()

            If xValue:Has( TORM_AS )

                cField := xValue:Substr( 1, xValue:At( TORM_AS ) - 1 )
                cAlias := xValue:Substr( xValue:RAt( TORM_AS ) + TORM_AS:Len(),  xValue:Len() )
                aAdD( ::aSelect, MSelect():New( cField, cAlias ) )

            ElseIf xValue:NotHas( Space( 1 ) )

                aAdD( ::aSelect, MSelect():New( xValue ) )

            Endif

        Endif
        
    next

Return ( Nil )

/* METHOD: Position( cField )
    Devuelve la posición de cField dentro de aSelect
    
    Parámetros:
        cField - Campo a buscar

Devuelve:
    Numérico
*/
METHOD Position( cField ) CLASS TORMSelect

    Local nPosition := 0
    Local oSelect := Nil

    for each oSelect in ::aSelect
        
        If oSelect:cField:Upper() == cField:Upper()

            nPosition := oSelect:__enumindex 

        Endif

    next

Return ( nPosition )