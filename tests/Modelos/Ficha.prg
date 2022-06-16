#include 'hbclass.ch'

CREATE CLASS Ficha FROM TORMModel

    EXPORTED:    
        METHOD CreateStructure()

ENDCLASS

METHOD CreateStructure() CLASS Ficha

    // Datos

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código de la ficha'
        :uDefault := Space( 10 )
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
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

Return ( Nil )
