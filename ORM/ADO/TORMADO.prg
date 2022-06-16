/* CLASS: TORMADO 
    Se encarga de gestionar las conexiones ADO
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'

CREATE CLASS TORMADO

    EXPORTED:
        METHOD New( oTORMMOdel ) CONSTRUCTOR
        METHOD Connect()
        METHOD Open()
        METHOD Path()
        METHOD End()
        METHOD GetRecordSet()

    PROTECTED:
        DATA oTORMModel  AS OBJECT INIT Nil
        DATA oConnection AS OBJECT INIT Nil
        DATA oRecordSet  AS OBJECT INIT Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMMOdel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMMOdel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMMOdel ) CLASS TORMADO

    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: End(  )
    Cierra las conexiones y recordsets activos
*/
METHOD End(  ) CLASS TORMADO

    try 
        
        ::oRecordSet:Close()
        ::oConnection:Close()
        
    end

Return ( Nil )

/* METHOD: Connect(  )
    Realiza la conexión a la base de datos

Devuelve:
    Modelo
*/
METHOD Connect(  ) CLASS TORMADO

    Local oError := Nil

    try 

        ::oConnection := win_oleCreateObject( "ADODB.Connection" )
        ::oConnection:Open('Provider=Microsoft.Jet.OLEDB.4.0;Data Source="' + ::Path() + '";Extended Properties=dBASE IV;User ID=Admin;Password=;')
        
    catch oError

        ::oTORMModel:Success := .F.
        ::oTORMModel:__oReturn:Log := TTryCatchShowerror():New( oError ):ToString()
        
    end

Return ( ::oTORMModel )

/* METHOD: Path()
    Devuelve la ruta donde se encuentran los ficheros de la base de datos. Este método se debe sobreescribir mediante OVERRIDE O __ClsModMsg() para adaptarlo al entorno que se desee

Devuelve:
    Character
*/
METHOD Path( ) CLASS TORMADO
Return ( '' )

/* METHOD: Open( cQuery )
    Ejecuta una consulta que devuelve un RecordSet
    
    Parámetros:
        cQuery - Cadena SQL a ejecutar

Devuelve:
    Objeto RecordSet
*/
METHOD Open( cQuery ) CLASS TORMADO

    Local oError

    try 

        
        ::oRecordSet := win_oleCreateObject( "ADODB.Recordset" )
        ::oRecordSet:Open( cQuery, ::oConnection )
        
    catch oError

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:__oReturn:Log := TTryCatchShowerror():New( oError ):ToString()
        
    end

Return ( ::oRecordSet )

/* METHOD: GetRecordSet(  )
    Devuelve el recordset de la última consulta
    
Devuelve:
    RecordSet
*/
METHOD GetRecordSet(  ) CLASS TORMADO

Return ( ::oRecordSet )



// Group: PROTECTED METHODS