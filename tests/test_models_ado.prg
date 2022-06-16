#include 'hbclass.ch'
#include 'validation.ch'
#include 'TORM.ch'

// Pendiente de revisión más profundamente

CREATE CLASS FichaAdo FROM TORMModel

    DATA __DataSource          AS CHARACTER INIT TORM_DATASOURCE_ADODBF
    DATA __cName               AS CHARACTER INIT 'FichaAdo' READONLY

    EXPORTED:    
        METHOD CreateStructure()

ENDCLASS



METHOD CreateStructure() CLASS FichaAdo

    // Datos
    WITH OBJECT TORMField():New( Self )
        :cName  := 'ID'
        :cType  := '+'
        :cDescription := 'Identificador único'
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código de la ficha'
        :uDefault := Space( 10 )
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NACIMIENTO'
        :cType  := 'D'
        :cDescription := 'Fecha de nacimiento'
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CASADO'
        :cType  := 'L'
        :cDescription := 'Casado'
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName   := 'PESO'
        :cType   := 'N'
        :nLenght := 3
        :cDescription := 'Peso en Kg.'
        :hValid  := { VALID_RANGE => '10,120'}
        :AddFieldToModel()
    END 


    // Indices

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :lIsUnique      := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'NOMBRE'
        :cDescription   := 'Nombre de la ficha'
        :AddIndexToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'ID'
        :cDescription   := 'Identificador único'
        :AddIndexToModel()
    END

Return ( Nil )