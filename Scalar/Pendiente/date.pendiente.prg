**/
   * FUNCION que Devuelve .T. si una variable suministrada en realidad es una fecha
 
   * @author  Bingen Ugaldebere
   * @param   xFecha    Fecha en formato Date o Character
 
   * @return  .T. / .F.
*/
 
function EsFecha( xFecha )
return Alltrim(ToString(xFecha)) == Dtoc(CToD(Alltrim(ToString(xFecha))))
 
**/
   * FUNCION que Devuelve una fecha como un texto con el formato "31-12-09" o muy corta "31-12"
 
   * @author  Bingen Ugaldebere
   * @param   xFecha    Fecha en formato Date o Character
   * @param   lMuyCorta Si se quiere el resultado solo con dia y mes
 
   * @return  Una cadena con el formato "31-12-09" o muy corta "31-12"
*/
 
FUNCTION FECHACORTA(xFecha,lMuyCorta)
   Local cRet:=""
 
   DEFAULT xFecha To DATE()
   DEFAULT lMuyCorta To .F.
 
   xFecha := If(Valtype(xFecha) == "C",Ctod(xFecha),xFecha)
 
   If xFecha==Ctod("  -  -    ")
      cRet:=""
   ElseIf lMuyCorta
      cRet:=Left(Dtoc(xFecha),5)
   Else
      cRet:=LEFT(DTOC(xFecha),6)+RIGHT(DTOC(xFecha),2)
   Endif
 
Return cRet
 
**/
   * FUNCION que Devuelve una fecha como un texto con formato "24 de febrero de 1965"
 
   * @author  Bingen Ugaldebere
   * @param   xFecha    Fecha en formato Date o Character
 
   * @return  Una cadena con el formato "24 de febrero de 1965"
*/
 
FUNCTION FechaLarga(xFecha)
   DEFAULT xFecha To DATE()
 
   xFecha := If(Valtype(xFecha) == "C",Ctod(xFecha),xFecha)
 
   If xFecha==Ctod("  -  -    ")
      Return ""
   Endif
 
RETURN  DtoT(xFecha)
 
**/
   * FUNCION que Devuelve una fecha como texto con el formato deseado
   * @author  Bingen Ugaldebere
   * @param   dFecha     Fecha a convertir
   * @param   cFecha     Plantilla con el formato de la fecha (default "dd de mmmm de aaaa")
   *              Elementos para plantilla
   *                0d -- día anteponiendo 0 en los días de un dígito
   *                dd -- día
   *                0m -- número del mes anteponiendo 0 en los meses de un dígito
   *                mm -- número del mes
   *               mmm -- las primeras tres letras del mes en minusculas
   *               Mmm -- las primeras tres letras del mes en comenzando con mayuscula
   *               MMM -- las primeras tres letras del mes en mayusculas
   *              mmmm -- el nombre del mes en minusculas
   *              Mmmm -- el nombre del mes comenzando con mayuscula
   *              MMMM -- el nombre del mes en mayusculas
   *                aa -- año con dos dígitos
   *              aaaa -- año con cuatro dígitos
 
   * @return  Una cadena con el formato deseado por defecto "dd de mmmm de aaaa"
*/
 
FUNCTION dToT(xFecha,cFecha)
   Local cVar
 
   Default xFecha To Date()
   Default cFecha To "dd de mmmm de aaaa"
 
   xFecha := If(Valtype(xFecha) == "C",Ctod(xFecha),xFecha)
 
   cVar:=if(day(xFecha)>0,allTrim(str(day(xFecha))),"  ")
   cFecha:=strTran(cFecha,"dd",cVar)
   cFecha:=strTran(cFecha,"DD",cVar)
   cVar:=if(day(xFecha)>0,strZero(day(xFecha),2),"  ")
   cFecha:=strTran(cFecha,"0d",cVar)
   cFecha:=strTran(cFecha,"0D",cVar)
   cVar:={"   ","enero","febrero","marzo","abril","mayo","junio","julio","agosto",;
                "septiembre","octubre","noviembre","diciembre"}[month(xFecha)+1]
   cFecha:=strTran(cFecha,"mmmm",cVar)
   cFecha:=strTran(cFecha,"Mmmm",upper(left(cVar,1))+subStr(cVar,2))
   cFecha:=strTran(cFecha,"MMMM",upper(cVar))
   cVar:=left(cVar,3)
   cFecha:=strTran(cFecha,"mmm",cVar)
   cFecha:=strTran(cFecha,"Mmm",upper(left(cVar,1))+subStr(cVar,2))
   cFecha:=strTran(cFecha,"MMM",upper(cVar))
   cVar:=if(month(xFecha)>0,allTrim(str(month(xFecha))),"  ")
   cFecha:=strTran(cFecha,"mm",cVar)
   cFecha:=strTran(cFecha,"MM",cVar)
   cVar:=if(day(xFecha)>0,strZero(month(xFecha),2),"  ")
   cFecha:=strTran(cFecha,"0m",cVar)
   cFecha:=strTran(cFecha,"0M",cVar)
   cVar:=if(year(xFecha)>0,TRANSFORM(year(xFecha),"@E 9999"),"    ")
   cFecha:=strTran(cFecha,"aaaa",cVar)
   cFecha:=strTran(cFecha,"AAAA",cVar)
   cVar:=right(cVar,2)
   cFecha:=strTran(cFecha,"aa",cVar)
   cFecha:=strTran(cFecha,"AA",cVar)
 
