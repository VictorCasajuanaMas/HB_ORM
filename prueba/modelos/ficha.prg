#include 'hbclass.ch'
#include 'Validation.ch'

CREATE CLASS Ficha FROM TORMModel
  EXPORTED:
    METHOD CreateStructure()
ENDCLASS

METHOD CreateStructure() CLASS Ficha

    WITH OBJECT TORMField():New( Self )
        :cName   := 'CODIGO'
        :cType   := 'N'
        :nLenght := 10
        :cDescription := 'Código de la Ficha'
        :hValid   := { ;
                        VALID_REQUIRED => 'si',;
                        VALID_MIN => 0 ;
                    }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NOMBRE'
        :cType   := 'C'
        :nLenght := 100
        :cDescription := 'Nombre del Ficha'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'EMAIL'
        :cType   := 'C'
        :nLenght := 255
        :cDescription := 'Email del Ficha'
        :hValid   := { ;
                            VALID_EMAIL => 'si';
                    }
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

Return ( Nil )