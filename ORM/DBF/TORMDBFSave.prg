/* CLASS: TORMDBFSave
          Se encarga de guardar el buffer del modelo en la tabla DBF

*/

#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFSave FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) Constructor
        METHOD Save( cAlias )

            DATA oTORMModel AS OBJECT Init Nil
    PROTECTED:
        DATA cAlias     AS STRING Init Nil

ENDCLASS

METHOD New( oTORMModel ) CLASS TORMDBFSave

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )


/* METHOD: Save( )
    Guarda los datos del buffer actual en la tabla .DBF 

    Parámetros:
        cAlias - Alias de la tabla a guardar. Si no se le pasa lo abre

Devuelve:
    Objeto
*/
METHOD Save( cAlias ) CLASS TORMDBFSave
    
    Local lReadyToSave  := .F.
    Local rSeek         := Nil
    Local rLock         := Nil
    Local rAppend       := Nil

    If cAlias != Nil 

        ::cAlias := cAlias 

    Else

        If TORMDBFTableExist():New( ::oTORMModel ):Exists( 'dbf' ):Fail()
            
            TORMDBFCreateTable():New( ::oTORMModel ):Create()
            
        Endif
        
        ::cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()

    Endif
    
    If ::oTORMModel:Success()

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[29][1], TORM_INFO_MESSAGE[29][2], { ::oTORMModel:TableName(), ::cAlias } ) )
        
        If ::oTORMModel:__lInEdition

            If .Not. ::oTORMModel:__xFindValue:Empty()

                rSeek := TORMDBFSeek():New( ::oTORMModel ):Seek( MDBFSEek():New( ::cAlias, ::oTORMModel:__xFindValue ) )

            else

                rSeek := TORMDBFGoToInternalDbId():New( ::oTORMModel ):Position( ::cAlias )

            Endif

            rLock := TORMDBFRLock():New( ::oTORMModel ):Lock( ::cAlias )

            If rSeek:Success() .And. rLock:Success()
            
                lReadyToSave := .T.

            Else

                ::oTORMModel:__oReturn:Log := rSeek
                ::oTORMModel:__oReturn:Log := rLock

            Endif
            
        else

            rAppend := TORMDBFDbAppend():New( ::oTORMModel ):Append( ::cAlias )

            If rAppend:Success()
            
                lReadyToSave := .T.

            Else 

                ::oTORMModel:__oReturn:Log := rAppend

            Endif
            
        Endif
        
        If lReadyToSave

            TORMDBFPutToAlias():New( ::oTORMModel ):Put( ::cAlias ):Success()

            If ::oTORMModel:Success()

                ::oTORMModel:__lInEdition := .T.

            Endif

        Endif

        If cAlias == Nil

            TORMDBFCloseTable():New( ::oTORMModel ):Close( ::cAlias )

        Endif

    Endif

Return ( ::oTORMModel )