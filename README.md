# HB_ORM
ORM realizado en Harbour. 
Actualmente solo funciona con DBF pero está preparado para incluir más orígenes de datos.

Se pueden realizar consultas utilizando varios métodos como
~~~
oFicha:Select('CODIGO AS COD', 'NOMBRE', 'DIRECCION', 'FECHA')
      :Where('CODIGO',1)
      :WhereIn('CODIGO',{5,6,7})
      :OrWhere('NOMBRE','Like','A%)
      :WhereBetween('CODIGO',{10,20})
      :OrderBy('NOMBRE')
      :Take(10);
      :OffSet(5);
      :Get()
~~~

~~~
oFicha:Where('CODIGO','>=',10)
      :Update({'CP' => '80800'})
~~~

~~~
oFicha:WhereBetween('CODIGO',{10,20})
      :Delete()
~~~

~~~
oFicha := Ficha():New()
oFicha:CODIGO := 1
oFicha:Save()
oFicha:Find(1)
~~~

~~~
?oFicha:CODIGO
?oFicha:oDireccion:POBLACION
~~~

~~~
oFactura := Factura():New(1)
for each oLinea in oFactura:oLineas
      ?oLinea:ARTICULO
Next
~~~

Ver documentación completa: https://github.com/VictorCasajuanaMas/HB_ORM/tree/main/ORM#readme


### ORM
\ORM : Código del ORM

### Dependencias:
\Scalar
\TCollection
\TLog
\TReturn
\TTryCatchShowError
\TValidation

### opcionales
\debugger : Debug para vscode

### prueba
\prueba : Pequeño código para hacer pruebas

### test
\test : Test unitarios del ORM
