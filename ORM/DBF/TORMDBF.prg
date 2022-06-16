/* CLASS: TORMDBF
          Se encarga de mantener el entorno para trabajar con los DBF

*/


#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBF

    EXPORTED:
        METHOD New() CONSTRUCTOR
        METHOD Path()
        METHOD SetPath( cPath )
        METHOD GetSource( cFile, oTORMModel )

    PROTECTED:
        CLASSDATA cPath AS CHARACTER INIT ''

ENDCLASS

/* METHOD: New( )
    Constructor.

Devuelve:
    Self
*/
METHOD New() CLASS TORMDBF

    REQUEST DBFCDX
    RDDSETDEFAULT ("DBFCDX")
    Set( _SET_DELETED, 'ON' )
    
Return ( Self )

/* METHOD: Path()
    Devuelve la ruta del fichero a Abrir. Este método se debe sobreescribir mediante OVERRIDE O __ClsModMsg() para adaptarlo al entorno que se desee
    También se puede modificar para llamar a una función externa pasando el parámetro Self

Devuelve:
    Character
*/
METHOD Path(  ) CLASS TORMDBF

    If ::cPath:Empty() 

        Return ( PathOfFile( Self:oTORMModel ) )

    Else

        Return ( ::cPath )

    Endif

/* METHOD: GetSource(  )
    Devuelve un objeto mSource con la información necesaria del origen de datos
    Nota: Este método está pensado para llamaerse como Singleton
    
    Parámetros:
        oTORMModel - Modelo
        cFile      - Fichero origen

Devuelve:
    oReturn
*/
METHOD GetSource( cFile, oTORMModel ) CLASS TORMDBF

    Local oReturn := TReturn():New()
    Local oError  := Nil
    Local oSource := mSource():New()


    oReturn:Success := .T.
    oSource:cOrigin := cFile

    try 
        
        oTORMModel:LogWrite( hb_StrReplace( TORM_INFO_MESSAGE[1][1], TORM_INFO_MESSAGE[1][2] , {cFile} ) )
        If .Not. hb_FGetDateTime( cFile , @oSource:tDateTime )
 
            oReturn:Success := .F.
            oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[56][1], TORM_ERROR_MESSAGE[56][2] ,{ cFile } ) )
 
        Endif

    catch oError

        oReturn:Success := .F.
        oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[57][1], TORM_ERROR_MESSAGE[57][2], { cFile, TTryCatchShowerror():New( oError ):ToString() } ))
           
    end

    try 

        oTORMModel:LogWrite( hb_StrReplace( TORM_INFO_MESSAGE[2][1], TORM_INFO_MESSAGE[2][2], {cFile} ) )
        oTORMModel:__oSource:nSize := hb_FSize( cFile )
           
    catch oError

        oReturn:Success := .F.
        oTORMModel:LogWrite( oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[58][1], TORM_ERROR_MESSAGE[58][2], {cFile ,TTryCatchShowerror():New( oError ):ToString() } ) )
           
    end

    oReturn:Return := oSource

Return ( oReturn )


// Group: PROTECTED METHODS

/* METHOD: SetPath( cPath )
    Asigna el path, se utiliza para saltarse el path devuelto por la función path
    
    Parámetros:
        cPath - Path a asignar
*/
METHOD SetPath( cPath ) CLASS TORMDBF

    If HB_ISCHAR( cPath )

        ::cPath := cPath

    Endif

Return ( Nil )

