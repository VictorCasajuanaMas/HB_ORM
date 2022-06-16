#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

/* CLASS: TORMDBFOpenTable
    Se encarga de abrir el fichero .DBF
*/


CREATE CLASS TORMDBFOpenTable FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) Constructor
        METHOD Open()

            DATA oTORMModel AS OBJECT Init Nil
    PROTECTED:

        DATA cSource AS CHARACTER INIT ''

        METHOD CheckIndex()
        METHOD SetSourceData()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor, se le inyecta el modelo

    Parámetros:
        - oTORMModel : objeto TORMModel

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFOpenTable

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Open()
    Abre el fichero .DBF y devuelve el Alias

Devuelve:
    Model
*/
METHOD Open() CLASS TORMDBFOpenTable

    Local cAlias := TORMDbfAlias():New():GetAlias()
    Local oError := .T.

    ::cSource := ::Path() + ::oTORMModel:TableName()

    try 
        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[21][1], TORM_INFO_MESSAGE[21][2], {::cSource,cAlias} ) )
        dbUseArea( .t., 'DBFCDX', ::cSource, cAlias, .t., .f. )

        If ::oTORMModel:__oLazyLoad:CanLazyShared() .And.;
            ::oTORMModel:&(TORM_LAZYSHARED) != Nil
 
            ::oTORMModel:&(TORM_LAZYSHARED):cSource := ::cSource
 
        Endif
        
        If ::oTORMModel:__oIndexes:HasIndexes()

            ordListAdd( ::cSource )

        Endif

        ::oTORMModel:__oReturn:Return  := cAlias
        ::oTORMModel:__oReturn:Success := .T.

    catch oError

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[31][1], TORM_ERROR_MESSAGE[31][2], { ::cSource, cAlias, TTryCatchShowerror():New( oError ):ToString() } ))
        
    end

    ::SetSourceData()
    ::CheckIndex()

Return ( cAlias )

/* METHOD: CheckIndex()
    Revisa que el indice exista, de lo contrario lo crea
*/
METHOD CheckIndex() CLASS TORMDBFOpenTable

    If ::oTORMModel:__oIndexes:HasIndexes() .And.;
       TORMDBFTableExist():New( ::oTORMModel ):Exists( 'cdx' ):Fail()

        ::oTORMModel:__oReturn:Success := TORMDBFCreateIndex():New( ::oTORMModel ):Create():Success()

    Endif

Return ( Nil )

/* METHOD: SetSourceData(  )
    Asigna la información del source al modelo
    
    Parámetros:
        

Devuelve:
    oReturn
*/
METHOD SetSourceData(  ) CLASS TORMDBFOpenTable

    Local oError  := Nil
    Local cFile   := ::cSource + '.dbf'
    Local oReturn := Nil

    ::oTORMModel:__oSource:cOrigin := ::cSource

    If ::oTORMModel:Success .And. ;
       ::oTORMModel:__oLazyLoad:lEnable .And.;
       ::oTORMModel:__oLazyLoad:IsPessimist()     // Solamente lo hago cuando está el lazyloadpessimist activado para evitar estas peticiones a la persistencia después de abrir el origen si no hace falta

       oReturn := TORMDBF():GetSource( cFile, ::oTORMModel )

       If oReturn:Success 

            ::oTORMModel:__oSource := oReturn:Return

       Endif

    Endif

Return ( ::oTORMModel:__oReturn )