RETURN cFecha
 
**/
   * FUNCION que Devuelve un texto con un rango de fechas
 
   * @author   Version 1.0 Mayo 5/99  Daniel García
   * @param    xFecIni    Fecha inicial del rango a convertir o un array con la fecha inicial y final
   * @param    xFecFin    Fecha final del rango a convertir
   * @param    cCadenaIni Cadena inicial a devolver si no se pasa de agrega "del "
   *            Para suprimir se pasa una cadena vacía.
 
 
   * @return  Una cadena con el texto resultante
 
   * Ejemplo:       fecha inicial     fecha final    texto devuelto
   *      Caso 1     01/01/1999       01/01/1999     del 1 de enero de 1999
   *      Caso 2     01/01/1999       31/01/1999     del 1 al 31 de enero de 1999
   *      Caso 3     01/01/1999       31/12/1999     del 1 de enero al 31 de diciembre de 1999
   *      Caso 4     01/01/1998       31/12/1999     del 1 de enero de 1998 al 31 de diciembre de 1999
 
   * NOTA: Si se envia una matriz en xFecIni y no se envia xFecFin, toma el primer
   *       elemento de xFecIni como el valor de xFecIni, y el segundo elemento como
   *       el valor de xFecFin
*/
 
FUNCTION DTOTRANGO(xFecIni, xFecFin, cCadenaIni)
 
   If(Valtype(cCadenaIni)#"C", cCadenaIni:='del ',)  // Valida cadena inicial por default "del "
 
   IF valType(xFecIni)="A" .AND. xFecFin=nil .AND. len(xFecIni)>1
      xFecFin:=xFecIni[2]
      xFecIni:=xFecIni[1]
   ENDIF
 
   If xFecFin=Nil
      xFecFin:=xFecIni
   Endif
 
   IF (Valtype(xFecIni) = "D" .AND. Valtype(xFecFin) = "D")     // Solo si son fechas
      IF xFecIni = xFecFin       // Si las fecha son iguales
         cCadenaIni:=cCadenaIni + dToT(xFecFin, "dd de mmmm de aaaa")
      Else
         If Year(xFecIni) = Year(xFecFin)                     // Las fechas son del mismo año
            If Month(xFecIni) = Month(xFecFin)                // Las fechas son del mismo mes
               cCadenaIni:=cCadenaIni + dToT(xFecIni, "dd")         // Tomar el día
            Else                                              // Si no son del mismo mes
               cCadenaIni:=cCadenaIni + dToT(xFecIni, "dd de mmmm")  // Tomar día y mes
            EndIf
            cCadenaIni:=cCadenaIni + dToT(xFecFin, " al dd de mmmm de aaaa")
         Else                                                 // Si no son del mismo año
            cCadenaIni:=cCadenaIni + dToT(xFecIni, "dd de mmmm de aaaa") + dToT(xFecFin, " al dd de mes de aaaa")
         EndIf
      EndIf
   ENDIF
 
Return cCadenaIni
 
**/
   * FUNCION que Devuelve un string con la edad en años, meses y dias
 
   * @author  Bingen Ugaldebere
   * @param   dFechaIni Fecha de nacimiento o inicial
   * @param   dFechaFin Fecha de referencia final por defecto Date()
 
   * @return  Una cadena con la edad en años, meses y dias
*/
 
 Function Calc_Edad( dFechaIni, dFechaFin )
   LOCAL dsmsas, cResp := "", cAnos, cMeses, cDias
 
   Default dFechaFin To Date()
 
   If ! Empty(dFechaIni)
 
      dSmsas := DDMMAA( dFechaFin, dFechaIni )
      cAnos  := SUBSTR( dsmsas, 5, 3 )
      cMeses := SUBSTR( dsmsas, 3, 2 )
      cDias  := SUBSTR( dsmsas, 1, 2 )
 
      cResp := alltrim( cAnos )  + IIF( VAL(cAnos)==1,  " Año, ", " Años, " )+;
               cMeses + IIF( VAL(cMeses)==1, " Mes y ", " Meses y " ) +;
               cDias  + IIF( VAL(cDias)==1,  " Día", " Días" )
   Endif
 
 RETURN  cResp
 
**/
   * FUNCION que Devuelve la diferencia de años meses y dias de Las fechas pasadas como parámetros, en un string de 6 posiciones con formato ddmmaa
   *        En el prg se deben  sustraer cada uno de ellos....
 
   * @author  Bingen Ugaldebere
   * @param   dFechaIni Fecha inicial
   * @param   dFechaFin Fecha final
 
   * @return  Una cadena con la diferencia
*/
 
FUNCTION DDMMAA( dFechaFin, dFechaIni )
LOCAL nDifDia, nDifMes, nDifAno, nCantDiaMesAnt, nAno, nMes
 
   nMes = MONTH( dFechaFin ) - 1
   nAno = YEAR( dFechaFin )
   nCantDiaMesAnt = IIF( nMes=2, IIF( nAno%4 # 0, 28, 29 ),IIF( nMes=4 .OR.;
             nMes=6 .OR. nMes=9 .OR. nMes=11, 30, 31 ) )
   nDifDia = DAY( dFechaFin ) - DAY( dFechaIni )
   nDifMes = MONTH( dFechaFin ) - MONTH( dFechaIni )
   nDifAno = YEAR( dFechaFin ) - YEAR( dFechaIni )
 
   IF nDifMes < 0
      nDifAno = nDifAno - 1
      nDifMes = MONTH( dFechaFin ) + 12 - MONTH( dFechaIni )
   ENDIF
 
   IF nDifDia < 0
      IF nDifMes <= 0
         nDifMes += 11
         nDifAno -= 1
      ElSE
         nDifMes -= 1
      ENDIF
      nDifDia = DAY( dFechaFin ) + nCantDiaMesAnt - DAY( dFechaIni )
   ENDIF
 
RETURN( STR( nDifDia, 2 ) + STR( nDifMes, 2 ) + STR( nDifAno, 3 ) )
 
**/
   * FUNCION que Devuelve el nombre de un día de una fecha
 
   * @author  Bingen Ugaldebere
   * @param   dDate Fecha de referencia
 
   * @return  Nombre del día en castellano
*/
 
function DiaTexto(dDate)
local nDia
   Default dDate to Date()
   nDia := Dow(dDate)-1
   if nDia == 0; nDia := 7 ; endif
return {"Lunes","Martes","Miercoles","Jueves","Viernes","Sábado","Domingo"}[nDia]
 
**/
   * FUNCION que Averigua el nombre del día de la fecha o número de día enviado.
 
   * @author  Sanrom's Software de México 14/08/97
   * @param   xFecha  Parámetro que indica la fecha o Número del día a convertir. por defecto Date()
   * N O T A S  : El parámetro podrá ser una fecha válida o un número comprendido entre 1 y 7.
   
   * @return  cDia    Una cadena con el nombre del día que corresponde a la fecha o número enviado.
*/
 
FUNCTION Dia( xFecha, nLong )
   LOCAL nDia                 // Número del día a averiguar su nombre.
   LOCAL cDia := ""
 
   DEFAULT xFecha TO DATE()   // Por default tomar  la fecha del sistema.
   DEFAULT nLong TO 0
 
   nDia := IF( VALTYPE(xFecha)="N", xFecha, DOW( xFecha ) )
 
   SWITCH nDia
      CASE 1;   cDia := "Domingo";     EXIT
      CASE 2;   cDia := "Lunes";       EXIT
      CASE 3;   cDia := "Martes";      EXIT
      CASE 4;   cDia := "Miércoles";   EXIT
      CASE 5;   cDia := "Jueves";      EXIT
      CASE 6;   cDia := "Viernes";     EXIT
      CASE 7;   cDia := "Sábado";      EXIT
   END
 
   IF nLong > 0
      cDia := LEFT(cDia, nLong)
   ENDIF
RETURN(cDia)
 
**/
   * FUNCION que Suma Días a una fecha tomando solo días Hábiles util paar plazos administrativos
 
   * @author  Sanrom's Software de México 14/08/97
   * @param   <fFecha>  - Parámetro que indica la fecha desde la cuál se va a Partir.
   * @param   <<nDias>   - Número de días que se le van a sumar, si no se manda, se suma 0
   * @param   <nDato>   - Dato que se desea 1 = Fecha, 2 = Dias a Sumar
   * @param   <fFecha2> - Indica una fecha hasta la cual se quiere llegar para regresar los días hábiles entre esas fechas
   * N O T A S  : Si no se manda la fecha o los días regresa la fecha del sistema o el siguiente dia habil.
   
   * @return  fFechaFIn   Una fecha con los días sumado, tomando solo días hábiles.
*/
 
FUNCTION DiaHabil( fFecha, nDias, nDato, fFecha2)
   LOCAL cAno
   LOCAL nHabil                    // Contador de Días Hábiles, hasta llegar a nDias enviados.
   LOCAL fFechaFin                 // Fecha con los días ya sumados para ser hábil
   LOCAL nNoHabil := 0             // Días que no son hábiles para incrementar a nDias
 
   DEFAULT fFecha TO DATE()      // Por default tomar  la fecha del sistema.
   DEFAULT nDias TO 0           // Por default no incrementa días
   DEFAULT nDato TO 1           // Por default regresa la fecha hábil
 
   IF fFecha2 <> NIL .AND. fFecha < fFecha2
      nDias := fFecha2 - fFecha
   ENDIF
 
   FOR nHabil := 0 TO nDias
       fFechaFin := fFecha + (nNoHabil + nHabil)
       cAno := PADL(YEAR(fFechaFin), 4, "0")
 
       ** Si la fecha es domingo, sabado o un día festivo, incrementa los dias a sumar a la fecha
       IF DOW(fFechaFin) == 1 .OR. DOW(fFechaFin) == 7 .OR. fFechaFin == CTOD("01/01/" + cAno) .OR.;
          fFechaFin == CTOD("05/02/" + cAno) .OR. fFechaFin == CTOD("21/03/" + cAno) .OR. fFechaFin == CTOD("01/05/" + cAno) .OR.;
          fFechaFin == CTOD("16/09/" + cAno) .OR. fFechaFin == CTOD("02/11/" + cAno) .OR. fFechaFin == CTOD("20/11/" + cAno) .OR.;
          fFechaFin == CTOD("12/12/" + cAno) .OR. fFechaFin == CTOD("25/12/" + cAno)
 
          ++nNoHabil   // Incrementa los días que no son hábiles para sumarlos a los dias solicitados
          --nHabil     // Decrementa el contador de los días, para dar otra vuellta y ver si cae en día Hábil
       ENDIF
 
       IF fFecha2 <> NIL .AND. fFechaFin >= fFecha2
          EXIT
       ENDIF
   NEXT
 
   DO CASE
      CASE nDato == 1                         // Regresa la Fecha en Días Hábiles
           fFechaFin := fFecha + (nNoHabil + nDias)
 
      CASE nDato == 2
           fFechaFin := nNoHabil + nDias      // Regresa los días reales que se necesitan suma para ser hábil
 
      CASE nDato == 3                         // Regresa los días que nos son hábiles
           fFechaFin := nNoHabil
 
      CASE nDato == 4                         // Regresa los días que son hábiles ente 2 fechas
           fFechaFin := nHabil
   ENDCASE
 
RETURN(fFechaFin)
 
**/
   * FUNCION que nos dice cuantos días laborables hay entre dos fechas
 
   * @author  Bingen Ugaldebere
   * @param   dFechaIni  Parámetro que indica la fecha de inicio
   * @param   dFechaFin  Parámetro que indica la fecha de final
   * @param   aFestivos  [Opcional] Array con las festividades a tener en cuenta entre ambas fechas
   * @param   lIncluirSabados [Opcional] Si los sábados se tienen en cuenta como laborales, por defecto .F.
 
   * @return  nDias  Total de días laborables incluidos  dFechaIni y dFechaFin
*/
 
 
Function DiasLaborales(dFechaIni,dFechaFin,aFestivos,lIncluirSabados)
Local nDias:=0
Default aFestivos to {}
default lIncluirSabados to .F.
 
   Do while dFechaIni<=dFechaFin
      IF (DoW(dFechaIni)>1 .And. DoW(dFechaIni)<7 ) .Or. (lIncluirSabados .And. DoW(dFechaIni)=7)
         If AScan(aFestivos,dFechaIni)=0
            ++nDias
         Endif
      Endif
      dFechaIni++
   Enddo
 
Return nDias
 
*
**/
   * FUNCION que averigua el nombre del mes de la fecha o número de mes enviado.
 
   * @author  Sanrom's Software de México 10/07/96
   * @param   <xFecha>  - Parámetro que indica la fecha o Número del mes a convertir.
   * @param   <<nDias>  - Número de días que se le van a sumar, si no se manda, se suma 0
   * @param   <nDato>   - Dato que se desea 1 = Fecha, 2 = Dias a Sumar
   * @param   <fFecha2> - Indica una fecha hasta la cual se quiere llegar para regresar los días hábiles entre esas fechas
   * N O T A S  : El parámetro podrá ser una fecha válida o un número comprendido entre 1 y 12.
   
   * @return  cMes   Una cadena con el nombre del mes que corresponde a la fecha o número enviado.
*/
 
FUNCTION Mes( xFecha )
   LOCAL cMes
   LOCAL nMes                 // Número del mes a averiguar su nombre.
 
   DEFAULT xFecha TO DATE()   // Por default tomar  la fecha del sistema.
 
  DO CASE
     CASE ValType(xFecha) == "C"
          IF "/" $ xFecha
             xFecha := CToD( Left(xFecha, 10) )
          ELSE
             xFecha := SToD( Left(xFecha, 10) )
          ENDIF
 
      CASE HB_IsDateTime(xFecha)
         #ifdef __XHARBOUR__
            xFecha := SToD( Left(TToS(xFecha), 8) )
         #else
            xFecha := SToD( Left(HB_TToS(xFecha), 8) )
         #endif
  ENDCASE
 
  IF ValType(xFecha) == "D"
     nMes := Month(xFecha)
  ELSEIF ValType(xFecha) == "N"
     nMes := xFecha
  ENDIF
 
   SWITCH nMes
      CASE  1;   cMes := "Enero";      EXIT
      CASE  2;   cMes := "Febrero";    EXIT
      CASE  3;   cMes := "Marzo";      EXIT
      CASE  4;   cMes := "Abril";      EXIT
      CASE  5;   cMes := "Mayo";       EXIT
      CASE  6;   cMes := "Junio";      EXIT
      CASE  7;   cMes := "Julio";      EXIT
      CASE  8;   cMes := "Agosto";     EXIT
      CASE  9;   cMes := "Septiembre"; EXIT
      CASE 10;   cMes := "Octubre";    EXIT
      CASE 11;   cMes := "Noviembre";  EXIT
      CASE 12;   cMes := "Diciembre";  EXIT
      #ifdef __XHARBOUR__
         DEFAULT;   cMes := ""
      #else
        Otherwise;   cMes := ""
      #endif
   END
RETURN( cMes )
 
**/
   * FUNCION que investiga los Años, Meses y Días transcurridos desde la fecha <fFechaIni> y la fecha <fFechaFin>
 
   * @author  Sanrom's Software de México 2001
   * @param   <fFechaIni> -> Primera fecha a tratar.
   * @param   <fFechaFin> -> Segunda Fecha a tratar. Si se omite este parámetro, se tomará la fecha actual con DATE().
   * @param   <nRegresa>  -> Indica que tipo de dato se está solicitando: 1 = Años  2 = Años y Meses  3 = Años, Meses y Días
   * @param   <cSeparador> -> Caracter a utilizar como separador entre los Años, Meses y Días. Por default será: "."
 
   * N O T A S  : El parámetro podrá ser una fecha válida o un número comprendido entre 1 y 12.
   
   * @return  <cTiempo> -> Cadena de caracteres con los Años, Meses y Días transcurridos desde la fecha <fFechaIni> hasta la fecha <fFechaFin>
   * E J E M P L O: ? Tiempo( CTOD("17/07/1971"), CTOD("06/07/2001"), 1) ) -> "29"     // Años
   *                ? Tiempo( CTOD("23/03/1972"), CTOD("06/07/2001"), 2) ) -> "29.3"   // Años.Meses
   *                ? Tiempo( CTOD("03/04/1960"), CTOD("06/07/2001"), 3) ) -> "41.3.3" // Años.Meses.Días
