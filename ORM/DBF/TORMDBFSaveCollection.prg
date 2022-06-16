/* CLASS: TORMDBFSaveCollection 
    Guarda el contenido de la colección del modelo en el caso de que se haya modificado.
*/
#include 'hbclass.ch'
#include 'TORM.ch'

CREATE CLASS TORMDBFSaveCollection

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR
        METHOD Save( lNewData )

            DATA oTORMModel AS OBJECT INIT Nil
    PROTECTED:

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor.  
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFSaveCollection

    ::oTORMMOdel := oTORMModel

Return ( Self )


/* METHOD: Save( lNewData )
    Guarda la colección del modelo en el caso de que se haya modificado.
    
    Parámetros:

        lNewData - Se activa cuando ha de añadirse la data independientemente de si se ha modificado o no

Devuelve:
    Objeto
*/
METHOD Save( lNewData ) CLASS TORMDBFSaveCollection

    Local cAlias := TORMDBFOpenProcess():New( ::oTORMModel ):OpenProcess()

    lNewData := lNewData:Value( .F. )
    
    If ::oTORMModel:Success()

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[30][1], TORM_INFO_MESSAGE[30][2], { ::oTORMModel:TableName, cAlias } ) )
        ::oTORMModel:GoTop()

        While !::oTORMMOdel:Eof()

            If ::oTORMModel:IsDirty() .And. .Not. lNewData
                
                ::oTORMModel:__lInEdition := .T.

            else

                ::oTORMModel:__lInEdition := .F.

            Endif

            TORMDBFSave():New( ::oTORMModel ):Save( cAlias )
            ::oTORMMOdel:Skip()

        Enddo

        TORMDBFCloseTable():New( ::oTORMModel ):Close( cAlias )

    Endif

Return ( ::oTORMModel )

// Group: PROTECTED METHODS