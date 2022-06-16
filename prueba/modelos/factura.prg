#include 'hbclass.ch'
#include 'Validation.ch'

CREATE CLASS Factura FROM TORMModel
  EXPORTED:
    METHOD CreateStructure()
    METHOD Lineas()
    METHOD Cliente()
ENDCLASS

METHOD Lineas() CLASS Factura
    ::HasMany( FacturaLinea():New(), 'NUMERO' )
Return ( Self )

METHOD Cliente() CLASS Factura
    ::HasOne( Cliente():New( ::CODCLI ):Formadepago(), 'CODCLI' )
Return ( Self )

METHOD CreateStructure() CLASS Factura

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NUMERO'
        :cType   := 'N'
        :nLenght := 10
        :cDescription := 'Número de la factura'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'FECHA'
        :cType   := 'D'
        :cDescription := 'Fecha de la factura'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'CODCLI'
        :cType   := 'N'
        :nLenght := 10
        :cDescription := 'Cliente de la factura'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'TOTAL'
        :cType   := 'N'
        :nLenght :=  10
        :nDecimals := 2
        :cDescription := 'Total Factura'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'NUMERO'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

Return ( Nil )

CREATE CLASS FacturaLinea FROM TORMModel
  EXPORTED:
    METHOD CreateStructure()

ENDCLASS

METHOD CreateStructure() CLASS FacturaLinea

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NUMERO'
        :cType   := 'N'
        :nLenght := 10
        :cDescription := 'Número de la factura'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName := 'CONCEPTO'
        :cType := 'C'
        :nLenght := 100
        :cDescription := 'Concepto de la factura'
        :AddFieldtoModel()
    END

    WITH OBJECT TormField():New( Self )
        :cName   := 'CANTIDAD'
        :cType   := 'N'
        :nLenght := 10
        :cDescription := 'Cantidad de la factura'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'NUMERO'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

Return ( Nil )