// Clase que se encarga de gestionar un fichero de log
// TODO: Co

#include 'hbclass.ch'

CREATE CLASS TLog
    EXPORTED:
        DATA __cFile AS CHARACTER INIT 'log.log'

        METHOD New() Constructor
        METHOD LogActivate()
        METHOD LogGlobalActivate()
        METHOD LogWrite( cLog )
        METHOD LogDelete()

    PROTECTED:

        CLASSDATA __lLogGlobalActivated AS LOGICAL INIT .F.

        DATA __lLogActivated AS LOGICAL INIT .F.

        METHOD LogIsActivated()
        METHOD LogGlobalIsActivated()
    
ENDCLASS

METHOD New() CLASS TLog
Return ( Self )

METHOD LogDelete() CLASS TLog

    fErase( ::__cFile )

Return ( Nil )

METHOD LogWrite( cLog ) CLASS TLog

    Local hFile   := Nil
    Local cBuffer := ''

    If ::LogIsActivated .Or.;
       ::LogGlobalIsActivated

        If .Not. File( ::__cFile )

            hFile := fCreate( ::__cFile, 0 )

        Else

            hFile := fOpen( ::__cFile, 2 )
            FSeek( hFile, 0, 2)

        Endif

        cBuffer := Date():Str() + ' ' + Time() + ' ' + cLog:Alltrim() + hb_eol()
        cBuffer := cBuffer:Alltrim()

        fWrite( hFile, cBuffer )

        fClose( hFile )

    Endif

Return ( Nil )

METHOD LogActivate()

    ::__lLogActivated := .T.

Return ( Nil )

METHOD LogIsActivated() CLASS TLog
Return ( ::__lLogActivated )    

METHOD LogGlobalActivate()

    ::__lLogGlobalActivated := .T.

Return ( Nil )

METHOD LogGlobalIsActivated() CLASS TLog
Return ( ::__lLogGlobalActivated )    

