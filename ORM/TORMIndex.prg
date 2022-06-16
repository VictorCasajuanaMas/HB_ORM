#Include 'hbclass.ch'

CREATE CLASS TORMIndex

    EXPORTED:
        DATA cField        AS CHARACTER INIT ''
        DATA lIsPrimaryKey AS LOGICAL   INIT .F.
        DATA lIsUnique     AS LOGICAL   INIT .F.
        DATA cDescription  AS CHARACTER INIT ''
        DATA nNumeral      AS NUMERIC   INIT 0

        DATA oTORMModel    AS OBJECT    Init Nil

        METHOD New() CONSTRUCTOR

        METHOD AddIndexToModel()

ENDCLASS

METHOD New( oTORMModel ) CLASS TORMIndex

    ::oTORMModel := oTORMModel

Return ( Self )

METHOD AddIndexToModel() CLASS TORMIndex

    aAdD( ::oTORMModel:__oIndexes:aIndex, Self )
    ::oTORMModel:__oIndexes:aIndex[ ::oTORMModel:__oIndexes:aIndex:Len() ]:nNumeral := ::oTORMModel:__oIndexes:aIndex:Len()

    If ::lIsPrimaryKey

        ::oTORMModel:__oIndexes:oPrimaryKey:cName := ::cField
        ::oTORMModel:__oIndexes:lPrimaryKey := .T.

    Endif

Return ( Nil )