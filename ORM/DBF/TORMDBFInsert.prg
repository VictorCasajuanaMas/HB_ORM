/* CLASS: TORMDBFInsert 
    Inserta en la tabla varios registros
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFInsert FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Insert( aData )

    PROTECTED:
        DATA oTORMModel AS OBJECT Init Nil

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFInsert

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Insert( aData )
    Inserta datos en la tabla devolviendo el número de registros que se han insertado
    
    Parámetros:
        aData - Array de datos a insertar

Devuelve:
    Numérico
*/


METHOD Insert( aData ) CLASS TORMDBFInsert

    Local nrecordsAdded := 0
    Local hData := hb_Hash()
    Local cAlias := ''

    If HB_ISARRAY( aData )

        If TORMDBFTableExist():New( ::oTORMModel ):Exists( 'dbf' ):Fail()
        
            TORMDBFCreateTable():New( ::oTORMModel ):Create()
            
        Endif
        
        cAlias := TORMDBFOpenTable():New( ::oTORMModel ):Open()
        
        If ::oTORMModel:Success

            for each hData in aData

                if HB_ISHASH( hData ) .And.;
                   TORMDBFDbAppend():New( ::oTORMModel ):Append( cAlias ):Success()

                    If TORMDBFPutHashToAlias():New( cAlias, ::oTORMModel ):Put( hData ):Success()

                        nrecordsAdded++

                    Endif

                    TORMDBFDBUnlock():New( ::oTORMModel ):RUnlock( cAlias )

                Endif
                
            next

            TORMDBFCloseTable():New( ::oTORMModel ):Close( cAlias )

        Endif

    Endif

Return ( nrecordsAdded )

// Group: PROTECTED METHODS  