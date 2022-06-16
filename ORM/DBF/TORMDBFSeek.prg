/* CLASS: TORMDBFSeek
    Se encarga de localizar registros en el fichero .DBF
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFSeek FROM TORMDBF

    EXPORTED:
    // TODO: Susutituir las variables cAlias, xFindValue y cOrder por el Modelo MDBFSeek
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Seek( oFind )
        METHOD SeekIndex( nOrder, xFindValue )
        METHOD Locate( cOrder, xFindValue )

    PROTECTED:
        DATA oTORMModel AS OBJECT    INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor, se le pasa el alias donde buscar la información

    Parámetros:
        oTORMmodel  - Modelo
        
Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFSeek

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Seek( oFind  )
    Busca en el alias oTORMModel:__xfindvalue 

    Parámetros:
        oFind - Objeto MDBFSeek

    Devuelve:
        TReturn
*/
METHOD Seek( oFind ) CLASS TORMDBFSeek

    
    Local oReturn := Nil
    Local nOrder := ::oTORMModel:__oIndexes:IndexNumeral( oFind:cOrder )

    If nOrder != 0 

        oReturn := ::SeekIndex( nOrder, oFind )

    Else

        oReturn := ::Locate( oFind )

    Endif

Return ( oReturn )


/* METHOD: SeekIndex( nOrder, oFind )
    Realiza la búsqueda por índice
    
    Parámetros:
        nOrder - Nº de orden en los indices del DBF
        oFind - Objeto MDBFSeek

Devuelve:
    oReturn
*/
METHOD SeekIndex( nOrder, oFind ) CLASS TORMDBFSeek

    Local oReturn := TReturn():New()
    Local oError  := Nil

    
    If HB_ISOBJECT( oFind:xFindValue )

        oFind:xFindValue := oFind:xFindValue:ToString( oFind:oModelAuxiliar )

    Endif

    try 

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[31][1], TORM_INFO_MESSAGE[31][2], { oFind:xFindValue:Str(), ::oTORMModel:TableName(), nOrder, oFind:cAlias } ) )
        ( oFind:cAlias )->( DbSetOrder( nOrder ) )
        oReturn:Success := ( oFind:cAlias )->( DbSeek( oFind:xFindValue ) )

    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[42][1], TORM_ERROR_MESSAGE[42][2], { TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( oReturn )

/* METHOD: Localte( oFind )
    Localiza una búsqueda sin índice
    
    Parámetros:
        oFind - Objeto MDBFSeek

Devuelve:
    oReturn
*/
METHOD Locate( oFind ) CLASS TORMDBFSeek

    Local oReturn := TReturn():New()

    try 

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[32][1], TORM_INFO_MESSAGE[32][2], { oFind:xFindValue:Str(), ::oTORMModel:TableName(), oFind:cOrder, oFind:cAlias } ) )
        ( oFind:cAlias )->( __dbLocate( { | | &( oFind:cAlias + '->' + oFind:cOrder) == oFind:xFindValue },,,,.f. ) )
        oReturn:Success := &( oFind:cAlias + '->' + oFind:cOrder) == oFind:xFindValue

    catch oError

        oReturn:Success := .F.
        ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[43][1], TORM_ERROR_MESSAGE[43][2], { TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( oReturn )