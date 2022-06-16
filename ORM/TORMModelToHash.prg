/* CLASS: TORMModelToHash 
    Convierte un modelo a un hash
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMModelToHash

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD ToHash()

            DATA oTORMModel AS OBJECT INIT Nil
            DATA hHash      AS HASH   INIT hb_hash()
            DATA aDataToSelect AS ARRAY INIT Array( 0 )
    PROTECTED:


        METHOD AssignDataFields(  )
        METHOD SpecialData()
        METHOD GetDataToSelect()

ENDCLASS


// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 

   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMModelToHash

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: ToHash(  )
    Devuelve todos los DATA del modelo en un hash
    
Devuelve:
    Hash
*/
METHOD ToHash(  ) CLASS TORMModelToHash

    ::GetDataToSelect()
    ::AssignDataFields()
    ::SpecialData()

Return ( ::hHash )


// Group: PROTECTED METHODS

/* METHOD: AssignDataFields(  )
    Asigna los datos standard al Hash
*/
METHOD AssignDataFields(  ) CLASS TORMModelToHash

    Local aData         := Array( 0 )
    Local lDataSelected := .F.
    Local xValue        := Nil
    Local cAlias        := ''
    Local oSelect       := Nil

    for each oSelect in ::aDataToSelect

        If oSelect:cAlias != TORM_SELECT_INTERNALDBID

            xValue := ::oTORMModel:&( oSelect:cField ) 

            If HB_ISOBJECT( xValue ) .And.;
               __objHasMethod( xValue, 'ToHash' )

                ::hHash := hb_HMerge( ::hHash, xValue:ToHash() )

            ElseIf ::oTORMModel:__oRelations:aRelations:NotExist( oSelect:cAlias:Upper() )

                ::hHash[ oSelect:cAlias ] := xValue

            Endif

        Endif

    next

Return ( Nil )

/* METHOD: Specialdata(  )
    Asigna los datos especiales al Hash
    
*/
METHOD Specialdata(  ) CLASS TORMModeltoHash

    If ::oTORMModel:__oQuery:oSelect:Exist( TORM_SELECT_INTERNALDBID )

        ::hHash[ TORM_SELECT_INTERNALDBID ] := ::oTORMModel:GetInternalDbId()

    Endif

Return ( Nil )

/* METHOD: GetDataToSelect(  )
    Rellena el array de datos a devolver por el hash
*/
METHOD GetDataToSelect(  ) CLASS TORMModelToHash

    Local oSelect   := Nil
    Local aData     := Nil
    Local oRelation := Nil

    ::aDataToSelect := Array( 0 )

    If .Not. ::oTORMModel:__oQuery:oSelect:Empty()

        for each oSelect in ::oTORMModel:__oQuery:oSelect:Get()

            aAdD( ::aDataToSelect, oSelect)

        next

        for each oRelation in ::oTORMModel:__oRelations:aRelations

            aAdD( ::aDataToSelect, MSelect():New( oRelation:cName ) )

        next

    Else

        for each aData in __objGetValueList( ::oTORMModel )

            If aData[ HB_OO_DATA_VALUE ] != Nil

                aAdD( ::aDataToSelect, MSelect():New( aData[ HB_OO_DATA_SYMBOL ] ) )

            Endif

        next

    Endif
    
Return ( Nil )