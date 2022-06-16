/* CLASS: TORMGetStructureStr 
    Devuelve la estructura del modelo
*/
#include 'hbclass.ch'

CREATE CLASS TORMGetStructureStr

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Get( ... )

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se inyecta el modelo 
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMGetStructureStr

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Get( ... )
    Devuelve la estructura en sí

    Parámetros:
        ... - Campos de la estructura a devolver, si no se pasa se devuelven todos

    Devuelve:
    Array
*/
METHOD Get( ... ) CLASS TORMGetStructureStr

    Local aStruct     := Array( 0 )
    Local cStruct     := ''
    Local aProperties := Array( 0 )
    Local cProperty   := ''
    Local oTORMField  := Nil

    If hb_AParams():Empty()

        aProperties := TORMField():New():GetProperties()

    Else

        aProperties := hb_Aparams()

    Endif

    for each oTORMField in ::oTORMModel:__aFields

        cStruct := ''
        
        for each cProperty in aProperties

            if .Not. cStruct:Empty()

                cStruct += ','

            Endif

            cStruct += oTORMField:&(cProperty):Str()
        
        next

        aAdD( aStruct, cStruct )

    next

Return ( aStruct )

// Group: PROTECTED METHODS