*/
 
FUNCTION Tiempo(fFechaIni, fFechaFin, nRegresa, cSeparador)
  LOCAL cAnos, cMeses, cDias, cTiempo
  LOCAL nAnos, nMeses, nDias, nDiaUltimo, fAux
  LOCAL nAnoIni, nAnoFin, nMesIni, nMesFin, nDiaIni, nDiaFin
 
  DEFAULT fFechaFin TO DATE()
  DEFAULT nRegresa TO 1
  DEFAULT cSeparador TO "."
 
  IF Empty(fFechaIni)
     RETURN("")
  ENDIF
 
 
  nAnoIni := YEAR(fFechaIni)
  nAnoFin := YEAR(fFechaFin)
 
  nMesIni := MONTH(fFechaIni)
  nMesFin := MONTH(fFechaFin)
 
  nDiaIni := DAY(fFechaIni)
  nDiaFin := DAY(fFechaFin)
 
 
  // AÑOS...
  nAnos := 0
 
  IF nAnoFin > nAnoIni
     nAnos := nAnoFin - nAnoIni
 
     // Decrese el año en uno si la fecha (mes/día) no ha ocurrido aún
     // en la fecha <fFechaFin>
     IF (nMesFin < nMesIni  .OR. ;
        (nMesFin == nMesIni .AND.;
         nDiaFin < nDiaIni))
 
        --nAnos
     ENDIF
  ENDIF
 
 
  // MESES...
  DO CASE
     CASE nMesIni > nMesFin
          nMeses := 12 - nMesIni + nMesFin - IF(nDiaIni > nDiaFin, 1, 0)
 
     CASE nMesIni < nMesFin
          nMeses := nMesFin - (nMesIni + IF(nDiaIni > nDiaFin, 1, 0))
 
     CASE nDiaFin < nDiaIni
          nMeses := 11
 
     OTHERWISE
          nMeses := 0
  ENDCASE
 
 
  // DIAS...
  fAux := CTOD( STR(nDiaIni) + "/" + STR(nMesFin - 1) + "/" + STR(nAnoFin, 4) )
 
  IF Empty(fAux)
     fAux := CTOD("01/" + STR(nMesFin - 1) + "/" + STR(nAnoFin, 4))
  ENDIF
 
  nDias := fFechaFin - fAux
  nDiaUltimo := DAY( LastOfMonth(fAux) )
  nDias :=  IF(nDias >= nDiaUltimo, nDias - nDiaUltimo, nDias)
 
 
  cAnos := AllTrim( STR(nAnos) )
  cMeses:= AllTrim( STR(nMeses) )
  cDias := AllTrim( STR(nDias) )
 
  SWITCH nRegresa
     CASE 1;    cTiempo := cAnos;                        EXIT
     CASE 2;    cTiempo := cAnos + cSeparador + cMeses;  EXIT
     CASE 3;    cTiempo := cAnos + cSeparador + cMeses + cSeparador + cDias
  END
 
