#include 'hbclass.ch'

CREATE CLASS ClientePlus From Cliente

    EXPORTED:
        METHOD NombreCompleto()
        METHOD NumeroFacturas()
ENDCLASS

METHOD NombreCompleto() CLASS ClientePlus
Return ( ::NOMBRE:Alltrim() + ' ' + ::APELLIDO:Alltrim() )

METHOD NumeroFacturas() CLASS ClientePlus

    Local oFactura As Object := Factura():New()
    Local nNumeroFacturas As Numeric := 0

    nNumeroFacturas := oFactura:Where( 'CODCLI', ::CODIGO):Count()

Return ( nNumeroFacturas )