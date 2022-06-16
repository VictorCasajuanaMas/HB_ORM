#include 'hbclass.ch'
#include 'validation.ch'

// Modelos utilizados en los tests

CREATE CLASS TestDoc FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()
        METHOD Ficha()
        METHOD Ficha2()
        METHOD Ficha_Nombre()
        METHOD AllRelations()
        METHOD Lineas()

END CLASS

METHOD Ficha( ... ) CLASS TestDoc

    ::HasOne( TestFicha():New( ):Select( ... ), 'TESTFICHA' )

Return ( Self )

METHOD Ficha_Nombre() CLASS TestDoc


    ::HasOne( TestFicha():New():Select('NOMBRE'), 'TESTFICHA' )

Return ( Self )

METHOD Ficha2() CLASS TestDoc

    ::HasOne( TestFicha2():New(), 'TESTFICHA2' ) 
Return ( Self )

METHOD Lineas( ) CLASS TestDoc

    ::HasMany( TestDocLin():New(), ::__xFindValue  ) 

Return ( Self )

METHOD AllRelations() CLASS TestDoc
    ::Ficha()
    ::Ficha2()
Return ( Self )

METHOD CreateStructure() CLASS TestDoc


    WITH OBJECT TORMField():New( Self )
        :cName   := 'SERIE'
        :cType   := 'N'
        :nLenght := 4
        :cDescription := 'Serie del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NUMERO'
        :cType   := 'N'
        :nLenght := 6
        :cDescription := 'Número del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'FECHA'
        :cType   := 'D'
        :cDescription := 'Fecha del documento'
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName  := 'TESTFICHA'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código de la ficha'
        :uDefault := Space( 10 )
        :AddFieldtoModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'TESTFICHA2'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código de la segunda ficha'
        :uDefault := Space( 10 )
        :AddFieldtoModel()
    END 

    // Indices

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'STR(SERIE,4)+STR(NUMERO,6)'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'FECHA'
        :cDescription   := 'Fecha'
        :AddIndexToModel()
    END

    // Llaves Foráneas

    WITH OBJECT TORMForeignKey():New( Self )
        :cModel         := 'TestDocLin'
        :cField         := 'STR(SERIE,4)+STR(NUMERO,6)'
        :AddForeignKeyToModel()
    END

Return ( Nil )

CREATE CLASS TestDocLin FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

END CLASS

METHOD CreateStructure() CLASS TestDocLin

    WITH OBJECT TORMField():New( Self )
        :cName   := 'SERIE'
        :cType   := 'N'
        :nLenght := 4
        :cDescription := 'Serie del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NUMERO'
        :cType   := 'N'
        :nLenght := 6
        :cDescription := 'Número del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'ARTICULO'
        :cType   := 'C'
        :nLenght := 20
        :cDescription := 'Artículo del documento'
        :AddFieldtoModel()
    END

    // Indices

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'STR(SERIE,4)+STR(NUMERO,6)'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'ARTICULO'
        :cDescription   := 'Articulo'
        :AddIndexToModel()
    END

Return ( Nil )

CREATE CLASS TestFichaDefault FROM TORMModel

    EXPORTED:
        METHOD SetDefaultData()
        METHOD CreateStructure()

ENDCLASS

METHOD SetDefaultData() CLASS TestFichaDefault

    ::CODIGO := 1
    ::NOMBRE := 'por defecto'

Return ( Nil )

METHOD CreateStructure() CLASS TestFichaDefault

    // Datos

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

Return  ( Nil )




CREATE CLASS TestFicha FROM TORMModel

    EXPORTED:    
        METHOD CreateStructure()

ENDCLASS



METHOD CreateStructure() CLASS TestFicha

    // Datos

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

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE1'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE2'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE3'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE4'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE5'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE6'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE7'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE8'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE9'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE10'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE11'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE12'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE13'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE14'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE15'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE16'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE17'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE18'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE19'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE20'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
        :AddFieldToModel()
    END 
    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE21'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :hValid := { VALID_LENGHT => 100 }
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

Return ( Nil )

CREATE CLASS TestFicha2 FROM TORMModel

    EXPORTED:    
        METHOD CreateStructure()

ENDCLASS

METHOD CreateStructure() CLASS TestFicha2

    // Datos

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

Return ( Nil )


CREATE CLASS ModeloSinIndices FROM TORMModel

    EXPORTED:    
        METHOD CreateStructure()

ENDCLASS

METHOD CreateStructure() CLASS ModeloSinIndices

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre de la ficha'
        :uDefault := Space( 10 )
        :AddFieldToModel()
    END 

Return ( Nil )



CREATE CLASS TestPagos FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

ENDCLASS 

METHOD CreateStructure() class TestPagos
    WITH OBJECT TORMField():New( Self )
        :cName   := 'SERIE'
        :cType   := 'N'
        :nLenght := 4
        :cDescription := 'Serie del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NUMERO'
        :cType   := 'N'
        :nLenght := 6
        :cDescription := 'Número del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName  := 'FECHA_VEN'
        :cType  := 'D'
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName   := 'CONTABI'
        :cType   := 'C'
        :nLenght := 1
        :AddFieldToModel()
    END 

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'STR(SERIE,4)+STR(NUMERO,6)'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'FECHA_VEN'
        :cDescription   := 'Fecha de vencimiento'
        :AddIndexToModel()
    END

Return( Nil )

CREATE CLASS Articulo FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()
        METHOD StockAlmacen()
        METHOD Tarifa()