RETURN(cTiempo)
 
**/
   * FUNCION que averigua el número del mes de la fecha o cadena del mes enviado.
 
   * @author  Sanrom's Software de México 17/08/04
   * @param   <xFecha>  = Parámetro que indica la fecha o Cadena del mes a convertir.
 
   * N O T A S  : El parámetro podrá ser una fecha válida o una cadena con el nombre del mes.
   
   * @return  nMes  Un número con el mes que corresponde a la fecha o cadena enviada.
   * EJEMPLO: ? MesToNum("Febrero") -> 2
   *          ? MesToNum(DATE())    -> 8
   *          ? MesToNum("III")     -> 3
   *          ? MesToNum("October") -> 10
*/
 
FUNCTION MesToNum(xFecha)
   LOCAL cMes
 
   DEFAULT xFecha TO ""
 
   IF ValType(xFecha) == "D"
      xFecha := CMonth(xFecha)
   ELSEIF ValType(xFecha) == "N"
      xFecha := AllTrim( STR(xFecha) )
   ELSEIF ValType(xFecha) == "C" .AND. SUBSTR(AllTrim(xFecha), 1, 1) == "0"
      xFecha := AllTrim( STR( VAL(xFecha) ) )
   ENDIF
 
   cMes := AllTrim( Upper(xFecha) )
   cMes := SUBSTR(cMes, 1, 3)
 
   DO CASE
      CASE cMes == "1"  .OR. cMes == "I"    .OR. cMes == "ENE" .OR. cMes == "JAN";		RETURN(1)
      CASE cMes == "2"  .OR. cMes == "II"   .OR. cMes == "FEB" .OR. cMes == "FEB";		RETURN(2)
      CASE cMes == "3"  .OR. cMes == "III"  .OR. cMes == "MAR" .OR. cMes == "MAR";		RETURN(3)
      CASE cMes == "4"  .OR. cMes == "IV"   .OR. cMes == "ABR" .OR. cMes == "APR";		RETURN(4)
      CASE cMes == "5"  .OR. cMes == "V"    .OR. cMes == "MAY" .OR. cMes == "MAY";		RETURN(5)
      CASE cMes == "6"  .OR. cMes == "VI"   .OR. cMes == "JUN" .OR. cMes == "JUN";		RETURN(6)
      CASE cMes == "7"  .OR. cMes == "VII"  .OR. cMes == "JUL" .OR. cMes == "JUL";		RETURN(7)
      CASE cMes == "8"  .OR. cMes == "VIII" .OR. cMes == "AGO" .OR. cMes == "AUG";		RETURN(8)
      CASE cMes == "9"  .OR. cMes == "IX"   .OR. cMes == "SEP" .OR. cMes == "SEP";		RETURN(9)
      CASE cMes == "10" .OR. cMes == "X"    .OR. cMes == "OCT" .OR. cMes == "OCT";		RETURN(10)
      CASE cMes == "11" .OR. cMes == "XI"   .OR. cMes == "NOV" .OR. cMes == "NOV";		RETURN(11)
      CASE cMes == "12" .OR. cMes == "XII"  .OR. cMes == "DIC" .OR. cMes == "DEC";		RETURN(12)
   ENDCASE
 
