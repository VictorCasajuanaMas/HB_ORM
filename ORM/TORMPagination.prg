/* CLASS: TORMPagination 
    Se encarga de gestionar la paginación
*/
#include 'hbclass.ch'


CREATE CLASS TORMPagination

    EXPORTED:

        DATA oLastPageNumber   AS OBJECT  INIT Nil
        
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD GoTop() 
        METHOD GoBottom()
        METHOD GetActualPageNumber()
        METHOD GetLastPageNumber()
        METHOD SetActualPageNumber()
        METHOD InitLastPageNumber()
        METHOD RecCount()
        METHOD NextPage()
        METHOD PrevPage()
        METHOD SetRowsxPage()
        METHOD FirstRowOfPage()
        METHOD Init()
        METHOD Refresh()

    PROTECTED:
        DATA oTORMModel        AS OBJECT  INIT Nil
        DATA __oQuery          AS OBJECT  INIT Nil
        DATA oLastPageNumber   AS OBJECT  INIT Nil
        DATA nActualPageNumber AS NUMERIC INIT 0
        DATA nRowsxPage        AS NUMERIC INIT 100

        METHOD GetTotalPages(  )
        METHOD SaveQuery()
        METHOD RestoreQuery()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se le inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMPagination

    ::oTORMModel      := oTORMModel
    ::oLastPageNumber := TORMLastPageNumber():New()

Return ( Self )

/* METHOD: SetActualPageNumber( nPageNumber )
    Asigna el número de página actual
    
    Parámetros:
        nPageNumbert - Número de página a asignar

Devuelve:
    
*/
METHOD SetActualPageNumber( nPageNumber ) CLASS TORMPagination

    ::nActualPageNumber := nPageNumber

Return ( Nil )


/* METHOD: InitLastPageNumber()
    Fuerza a recalcular el último número de página

Devuelve:
    
*/
METHOD InitLastPageNumber(  ) CLASS TORMPagination

    ::nActualPageNumber := nPageNumber

Return ( Nil )



/* METHOD: GoTop(  )
    Se desplaza al primer registro de la primera página del query
*/
METHOD GoTop(  ) CLASS TORMPagination

    ::SetActualPageNumber( 1 )
    ::SaveQuery()
    ::oTORMModel:Take( ::nRowsxPage ):Get()
    ::RestoreQuery()

Return ( Nil )


/* METHOD: GoBottom(  )
    Se desplaza al último registro de la última página del query
*/
METHOD GoBottom(  ) CLASS TORMPagination

    Local nRecCount := ::RecCount()
    ::SetActualPageNumber( ::GetTotalPages( nRecCount ) )
    ::oLastPageNumber:LastPageNumber := ::nActualPageNumber
    ::SaveQuery()
    ::oTORMModel:OffSet( ::FirstRowOfPage() ):Get()
    ::RestoreQuery()

Return ( Nil )

/* METHOD: SetRowsxPage( nRowsxPage )
    Asigna el número de registros por página
    
    Parámetros:
        nRowsxPage - Nº de registros por página a asignar
*/
METHOD SetRowsxPage( nRowsxPage ) CLASS TORMPagination

    ::nRowsxPage := nRowsxPage

Return ( Nil )

/* METHOD: GetActualPageNumber(  )
    Devuelve la página actual de la paginación

Devuelve:
    Numérico
*/
METHOD GetActualPageNumber(  ) CLASS TORMPagination
Return ( ::nActualPageNumber )

/* METHOD: GetLastPageNumber(  )
    Devuelve el número de la última página, en caso de que sea Nil se ejecuta la consulta
    
    Parámetros:
        

Devuelve:
    Numérico
*/
METHOD GetLastPageNumber(  ) CLASS TORMPagination

    If .Not. ::oLastPageNumber:IsLoaded()

        ::oLastPageNumber:LastPageNumber := ::GetTotalPages( ::RecCount() )

    Endif

Return ( ::oLastPageNumber:LastPageNumber )

/* METHOD: RecCount(  )
    Devuelve el número de registros
    
Devuelve:
    Numérico
*/
METHOD RecCount(  ) CLASS TORMPagination

    Local nNumberofRecords := 0

    If ::oTORMModel:__oQuery:HasWhere()

        nNumberofRecords := ::oTORMModel:Count()

    Else

        nNumberofRecords := ::oTORMModel:RecCount()

    Endif

Return ( nNumberofRecords )


/* METHOD: NextPage(  )
    Salta a la siguiente página
*/
METHOD NextPage(  ) CLASS TORMPagination

    ::GetLastPageNumber()

    If ::nActualPageNumber < ::oLastPageNumber:LastPageNumber

        ::SetActualPageNumber( ::nActualPageNumber + 1 )  
        ::SaveQuery()
        ::oTORMModel:OffSet( ::FirstRowOfPage() );
                    :Take( ::nRowsxPage );
                    :Get()
        ::RestoreQuery()

    Endif

Return ( Nil )

/* METHOD: PrevPage(  )
    Retrocede una página
*/
METHOD PrevPage(  ) CLASS TORMPagination

    If ::nActualPageNumber > 1

        ::SetActualPageNumber( ::nActualPageNumber -1 )
        ::SaveQuery()
        ::oTORMModel:OffSet( ::FirstRowOfPage() );
                    :Take( ::nRowsxPage );
                    :Get()
        ::RestoreQuery()

    Endif

Return ( Nil )

/* METHOD: Init(  )
    Inicializa los valores de la paginación
    
    Parámetros:
        

Devuelve:
    
*/
METHOD Init(  ) CLASS TORMPagination

    ::oLastPageNumber:Init()
    ::SetActualPageNumber( 0 )

Return ( Nil )

/* METHOD: Refresh(  )
    Refresca los datos de la página actual
*/
METHOD Refresh(  ) CLASS TORMPagination

    ::SaveQuery()
    ::oTORMModel:OffSet( ::FirstRowOfPage() );
                :Take( ::nRowsxPage );
                :Get()
    ::RestoreQuery()

Return ( Nil )

// Group: PROTECTED METHODS 

/* METHOD: GetTotalPages( nRecCount )
    Devuelve el número total de páginas que tiene la tabla según la paginación
    
    Parámetros:

        nRecCount - Número de registros en la tabla

Devuelve:
    Numérico
*/
METHOD GetTotalPages( nRecCount  ) CLASS TORMPagination

    Local nTotalPages := nRecCount / ::nRowsxPage

    If nTotalPages % 1 != 0

        nTotalPages := nTotalPages:Int() + 1

    Endif

Return ( nTotalPages )

/* METHOD: FirstRowofPage(  )
    Devuelve el primer registro de la página en relación a todos los registros de la consulta
    
    Parámetros:
        

Devuelve:
    Numérico
*/
METHOD FirstRowofPage(  ) CLASS TORMPagination
Return ( ( ( ::nActualPageNumber -1 ) * ::nRowsxPage ) + 1 )

/* METHOD: SaveQuery(  )
    Guarda el Query actual del modelo
*/
METHOD SaveQuery(  ) CLASS TORMPagination

    ::__oQuery := __objClone( ::oTORMModel:__oQuery )

Return ( Nil )

/* METHOD: RestoreQuery(  )
    Restaura el query previamente guardado
*/
METHOD RestoreQuery(  ) CLASS TORMPagination

    ::oTORMModel:__oQuery := __objClone( ::__oQuery )

Return ( Nil )