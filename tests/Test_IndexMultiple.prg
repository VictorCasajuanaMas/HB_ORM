/* CLASS: Test_TIndexMultiple
    
*/
#include 'hbclass.ch'
#include 'validation.ch'
#include 'TORM.ch'

CREATE CLASS Test_IndexMultiple FROM TestCase

    EXPORTED:
        DATA aCategories AS ARRAY INIT {'TODOS'}

        METHOD Test_GetDatas()
        METHOD Test_GetDatasRaw()
        METHOD Test_Get()
        METHOD Test_ToSeek()
        METHOD Test_IsEmpty()
        METHOD Test_GetRaw()

ENDCLASS 

METHOD Test_GetDatas() CLASS Test_IndexMultiple

    Local oIndexMultiple := Nil
    
    oIndexMultiple := TIndexMultiple():New( { 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:Arrayequals( { 'SERIE','NUMERO' }, oIndexMultiple:GetDatas())

    oIndexMultiple := TIndexMultiple():New( { 'DOCUMENTO' => { 'FACCCAB',10 }, 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:Arrayequals( { 'DOCUMENTO','SERIE','NUMERO' }, oIndexMultiple:GetDatas())

Return ( Nil )

METHOD Test_GetDatasRaw() CLASS Test_IndexMultiple

    Local oIndexMultiple := Nil
    
    oIndexMultiple := TIndexMultiple():New( { 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:Arrayequals( { '2001',' 12345' }, oIndexMultiple:GetDatasRaw())

    oIndexMultiple := TIndexMultiple():New( { 'DOCUMENTO' => { 'FACCCAB',10 }, 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:Arrayequals( { 'FACCCAB   ', '2001',' 12345' }, oIndexMultiple:GetDatasRaw())

Return ( Nil )

METHOD Test_Get() CLASS Test_IndexMultiple

    Local oIndexMultiple := Nil
    
    oIndexMultiple := TIndexMultiple():New( { 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:equals( 2001, oIndexMultiple:Get( 'SERIE') )
    ::assert:equals( 12345, oIndexMultiple:Get( 'NUMERO'))
    ::assert:null( oIndexMultiple:Get( 'NADA') )

    oIndexMultiple := TIndexMultiple():New( { 'DOCUMENTO' => { 'FACCCAB',10 }, 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:equals( 2001, oIndexMultiple:Get( 'SERIE') )
    ::assert:equals( 12345, oIndexMultiple:Get( 'NUMERO'))
    ::assert:equals( 'FACCCAB', oIndexMultiple:Get( 'DOCUMENTO'))

Return ( Nil )

METHOD Test_ToSeek() CLASS Test_IndexMultiple

    Local oIndexMultiple := Nil
    
    oIndexMultiple := TIndexMultiple():New( { 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:equals( '2001 12345', oIndexMultiple:ToSeek() )

    oIndexMultiple := TIndexMultiple():New( { 'DOCUMENTO' => { 'FACCCAB',10 }, 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:equals( 'FACCCAB   2001 12345', oIndexMultiple:ToSeek() )

Return ( Nil )

METHOD Test_IsEmpty() CLASS Test_IndexMultiple

    Local oIndexMultiple := Nil
    
    oIndexMultiple := TIndexMultiple():New( { 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:False( oIndexMultiple:Empty() )
    oIndexMultiple := TIndexMultiple():New( { 'SERIE' => { , 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:False( oIndexMultiple:Empty() )
    oIndexMultiple := TIndexMultiple():New( { 'SERIE' => { , 4 }, 'NUMERO' => { , 6 } })
    ::assert:True( oIndexMultiple:Empty() )

Return ( Nil )

METHOD Test_GetRaw() CLASS Test_IndexMultiple

    Local oIndexMultiple := Nil
    
    oIndexMultiple := TIndexMultiple():New( { 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:equals( 'STR(SERIE,4)+STR(NUMERO,6)', oIndexMultiple:GetRaw() )

    oIndexMultiple := TIndexMultiple():New( { 'DOCUMENTO' => { 'FACCCAB',10 }, 'SERIE' => { 2001, 4 }, 'NUMERO' => { 12345, 6 } })
    ::assert:equals( 'DOCUMENTO+STR(SERIE,4)+STR(NUMERO,6)', oIndexMultiple:GetRaw() )

Return ( Nil )