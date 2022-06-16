/* CLASS: TDb 
    Clase que se encarga de gestionar las opciones que afectan a varios modelos de datos
*/
#include 'hbclass.ch'
#include 'hbcompat.ch'

CREATE CLASS TDb

    EXPORTED:
        METHOD New(  ) CONSTRUCTOR

        METHOD GetModels()

    PROTECTED:
        METHOD IsModel()

    CLASSDATA mSymbols AS CHARACTER INIT ''

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New(  )
    Constructor.  
    
Devuelve:
    Self
*/
METHOD New(  ) CLASS TDb
Return ( Self )

/* METHOD: GetModels(  )
    Devuelve un array con los modelos que hay registrados

Devuelve:
    Array
*/
METHOD GetModels(  ) CLASS TDb

    Local aModels  := Array( 0 )
    Local cSymbol  := ''
    Local nCount   := 0

    for nCount := 1 to __DynsCount()

        if __DynsIsFun( nCount )

            cSymbol := __DynsGetName( nCount )
            AAdd( aModels, cSymbol )

            /* If ::IsModel( cSymbol )


            endif */

        Endif

    end

Return ( aModels )

// Group: PROTECTED METHODS

/* METHOD: IsModel( cSymbol )
    Determina si cSymbol corresponde a una clase y si también es un modelo de datos
    
    Parámetros:
        cSymbol - Valor a comprobar

Devuelve:
    Lógico
*/
METHOD IsModel( cSymbol ) CLASS TDb

    Local lIsModel  := .F.
    Local oInstance := Nil
    Local oError    := Nil

    
    if cSymbol:Left( 2 ) != "__" .And.;     // Descarta funciones internas
       cSymbol:Left( 5 ) != "MYSQL" .And.;  
       cSymbol != "MULTIPLICAFACTURACLIENTE2" .And.;  
       cSymbol:Upper():Left( 1 ) == 'M'    // Todos los modelos empiezan por m

        try 
        
            ::mSymbols += cSymbol + hb_eol()
            hb_MemoWrit('symbol.txt', ::mSymbols )
            oInstance := &( cSymbol + "()" )
    
            lIsModel := hb_IsObject( oInstance ) .And.;
                        oInstance:IsKindOf( 'TORMMODEL' )
    
        end

    EndIf


Return ( lIsModel )