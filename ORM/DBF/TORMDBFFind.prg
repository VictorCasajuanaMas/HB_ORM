/* CLASS: TORMDBFFind
    Busca un registro en el orden principal y devuelve el modelo
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFFind FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Find( cOrder )

            DATA oTORMModel AS OBJECT Init Nil

    PROTECTED:

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor, se le inyecta el modelo

    Parámetros:
        - oTORMModel : objeto TORMModel
        
Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFFind

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: Find( cOrder )
    Busca el registro en el orden principal Devuelve el Modelo

    Parámetros:
        cOrder - Campo del modelo a localizar

Devuelve:
    Modelo
*/
METHOD Find( cOrder ) CLASS TORMDBFFind

    Local cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()

    cOrder := ::oTORMModel:__oIndexes:OrderDefault( cOrder )
    
    If ::oTORMModel:Success()

        If TORMDBFSeek():New( ::oTORMModel ):Seek( MDBFSEek():New( cAlias, ::oTORMModel:__xFindValue, cOrder ) ):Success()

            ::oTORMModel:__oReturn := TORMDBFLoadFromAlias():New( ::oTORMModel ):Model( cAlias )
            ::oTORMModel:__oRelations:RefreshRelations()

        else

            ::oTORMModel:__oReturn:Success := .F.
            ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[19][1], TORM_ERROR_MESSAGE[19][2], { ::oTORMModel:__xFindValue:Str(), ::oTORMModel:TableName() }) )

        Endif
        TORMDBFCloseTable():New( ::oTORMModel ):Close( cAlias )

    Endif

Return ( ::oTORMModel )