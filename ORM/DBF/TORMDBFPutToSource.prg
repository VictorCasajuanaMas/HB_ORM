/* CLASS: TORMDBFPutToSource 
    Persiste los datos del modelo al DBF
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'dbinfo.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFPutToSource FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Put( calias )

            DATA oTORMMOdel AS OBJECT INIT Nil
    PROTECTED:

        METHOD PutOneRecord( cAlias, oTORMModel )
        METHOD PutMultipleRecord( cAlias )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFPutToSource

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Put( cAlias )
    Persiste los datos del Modelo a cAlias
    
    Parámetros:
        cAlias - Alias

Devuelve:
    oReturn
*/
METHOD Put( cAlias ) CLASS TORMDBFPutToSource

    Local oReturn := TReturn():New()

    If ::oTORMModel:HasCollection()

        ::PutMultipleRecord( cAlias )

    Else

        ::PutOneRecord( cAlias, ::oTORMModel )

    Endif

Return ( oReturn )

// Group: PROTECTED METHODS

/* METHOD: PutOneRecord( cAlias, oTORMModel )
    Persiste el modelo en al Alias
    
    Parámetros:
        cAlias     - Alias a persistir
        oTORMModel - Modelo

Devuelve:
    oReturn
*/
METHOD PutOneRecord( cAlias, oTORMModel ) CLASS TORMDBFPutToSource

    // Modificado.

    Local oReturn       := TReturn():New( .T. )
    Local oField        := Nil
    Local lBeforeLocked := .F.
    Local lIsLocked     := .F.

    oReturn := TORMDBFGoToInternalDbId():New( oTORMModel ):Position( cAlias )

    If oReturn:Success

        try 

            ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[24][1], TORM_INFO_MESSAGE[24][2], { oTORMModel:TableName, cAlias} ) )
            lBeforeLocked := (cAlias)->( dbRecordInfo( DBRI_LOCKED ) )

            If lBeforeLocked

                lIsLocked := .T.

            Else

                lIsLocked := TORMDBFRLock():New( ::oTORMModel ):Lock( cAlias ):Success

            Endif

            If lIsLocked

                for each oField in oTORMModel:__aFields

                    &( cAlias + '->' + oField:cName ) := oTORMModel:&( oField:cName )

                Next

            Else
                oReturn:Success := .F.
                ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[34][1], TORM_ERROR_MESSAGE[34][2], { oTORMModel:TableName(), cAlias, oTORMModel:GetInternalDbId():Str() } ) )
            Endif

            If .Not. lBeforeLocked
                TORMDBFDbUnlock():New( oTORMModel ):RUnlock( cAlias )
            Endif

        catch oError

            oReturn:Success := .F.
            ::oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[35][1], TORM_ERROR_MESSAGE[35][2], { oTORMModel:TableName(),cAlias, TTryCatchShowerror():New( oError ):ToString() } ) )
        
        end

    Endif

Return ( oReturn )

/* METHOD: PutMultipleRecord( cAlias )
    Persiste la colección del modelo al alias
    
    Parámetros:
        cAlias - Alias a persistir

Devuelve:
    oReturn
*/
METHOD PutMultipleRecord( cAlias ) CLASS TORMDBFPutToSource

    Local oReturn       := TReturn():New( .T. )
    Local rPutOneRecord := Nil
    Local oRecno        := TORMDBFRecno():New( cAlias, ::oTORMModel )

    If oRecno:Success

        ::oTORMModel:GoTop()

        While .Not. ::oTORMModel:Eof() .And.;
            oReturn:Success

            If ( rPutOneRecord := ::PutOneRecord( cAlias, ::oTORMModel ) ):Fail

                oReturn:Success := .F.
                oReturn:Log     := rPutOneRecord

            Endif

            ::oTORMModel:Skip()

        Enddo

        oRecno:Go()

    Else

        oReturn := oRecno

    Endif

Return ( oReturn )