/* CLASS: TORMFieldValidationDefault 
    Crea las validaciones por defecto según las caracteríasticas del campo y las añade a la ya existente
*/
#include 'hbclass.ch'
#include 'validation.ch'

CREATE CLASS TORMFieldValidationDefault

    EXPORTED:
        METHOD New( oTORMField ) CONSTRUCTOR

        METHOD Default()

    PROTECTED:
        DATA oTORMField AS OBJECT INIT Nil

        METHOD Character()
        METHOD Numeric()

ENDCLASS

// Group: EXPORTED METHODS

/* METHOD: New( oTORMField )
    Constructor. Se le inyecta el objeto oTORMField 
    
   Parametros:
     oTORMField - Objeto contenedor de los datos del campo

Devuelve:
    Self
*/
METHOD New( oTORMField ) CLASS TORMFieldValidationDefault

    ::oTORMField := oTORMField

Return ( Self )

/* METHOD: Default()
    Asigna los valores por defecto
Devuelve:
    
*/
METHOD Default() CLASS TORMFieldValidationDefault

    ::Character()
    ::Numeric()

Return ( Nil )

// Group: PROTECTED METHODS 

/* METHOD: Character()
    Asigna los valores por defecto para los caracteres
*/
METHOD Character() CLASS TORMFieldValidationDefault

    If ::oTORMField:cType == 'C' .And.;
       .Not. ::oTORMField:hValid:HasKey( VALID_LENGHT )

        ::oTORMField:hValid[ VALID_LENGHT ] := ::oTORMField:nLenght

    Endif

Return ( Nil )

/* METHOD: Numeric()
    Asigna los valores por defecto para los numéricos
*/
METHOD Numeric() CLASS TORMFieldValidationDefault

    If ::oTORMField:cType == 'N' .And.;
        .Not. ::oTORMField:hValid:HasKey( VALID_RANGE )
 
         ::oTORMField:hValid[ VALID_RANGE ] := '-' + Replicate( '9', ::oTORMField:nLenght-1 ) + ',' + Replicate( '9', ::oTORMField:nLenght )
 
     Endif

Return ( Nil )