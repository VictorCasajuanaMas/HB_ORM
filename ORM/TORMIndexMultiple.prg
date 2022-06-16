#include 'hbclass.ch'

#DEFINE FIELD_VALUE      1
#DEFINE FIELD_LENGTH     2
#DEFINE FIELD_MODEL      3

CREATE CLASS TIndexMultiple 
// Se le pasa por New el índice a procesar:
// { 'SERIE' => { nSerie, 4 }, 'NUMERO' => { nNumero, 6 } }
// { 'nombredelcampo' => { valor, ancho } }
// el array de campos ha de ir en el mismo órden que en la definición del índice, por ejemplo:
// STR(SERIE,4)+STR(NUMERO,6) se pasa así: { 'SERIE' => { nSerie, 4 }, 'NUMERO' => { nNumero, 6 } }

    EXPORTED:
        METHOD New( hdatas ) CONSTRUCTOR
        METHOD GetDatas()
        METHOD Get( cData )
        METHOD GetDatasRaw( )
        METHOD Empty()
        METHOD ToSeek()
        METHOD GetRaw()
        
        METHOD Str()           INLINE ::ToSeek()
        METHOD ToString( ... ) INLINE ::ToSeek( ... )
        
    PROTECTED:
        DATA hdatas  AS HASH INIT hb_Hash()

ENDCLASS

METHOD New( hdatas ) CLASS  TIndexMultiple

    If HB_ISHASH( hdatas )

        ::hdatas := hdatas

    Endif

Return ( Self )

METHOD GetDatas(  ) CLASS  TIndexMultiple
Return ( hb_hKeys( ::hDatas ) )

METHOD GetDatasRaw( oModel )  CLASS TIndexMultiple

    Local aData     := Array( 0 )
    Local aDatasRaw := Array( 0 )

    
    for each aData in ::hDatas

        If aData:Get( FIELD_MODEL ):Value( .F. ) .And.;
           oModel != Nil

            aData[ FIELD_VALUE ] := oModel:&( aData:__enumkey )  // Se trata de una relación HasOne o HasMany, por lo que trabajo con el dato del modelo de la relación

        Endif

        switch Valtype( aData[ FIELD_VALUE ] )
            case 'N'

                aAdD( aDatasRaw, aData[ FIELD_VALUE ]:StrRaw( aData[ FIELD_LENGTH ] ) )
                
            exit

            case 'C'

                aAdD( aDatasRaw, aData[ FIELD_VALUE ]:SpacesRight( aData[ FIELD_LENGTH ] ) )
                
            exit
        endswitch
        
    next

Return ( aDatasRaw )

METHOD Get( cData ) CLASS TIndexMultiple

    Local xReturn := Nil

    If ::hDatas:HasKey( cData )

        xReturn := ::hDatas:ValueOfKey( cData )[ FIELD_VALUE ]

    Endif

Return ( xReturn )

METHOD ToSeek( oModel ) CLASS TIndexMultiple

    Local cToSeek   := ''
    Local cRawValue := ''

    for each cRawValue in ::GetDatasRaw( oModel )

        cToSeek += cRawValue
        
    next

    
Return ( cToSeek )

METHOD Empty() CLASS TIndexMultiple

    Local lIsEmpty := .T.
    Local aData    := Array( 0 )

    for each aData in ::hDatas
        
        If aData[ FIELD_VALUE ] != Nil

            lIsEmpty := .F.

        Endif

    next

Return ( lIsEmpty )

METHOD GetRaw() CLASS TIndexMultiple

    Local cGetRaw := ''
    Local aData   := Array( 0 )

    for each aData in ::hDatas

        If cGetRaw:NotEmpty()

            cGetRaw += '+'
            
        Endif

        switch Valtype( aData[ FIELD_VALUE ] )

            case 'N'

                cGetRaw += 'STR(' + aData:__enumkey  + ',' + aData[ FIELD_LENGTH ]:Str() + ')'

            exit

            case 'C'

                cGetRaw += aData:__enumkey 

            exit

        endswitch
        
    next

Return ( cGetRaw )