RETURN(0)
 
 
**/
   * FUNCION que suma años, meses y/o días a una fecha determinada.
 
   * @author  Sanrom's Software de México 2004
   * @param   <fFecha> = Fecha a tratar.
   * @param   <nAnos>  = Número de Años que se desea incrementar a la fecha enviada.
   * @param   <nMeses> = Número de Meses que se desea incrementar a la fecha enviada.
   * @param   <nDias>  = Número de Días que se desea incrementar a la fecha enviada.
 
   * N O T A S  : El parámetro podrá ser una fecha válida o una cadena con el nombre del mes.
   
   * @return  <fNewFecha> = Nueva fecha con los Años, Meses y Días incrementados.
   * E J E M P L O: ? FechaMas(CToD("17/07/71"), 33,  8, 32) => 18/04/2005
   *                ? FechaMas(CToD("17/07/71"), 32, 16, 40) => 27/12/2004
*/
 
FUNCTION FechaMas(fFecha, nAnos, nMeses, nDias)
   DEFAULT nAnos TO 0
   DEFAULT nMeses TO 0
   DEFAULT nDias TO 0
 
   IF ValType(fFecha) <> "D" .OR. Empty(fFecha)
      RETURN( CToD("  /  /  ") )
   ENDIF
 
   nMeses := Month(fFecha)+ nMeses
   DO WHILE nMeses > 12
      nAnos++
      nMeses -= 12
   ENDDO
 
   nAnos := Year(fFecha) + nAnos
 
   fFecha := CToD(PADL( DAY(fFecha), 2, "0" ) + "/" + PADL(nMeses, 2, "0") + "/" + PADL(nAnos, 4, "0"))
   fFecha += nDias
 
