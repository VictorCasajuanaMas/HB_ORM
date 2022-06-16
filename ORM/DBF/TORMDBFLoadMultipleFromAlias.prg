
/* CLASS: TORMDBFLoadMultipleFromAlias 
    Carga varios registros del alias actual a la colección según los criterios del oden y valor de búsqueda
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'dbinfo.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFLoadMultipleFromAlias FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Model( oFind )

            DATA oTORMModel     AS OBJECT INIT Nil
    PROTECTED:

        METHOD xFindValue( xFindValue )
        METHOD InData( oFind )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor.  Se le inyecta el modelo
    
   Parametros:
      oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFLoadMultipleFromAlias

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Model( oFind )
    Carga los datos de los registros encontrados al modelo

    Parámetros:
        oFind - Objeto MDBFSeek

Devuelve:
    oReturn
*/
METHOD Model( oFind ) CLASS TORMDBFLoadMultipleFromAlias

    Local oModel         := Nil
    //Local oModelBase     := &(::oTORMModel:ClassName())():New()
    Local oRecno         := TORMDBFRecno():New( oFind:cAlias, ::oTORMModel )
    Local oLoadFromAlias := Nil
    Local oError         := Nil

    If oRecno:Success()

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[19][1], TORM_INFO_MESSAGE[19][2], {oFind:cAlias, ::oTORMModel:TableName() } ) )

        ::oTORMModel:__oReturn:Success := .T.
        ::oTORMModel:Initialize()
        oFind:cOrder := ::oTORMModel:__oIndexes:OrderDefault( oFind:cOrder )

        If ( oFind:cAlias )->( DbOrderInfo( DBOI_ORDERCOUNT ) ) == 0 .Or.; // No hay índices, por lo tanto voy al principio
           oFind:xFindValue == Nil

            ( oFind:cAlias )->( DbGoTop() )

        Else

            TORMDBFSeek():New( ::oTORMModel ):Seek( MDBFSEek():New( oFind:cAlias, oFind:xFindValue, oFind:cOrder ) ):Success()

        Endif

        While ::InData( oFind ) .And.;
            ::oTORMModel:Success

            oModel := &(::oTORMModel:ClassName())():New()
            //oModel := __objClone( oModelBase )
            oLoadFromAlias := TORMDBFLoadFromAlias():New( oModel ):Model( oFind:cAlias )

            If oLoadFromAlias:Success

                ::oTORMModel:Inject( oModel )

            Else

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:__oReturn:Log := oLoadFromAlias

            Endif

            try 

                ( oFind:cAlias )->( DbSkip()) 
                
            catch oError

                ::oTORMModel:__oReturn:Success := .F.
                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[30][1], TORM_ERROR_MESSAGE[30][2], { ::oTORMModel:TableName(), TTryCatchShowError():New( oError ):ToString() } ) )
                
            end

        Enddo

        oRecno:Go()

    Else

        ::oTORMModel:__oReturn := oRecno:oReturn

    endif

Return ( ::oTORMModel:__oReturn )


// Group: PROTECTED METHODS

/* METHOD: InData( oFind )
    Devuelve si el registro cumple con las condiciones de la búsqueda

    Parámetros:
        oFind - Objeto MDBFSeek
        
Devuelve:
    Lógico
*/
METHOD InData( oFind ) CLASS TORMDBFLoadMultipleFromAlias

    Local lInData := .Not. ( oFind:cAlias )->( Eof() )
    Local cData   := ''

    If ( oFind:cAlias )->( DbOrderInfo( DBOI_ORDERCOUNT ) ) != 0    // SI no hay índices, siempre se pilla todo el contenido

        If HB_ISOBJECT( oFind:xFindValue )

            for each cData in oFind:xFindValue:GetDatas()

                lInData := Iif( &( oFind:cAlias + '->' + cData ) == oFind:xfindValue:Get( cData ), lInData, .F. )
                
            next

        ElseIf oFind:xFindValue != Nil

            lInData := Iif( &( oFind:cAlias + '->' + oFind:cOrder ) == oFind:xFindValue, lIndata, .F. )

        Endif

    Endif

Return ( lInData )

/* METHOD: xFindValue( xFindValue )
    Devuelve el valor a buscar dependiendo de si xFindValue es un objeto (interface IORMIndexComposite) o un campo normal
    
    Parámetros:
        xfindValue - Objeto o valor a buscar

Devuelve:
    Valor de búsqueda
*/
METHOD xFindValue( xFindValue ) CLASS TORMDBFLoadMultipleFromAlias

    if HB_ISOBJECT( xFindValue )

        xFindValue := xFindValue:ToString()

    Else

        xFindValue := xFindValue

    Endif

Return ( xFindValue )