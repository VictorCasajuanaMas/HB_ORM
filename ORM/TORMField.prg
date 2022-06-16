/* CLASS: TORMField
          Clase que se encarga delos campos del Modelo

*/

#Include 'hbclass.ch'

CREATE CLASS TORMField

    EXPORTED:
        DATA cName          AS CHARACTER    Init ''
        DATA cType          AS CHARACTER    Init ''
        DATA nLenght        AS NUMERIC      Init 0
        DATA nDecimals      AS NUMERIC      Init 0
        DATA cDescription   AS CHARACTER    Init ''
        DATA uDefault       
        DATA hValid         AS HASH         Init Hb_Hash()

        DATA oTORMModel AS OBJECT Init Nil

        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD AddFieldtoModel()
        METHOD Set( cName, cType, nLenght, nDecimals, cDescription, uDefault, hValid )
        METHOD ReadytoSave()
        METHOD GetProperties()

    PROTECTED:
        METHOD SetInitValue()
        METHOD SetValidationDefault()
        METHOD SetDefaultLenght()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Crea el objeto y le inyecta el modelo

    Parametros:
        - oTORMModel : Objeto TORMModel al que se añadirá el campo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMField

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: AddfieldtoModel( )
    Añade el campo en el array de campos del modelo y crea la DATA con el valor inicial por defecto

Devuelve:
    Nil
*/
METHOD AddFieldtoModel() CLASS TORMField
    

    ::SetDefaultLenght()
    aAdD( ::oTORMModel:__aFields, Self )
    __objAddData( ::oTORMModel, ::cName )
    ::SetInitValue()
    ::SetValidationDefault()

Return ( Nil )

/* METHOD: Set( ... )
    Asigna los valores al objeto
    
    Parámetros:
        ... - Todos los valores

*/
METHOD Set( cName, cType, nLenght, nDecimals, cDescription, uDefault, hValid ) CLASS TORMField

    ::cName        := Iif( cName:NotEmpty(),        cName,        ::cName )
    ::cType        := Iif( cType:NotEmpty(),        cType,        ::cType )
    ::nLenght      := Iif( nLenght:NotEmpty(),      nLenght,      ::nLenght )
    ::nDecimals    := Iif( nDecimals:NotEmpty(),    nDecimals,    ::nDecimals )
    ::cDescription := Iif( cDescription:NotEmpty(), cDescription, ::cDescription )
    ::uDefault     := Iif( uDefault:NotEmpty(),     uDefault,     ::uDefault )
    ::hValid       := Iif( hValid:NotEmpty(),       hValid,       ::hValid )

Return ( Self )

/* METHOD: ReadyToSave(  )
    Indica si el campo es apto para poder guardarse en la tabla
    
Devuelve:
    Lógico
*/
METHOD ReadyToSave(  ) CLASS TORMField


    Local lReadyToSave := .T.

    If ::cType == '+'

        lReadyToSave := .F.

    Endif

Return ( lReadyToSave )

/* METHOD: GetProperties(  )
    Devuelve un array con las propiedades que puede tener un campo

Devuelve:
    Array
*/
METHOD GetProperties(  ) CLASS TORMField
Return ( {'cName','cType','nLenght','nDecimals','cDescription','uDefault','hValid'} )

// Group: PROTECTED METHODS

/* METHOD: SetInitValue( )
    Asigna el valor por defecto que ha de tener el campo cuando se crea

Devuelve:
    Nil
*/
METHOD SetInitValue() CLASS TORMField

    Local xInit := Nil

    If .Not. Empty( ::uDefault )

        __objSetValueList( ::oTORMModel, { { ::cName, ::uDefault } } )

    Else

        xInit := TORMFieldInit():New( Self ):Init()
        __objSetValueList( ::oTORMModel, { { ::cName, xInit } } )

    Endif

Return ( Nil )

/* METHOD: SetValidationDefault()
    Asigna la validación por defecto según las características del campo y la añade a la ya existente

Devuelve:
    Nil
*/
METHOD SetValidationDefault() CLASS TORMField

    TORMFieldValidationDefault():New( Self ):Default()

Return ( Nil )


/* METHOD: SetDefaultLenght(  )
    Establece el ancho por defecto de un campo

Devuelve:
    Nil
*/
METHOD SetDefaultLenght() CLASS TORMField

    switch ::cType

        case 'D'

            ::nLenght := 8

        exit

        case 'L'

            ::nLenght := 1

        exit

        case '+'

            ::nLenght := 4

        exit 

    endswitch

Return ( Nil )