ENDCLASS 

METHOD StockAlmacen( cAlmacen ) CLASS Articulo

    ::HasOne( Stock():New( ):Select('ALMACEN AS ALM' + cAlmacen, 'CANTIDAD AS STK' + cAlmacen), TIndexMultiple():New( { 'CODIGO' => { '', 10, .t. }, 'ALMACEN' => { cAlmacen, 10 } } ) , 'alm'+cAlmacen ) 

Return ( Self )

METHOD Tarifa( ) CLASS Articulo

    ::HasMany( Tarifa():New(), 'CODIGO')

Return ( Self )

METHOD CreateStructure() CLASS Articulo

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código del articulo'
        :AddFieldToModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre del Artículo'
        :AddFieldToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :AddIndexToModel()
    END

    WITH OBJECT TORMForeignKey():New( Self )
        :cModel         := 'Stock'
        :cField         := 'ARTICULO'
        :AddForeignKeyToModel()
    END

Return ( Nil )

CREATE CLASS Tarifa FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

ENDCLASS

METHOD CreateStructure( ) CLASS Tarifa

    WITH OBJECT TORMField():New( Self )
        :cName  := 'ARTICULO'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código del Artículo'
        :AddFieldToModel()
    END

    WITH OBJECT TormField():New( Self )
        :cName := 'PRECIO'
        :cType := 'N'
        :nLenght := 10
        :nDecimals := 2
        :cDescription := 'Precio del Artículo'
        :AddFieldToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'ARTICULO'
        :lIsPrimaryKey  := .T.
        :AddIndexToModel()
    END

Return ( Nil )

CREATE CLASS Stock FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

ENDCLASS 

METHOD CreateStructure() CLASS  Stock

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código del articulo'
        :AddFieldToModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName  := 'ALMACEN'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código del Almacén'
        :AddFieldToModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName        := 'CANTIDAD'
        :cType        := 'N'
        :nLenght      := 10
        :nDecimals    := 2
        :cDescription := 'Stock articulo'
        :AddFieldToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO+ALMACEN'
        :lIsPrimaryKey  := .T.
        :AddIndexToModel()
    END

Return ( Nil )

CREATE CLASS AutoInc FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

ENDCLASS 

METHOD CreateStructure() CLASS  AutoInc

    WITH OBJECT TORMField():New( Self )
        :cName  := 'ID'
        :cType  := '+'
        :nLenght:= 10
        :AddFieldToModel()
    END

Return ( Nil )

CREATE CLASS TestFichaLazy FROM TORMModel

    EXPORTED:    
        CLASSDATA __oLazyLoadShared AS OBJECT 
        METHOD CreateStructure()

ENDCLASS



METHOD CreateStructure() CLASS TestFichaLazy

    // Datos

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

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :lIsUnique      := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

Return ( Nil )

CREATE CLASS Cliente FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()
        METHOD Formapago()

ENDCLASS

METHOD FormaPago() CLASS Cliente
    ::HasOne( FormaPago():New( ::CODFPAG ):TipoPago(), 'CODFPAG')
Return ( Self )

METHOD CreateStructure() CLASS Cliente

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
        :cName  := 'CODFPAG'
        :cType  := 'N'
        :nLenght:= 10
        :cDescription := 'Forma de Pago'
        :AddFieldToModel()
    END 

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :lIsUnique      := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

Return ( Nil )

CREATE CLASS FormaPago FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()
        METHOD TipoPago()

ENDCLASS

METHOD TipoPago() CLASS FormaPago
    ::HasOne( TipoPago():New( ::CODTPAG ), 'CODTPAG')
Return ( Self )

METHOD CreateStructure() CLASS FormaPago

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'N'
        :nLenght:= 10
        :cDescription := 'Código de la ficha'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE'
        :cType  := 'C'
        :nLenght:= 50
        :cDescription := 'Nombre de la forma de pago'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODTPAG'
        :cType  := 'N'
        :nLenght:= 10
        :cDescription := 'Tipo de Pago'
        :AddFieldToModel()
    END 

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :lIsUnique      := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

Return ( Nil )

CREATE CLASS TipoPago FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

ENDCLASS

METHOD CreateStructure() CLASS TipoPago

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'N'
        :nLenght:= 10
        :cDescription := 'Código de la ficha'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE'
        :cType  := 'C'
        :nLenght:= 50
        :cDescription := 'Nombre del tipo de pago'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :lIsUnique      := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

Return ( Nil )

CREATE CLASS Ficha FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

ENDCLASS

METHOD CreateStructure() CLASS Ficha

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'N'
        :nLenght:= 10
        :cDescription := 'Código de la ficha'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE'
        :cType  := 'C'
        :nLenght:= 50
        :cDescription := 'Nombre del tipo de pago'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :lIsUnique      := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

    WITH OBJECT TORMForeignKey():New( Self )
        :cModel         := 'FichaDir'
        :cField         := 'CODIGO'
        :AddForeignKeyToModel()
    END

Return ( Nil )

CREATE CLASS FichaDir FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

ENDCLASS

METHOD CreateStructure() CLASS FichaDir

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'N'
        :nLenght:= 10
        :cDescription := 'Código de la ficha'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMField():New( Self )
        :cName  := 'DIRECCION'
        :cType  := 'C'
        :nLenght:= 50
        :cDescription := 'Dirección'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldToModel()
    END 

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :lIsUnique      := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

Return ( Nil )