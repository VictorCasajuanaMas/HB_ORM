/* CLASS: TORMDBFLoadFromAlias
    Carga los registros del recno del alias actual al modelo
*/

#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFLoadfromAlias FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Model( cAlias )
        METHOD Hash( cAlias, aSelect )

            DATA oTORMModel AS OBJECT Init Nil
    PROTECTED:
        METHOD SelectCheck()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMMOdel )
    Constructor, se le inyecta el modelo

    Parámetros:
        - oTORMModel : objeto TORMModel
        
Devuelve:
    Self        
*/
METHOD New( oTORMModel ) CLASS TORMDBFLoadfromAlias

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: Model( cAlias )
    Carga los datos del recno del alias al modelo

    Parámetros:
        cAlias - Alias con el recno posicionado

Devuelve:
    TReturn     
*/
METHOD Model( cAlias ) CLASS TORMDBFLoadfromAlias

    Local oReturn       := TReturn():New()
    Local oField        := Nil
    Local xValueofField := Nil
    Local aData         := Array( 0 )
    Local aValues       := Array( 0 )
    Local nCount        := 1
    Local cFields       := ''
    Local oError        := Nil
    
    
    try 

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[17][1], TORM_INFO_MESSAGE[17][2], {cAlias, ::oTORMModel:TableName()} ) )
        __objSetValueList( ::oTORMModel, {{ ::oTORMModel:InternalDbIdName() , ( cAlias )->( Recno() ) } } )

        cFields := ::oTORMModel:__oQuery:oSelect:GetStr()

        If cFields:Empty()

            cFields := ::oTORMModel:GetFieldsStr()

        Endif

        // Cargo todos los valores del alias actual al array
        Select( cAlias )
        aValues := Eval( &( "{||{" + cFields + "}}" ) )         

        // Creo un array bidimensional con los nombres de los campos y sus valores
        aEval( hb_atokens( cFields, ',' ), { | cfield | aAdD( aData, { cField, aValues[ nCount++ ] } ) } )

        // Asigno al modelo los datos del array bidimensional
        __objSetValueList( ::oTORMModel, aData )


        // Asigno los datos al buffer inicial
        If ::oTORMModel:InitialBuffer:WithInitialBuffer()

            ::oTORMModel:__oInitialBuffer:Update( ::oTORMModel )

        Endif

       oReturn:Success := .T.
        ::oTORMModel:__lInEdition := .T.
        
    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[28][1], TORM_ERROR_MESSAGE[28][2], { ::oTORMModel:TableName, TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( oReturn )


/* METHOD: Hash( cAlias, aSelect )
    Carga los datos del recno del alias al Hash

    Parámetros:
        cAlias - Alias con el recno posicionado
        aSelect - DATAS a cargar
        
Devuelve:
    TReturn     
*/
METHOD Hash( cAlias, aSelect ) CLASS TORMDBFLoadfromAlias

    Local oReturn       := TReturn():New()
    Local cField        := ''
    Local xValueofField := Nil
    Local hData         := hb_Hash()
    Local oError        := Nil

    aSelect := ::SelectCheck( aSelect )

    try 

        for each cField in aSelect

            hData[ cField] :=  &( cAlias + '->' + cField )
            
        next

        oReturn:Return := hData
        oReturn:Success := .T.
        
    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[29][1], TORM_ERROR_MESSAGE[29][2], { ::oTORMModel:TableName(), TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( oReturn )


/* METHOD: SelectCheck( aSelect )
    Revisa los campos que han de devolverse y devuelve un array con los campos a devolver

Parámetros:
    aSelect - Array con los campos a incluir en el modelo a cargar del DBF. Nil se inlcluyen todos

Devuelve:
    Array
*/
METHOD SelectCheck( aSelect ) CLASS TORMDBFLoadFromAlias

    Local aFields := Array( 0 )
    Local cfieldSelect := ''
    Local oTORMField := Nil 

    If aSelect:Empty()

        for each oTORMField in ::oTORMModel:__aFields
            
            aAdD( aFields, oTORMField:cName )

        next

    Else

        for each cFieldSelect in aSelect

            If aScan( ::oTORMModel:__aFields, { | cFieldModel | cFieldModel:cName:Upper() == cFieldSelect:Upper() } ) != 0

                aAdD( aFields, cFieldSelect )

            Endif
            
        next

    Endif

Return ( aFields )