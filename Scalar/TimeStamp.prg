/* CLASS: Scalar TimeStamp
          Clase que contiene los métodos para el tipo de dato TimeStamp
*/
#INCLUDE 'hbclass.ch'

CREATE CLASS TimeStamp INHERIT HBScalar FUNCTION HBTimeStamp

   METHOD Date()
   METHOD Time()
   METHOD Year()
   METHOD Month()
   METHOD Day()
   METHOD Hour()
   METHOD Minute()
   METHOD Sec()
   METHOD Str()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: Date()
    Método que devuelve la fecha del dato

Devuelve:
    Date
*/
METHOD Date() CLASS TimeStamp
RETURN hb_TToD( Self,, "" )

/* METHOD: Time()
    Método que devuelve la hora del dato

Devuelve:
   String    
*/
METHOD Time() CLASS TimeStamp
RETURN hb_TToC( Self, "", "hh:mm:ss" )

/* METHOD: Year()
    Método que devuelve el año del dato

Devuelve:
   Numérico    
*/
METHOD Year() CLASS TimeStamp
RETURN Year( Self )

/* METHOD: Month()
    Método que devuelve el mes del dato

Devuelve:
    Numérico
*/
METHOD Month() CLASS TimeStamp
RETURN Month( Self )

/* METHOD: Day()
    Método que devuelve el día del dato

Devuelve:
   Numérico    
*/
METHOD Day() CLASS TimeStamp
RETURN Day( Self )

/* METHOD: Hour()
    Método que devuelve la hora del dato

Devuelve:
   Numérico    
*/
METHOD Hour() CLASS TimeStamp
RETURN hb_Hour( Self )

/* METHOD: Minute()
    Método que devuelve el minuto del dato

Devuelve:
   Numérico
*/
METHOD Minute() CLASS TimeStamp
RETURN hb_Minute( Self )

/* METHOD: Sec()
    Método Devuelve los segundos del dato

Devuelve:
   Numérico    
*/
METHOD Sec() CLASS TimeStamp
RETURN hb_Sec( Self )

/* METHOD Str()
    Devuelve el timestamp en string, por temas de compatibilización
Devuelve:
    String    
*/
METHOD Str() CLASS TimeStamp
Return hb_TSToStr( Self )