RETURN (fFecha)
 
**/
   * FUNCION que Devuelve un año inserto en una fecha o numerico o caracter
 
   * @author  Bingen Ugaldebere
   * @param   xFecha    Fecha en formato Date o Character o Numeric
   * @param   lCorta    Si se quiere el resultado solo con 2 numeros
 
   * @return  Una cadena con el formato "31-12-09" o muy corta "31-12"
*/
 
FUNCTION YearOf(xFecha,lCorta)
Local nYear
 
   Default lCorta to .F.
 
   Do CAse
   Case xFecha=Nil
      nYear:=Year(Date())
   Case Valtype(xFecha)="N"
      nYear:=xFecha
   Case Valtype(xFecha)="C" .And. Ctod(xFecha)<>Ctod("  -  -    ")
      nYear:=Year(Ctod(xFecha))
   Case Valtype(xFecha)="C"
      nYear:=Val(xFecha)
   Case Valtype(xFecha)="D"
      nYear:=Year(xFecha)
   Otherwise
      nYear:=0
      LogDebug("Fecha incorrecta en función YearOff "+Alltrim(ToString(xFecha)))
   EndCase
 
Return Val(Right("0000"+Str(nYear),If(lCorta,2,4)))
 
 
**/
   * FUNCION que suma a un datetime nAnos, nMeses, nDias, nHoras, nMinutos
 
   * @author  Bingen Ugaldebere
   * @param   cFechaHora   cadena DateTime   "20120823 12:01:50"
   * @param   nAnos        años a sumar
   * @param   nMeses       meses a sumar
   * @param   nDias        días a sumar
   * @param   nHoras       horas a sumar
   * @param   nMinutos     minutos a sumar
 
   * @return  Una cadena con un datetime sumando a otro datetime nAnos, nMeses, nDias, nHoras, nMinutos
