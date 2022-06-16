/* CLASS: TORMDBFPutHashToAlias 
    Pasa los datso de un hash al registro actual del fichero DBF
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFPutHashToAlias FROM TORMDBF

    EXPORTED:
        METHOD New( cAlias, oTORMModel ) CONSTRUCTOR
        METHOD Put( hData )

    PROTECTED:
        DATA cAlias     AS CHARACTER INIT ''
        DATA oTORMModel AS OBJECT    INIT Nil
        METHOD GetValue( xValue )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( cAlias, oTORMModel )
    Constructor. se le inyecta el alias 
    
   Parametros:
     cAlias - alias del fichero DBF
     oTORMModel - modelo de datos

Devuelve:
    Self
*/
METHOD New( cAlias, oTORMModel ) CLASS TORMDBFPutHashToAlias

    ::Super:New()
    ::cAlias := cAlias
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Put( hData )
    Pasa los datos de hData al registro actual del DBF
    
    Parámetros:
        hData - Hash con los datos a pasar

Devuelve:
    TReturn
*/
METHOD Put( hData ) CLASS TORMDBFPutHashToAlias

    Local oReturn := TReturn():New()
    Local hItem := hb_Hash()
    Local oError := Nil

    try 

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[22][1], TORM_INFO_MESSAGE[22][2], {::oTORMModel:TableName(), ::cAlias} ) )

        for each hItem in hData

            ( ::cAlias )->( FieldPut ( ( ::cAlias )->( FieldPos( hItem:__enumkey ) ) , ::GetValue( hItem:__enumvalue ) ) )
        
        next
        oReturn:Success := .T.
        
    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log     := hb_StrReplace( TORM_ERROR_MESSAGE[32][1], TORM_ERROR_MESSAGE[32][2], { ::oTORMModel:TableName(), ::cAlias, TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( oReturn )

// Group: PROTECTED METHODS

/* METHOD: GetValue( xValue )
    Devuelve el valor a asignar
    
    Parámetros:
        xValue - Cualquier valor

Devuelve:
    Cualquier Valor
*/
METHOD GetValue( xValue ) CLASS TORMDBFPutHashToAlias

    Local xResultValue := Nil

    if .Not. HB_ISBLOCK( xValue )

        xResultValue := Eval({||xValue})

    Else

        xResultValue := Eval(xValue)

    Endif

Return ( xResultValue )