#include 'hbclass.ch'
#include 'Validation.ch'

CREATE CLASS Cliente FROM TORMModel
  EXPORTED:
    METHOD CreateStructure()
    METHOD Formadepago( )
ENDCLASS

METHOD Formadepago(  ) CLASS Cliente

    ::HasOne( Formapago():New( ::FORMAPAGO ), 'FORMAPAGO' )

Return ( Self )

METHOD CreateStructure() CLASS Cliente

    WITH OBJECT TORMField():New( Self )
        :cName   := 'CODIGO'
        :cType   := 'N'
        :nLenght := 10
        :cDescription := 'Código del Cliente'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NOMBRE'
        :cType   := 'C'
        :nLenght := 100
        :cDescription := 'Nombre del Cliente'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'APELLIDO'
        :cType   := 'C'
        :nLenght := 100
        :cDescription := 'Apellido del Cliente'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'PESO'
        :cType   := 'N'
        :nLenght :=  5
        :nDecimals := 2
        :cDescription := 'Peso'
        :hValid   := { VALID_RANGE => '10,120' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'FORMAPAGO'
        :cType   := 'N'
        :nLenght := 10
        :cDescription := 'Forma de pago'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'NOMBRE'
        :cDescription   := 'Orden por Nombre'
        :AddIndexToModel()
    END

Return ( Nil )