*/
FUNCTION DateTimeSuma(cFechaHora, nAnos, nMeses, nDias, nHoras, nMinutos)
Local dFecha, cHora, cHoraEnt
 
   Default cFechaHora   To DToS(Date())+" "+Time()
   DEFAULT nAnos        TO 0
   DEFAULT nMeses       TO 0
   DEFAULT nDias        TO 0
   DEFAULT nHoras       TO 0
   DEFAULT nMinutos     TO 0
 
   dFecha:=Stod(Left(cFechaHora,8))
   cHora :=Right(cFechaHora,8)
 
   //Controles
   IF ValType(dFecha) <> "D" .OR. Empty(dFecha)
      LogDebug("Fecha incorrecta en función DateTimeSuma "+cFechaHora)
      Return cFechaHora
   ENDIF
 
   If !ValHora( cHora )
      LogDebug("Hora incorrecta en función DateTimeSuma "+cFechaHora)
      Return cFechaHora
   ENDIF
 
 
   //Añadir años
   nAnos := Year(dFecha) + nAnos
 
   //Añadir meses
   nMeses := Month(dFecha)+ nMeses
   DO WHILE nMeses > 12
      nAnos++
      nMeses -= 12
   ENDDO
 
   dFecha := CToD(PADL( DAY(dFecha), 2, "0" ) + "/" + PADL(nMeses, 2, "0") + "/" + PADL(nAnos, 4, "0"))
 
 
   If nMinutos>=60
      nHoras+=Int(nMinutos/60)
      nMinutos:=nMinutos-(Int(nMinutos/60)*60)
   Endif
 
   If nHoras>=24
      nDias+=Int(nHoras/24)
      nHoras:=nHoras-(Int(nHoras/24)*24)
   Endif
 
   //Añadir días
   dFecha += nDias
 
   //Añadir Horas
   cHoraEnt:=cHora
   cHora:=AddMinute(cHora,nHoras*60,6)
   If cHora<cHoraEnt
      dFecha++
   Endif
 
   //Añadir minutos
   cHoraEnt:=cHora
   cHora:=AddMinute(cHora,nMinutos,6)
   If cHora<cHoraEnt
      dFecha++
   Endif
 
