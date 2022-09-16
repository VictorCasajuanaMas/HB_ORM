/* CLASS: TORMDBFLazyLoadCheck 
    Chequea si el DBF que ha realizado la carga inicial del LazyLoad es el mismo que el que se esta usando actualmente.
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFLazyLoadCheck FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Check()
            

            DATA oTORMModel AS OBJECT INIT NIL
    PROTECTED:

        METHOD Initialize()
        METHOD CheckSource()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor.  
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFLazyLoadCheck

    ::oTORMModel = oTORMModel

Return ( Self )


/* METHOD: Check(  )
    Comprueba si el DBF que ha realizado la carga inicial del LazyLoad es el mismo que el que se esta usando actualmente.
*/
METHOD Check() CLASS TORMDBFLazyLoadCheck

    
    ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[16][1], TORM_INFO_MESSAGE[16][2], {::oTORMModel:TableName()} ) )

    If ::oTORMModel:__oLazyLoad:CanLazyShared() .And.;
       ::oTORMModel:__oSource:cOrigin != ::Path() + ::oTORMModel:TableName()

        ::Initialize()
        Return ( Nil )

    Endif

    If ::oTORMModel:__oLazyLoad:IsPessimist() .And.;
       .Not. ::CheckSource():Success()

        ::Initialize()
        Return ( Nil )  

    Endif

Return ( Nil )

// Group: PROTECTED METHODS

/* METHOD: Initialize(  )
    Inicializa el LazyuLoad que haya cargado.
*/
METHOD Initialize(  ) CLASS TORMDBFLazyLoadCheck

    If ::oTORMModel:__oLazyLoad:CanLazyShared() 

        ::oTORMModel:&(TORM_LAZYSHARED):InitCollection()

    Endif

    ::oTORMModel:Initialize()
    ::oTORMModel:__oSource:cOrigin := ''

Return ( Nil )

/* METHOD: CheckSource(  )
    Comprueba si la tabla origen ha sido modificada
Devuelve:
    oReturn
*/
METHOD CheckSource(  ) CLASS TORMDBFLazyLoadCheck

    Local oReturn := TORMDBF():GetSource( ::Path() + ::oTORMModel:TableName() + '.dbf', ::oTORMModel )

    If oReturn:Success 

        oReturn:Success := oReturn:Return:cOrigin == ::oTORMModel:__oSource:cOrigin .And.;
                           oReturn:Return:tDateTime == ::oTORMModel:__oSource:tDateTime .And.;
                           oReturn:Return:nSize == ::oTORMModel:__oSource:nSize

    Endif

Return ( oReturn )

