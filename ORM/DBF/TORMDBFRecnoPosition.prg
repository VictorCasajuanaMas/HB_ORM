/* CLASS: TORMDBFRecnoPosition 
    Posiciona el recno del Alias en el InternalDbId del Modelo
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'

CREATE CLASS TORMDBFRecnoPosition FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        
        METHOD ToPosition( cAlias )

    PROTECTED:
        DATA oTORMModel AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFRecnoPosition

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: ToPosition( cAlias )
    Posiciona el registro en sí
    
    Parámetros:
        cAlias - Alias a procesar

Devuelve:
    oReturn
*/
METHOD ToPosition( cAlias ) CLASS TORMDBFRecnoPosition

    Local oReturn := TReturn():New()

    try 

        ( cAlias )->( DbGoTo( ::oTORMModel:GetInternalDbId() ) )
        oReturn:Success := ( cAlias )->( Recno() ) == oTORMModel:GetInternalDbId()

        If oReturn:Fail

            oReturn:Log := '#ORM039 Ocurrió un error en el posicionamiento del registro de la tabla ' + ::oTORMModel:TableName()
    
        Endif
    
        
    catch oError

        oReturn:Success := .F.
        oReturn:Log := '#ORM040 Ocurrió un error en el posicionamiento del registro de la tabla ' + ::oTORMModel:TableName() + hb_eol() + TTryCatchShowerror():New( oError ):ToString()
        
    end

Return ( oReturn )

// Group: PROTECTED METHODS