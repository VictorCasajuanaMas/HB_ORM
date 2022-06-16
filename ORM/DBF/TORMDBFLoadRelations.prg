/* CLASS: TORMDBFLoadRelations 
    Se encarga de cargar las relaciones del modelo
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'
#include 'Torm.ch'

CREATE CLASS TORMDBFLoadRelations FROM TORMDBF

    EXPORTED:
        METHOD New( oTORMModel ) CONSTRUCTOR

        METHOD Load()

            DATA oTORMModel AS OBJECT INIT Nil
    PROTECTED:

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMModel )
    Constructor. Se inyecta el modelo 
    
   Parametros:
     oTORMModel - Modelo

Devuelve:
    Self
*/
METHOD New( oTORMModel ) CLASS TORMDBFLoadRelations

    ::Super:New()
    ::oTORMModel := oTORMModel

Return ( Self )

/* METHOD: Load(  )
    Revisa las relaciones del modelo y las carga en cada modelo de la relación.
    Nota: Esto se hace así porque si en cada carga de modelo hay que cargar sus relaciones, es una apertura y cierre de tablas que hace muy lento el proceso.
*/
METHOD Load(  ) CLASS TORMDBFLoadRelations

    Local oRelation          := Nil
    Local oChildModel        := Nil
    Local oModelinCollection := Nil
    Local cAlias             := Nil
    Local cOrder             := ''
    Local oTORMDBFSeek       := Nil
    
    If ::oTORMModel:__oRelations:HasRelations()

        ::oTORMModel:LogWrite( hb_StrReplace(TORM_INFO_MESSAGE[20][1], TORM_INFO_MESSAGE[20][2], { ::oTORMModel:TableName() } ) )

        for each oRelation in ::oTORMModel:__oRelations:GetRelations()

            If ::oTORMModel:Success

                // Pillo el modelo
                oChildModel := &( oRelation:oChildModel:ClassName() )():New()
                // Abro la tabla del modelo
                cAlias := TORMDBFOpenTable():New( oChildModel ):Open()
        
                If oChildModel:Success() 

                    // Ahora recorro toda la colección y cargo la relación en cada modelo de la colección
                    for each oModelinCollection in ::oTORMModel:GetCollection()

                        oModelinCollection:&( oRelation:cName ) := __objClone( oRelation:oOriginalChildModel )
                        
                        switch oRelation:cType
                            
                            case TORM_RELATION_HASONE
                                
                                cOrder := oModelinCollection:&( oRelation:cName ):__oIndexes:OrderDefault( )

                                If HB_ISOBJECT( oRelation:xField )

                                    oTORMDBFSeek := TORMDBFSeek():New( oModelinCollection:&( oRelation:cName ) ):Seek( MDBFSEek():New( cAlias, oRelation:xField, cOrder, oModelinCollection ) )
                                else
                                    
                                    oTORMDBFSeek := TORMDBFSeek():New( oModelinCollection:&( oRelation:cName ) ):Seek( MDBFSEek():New( cAlias, oModelinCollection:&( oRelation:xField ), cOrder ) )

                                Endif

                                If oTORMDBFSeek:Success()

                                    ::oTORMModel:__oReturn := TORMDBFLoadFromAlias():New( oModelinCollection:&( oRelation:cName ) ):Model( cAlias )

                                Endif

                            exit

                            case TORM_RELATION_HASMANY

                                // TODO: No se si llegará a hacer falta

                            exit

                        endswitch

                    next

                Else

                    ::oTORMModel:__oReturn:Success := .F.
                    ::oTORMModel:__oReturn:Log     := ::oChildModel:Log

                Endif

                TORMDBFCloseTable():New( ::oTORMModel ):Close( cAlias )

            Endif
            
        next

    Endif

Return ( ::oTORMModel:__oReturn )

// Group: PROTECTED METHODS