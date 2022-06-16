/* CLASS: TORMDBFCheck 
    Chequea que el fichero DBF sea correcto, tenga todos los campos con los tipos correctos y tamaños, también revisa los ficheros índices
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'dbstruct.ch'
#include 'TORM.ch'
CREATE CLASS TORMDBFCheck

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Check( cAlias )

    PROTECTED:
        DATA oTORMModel AS OBJECT    INIT Nil
        DATA cAlias     AS CHARACTER INIT ''
    
        METHOD CheckStruct( )
        METHOD FieldOk( oTORMField, aField )

ENDCLASS


// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFCheck

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Check( cAlias )
    Chequea la DBF en sí

    Parámetros:
        cAlias - Si se le pasa el alias no lo abre para aumentar la velocidad
*/
METHOD Check( cAlias ) CLASS TORMDBFCheck

    
    ::oTORMModel:__oReturn:Success := .T.
    If cAlias:Empty()

        ::cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()

    Else

        ::cAlias := cAlias

    Endif

    If ::oTORMModel:Success()

        ::CheckStruct()

        If cAlias:Empty()

            TORMDBFCloseTable():New( ::oTORMModel ):Close( ::cAlias )

        Endif

    Endif

Return ( Nil )

// Group: PROTECTED METHODS
/* METHOD: CheckStruct( )
    Comprueba la estructura del fichero DBF según el modelo y cambia el estado del modelo según el resultado
*/
METHOD CheckStruct(  ) CLASS TORMDBFCheck

    Local aStruct    := Array( 0 )
    Local oError     := Nil
    Local oTORMField := Nil
    Local nPosition  := 0

    try 

        
        aStruct := ( ::cAlias )->( DbStruct() )

        for each oTORMField in ::oTORMModel:__aFields

            If ( nPosition := aScan( aStruct, { | aField | aField[ DBS_NAME ]:Upper() == oTORMField:cName:Upper() } ) ) != 0

                ::FieldOk( oTORMField, aStruct:Get( nPosition ) )

            else

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[51][1], TORM_ERROR_MESSAGE[51][2], { ::oTORMModel:TableName(), oTORMField:cName } ) )

            Endif
            
        next
        
    catch oError

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[50][1], TORM_ERROR_MESSAGE[50][2], { ::oTORMModel:TableName(), TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( Nil )

/* METHOD: FieldOk( oTORMField, aField )
    Comprueba que el campo de la DBF sea igual que el campo del modelo
    
    Parámetros:
        oTORMField - Campo del modelo a comprobar
        aField - Array con la estructura del campo en la DBF

Devuelve:
    oReturn
*/
METHOD FieldOk( oTORMField, aField ) CLASS TORMDBFCheck

    Local oReturn := TReturn():New()
    Local cType   := ''

    oReturn:Success := .F.

    If aField[ DBS_TYPE ]:Upper() == '@'    // caprichos del xBase
    
        cType := 'T'
    
    else
    
        cType := aField[ DBS_TYPE ]:Upper()
    
    Endif
    
    If cType != oTORMField:cType:Upper()

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[52][1], TORM_ERROR_MESSAGE[52][2], { ::oTORMModel:TableName(), oTORMField:cName, oTORMField:cType, cType } ) )

    Endif

    If aField[ DBS_LEN ] != oTORMField:nLenght 

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[53][1], TORM_ERROR_MESSAGE[53][2], { ::oTORMModel:TableName(), oTORMField:cName, oTORMField:nLenght:Str(), aField[ DBS_LEN ]:Str() } ) )

    Endif

    If aField[ DBS_DEC ] != Nil .And.;
       aField[ DBS_DEC ] != oTORMField:nDecimals

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[54][1], TORM_ERROR_MESSAGE[54][2], { ::oTORMModel:TableName(), oTORMField:cName, oTORMField:nDecimals:Str(), aField[ DBS_DEC ]:Str() } ) )

    Endif

Return ( oReturn )