RETURN DToS(dFecha)+" "+cHora
 
 
**/
   * FUNCION que resta a un datetime nAnos, nMeses, nDias, nHoras, nMinutos
 
   * @author  Bingen Ugaldebere
   * @param   cFechaHora   cadena DateTime   "20120823 12:01:50"
   * @param   nAnos        años a sumar
   * @param   nMeses       meses a sumar
   * @param   nDias        días a sumar
   * @param   nHoras       horas a sumar
   * @param   nMinutos     minutos a sumar
 
   * @return  Una cadena con un datetime restando a otro datetime nAnos, nMeses, nDias, nHoras, nMinutos
*/
FUNCTION DateTimeResta(cFechaHora, nAnos, nMeses, nDias, nHoras, nMinutos)
Local dFecha, cHora, cHoraEnt
 
   Default cFechaHora   To DToS(Date())+" "+Time()
   DEFAULT nAnos        TO 0
   DEFAULT nMeses       TO 0
   DEFAULT nDias        TO 0
   DEFAULT nHoras       TO 0
   DEFAULT nMinutos     TO 0
 
   dFecha:=Stod(Left(cFechaHora,8))
   cHora :=Right(cFechaHora,8)
 
   //Controles
   IF ValType(dFecha) <> "D" .OR. Empty(dFecha)
      LogDebug("Fecha incorrecta en función DateTimeSuma "+cFechaHora)
      Return cFechaHora
   ENDIF
 
   If !ValHora( cHora )
      LogDebug("Hora incorrecta en función DateTimeSuma "+cFechaHora)
      Return cFechaHora
   ENDIF
 
 
   //Restar años
   nAnos := Year(dFecha) - nAnos
 
   //Restar meses
   nMeses := Month(dFecha)- nMeses
   DO WHILE nMeses > 12
      nAnos--
      nMeses -= 12
   ENDDO
 
   dFecha := CToD(PADL( DAY(dFecha), 2, "0" ) + "/" + PADL(nMeses, 2, "0") + "/" + PADL(nAnos, 4, "0"))
 
 
   If nMinutos>=60
      nHoras-=Int(nMinutos/60)
      nMinutos:=nMinutos-(Int(nMinutos/60)*60)
   Endif
 
   If nHoras>=24
      nDias-=Int(nHoras/24)
      nHoras:=nHoras-(Int(nHoras/24)*24)
   Endif
 
   //Restar días
   dFecha -= nDias
 
   //Restar Horas
   cHoraEnt:=cHora
   cHora:=AddMinute(cHora,nHoras*-60,6)
   If cHora>cHoraEnt
      dFecha--
   Endif
 
   //Añadir minutos
   cHoraEnt:=cHora
   cHora:=AddMinute(cHora,nMinutos*-1,6)
   If cHora>cHoraEnt
      dFecha--
   Endif
 
RETURN DToS(dFecha)+" "+cHora