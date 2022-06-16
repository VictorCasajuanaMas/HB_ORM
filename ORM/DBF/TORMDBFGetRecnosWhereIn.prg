/* CLASS: TORMDBFGetRecnosWhereIn 
    Devuelve un array con los recnos correspondientes al condicional WhereIn
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFGetRecnosWhereIn

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Get( cAlias ) 

    PROTECTED:
        DATA oTORMModel AS OBJECT    INIT Nil
        DATA cAlias     AS CHARACTER INIT ''

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor.  
   Parametros:
     oTORMModel - Se le inyecta el modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFGetRecnosWhereIn

    ::oTOrmmodel := oTORMModel

Return ( Self )

// Group: PROTECTED METHODS

/* METHOD: Get( )
    Devuelve un array con los números de recnos a procesar

Devuelve:
    Array
*/
METHOD Get( cAlias) CLASS TORMDBFGetRecnosWhereIn

    Local aRecnos    := Array( 0 )
    Local rSeek      := Nil
    Local xFindValue := Nil
    Local oError     := Nil

    ::cAlias := cAlias

    try 

        if ::oTORMModel:__oQuery:oWhereInConditions:lHasCondition .And.;
           ::oTORMModel:__oIndexes:HasIndex( ::oTORMModel:__oQuery:oWhereInConditions:cField:Upper() ) // De momento el WhereIn solo funciona si hay índice, y creo que sería mejor así...

           ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[12][1], TORM_INFO_MESSAGE[12][2], {::oTORMModel:TableName(), ::oTORMModel:__oQuery:oWhereInConditions:aIn:Str() } ) )

            for each xFindValue in ::oTORMModel:__oQuery:oWhereInConditions:aIn

                If TORMDBFItemsToTake():New( ::oTORMModel):Get( aRecnos:Len() )

                    rSeek := TORMDBFSeek():New( ::oTORMModel ):Seek( MDBFSEek():New( ::cAlias, xFindValue ) )

                    If rSeek:Success()

                        aAdD( aRecnos, ( ::cAlias )->( Recno() ) )

                    Endif

                Endif
                
            next

        Endif
        
    catch oError

        ::oTORMModel:__oReturn:Success := .F.
        ::oTORMModel:LogWrite( ::oTORMModel:__oReturn:Log := hb_StrReplace( TORM_ERROR_MESSAGE[24][1], TORM_ERROR_MESSAGE[24][2], {  TTryCatchShowerror():New( oError ):ToString() } ) )
        
    end

Return ( aRecnos )