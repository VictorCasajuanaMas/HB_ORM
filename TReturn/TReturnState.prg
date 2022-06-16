/* CLASS: TReturnState 
    Se encarga de darles un estado directo a las clases que tienen un objeto TReturn denominado __oReturn mediante el acceso directo a su estado
*/
#include 'hbclass.ch'

CREATE CLASS TReturnState

    EXPORTED:
        METHOD Success()     INLINE ::__oReturn:Success
        METHOD Fail()        INLINE ::__oReturn:Fail
        METHOD LogToString() INLINE ::__oReturn:LogToString()

ENDCLASS