#include 'hbclass.ch'
#include "xhbcls.ch"
Function Main()
    
    Local cInitTime := Time()
    
    SET DATE BRITISH
    SET CENTURY ON

    ?'Inicio:' + cInitTime


    OverRideMethods()

    oSuite := TestSuite():New()
    oRunner := TestTestRunner():New()
    oSuite:setCategories( {'TODOS'} ) 

    oTestFicha := TestFicha():New()

    oSuite:addTest( Test_ORM_DBF():New() )
    oSuite:addTest( Test_ORM_ADO():New() )
    oSuite:addTest( Test_ORM():New() )
    oSuite:addTest( Test_Valid():New() )
    oSuite:addTest( Test_ORM_LazyLoad():New() )
    oSuite:addTest( Test_IndexMultiple():New() )

    oRunner:Run( oSuite )
    oSuite:End()

    ?'Fin:' + Time()
    ?'Duracion:' + ElapTime( cInitTime, Time() )
    
Return ( Nil )

Static Function OverRideMethods()

   TORMDBF():SetPath( '.\db\' )
   OVERRIDE METHOD Path  IN CLASS TORMADO WITH Ruta

Return ( Nil )

Function Ruta()
Return ( '.\db\' )