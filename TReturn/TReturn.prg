/* CLASS: TReturn
    Utilizada para devolver como valor con valor añadido a las funciones y también para dar estado a las clases.
    También incluye un log como ayuda a la trazabilidad de las clases y funciones. 
    El log internamente se gestiona mediante modelos partiendo de la base del modelo MLogReturn, esto permite poder utilizar otros modelos
    de log que contengan más información. El único requisito es que el modelo ha de tener una DATA cMessage
*/

#include 'hbclass.ch'

CREATE CLASS TReturn

    EXPORTED:
        METHOD New( lSuccessDefault, oLogModel ) CONSTRUCTOR
        METHOD End()

        METHOD Success( lSuccess ) SETGET
        METHOD Return( uReturn )   SETGET
        METHOD Message( cMessage ) SETGET
        METHOD Fail()

        METHOD Log( cLogMessage )  SETGET
        METHOD GetaLogMessage()

        METHOD LogToString()

        METHOD SetLogModel( oLogModel )
        METHOD ArrayLogAssign( aLogMessage )
        METHOD LogAssign( oLogMessage )

    PROTECTED:
        DATA lSuccess    AS LOGICAL   INIT .F.
        DATA uReturn  
        DATA cMessage    AS CHARACTER INIT ''
        DATA aLogMessage AS ARRAY     INIT Array( 0 )
        DATA oLogModel   AS OBJECT    INIT Nil

        METHOD aAdDLog( xLogMessage )

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( lSuccessDefault, oLogModel )
    Constructor

    Parámetros:
        lSuccessDefault - Valor inicial de la variable lSuccess
        oLogModel - Objeto base para el log en caso de ser diferente del standard

Devuelve:
    Self
*/
METHOD New( lSuccessDefault, oLogModel ) CLASS TReturn

    ::lSuccess := lSuccessDefault:Value( .F. )

    If oLogModel != Nil .And.;
       HB_ISOBJECT( oLogModel )

       ::SetLogModel( oLogModel )

    Else

        ::SetLogModel( MLogReturn():New() )

    Endif

Return ( Self )

METHOD End() CLASS TReturn
Return ( Nil )

METHOD Success( lSuccess ) CLASS TReturn

    If lSuccess:NotEmpty()

        ::lSuccess := lSuccess

    Endif

Return ( ::lSuccess )


METHOD Return( uReturn ) CLASS TReturn

    If hb_AParams():NotEmpty()

        ::uReturn := uReturn

    Endif

Return ( ::uReturn )


METHOD Message( cMessage ) CLASS TReturn

    If cMessage:NotEmpty()

        ::cMessage := cMessage

    Endif

Return ( ::cMessage )

METHOD Fail() CLASS TReturn
Return ( !::lSuccess )

/* METHOD: Log( xLogMessage )
    Añade un mensaje al log y devuelve un string con el contedido del log

    Parámetros:
        xLogMessage - Puede ser un mensaje o un objeto de mensaje

Devuelve:
    String
*/
METHOD Log( xLogMessage ) CLASS TReturn

    Local cLogMessage := ''

    ::aAdDLog( xLogMessage )
    aEval( ::aLogMessage, { | mReturn | cLogMessage += mReturn:cMessage + Chr(10) })

Return ( cLogMessage )
    
/* METHOD: aAddLog( xLogMessage )

    Parámetros:
        xLogMessage - Puede ser un mensaje o un objeto de mensaje

*/
METHOD aAdDLog( xLogMessage ) CLASS TReturn

    Local oLogReturn

    If xLogMessage:ClassName() == 'TRETURN'

        ::ArrayLogAssign( xLogMessage:GetaLogMessage() )

    Else

        If !HB_ISARRAY( xLogMessage )

            If HB_ISCHAR( xLogMessage )

                WITH OBJECT oLogReturn := &( ::oLogModel:ClassName())():New()
                    :cMessage := xLogMessage
                END

            ElseIf HB_ISOBJECT( xLogMessage )

                oLogReturn := ::LogAssign( xLogMessage )

            Endif

            xLogMessage := { oLogreturn }

        Endif

        ::ArrayLogAssign( xLogMessage )

    Endif

Return ( Nil )

METHOD ArrayLogAssign( aLogMessage ) CLASS TReturn

    Local oItem

    for each oItem in aLogMessage

        aAdD( ::aLogMessage, ::LogAssign( oItem ) )
        
    next

Return ( Nil )

METHOD LogAssign( oLogMessage ) CLASS TReturn

    Local cDataName
    Local oLogReturn

    If oLogMessage:ClassName() == ::oLogModel:ClassName()

        oLogReturn := oLogMessage

    Else

        oLogReturn := &( ::oLogModel:ClassName())():New()

        for each cDataName in  __objGetValueList( ::oLogModel ):Transpose()[1]

            If __objHasData( oLogMessage, cDataName )

                oLogReturn:&( cDataName ) := oLogMessage:&( cDataName )

            Endif
            
        next

    Endif

Return ( oLogReturn )

METHOD GetaLogMessage() CLASS TReturn
Return ( ::aLogMessage )

METHOD LogToString() CLASS TReturn

    Local MReturn
    Local cLogReturn := ''

    for each mReturn in ::aLogMessage

        If cLogReturn:NotEmpty()

            cLogReturn += Chr(10)

        Endif

        cLogReturn += mReturn:cMessage 
        
    next

Return ( cLogReturn:Alltrim() )

METHOD SetLogModel( oLogModel ) CLASS TReturn

    ::oLogModel := oLogModel

Return ( Nil )