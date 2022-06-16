/* CLASS: TORMDBFUpdate 
    Realiza una actualización masiva de los datos de una tabla según hData y el condicionante del where
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFUpdate FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Update( hData ) 

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil
        DATA hData      AS HASH   INIT hb_Hash()
        DATA cAlias     AS CHARACTER INIT ''

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor.  
   Parametros:
     oTORMModel - Se le inyecta el modelo  

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFUpdate

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Update( hData )
    Realiza la actualización en si misma.
    
    Parámetros:
        hData - Hash con los datos a actualizar

Devuelve:
    Nº de registros modificados
*/
METHOD Update( hData ) CLASS TORMDBFUpdate

    Local nRowsModified := 0
    Local aRecnos       := Array( 0 )
    Local nRecno        := 0
    Local rLock         := Nil
    Local lOneError     := .F.
    Local oError        := Nil
    Local nRecnoActual  := 0

    
    if HB_ISHASH( hData )

        If TORMDBFTableExist():New( ::oTORMModel ):Exists( 'dbf' ):Fail()
        
            TORMDBFCreateTable():New( ::oTORMModel ):Create()
            
        Endif
        
        ::cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()
    
        If ::oTORMModel:Success()

            aRecnos := TORMDBFGetOrdCondSet():New( ::oTORMModel ):Get( ::cAlias )
            aRecnos:ArrayInsert( TORMDBFGetRecnosWhereIn():New( ::oTORMModel ):Get( ::cAlias ) )

            If ::oTORMModel:Success()

                ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[34][1], TORM_INFO_MESSAGE[34][2], { ::oTORMModel:TableName(), ::cAlias } ) )

                for each nRecno in aRecnos

                    If .Not. ::oTORMModel:Fail()

                        try 

                            ( ::cAlias )->( DbGoTo( nRecno ) )
                            nrecnoActual := ( ::cAlias )->( Recno() )
                            
                        catch oError

                            ::oTORMModel:__oReturn:Success := .F.
                            ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[60][1], TORM_ERROR_MESSAGE[60][2], { ::oTORMModel:TableName() } ) )
                            lOneError := .T.
                            
                        end

                        If nRecnoActual == nRecno

                            rLock := TORMDBFRLock():New( ::oTORMModel ):Lock( ::cAlias )

                            If rLock:Fail()

                                ::oTORMModel:__oReturn:Success := .F.
                                ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[59][1], TORM_ERROR_MESSAGE[59][2], { nRecno:Str(), ::oTORMModel:TableName, ::cAlias } ) )
                                lOneError := .T.

                            Else

                                If TORMDBFPutHashToAlias():New( ::cAlias, ::oTORMModel ):Put( hData ):Success()

                                    nRowsModified++ 
            
                                    If .Not. lOneError

                                        ::oTORMModel:__oReturn:Success := .T.

                                    Endif

                                Endif

                                TORMDBFDbUnlock():New(::oTORMModel ):RUnlock(  ::cAlias )
                    
                            Endif

                        Endif

                    Endif

                next
            
            Endif

            TORMDBFCloseTable():New( ::oTORMModel ):Close( ::cAlias )

        Endif

    else

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oREturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[62][1], TORM_ERROR_MESSAGE[62][2], { ::oTORMModel:TableName(), ::cAlias } ) )

    Endif

Return ( nRowsModified )


// Group: PROTECTED METHODS