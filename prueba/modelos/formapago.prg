#include 'hbclass.ch'
#include 'Validation.ch'

CREATE CLASS Formapago FROM TORMModel
  EXPORTED:
    METHOD CreateStructure()
    METHOD DameDefecto()
ENDCLASS

METHOD DameDefecto() CLASS Formapago

    Local oFormapago := Formapago():New()
    Local nDefecto := 0

    oFormapago:Find( .T., 'DEFECTO')
    If oFormapago:Success
        nDefecto := oFormapago:CODIGO
    Endif

    oFormapago:End()

Return ( nDefecto )

METHOD CreateStructure() CLASS Formapago

    WITH OBJECT TORMField():New( Self )
        :cName   := 'CODIGO'
        :cType   := 'N'
        :nLenght := 10
        :cDescription := 'Código de la Forma de pago'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NOMBRE'
        :cType   := 'C'
        :nLenght := 100
        :cDescription := 'Nombre de la Forma de pago'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'TIPOPAGO'
        :cType   := 'N'
        :nLenght := 10
        :cDescription := 'TIpo de Pago'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'DEFECTO'
        :cType   := 'L'
        :cDescription := 'Forma de pago por defecto'
        :AddFieldtoModel()
    END



    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END
    
Return ( Nil )