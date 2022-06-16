/* CLASS: TORMDBFAlias 
    Crea un alias
*/
#include 'hbclass.ch'

CREATE CLASS TORMDBFAlias

    EXPORTED:
        METHOD New( ) CONSTRUCTOR
        METHOD GetAlias() 

    PROTECTED:
        CLASSDATA nCountAlias AS NUMERIC Init 1

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( )
    Constructor.  
    
Devuelve:
    Self
*/
METHOD New(  ) CLASS TORMDBFAlias
Return ( Self )

/* METHOD: GetAlias( )
    Devuelve el Alias en sí    

Devuelve:
    Self
*/
METHOD GetAlias() CLASS TORMDBFAlias

    ::nCountAlias++

Return ( 'Alias' + ::nCountAlias:Str() )

// Group: PROTECTED METHODS
