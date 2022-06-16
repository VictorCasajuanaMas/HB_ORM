/* CLASS: TORMCollectionLoadFromCollection 
    Carga un registro de la colección al modelo actual
*/
#include 'hbclass.ch'

CREATE CLASS TORMCollectionLoadFromCollection

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Load( oRecord )

    PROTECTED:
        DATA oTORMModel AS OBJECT Init Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMCollectionLoadFromCollection

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Load( oRecord )
    Carga oRecord de la colección al modelo
    
    Parámetros:
        oRecord - Registro de la colección a cargar
*/
METHOD Load( oRecord ) CLASS TORMCollectionLoadFromCollection

    Local oField     := Nil
    Local aValueList := Array( 0 )
    Local nSteeps    := 0
    Local aFields    := Array( 0 )
    Local cField     := ''
    Local oSelect    := Nil

    // Si la consulta tiene selects, pillo solo los datos del select.
    If .Not. ::oTORMModel:__oQuery:oSelect:Empty()

        for each oSelect in ::oTORMModel:__oQuery:oSelect:Get()

            aAdD( aFields, oSelect:cField )
            
        next

    Else

        for each oField in ::oTORMModel:__aFields

            aAdD( aFields, oField:cName )

        Next

    Endif

    for each cField in aFields

        aAdD( aValueList, { cField, oRecord:&( cField ) } )
        nSteeps++

    next

    __objSetValueList( ::oTORMModel, aValueList )

Return ( Nil )

// Group: PROTECTED METHODS