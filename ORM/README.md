# ORM
Prototipo de ORM con harbour

- Introducción
- Requisitos
- Uso básico
  - Definición del modelo
  - Índices
  - Llaves foráneas
  - Recuperando información
 - Estado del modelo
 - Estado de los cambios en el modelo
 - Creación de nuevos registros
 - Modificación de registros
 - Borrado de registros
 - Carga desde origen
 - Guardar a origen
 - Métodos de consulta
 - LazyLoad
 - Validaciones
 - Colecciones
 - Paginación
 - Log
 - Métodos de BD

### INTRODUCCIÓN
El ORM está basado en el control de los modelos de datos mediante objetos relacionados entre sí. Es completamente abstracto del motor de base de datos que se utilice.

### REQUISITOS
Para el funcionamiento del ORM son necesarias las clases:
- **TReturn** : Ofrece el estado al modelo
- **TValidation** : Ofrece la funcionalidad de las validaciones
- **Clases Scalares** : Ofrecen mejor semántica al código
- **Tcollection** : Permite la gestión de la colección interna del modelo
- **TLog** : Permite generar un log

### ENTORNO
#### DBF
En entornos DBF para indicar la ruta donde se almacenan los modelos se puede realizar de varias formas:

Crear una función PathOfFile( oTORMModel ) que recibirá el modelo, esta función devolverá la ruta del fichero. De esta forma se puede indicar diferentes rutas dependiendo del nombre del modelo.
~~~
Function PathOfFile( oTORMModel )
  Local cPath := "" 
  // lógica que se desee según las características del modelo, por ejemplo el nombre
Return  ( cPath )
~~~


Sobreescribiendo el método Path() que se llama todas las veces que se debe acceder al fichero .DBF en el disco, esta función devolverá la ruta completa donde se ubica el fichero. 
~~~
OVERRIDE METHOD Path  IN CLASS TORMDBF WITH FuncionPath
~~~

también se puede asignar la ruta mediante el siguiente comando:
~~~
TORMDBF():SetPath('C:\RUTA\')
~~~


### USO BÁSICO

#### Definición del modelo
Para empezar a utilizar el ORM es necesario tener un modelo de datos definido. Esto se realiza creando una clase que hereda de TORMModel:
~~~
CREATE CLASS Persona FROM TORMModel
~~~
*Nota: Hay que incluir hbclass.ch para el correcto funcionamiento*


Por defecto, el nombre de la tabla de la base de datos será el plural del nombre del modelo. en este caso el nombre de la tabla sería **Personas**
este comportamiento puede ser modificado mediante la propiedad **__cName** del modelo:

~~~
CREATE CLASS Persona FROM TORMModel
  EXPORTED:
    DATA __cName AS CHARACTER INIT 'MiPersona" READONLY
ENDCLASS
~~~

Una vez definido el modelo, se deben configurar los datos que contendrá mediante el método `CreateStructure()`, en nuestro ejemplo anterior sería:

~~~
CREATE CLASS Persona FROM TORMModel
  EXPORTED:
    METHOD CreateStructure()
ENDCLASS

METHOD CreateStructure() CLASS Persona

    WITH OBJECT TORMField():New( Self )
        :cName   := 'CODIGO'
        :cType   := 'C'
        :nLenght := 10
        :cDescription := 'Código de la persona'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END
    
Return ( Nil )
~~~

Las propiedades que puede tener un dato del modelo son:
- **cName**: Nombre del campo
- **cType**: Tipo de dato: **C** Carácter, **N** Numérico, **L** Lógico, **D** Fecha, **T** DateTime, **+** AutoIncremental
- **nLenght**: Ancho del campo
- **nDecimals**: En caso de campos numéricos, número de decimales
- **cDescription**: Descripción del campo
- **uDefault**: Valor por defecto
- **hValid**: Validación
Una vez indicadas las propiedades, se debe llamar al método `AddFieldToModel()` de `TORMField()` para que lo añada correctamente

En el caso de que se quieran añadir más propiedades en el modelo, para que no interfieran en los datos propiamente dichos, deben ir precedidas de la doble línea inferior `__` por ejemplo:
~~~
CREATE CLASS Persona FROM TORMModel
  EXPORTED:
    DATA __DatoInterno AS NUMERIC INIT 0
ENDCLASS
~~~

#### Índices
de la misma forma, hay que definir los índices que tendrá el modelo:
~~~
WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
END
~~~

Las propiedades que puede tener un índice del modelo son:
- **cField**: Nombre del índice, ha de ser un campo definido en el modelo obligatoriamente
- **lIsPrimaryKey**: Indica si el índice es el primario, en caso contrario no hace falta indicar esta propiedad
- **cDescription**: Descripción del índice
- **lIsUnique**: Indica si el campo ha de ser único en la base de datos

El ORM está preparado para tener varios índices y también índices compuestos de varios campos como por ejemplo:

~~~
CREATE CLASS TestDoc FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

END CLASS

METHOD CreateStructure() CLASS TestDoc

    WITH OBJECT TORMField():New( Self )
        :cName   := 'SERIE'
        :cType   := 'N'
        :nLenght := 4
        :cDescription := 'Serie del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NUMERO'
        :cType   := 'N'
        :nLenght := 6
        :cDescription := 'Número del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'FECHA'
        :cType   := 'D'
        :cDescription := 'Fecha del documento'
        :AddFieldtoModel()
    END

    // Indices

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'STR(SERIE,4)+STR(NUMERO,6)'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'FECHA'
        :cDescription   := 'Fecha'
        :AddIndexToModel()
    END

Return ( Nil )
~~~

#### Llaves foráneas
Para mantener la integridad de la información, se puede configurar una o varias llaves foráneas en el modelo padre hacia el modelo hijo. En bases de datos SQL las llaves foráneas se definen en las tablas childs pero para mantener una compatibilidad con los ficheros DBF se ha incluido la definición de las llaves foráneas en las tablas padres, de este modo no se necesita una tabla auxiliar en la base de datos con la información de las relaciones de las llaves foráneas.
Actualmente solo se utilizan en el origen de datos DBF para la eliminación de las tablas Child cuando se elimina una tabla padre.
Como requisito imprescindible, el campo correspondiente a la llave foránea de ambas tablas relacionadas ha de ser **lprimarykey** en el índice

Teniendo en cuenta una base de datos con 2 tablas, una de facturas y otra de líneas de facturas, la definición de la llave foránea se realizaría en la tabla de facturas:
~~~
CREATE CLASS TestDoc FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

END CLASS

METHOD CreateStructure() CLASS TestDoc

    WITH OBJECT TORMField():New( Self )
        :cName   := 'SERIE'
        :cType   := 'N'
        :nLenght := 4
        :cDescription := 'Serie del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NUMERO'
        :cType   := 'N'
        :nLenght := 6
        :cDescription := 'Número del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    // Indices

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'STR(SERIE,4)+STR(NUMERO,6)'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

    // Llaves Foráneas

    WITH OBJECT TORMForeignKey():New( Self )
        :cModel         := 'TestDocLin'
        :cField         := 'STR(SERIE,4)+STR(NUMERO,6)'
        :AddForeignKeyToModel()
    END

Return ( Nil )
~~~

Y en la tabla de líneas de la factura no se le indicaría nada, simplemente ha de tener el primarykey como el mismo definido en la llave foránea de las facturas

~~~
CREATE CLASS TestDocLin FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

END CLASS

METHOD CreateStructure() CLASS TestDocLin

    WITH OBJECT TORMField():New( Self )
        :cName   := 'SERIE'
        :cType   := 'N'
        :nLenght := 4
        :cDescription := 'Serie del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'NUMERO'
        :cType   := 'N'
        :nLenght := 6
        :cDescription := 'Número del documento'
        :hValid   := { VALID_REQUIRED => 'si' }
        :AddFieldtoModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName   := 'ARTICULO'
        :cType   := 'C'
        :nLenght := 20
        :cDescription := 'Artículo del documento'
        :AddFieldtoModel()
    END

    // Indices

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'STR(SERIE,4)+STR(NUMERO,6)'
        :lIsPrimaryKey  := .T.
        :cDescription   := 'Orden principal'
        :AddIndexToModel()
    END

Return ( Nil )
~~~

A partir de esta configuración, cuando se elimine un registro de la tabla `TestDoc` mediante cualquier combinación del método `Delete()`, también se eliminarán los registros de `TestDocLin` que coincidan con la llave foránea. Este eliminado también se realiza si se ejecuta el comando `Delete()` sobre una colección de `TestDoc`

#### Recuperando información
Para cargar recuperar los datos de la base de datos y cargarlos en el modelo hay 2 formas. Mediante la obtención de un modelo o de varios modelos.
Cualquier acción que se realice para acceder a los datos de la BD, creará la tabla correspondiente en el caso de que no exista.

Los métodos `All()` y `Get()` son los que pueden devolver la colección, el resto devuelven solo un modelo. Cuando se utilizan `All()` y `Get()` se inyectan los datos recibidos a la colección que incorpora internamente el modelo y se pueden utilizar como una colección de datos. También modifican el estado del modelo según el éxito de la operación. Como parámetro se le puede indicar el formato del array que deseamos:

devuelve un Hash:
~~~
oPersonas:All( TORM_HASH )  
~~~

Devuelve un modelo:
~~~
oPersonas:Where( 'PESO', '<=', '90'):Get( TORM_MODEL ) 
~~~

TORM_HASH y TORM_MODEL están incluidas en TORM.ch

Para trabajar con el modelo, primero se tendrá que instanciar la clase y crear un objeto para poder trabajar con él:
~~~
oPersona := Persona():New()
~~~

#### Recuperando todos los registros
~~~
oPersona:All()
~~~

también es válida la siguiente forma:
~~~
oPersona := Persona():New():All()
~~~
en este caso, se crea la instancia y se ejecuta el método `All()` 

Los registros son cargados internamente en la colección de `oPersona` y pueden iterarse

#### Recuperando un registro por su índice principal
~~~
oPersona:Find( '123' )

? oPersona:NOMBRE
~~~

Cualquier método de búsqueda que se ejecuta dentro del objeto oPersona, carga los datos al propio objeto para poder utilizarlos posteriormente.

Si el índice principal es un índice compuesto, la búsqueda sería mediante un hash con la información a buscar:
partiendo del siguiente índice compuesto:
~~~
Str(SERIE,4)+Str(NUMERO,6)
~~~
realizando la siguiente búsqueda:
~~~
oFactura:Find( { 'SERIE' => 1, 'NUMERO' => 125 } )
~~~
Este código buscará la factura con serie 1 y número 125

Si por algún caso especial, se quiera realizar la búsqueda con anchos diferentes a los definidos en el índice, se pueden indicar mediante un array como en el siguiente ejemplo:
~~~
oFactura:Find( { 'SERIE' => { 1, 2 }, 'NUMERO' => { 125, 4 } } )
~~~
En este caso la cadena a buscar sería Str(SERIE,2)+Str(NUMERO,4)


#### Recupera un registro por su InternalDBID
~~~
oPersona:FindInternalID( 5 )
~~~
Recupera el registro cuya InternalDBID es 5

#### Recuperando una colección
~~~
oPersona:Where( 'PESO', '>=', '60' ):Get()
~~~

En el caso de que se desee recuperar los datos a partir de un índice compuesto, se puede aplicar la misma lógica que en el find:
~~~
oLineasFactura:Where( 'STR(SERIE,4)+STR(NUMERO,6)', { 'SERIE' => 1, 'NUMERO' => 1 } ):Get()
~~~
Este código recuperaría todas las líneas de la factura serie 1 número 1. Esto es más rápido que la siguiente consulta:
~~~
oLineasFactura:Where( { 'SERIE', 1 }, { 'NUMERO', 1 } } ):Get()
~~~
ya que en el siguiente ejemplo utilizará los índices configurados en el modelo y en el segundo realizará una búsqueda secuencial en el caso de que no exista ningún indice SERIE o NUMERO definidos en el modelo.

### End()
El método **End()** es muy aconsejable utilizarlo ya que libera la memoria que haya quedado utilizada por el modelo. En procesos donde se crean muchos modelos como iteraciones, boucles, etc..., aunque no sea aconsejable crearlos dentro de estas estructuras de control, es imprescindible llamar al método End() cuando se ha finalziado el uso del modelo.



### ESTADO DEL MODELO
El Modelo contiene un estado, en el caso de que la operación no haya sido satisfactoria por cualquier motivo ( en este caso podría ser que el código no existiera o un error al acceder a la base de datos ) cambia su estado y se complementa con un log de lo ocurrido. Las propiedades del estado del modelo son:
- **Success** Indica que la acción ha sido correcta
- **Fail** Indica que hay un error en la acción
- **LogToString** Devuelve una cadena con el error de la acción

~~~
If oPersona:Find( '123' ):Success
  
  ? oPersona:NOMBRE
  
Else

  ? 'No se encuentra el registro por el siguiente motivo: ' + oPersona:LogToString
  
Endif
~~~

#### ESTADO DE LOS CAMBIOS EN EL MODELO
El modelo puede indicar si sus datos han sido modificados desde que se recuperó la información de la base de datos

- **IsDirty()** Devuelve .T. si hay cambios en el modelo y .F. si no hay ningún cambio.
~~~
oPersona:Find( '123' )
oPersona:IsDirty()   // .F.
oPersona:NOMBRE := 'modificado'
oPersona:IsDirty()   // .T.
~~~

Se pueden pasar por parámetro los campos que deseemos comprobar:
~~~
oPersona:Find( '123' )
oPersona:IsDirty( 'NOMBRE' )   // .F.
oPersona:NOMBRE := 'modificado'
oPersona:IsDirty( 'NOMBRE' )   // .T.
oPersona:IsDirty( 'NOMBRE', 'CODIGO' )   // .T.
oPersona:IsDirty( 'CODIGO' )   // .F.
~~~

- **WasDifferent()** Indica mediante un objeto `TReturn()` si el modelo actual es diferente al que existe en la base de datos. En el Log del objeto devuelto, hay información sobre el tipo de diferencias.
~~~
oPersona := Persona:New( '123' )
oPersona:WasDifferent():Success()  // .F.
oPersona:NOMBRE := 'modificado'
oPersona:WasDifferent():Success()  // .T.
oPersona:Save()
oPersona:WasDifferent():Success()  // .F.
~~~

~~~
oPersona := Persona:New( '123' )
oPersona2 := Persona:New( '123' )
oPersona2:NOMBRE := 'modificado'
oPersona:WasDifferent():Success()  // .F.
oPersona2:Save()
oPersona:WasDifferent():Success()  // .T.
oPersona2:WasDifferent():Success()  // .F.
~~~

Esta información consulta el buffer inicial interno que se carga en el modelo cuando se instancia con los valores iniciales. Se puede desactivar la gestión de dicho buffer para optimizar el rendimiento.
~~~
oPersona:InitialBuffer:NoInitialBuffer()
~~~
desactiva el buffer inicial

mediante el método `oPersona:InitialBuffer:WithInitialBuffer()` se puede saber si un modelo tiene activado o no el buffer inicial



### CREACIÓN DE NUEVOS REGISTROS
El método `New()` crea una instancia del modelo en blanco y lo deja listo para añadir un registro nuevo en la base de datos, una vez asignados los valores con el método `Save()` se almacenan:
~~~
oPersona := Persona():New()
oPersona:CODIGO := '123'
oPersona:NOMBRE := 'Jose'

If oPersona:Save():Success

  ? 'Se ha creado el registro correctamente'
  
Else

  ? 'Ocurrió un problema añadiendo el registro' + oPersona:LogToString
  
Endif
~~~

Se pueden crear varios registros con el comando `Insert()` mediante un hash de datos:
~~~
oTestFicha:Insert({;
                    {'CODIGO'=>'111', 'NOMBRE'=>'Juan'},;
                    {'CODIGO'=>'222', 'NOMBRE'=>'Jose'},;
                    {'CODIGO'=>'333', 'NOMBRE'=>'Maria};
                  })
~~~

Se puede obtener un hash array con la estructura en blanco de un modelo mediante el siguiente código:
~~~
Persona:New():ToHash()
~~~

También se pueden indicar los campos que deseamos en la estructura en blanco:
~~~
Persona:New():Select( 'CODIGO', 'NOMBRE' ):ToHash()
~~~

En este caso se obtendría un registro en blanco de la estructura junto con sus relaciones:
~~~
Factura():New():Cliente():ToHash()
~~~
Esto puede resultar útil para la creación de objetos que necesiten la estructura sin necesidad de los datos, como por ejemplo un Browse. De este modo no se accede a la persistencia hasta que es necesario.


### MODIFICACIÓN DE REGISTROS
El método `find()` localiza un registro y lo carga en el modelo, posteriormente se pueden modificar los datos y con el método `Save()` guardarlo:
~~~
oPersona := Persona():New()
oPersona:Find( '123' )

// También es válido la siguiente forma
oPersona := Persona():New():Find( '123' ) 

If oPersona:Success

  oPersona:NOMBRE := 'Juan'
  
  If oPersona:Save():Success
  
    ? 'Se ha creado el registro correctamente'
    
  Else
  
    ? 'Ocurrió un problema modificando el registro' + oPersona:LogToString
    
  Endif
  
Else

  ? 'No se encuentra la persona con código 123'
  
Endif
~~~

Los datos pueden asignarse también mediante la carga de un Hash:
~~~
oPersona := Persona():New()
oPersona:Find( '123' )

If oPersona:Success

  oPersona:LoadFromHash( {;
                            'CODIGO' => '222',;
                            'NOMBRE' => 'Maria';
                          })

Endif
~~~

Se puede cargar la colección interna mediante un array de Hash, esto permite poder realizar iteraciones posteriores con la colección:
~~~
oPersona:LoadFromHashes( {;
                            { 'CODIGO' => '222', 'NOMBRE' => 'Maria' },;
                            { 'CODIGO' => '333', 'NOMBRE' => 'Jose' },;
                            { 'CODIGO' => '444', 'NOMBRE' => 'Juan' };
                          })
~~~
El modelo obtiene los datos del primer Hash del array, en este caso después de hacer el `LoadFromHashes()`el resultado del siguiente código:
~~~
? oPersona:CODIGO
~~~
sería 
~~~
222
~~~

También se puede realizar la misma carga de datos mediante Json con los métodos `LoadFromJson()` y `LoadFromJsons()` respectivamente.

El método `ToHash()` aplicado al modelo, devuelve los datos del modelo en un Hash. Teniendo en cuenta que tenemos un modelo cargado con CODIGO = 111 y NOMBRE = Juan, El resultado del siguiente código:
~~~
hData := oPersona:ToHash()
~~~
sería que hData obtendría el valor:
~~~
{ 'CODIGO' => '111', 'NOMBRE' => 'Juan' }
~~~

El métod `ToJson()` realiza la misma función que `ToHash()` pero devolviendo un Json


Se puede localizar un registro cuando se instancia el modelo
~~~
oPersona := Persona():New( '123' )
~~~

Las búsquedas del método `Find()` siempre se harán por el índice marcado como `lIsPrimaryKey`, si se desea buscar por cualquier otro campo del modelo se puede realizar pasando el nombre del campo como segundo parámetro:
~~~
oPersona:Find( 'Jose', 'NOMBRE' )
~~~
si existen varios registros en la tabla que cumplen la misma condición, cargará en el modelo el primer registro. Cuando se realiza un `Find()` por un campo que no está definido como índice en el modelo, puede ralentizarse en el caso de que hayan muchos registros en la tabla.

El método `First()` nos carga el primer registro de la tabla. Este método puede resultar útil para gestionar tablas de un único registro, aunque puede utilizarse igualmente para tablas con múltiples registros
~~~
oPersona:First()
oPersona:NOMBRE := 'Jose"
oPersona:Save()
~~~
este código obtendría el primer registro de la tabla y lo modificará.

Se le puede pasar como parámetro el orden que ha de aplicar para devolver el primer registro, si no se le pasa el orden utilizará el orden natural de la tabla.
~~~
oPersona:First( 'NOMBRE' )
~~~

El método `Last()` es una réplica del método `First()` pero devolviendo el último registro de la tabla. También se le puede pasar como parámetro el orden a aplicar.
~~~
oPersona:Last( 'NOMBRE' )
~~~


#### SaveCollection()
Este método nos almacenar en la persistencia los registros de la colección del modelo que hayan sido modificados. En el siguiente caso:
~~~
oPersona:All()
oPersona:GoTop()
While !oPersona:Eof()
  oPersona:PESO := 100
  oPersona:Skip()
Enddo
oPersona:SaveCollection()
~~~
modificará el peso de todos los registros de la tabla oPersona y los guardará en la persistencia. Esto se realiza con una sola solicitud a la base de datos.


#### SaveNewCollection()
Al igual que SaveCollection(), el método SaveNewCollection guarda la colección en la persistencia independientemente del estado de sus modelos. En el siguiente caso:
~~~
oPersona:All()
oPersona:GoTop()
oPersona:PESO := 100
oPersona:SaveCollection()
~~~
modificará el primer modelo de la colección sin tener en cuenta el resto, en cambio el siguiente caso:
~~~
oPersona:All()
oPersona:GoTop()
oPersona:PESO := 100
oPersona:SaveNewCollection()
~~~
"Duplicará" en la persistencia toda la colección con el PESO del primer modelo a 100.
SaveNewCollection() resulta útil para colecciones de datos creadas de nuevo, en el siguiente ejemplo se crea una colección de datos a partir de un Json, posteriormente se modifican datos y luego se guarda a la persistencia creando los registros nuevos.
~~~
oPersona:LoadFromJsons('[{"NOMBRE":"Jose"},{"NOMBRE":"Maria"}')
oPersona:GoTop()
oPersona:PESO := 80
oPersona:Skip()
oPersona:Peso := 81
oPersona:SaveNewCollection()
~~~


#### Update()
Permite actualizar masivamente registros:
~~~
?oPersona:Update( {'PESO'=> 100} )
~~~
modifica todos los registros del modelo oPersona asignando el peso a 100, imprime el nº de registros modificados

El método update se puede utilizar concatenando los métodos `Where()`, `OrWhere()` y `WhereIn()`
~~~
?oPersona:Where( 'CASADO', .T. ):Update( {'PESO'=> 100} )
~~~
modifica los registros cuyo campo CASADO sea .T. y les asigna el peso a 100

Se pueden realizar actualizaciones masivas más complejas
~~~
?oPersona:Where( { 'CASADO', .T.}, { 'EDAD', '>=', 18 ):Update( {'PESO'=> 100 } , { 'ALTURA' => 180 } )
~~~
modifica los registros cuyo campo CASADO sea .T. y la edad mayora a 18, les cambia el campo PESO y ALTURA

~~~
?oPersona:WhereIn( 'CODIGO', { '111', '555', '999' } ):Update( { PESO => 111 } )
~~~
Modifica el peso a los registros cuyo código sea 111, 555 o 999

También se pueden incluir codeblocks como valores a actualizar, esto permite ampliar exponencialmente las opciones de modificación de registros. En el siguiente ejemplo:
~~~
oPersona:Update( { 'NOMBRE' => {|| Upper(NOMBRE) } )
~~~
modifica el campo nombre con las mayúsculas.



### BORRADO DE REGISTROS
Mediante el método `Delete()` se puede eliminar un modelo pasando el valor del campo correspondiente al índice principal.
~~~
oPersona := Persona():New()
If oPersona:Delete( '123' ):Fail

  ? 'Error eliminando el registro:' + oPersona:LogToString
  
Else

  ? 'Registro eliminado correctamente'
  
Endif
~~~

Se puede eliminar grupos de registros:
~~~
oPersona:Delete( { '111', '222', '333' } ) 
~~~

Si previamente se carga un modelo, si se ejecuta el método `Delete()` el modelo será eliminado
~~~
oPersona:Find( '111' )
oPersona:Delete()
~~~
también sería válido:
~~~
oPersona:Find( '111' ):Delete()
~~~

### BORRADO DE COLECCIONES
Mediante el método `Where()` y `OrWhere` se puede eliminar una colección. La colección puede estar cargada previamente en el modelo mediante el método `Get()`
~~~
oPersona:Where( 'CODIGO', '>=', '333' ):Where( 'CODIGO', '<=', '888' ):Get()
oPersona:Delete()
~~~
Este código eliminaría todos los registros cuyos códigos estuviesen entre 333 y 888 ambos inclusive.

Ejecutando directamente el método `Delete()` junto con `Where()`se podría realizar la misma operación:
~~~
oPersona:Where( 'CODIGO', '>=', '333' ):Where( 'CODIGO', '<=', '888' ):Delete()
~~~


### BORRADO Y CREACIÓN SIMULTÁNEA
Los comandos delete e insert pueden ser utilizados juntos mediante el método `deleteandinsert()`. Esto nos permite realizar el volcado de varios registros previa eliminación de los existentes.

~~~
oPersona:DeleteandInsert( {'CODIGO', '>=', '333'}, { 'CODIGO' => '333', 'NOMBRE' => 'Lolo' } )
~~~

La inserción se realizará si el borrado inicial ha sido satisfactorio


### Carga desde origen
Existen varios métodos que permiten trabajar los modelos mediante un origen directo de datos, esto permite compatibilizar el ORM con otros sistemas de acceso para ayudar en la implementación.

#### LoadFromSource( xSource )
Carga los datos al modelo a partir de un origen. xSource puede ser un Alias de un DBF o un Query SQL. Actualmente solo es compatible con DBF
~~~
dbUseArea( .t., 'DBFCDX', cDbfFile, cAlias, .t., .f. )
(cAlias)->(DbSeek('333'))
oPersona := Persona():New()
oPersona:LoadFromSource( cAlias )
? oPersona:CODIGO
~~~
El resultado de este código sería 333
Se cargarán los datos del source que coincidan con el modelo.

#### LoadMultipleFromSource( xSource )
Permite la carga de colecciones a partir de un origen. xSource ha de ser un objeto que dependerá del tipo de origen. Actualmente solo es compatible con DBF
~~~
dbUseArea( .t., 'DBFCDX', cDbfFile, cAlias, .t., .f. )
oTestDoc := TestDoc():New()
oTestDoc:LoadMultipleFromSource( MDBFSeek():New( cAlias, TIndexMultiple():New( { 'SERIE' => { 1, 4 }, 'NUMERO' => { 1, 6 } }) , 'Str(SERIE,4)+Str(NUMERO,6)' )
~~~
Este código carga todas las líneas de cAlias cuya SERIE = 1 y NUMERO = 1 en la colección interna de oPersona.
`MDBFSeek()` es una estructura utilizada por `LoadMultipleFromSource` para encapsular la información que necesita este método para acceder a la información contenida en un fichero DBF


### Guardar directo a Origen
En ocasiones es necesario volver a persistir los datos cargados desde origen mediante los métodos `LoadFromSource()`y `LoadMultipleFromSource()`. Internamente el modelo almacena una referencia al registro de la tabla para su posterior actualización. En este caso los métodos para persistir los datos obtenidos son:

#### PutToSource( xSource )
Persiste el modelo al origen del mismo. xSource puede ser un Alias de un DBF o unQuery SQL. Actualmente solo es compatible con DBF
~~~
dbUseArea( .t., 'DBFCDX', cDbfFile, cAlias, .t., .f. )
(cAlias)->(DbSeek('333'))
oPersona := Persona():New()
oPersona:LoadFromSource( cAlias )
oPersona:NOMBRE := 'nuevo nombre'
If oPersona:PutToSource( cAlias ):Success
  ? 'los datos se han guardado correctamente'
Endif
~~~
Al tener el modelo un vínculo directo con el registro de la tabla, también se puede realizar un `PutToSource()` de un ítem de la colección obtenida mediante un `LoadMultipleFromSource`:

~~~
oTestDo := TestDoc():New()
dbUseArea( .t., 'DBFCDX', cDbfFile, cAlias, .t., .f. )
oTestDoc:LoadMultipleFromSource( MDBFSEek():New( cAlias, TIndexMultiple():New( { 'SERIE' => { 1, 4 }, 'NUMERO' => { 1, 6 } }), 'Str(SERIE,4)+Str(NUMERO,6)' ) )
oTestDoc:GoTop()
oTestDoc:Skip()
oTestDoc:ARTICULO := 'ARTMODIFICADO'
oTestDoc:PutToSource( cAlias )
oTestDoc:End()
(cAlias)->(DbCloseArea())
~~~
Este ejemplo modifica el código del artículo de la segunda línea de la colección y lo persiste en la base de datos.

####TIndexMultiple()
Clase que permite pasar los valores de índices compuestos en los casos concretos de carga y guardado a origen.
En el constructor New() se le pasará por hash los valores del índice compuesto. El orden de los valores ha de ser el mismo que el del índice compuesto.
Cada clave del hash contendrá un array con 2 valores, el primero es el valor de la variable y el segundo el ancho. La clave del item del hash es el nombre del campo.
En el siguiente ejemplo:
~~~
TIndexMultiple():New( { 'SERIE' => { 1, 4 }, 'NUMERO' => { 1, 6 } })
~~~
Se esta buscando en el índice compuesto Str(SERIE,4)+Str(NUMERO,6) los valores de serie = 1 y número = 1


### MÉTODOS DE CONSULTA
El ORM nos permite utilizar varios métodos para las consultas. Los métodos pueden concatenarse independientemente del orden. Para ejecutar la consulta el último método ha de ser el `get()`.
El resultado de estas dos consultas es el mismo:
~~~
oPersona:Where( 'NOMBRE', 'Juan' ):Select( 'CODIGO' ,'NOMBRE' ):Get()
~~~

~~~
oPersona:Select( 'CODIGO' ,'NOMBRE' ):Where( 'NOMBRE', 'Juan' ):Get()
~~~

#### WHERE
Indica el filtro para la recuperación de la colección.
Se le puede pasar una condición simple, con operador o un array de condiciones:

- ##### Condición simple:
~~~
oPersona:Where( 'NOMBRE', 'Juan' ):Get()
~~~
al no pasar un operador de condición, se tomará como `==`. En este caso cargará una colección en el modelo cuyos NOMBRE sean igual a Juan

~~~
oPersona:Where( 'PESO', '=>', '50' ):Get()
~~~
Devuelve todos los registros cuyo peso sea igual o superior a 50

~~~
oPersona:Where( {;
                  { 'CODIGO', '<', '999'},;
                  { 'PESO', '=>', '50' };
                 }):Get()
~~~
Devuelve todos los registros cuyo peso sea mayor o igual a 50 y el código menor a 999

También se puede realizar así:
~~~
oPersona:Where( 'CODIGO', '<', '999' ):Where( 'PESO', '=>', '50' ):Get()
~~~

Los operadores soportados por el método `Where()` son:
- **=** Igual que
- **==** Exactamente igual que
- **!=** **<>** **.Not.** Diferente de
- **>=** Mayor o igual que
- **<=** Menor o igual que
- **>** Mayor que
- **<** Menor que
- **%LIKE%** que contenga
- **LIKE%** que empiece por
- **%LIKE** que finalice por
- **%NOTLIKE%** que NO contenga
- **NOTLIKE%** que NO empiece por
- **%NOTLIKE** que NO finalice por

#### ORWHERE
Añade una condición adicional mediante el operador OR a la condición anterior
~~~
oPersona:Where( 'NOMBRE', 'Juan' ):OrWhere( 'PESO', '=>', 50):Get()
~~~
Esta consulta devolverá los registros cuyo nombre sean Juan **O** el peso sea superior a 50

El método Where acepta los mismos operadores que el where, también se puede pasar como parámetro un array de condiciones. Los array se anidarán por grupos de condiciones.
En el siguiente ejemplo:
~~~
oPersona:Where( {;
                  {'CODIGO', '==', '333' },;
                  {'PESO', 75};
                 });
        :OrWhere( {;
                   {'NOMBRE', 'Juan'},;
                   {'CASADO', .T.};
                 });
        :Get()
~~~                                  
Realizará una búsqueda mediante el siguiente código:
~~~
( CODIGO == '333' .AND. PESO == 75 ) .OR. ( NOMBRE == 'Juan' .AND. CASADO == .T. )
~~~


#### WHEREBETWEEN
indica que un valor debe estar entre dos condiciones.
~~~
oPersona:WhereBetween( 'CODIGO', { '111', '555' } ):Get()
~~~
Devolverá la colección de personas cuyo código esté entre 111 y 555 ambos inclusive.

#### WHEREIN
Este método es adicional al Where ya que permite devolver los registros cuyo campo de búsqueda se incluye en el array de valores:
~~~
oPersona:WhereIn( 'CODIGO', { '111', '555', '999' } ):Get()
~~~
Devuelve una colección de los registros cuyos códigos sean 111,555 y 999


#### SELECT
permite indicar los campos que se devolverán en la consulta. Si no se indica el método Select se devolverán todos los campos. Los campos han de ir entre comillas y separados por comas:
~~~
oPersona:Select( 'CODIGO', 'NOMBRE' ):All( TORM_HASH )
~~~
Carga todos los registros en la colección solo con el código y nombre y devuelve un hash con la colección y los dos campos.

Se pieden indicar alias de campos mediante `AS`
~~~
oPersona:Select( 'CODIGO AS COD', 'NOMBRE AS NOM' ):All( TORM_HASH )
~~~
Carga todos los registros en la colección solo con el código y nombre y devuelve un hash con la colección y los dos campos pero con las key's `COD`y `NOM`.

El orden de los Keys dentro del Hash devuelto, será el indicado en el método `Select()`

El método ´GetFieldsStr()´ devuelve una cadena con todos los campos indicados anteriormente por el select, si no se ha indicado ninguno devuelve todos los campos del modelo.
partiendo del siguiente código:
~~~
oPersona:Select( 'CODIGO', 'NOMBRE' ):All( )
~~~

el siguiente código
~~~
? oPersona:GetFieldsStr()
~~~
mostraría el siguiente valor:
~~~
'CODIGO,NOMBRE'
~~~

##### LoadLimits()
Este método realiza una consulta directa cargando en la colección 2 modelos, el primero y el último de la tabla. Resulta útil para tenerlo como ayuda a la hora de rellenar campos desde/hasta automáticamente.
~~~
oPersona:LoadLimits()   // Carga los 2 modelos en la colección
oPersona:GoTop()        // se posiciona en el primer modelo de la colección que corresponde al primer registro de la tabla
? oPersona:NOMBRE       // muestra el primer nombre de la tabla según el orden natural
oPersona:GoBottom()     // se posiciona en el segundo modelo de la colección que corresponde al último registro de la tabla
? oPersona:NOMBRE       // muestra el último nombre de la tabla según el orden natural
~~~

Este método optimiza la consulta ya que solamente realiza una lectura y apertura de la tabla para obtener la información.

Se le puede pasar el orden a utilizar para posicionarse en los límites de la tabla:
~~~
oPersona:LoadLimits('CODIGO')   // Carga los 2 modelos en la colección
oPersona:GoTop()                // se posiciona en el primer modelo de la colección que corresponde al primer registro de la tabla ordenada por código
? oPersona:NOMBRE               // muestra el primer nombre de la tabla según el orden de código
oPersona:GoBottom()             // se posiciona en el segundo modelo de la colección que corresponde al último registro de la tabla ordenada por código
? oPersona:NOMBRE               // muestra el último nombre de la tabla según el orden de código
~~~


##### Campos especiales:
- **TORM_SELECT_INTERNALDBID**: Devuelve el ID de la tabla. En el caso de ser tablas SQL, será el campo definido en `TORM.ch`. De tratarse de un fichero .DBF se aplica el valor del `Recno()` automáticamente.
~~~
aPersonas := oPersona:Select( 'CODIGO', 'NOMBRE', TORM_SELECT_INTERNALDBID ):All( TORM_HASH )
~~~
Devuelve el siguiente array aPersonas:
~~~
{
  {'CODIGO'=>'111', 'NOMBRE'=>'Juan',  'TORM_SELECT_INTERNALDBID'=> 1},;
  {'CODIGO'=>'222', 'NOMBRE'=>'Jose',  'TORM_SELECT_INTERNALDBID'=> 2},;
  {'CODIGO'=>'333', 'NOMBRE'=>'Maria', 'TORM_SELECT_INTERNALDBID'=> 3};
}
~~~


#### ORDERBY
Ordena la colección de la consulta, se le pueden pasar 2 parámetros:
- Campo a ordenar
- ASC : aplica el orden ascendente, si no se le pasa toma este por defecto, DESC aplica el orden descendente  Se pueden utilizar las constantes `TORM_ASC` y `TORM_DESC`
~~~
oPersona:Orderby( 'CODIGO' ):All()
~~~
devuelve la colección ordenada por el campo CODIGO ascendente
~~~
oPersona:Orderby( 'NOMBRE', TORM_DESC ):All( TORM_HASH )
~~~
devuelve un array de la tabla Persona con todos los datos ordenados por el campo NOMBRE descendente en formato Hash

#### TAKE
Limita el número de registros que se devolverán en la consulta
~~~
oPersona:Take( 3 ):Get()
~~~
Cargará los 3 primeros registros de la consulta en la colección.


#### OFFSET
Indica a partir de que registro ha de iniciar la consulta
~~~
oPersona:Offset( 10 ):Take( 5 ):Get()
~~~
Cargará los 5 primeros registros a partir del registro número 10

#### Persistencia de la consulta
Por defecto, cada vez que se ejecuta el método `Get()` en la consulta, se parte de los parámetros que se le han indicado al query con los diferentes métodos de consulta `Where()`, `OrderBy()`, `Take()`, etc... Se puede indicar al modelo que trabaje con una consulta persistente sin inicializar los parámetros en cada llamada al método `Get()`

~~~
oPersona:Where( 'PESO', '=>', '50' ):Get()
oPersona:Where( 'PESO', '<=', '100' ):OrderBy( 'NOMBRE' ):Get()
~~~
Estas dos consultas serán independientes ya que al finalizar el primer método `Get()` se inicializa la consulta ( query ) interno del modelo `oPersona`

Mediante el método `Query()` se puede activar y desactivar la persistencia de los parámetros de la consulta en el modelo:
- **PersistentOn()**: Activa la persistencia de la consulta en el modelo
- **PersistentOff()**: Desactiva la persistencia de la consulta en el modelo. Este método NO inicializa los parámetros de la consulta actual que tiene guardados el modelo, una vez ejecutado este método, los parámetros de la consulta serán inicializados inmediatamente después de la siguiente llamada al método `Get()`
- **Persistent()**: Devuelve el estado actual de la persistencia de la consulta en el modelo

~~~
oPersona:Where( 'PESO', '=>', '50' ):Query:PersistentOn():Get()
oPersona:Where( 'PESO', '<=', '100' ):OrderBy( 'NOMBRE' ):Get()
~~~
Ahora la segunda consulta también tendrá en cuenta las personas cuyo peso sea superior a 50 ya que se le ha activado la persistencia en los parámetros de la consulta

También se puede indicar de la siguiente forma:
~~~
oPersona:Query:PersistentOn()
oPersona:Where( 'PESO', '=>', '50' ):Get()
oPersona:Where( 'PESO', '<=', '100' ):OrderBy( 'NOMBRE' ):Get()
~~~

### LazyLoad
La carga diferida nos permite instanciar un modelo con una consulta pero sin que sea aplicada en la base de datos hasta que se ejecute un método que requiera la información. Una vez se haya adquirido la información, no se volverá a adquirir hasta que sea requerido por el método Reload(). Esto nos permite tener una caché de colecciones para la consulta sin tener que acceder a la base de datos aumentando la velocidad de proceso. Esta caché solamente se cargará si en algún momento de la aplicación es requerida, de lo contrario no será cargada, esto resulta útil para tablas de muy poco uso en las aplicaciones.

Instanciando con LazyLoad:
~~~
oPersonas := Persona():New():LazyLoad()
~~~
también es válido indicar el LazyLoad posteriormente al modelo:
~~~
oPersonas := Persona():New()
oPersonas:LazyLoad()
~~~
En ambos casos, se ha instanciado el modelo y se le ha indicado que a partir de ahora ha de trabajar con LazyLoad. Cualquier método que se aplica a oPersonas y necesite acceder a la base de datos, antes hará un `All()` y cargará la tabla en la colección interna del modelo, a partir de este momento ya no se volverá a acceder a la base de datos y todas las consultas se realizarán desde la colección interna del modelo:
~~~
oPersonas:Find( '111' )
~~~
Este código ejecutará `All()` y luego `Find( '111' )` sobre la colección cargada. Si se vuelve a realizar un `Find()` ya no ejecutará el método `All()` de nuevo.

Si se desea volver a cargar los datos de la base de datos en la colección interna del modelo:
~~~
oPersonas:Reload()
~~~

Se puede aplicar el método `Where()` al modelo para indicarle una condición a los datos que serán cargados en el `LazyLoad()`:
~~~
oPersonas := Persona():New()
oPersonas:Where( 'PESO', '=>', 50):LazyLoad()
~~~
Cuando se requiera la información, en la colección de oPersonas solamente se cargarán los registros cuyo PESO sea igual o mayor a 50

#### LazyLoadShared
Con este método se comparte la carga diferida de modelos instanciados anteriormente para optimizar aún más el acceso a la persistencia.

LazyLoadShared() tiene el mismo funcionamiento que LazyLoad() con la salvedad que comparte la colección.

En el siguiente caso:
~~~
oPersonas := Persona():New():LazyLoadShared()
~~~
No hay acceso a la persistencia hasta que se realice una consulta

La siguiente instrucción cargará la información en la colección del modelo para utilizarla a partir de ahora desde su caché
~~~
oPersonas:Find( '111' )
~~~

Si posteriormente instanciamos de nuevo el modelo:

~~~
oPersonas := Persona():New():LazyLoadShared()
oPersonas:Find( '111' )
~~~

En este caso, el find ya no realizará ninguna consulta a la persistencia ya que se ha realizado anteriormente.

Si después de un LazyLoadShared() se instancia un modelo con LazyLoad(), esta caché no será compartida con el resto de modelos ni cargará el contenido de los anteriore, será independiente.

En el caso del siguiente código:
~~~
oPersonas := Persona():New():LazyLoadShared()
oPersonas:Find( '111' )
oPersonas2 := Persona():New():LazyLoad()
oPersonas2:Find( '111' )
~~~
Ambos Find accederán a la persistencia ya que oPersonas2 no comparte la caché con oPersonas


#### LazyLoadPessimist
Activa la carga diferida pero en modo pesimista. Significa que cada vez que se llame a un método que requiera información, después de la primera carga, leerá el origen de datos y comparará si tiene las mismas características que en la primera carga. Si coinciden, tomará los datos que ya hay cargados en la colección del modelo para devolver la información, tal y como hace con el LazyLoad normal, pero si detecta algún cambio, hará un Reload() antes de procesar la información a devolver de nuevo.

Esto perjudica el rendimiento pero en un porcentaje muy bajo ya que solamente consulta la siguiente información en el origen de datos y suele ser muy rápido: 
- Tamaño del origen de datos
- Fecha y hora del origen de datos

En el siguiente ejemplo se muestra en comentarios como funciona el LazyLoadPessimist:
~~~
oTestFicha1 := TestFicha():New()
oTestFicha2 := TestFicha():New()

oTestFicha2:LazyLoad() 

oTestFicha1:Insert({;
                        {'CODIGO'=>'111', 'NOMBRE'=>'Jose'},;
                        {'CODIGO'=>'222', 'NOMBRE'=>'Maria'};
                    })

oTestFicha2:Find( '111' )       // Hago ahora el Find para que haga la primera carga de la colección como lazyload

oTestFicha1:Find( '111' )
oTestFicha1:NOMBRE := 'Pepito'
oTestFicha1:Save()

oTestFicha2:Find( '111' )       // Al estar el lazyload normal, no ha recargado ya que no detecta modificación en el source
? oTestFicha2:NOMBRE()          // la salida será 'Jose'
    
oTestFicha2:LazyLoadPessimist() // Cuando le activo el pesimist, la próxima vez comprobará si se han echo cambios y entonces verá que sí y hará un reload()
oTestFicha2:Find( '111' )  
? oTestFicha2:NOMBRE()          // la salida será 'Pepito'
~~~

### VALIDACIONES
El ORM puede contener validaciones en cada campo para aumentar la integridad de la información. El método `Valid()` ejecuta las validaciones de todos los campos del modelo y cambia el estado del mismo según si el resultado es correcto o no.
~~~
oPersona:Valid() // también se puede hacer: oPersona:Valid():Success
If oPersona:Success
  ? 'los datos son correctos'
Endif
~~~

Las Validaciones se configuran en la definición del campo mediante un Hash:
~~~
WITH OBJECT TORMField():New( Self )
  :cName   := 'PESO'
  :cType   := 'N'
  :nLenght := 3
  :cDescription := 'Peso en Kg.'
  :hValid  := { VALID_RANGE => '10,120'}
  :AddFieldToModel()
END 
~~~
*Nota: para el correcto funcionamiento hay que incluir Validation.ch en el modelo*

En este caso se le indica que el peso ha de estar entre 10 y 120. Partiendo de esta premisa el siguiente código cambiaría el estado del modelo a Fail
~~~
oPersona:PESO := 9
If oPersona:Valid():Fail
  ? 'El peso es incorrecto'
Endif
~~~


Existen los siguientes tipos de Validaciones:
- **VALID_RANGE** : Permite indicar un rango, se indica mediante dos valores separados por coma 
- **VALID_MIN** : indica el valor mínimo
- **VALID_MAX** : Indica el valor máximo
- **VALID_EXISTS** : Se aplica 'si' o 'no' y comprueba la existencia del valor en la tabla
- **VALID_REQUIRED** : Indica que el campo es obligatorio, en caso de estar vacío el estado del modelo pasaría a fail
- **VALID_EMAIL** : El campo ha de contener un email correcto. Si está vacío no pasa el estado del modelo a fail
- **VALID_LENGHT** : Indica el tamaño máximo del campo

se pueden configurar validaciones múltiples:
~~~
WITH OBJECT TORMField():New( Self )
  :cName   := 'PESO'
  :cType   := 'N'
  :nLenght := 3
  :cDescription := 'Peso en Kg.'
  :hValid  := { ;
                 VALID_RANGE => '10,120',;
                 VALID_REQUIRED => 'si';
               }
  :AddFieldToModel()
END
~~~

~~~
WITH OBJECT TORMField():New( Self )
  :cName   := 'EMAIL'
  :cType   := 'C'
  :nLenght := 250
  :cDescription := 'Dirección de correo electrónico'
  :hValid  := { ;
                 VALID_REQUIRED => 'si',;
                 VALID_EXISTS => 'no',;
                 VALID_EMAIL => 'si';
               }
  :AddFieldToModel()
END
~~~

Cuando se crea la estructura del modelo mediante los campos definidos en el método `CreateStructure()`, se configuran las validaciones mínimas automáticamente:
- Campos carácter: VALID_LENGHT => nLenght
- Campos Numéricos: VALID_RANGE => rango máximo aceptado

El Método valid permite pasar por parámetro un array de los campos a validar en el caso de que no se desee validar todo el modelo:
~~~
oPersona:Valid( { 'EMAIL', 'PESO' } )
~~~
En este caso solamente validaría los campos de Email y Peso

En el caso de los campos carácter, se puede desactivar la validación del tamaño para evitar que cuando se guarda a la persistencia una cadena más larga del ancho del campo, que pase igualmente y guarde la cadena ajustada al tamaño del campo en la persistencia. Para este comportamiento se utiliza el método `SoftValidationString()`. Si se le pasa .T. activa una validación "blanda" para que no de fallo al validar un campo carácter que sea mayor al tamaño del campo, .F. lo desactiva.
Al instanciar el modelo, por defecto este valor está en .T.
Teniendo un ancho de 100 al campo nombre, el siguiente código pasaría la validación:
~~~
oPersona:NOMBRE := Replicate('a',101)
oPersona:Valid()  // devolvería verdadero
oPersona:SoftValidationString( .F. )
oPersona:Valid()  // devolvería falso
~~~


### COLECCIONES
Una colección es un conjunto de modelos cargados en el propio modelo mediante los métodos `Get()` o `All()`. Se puede iterar en la colección y el modelo tendrá el valor del Item actual de la colección. Cuando se itera en la colección, la información del item actual de la colección siempre está cargada en el modelo.

Los siguientes métodos permiten iterar por la colección:
- **GoTop()** : Se sitúa en el primer registro 
- **GoBottom()** : Se sitúa en el último registro
- **Skip( nJump )** : Desplaza nJump items, si no se le pasa nJump salta 1 item

Los siguientes métodos devuelven información sobre la colección:

- **Len()** : Devuelve el nº de items 
- **Eof()** : Indica si se ha llegado al final de la colección
- **Bof()**: Indica si se ha llegado al principio de la colección
- **Position()** : Devuelve la posición actual en la colección
- **Empty()** : Si no hay datos cargados, ( Len() == 0 )
- **Refresh()** : Recarga los datos del item actual de la colección al modelo, este método se ejecuta siempre que se ejecuta cualquier método de desplazamiento.
- **GetCollection()** : Devuelve un array con toda la colección
- **__Find( xFindValue, cOrder)** : Busca un modelo en la colección 
- **__FindFirstBigger( xFindValue, cOrder)** : Busca el primer modelo que mayor a xFinValue.
- **__First()** : Devuelve el primer modelo de la colección
- **Inject( aData )** : Inserta los valores de aData en la colección. aData puede ser un modelo o un array de modelos
- **HasCollection()** : Indica si se ha cargado la colección. Puede ocurrir el caso de que `Len()` devuelva 0 pero `HasCollection()` verdadero ya que se ha intentado cargar una colección pero sin datos en el origen, por ejemplo una factura que no tiene líneas.
- **Sort( cOrder )** : Ordena la colección por el campo cOrder
- **ToHashes()**: Devuelve un array de los modelos de la colección convertidos a Hash
- **ToJsons()**: Devuelve un Json con la información de los modelos de la colección
- **ToArray( cFields )** : Devuelve un array de los modelos de la colección. Se le puede indicar cFields para indicar los campos que se quieren incluir en el array devuelto. Si no se le pasa los incluye todos.
- **Initialize()** : Elimina la colección del modelo
- **Eval( bBlock )** : Evalúa cada Item de la colección. El codeblock bBlock recibe como parámetro el item. El siguiente ejemplo cambia el valor `NOMBRE` de todos los modelos de la colección. Si no ocurre ningún error, devuelve .T.
~~~
oPersona:Eval( { | oItem | oItem:NOMBRE := 'Modificado' } )
~~~
 
El siguiente ejemplo carga toda la tabla Personas en la colección del modelo y la itera para mostrar todos sus registros
~~~
oPersonas:All()
oPersonas:GoTop()

While !oPersonas:Eof()

  ? oPersonas:NOMBRE
  
  oPersonas:Skip()
  
Enddo
~~~
Nota: Después de cargar una colección con los métodos `Get()` o `All()` en el modelo se carga el primer registro de la colección.

### PAGINACIÓN
Para poder utilizar el orm en grids de datos, se incorpora una paginación que funciona a partir del método `Pagination()` que gestiona internamente el objeto de la paginación. La paginación se realiza en base a la última consulta que se ha realizado en el modelo mediante los métodos `Get()` o `All()`.

El método `Pagination()`se utiliza junto con los siguientes métodos:
- **SetRowsxPage()** Indica el número de filas que tendrá la página
- **GoTop()** Carga en la colección del modelo los registros de la primera página.
- **GoBottom()** Carga en la colección del modelo los registros de la última página.
- **NextPage()** Desplaza a la siguiente página y carga en la colección del modelo los registros de la nueva página.
- **PRevPage()** Retrocede a la página anterior y carga en la colección del modelo los registros de la nueva página.
- **RecCount()** Devuelve el número de registros que tiene la consulta.
- **GetActualPageNumber()** Devuelve el número de página actual.
- **GetLastPageNumber()** Devuelve el número de la última página, por lo tanto el número de páginas totales de la consulta.
- **Refresh()** Refresca el contenido de la colección en la página actual

Partiendo de la siguiente consulta
~~~
oPersona:Where( 'CODIGO','>','10'):SELECT('CODIGO','NOMBRE'):Get()
~~~

Podemos paginar del siguiente modo:
~~~
oPersona:Pagination:SetRowsxPage( 25 )
oPersona:Pagination:GoTop()
~~~
este código indica que se trabajará con 25 registros por página y carga en la colección del modelo los registros de la primera página. 

~~~
oPersona:Pagination:GoTop()
For nCount := 1 To oPersona:Pagination:GetLastPageNumber()

  aCollection := oPersona:GetCollection()
  // procesar lo que se desee con la colección que es el resultado de la página actual
  oPersona:Pagination:NextPage()

Next
~~~
El código anterior recorre todas las páginas obteniendo la colección de registros de cada página para procesar lo que se desee.

~~~
oPersona:Pagination:Refresh()
~~~
Este código recarga la colección con los datos de la persistenca en la página actual


### RELACIONES
Uno de los puntos más importantes de un ORM son las relaciones entre modelos tal y como indica su nombre. Se pueden definir varios tipos de relaciones:

#### HasOne
Esta es una relación **1 a 1** y se define en el modelo como un método más:

~~~
METHOD Cliente() CLASS Factura

    ::HasOne( mClientes():New( ::CODCLI ), 'CODCLI' )

Return ( Self )
~~~

En este código, estamos indicando que el método `Cliente()` del modelo `Factura()` relaciona el campo `CODCLI` del modelo `Factura()` con el modelo `mClientes` mediante el Primary Key de `mClientes`. Dicho modelo de clientes se incluirá en el modelo factura como la DATA `oCliente`.
Por defecto se añade una `o` delante del nombre del método para crear el nombre del DATA, de este modo no chocará con el nombre de los DATA, no obstante este prefijo puede ser modificado en `TORM.ch` con la constante `TORM_PREFIX_RELATION`

Hay que instanciar la clase `mClientes` pasando en el método constructor `New()` el valor de búsqueda del cliente, que en este caso es el código de cliente del modelo factura `::CODCLI`

De este modo, partiendo del siguiente código:
~~~
oFactura := Factura():New( xvalordebúsqueda ):Cliente()
~~~

Tendremos disponible los datos del cliente dentro de `oFactura`
~~~
? oFactura:oCliente:NOMBRE
~~~

Se puede modificar el nombre que tendrá la relación dentro del modelo mediante un tercer parámetro:
~~~
METHOD Cliente() CLASS Factura
    ::HasOne( mClientes():New( ::CODCLI ), 'CODCLI', 'elcliente )
Return ( Self )
~~~
en este caso, el modelo devuelto se utilizaría de la siguiente forma:
~~~
? oFactura:elcliente:NOMBRE
~~~



Las relaciones también son aplicables a las colecciones, de tal forma con el siguiente código:
~~~
oFacturas := Factura():New():Cliente():All()
~~~

Nos cargará la colección de todas las facturas en oFactura con los datos de cada cliente pudiendo iterar con el siguiente código de ejemplo:
~~~
for each oFactura in oFacturas
  ? oFactura:oCliente:NOMBRE
next
~~~

Un método permite múltiples relaciones:
~~~
METHOD Cliente() CLASS Factura
    ::HasOne( mClientes():New( ::CODCLI ) , 'CODCLI' )
Return ( Self )

METHOD Formapago() CLASS Factura
    ::HasOne( mFormaPagos():New( ::CODFPA ), 'CODFPA' ) 
Return ( Self )

METHOD Representante() CLASS Factura
    ::HasOne( mRepresentantes():New( ::CODREP ), 'CODREP' ) 
Return ( Self )
~~~

teniendo en cuenta la definición anterior, podemos instanciar el modelo de factura con todas las relaciones de la siguiente forma:
~~~
oFactura := Factura():New( xvalordebúsqueda ):Cliente():Formapago():Representante()
~~~

el objeto oFactura tendrá la información de las formas de pago, representantes y clientes para acceder de la siguiente forma:
~~~
? oFactura:oCliente:NOMBRE, oFactura:oFormapago:NOMBRE, oFactura:oRepresentante:NOMBRE
~~~

En el caso de que las relaciones tengan los mismos campos, cuando se pide el modelo en formato Hash, se pueden modificar las relaciones para asignar un alias a los campos:
~~~
METHOD Representante() CLASS Factura
    ::HasOne( mRepresentantes():New( ::CODREP ):Select( 'CODIGO AS CODREP', 'NOMBRE AS NOMREP' ), 'CODREP' )
Return ( Self )

METHOD Cliente() CLASS Factura
    ::HasOne( mClientes():New( ::CODCLI ):Select( 'CODIGO AS CODCLI', 'NOMBRE AS NOMCLI'  ) , 'CODCLI' )
Return ( Self )
~~~
De este modo, en el hash devuelto las keys correspondientes a la información de los clientes y representantes sería `CODREP, NOMREP, CODCLI, NOMCLI`


Si un modelo tiene varias relaciones, no es obligatorio instanciarlo con todas ellas, solamente con las relaciones de los datos que deseemos.

Cuando es habitual utilizar varias veces el mismo grupo de relaciones al instanciar el modelo, se pueden crear métodos que agrupen relaciones. Partiendo de la base del ejemplo anterior:
~~~
METHOD Personas() CLASS Factura
    ::Cliente()
    ::Representante()
Return ( Self )
~~~
A partir de este método, el siguiente código:
~~~
oFactura := Factura():New( xValorbusqueda ):Personas()
~~~

cargaría las relaciones de `Cliente()` y `Representante()`

El sistema permite tener tantos métodos de agrupación de relaciones como se desee. También se pueden crear métodos que contengan otros métodos de agrupaciones:

~~~
METHOD AllRelations() CLASS Factura
  ::Personas()
  ::Formapago()
Return ( Self )
~~~

Por convención, todos los métodos de relaciones deben devolver el mismo objeto `Self`

Se puede indicar las columnas que se desean mostrar en la relación mediante el método `Select()`
~~~
METHOD Cliente() CLASS Factura
    ::HasOne( mClientes():New( ::CODCLI ):Select( 'NOMBRE', 'DIRECCION' ) , 'CODCLI' ) 
Return ( Self )
~~~

El siguiente código:
~~~
oFactura:= Factura():New( xValorbusqueda ):Cliente()
hFactura := oFactura:ToHash()
~~~

Asignaría un hash a `hFactura` con el siguiente contenido:
~~~
{ 'SERIE'=>99, 'NUMERO' => 9999, ... resto de datos de la factura ..., 'NOMBRE'=> 'nombre del cliente', 'DIRECCION'=> 'direccion del cliente }
~~~
el resto de datos del modelo del cliente no serían incluidos.

Se le pueden pasar parámetros a los métodos `HasOne()` de un modelo:
~~~
METHOD Cliente( ... ) CLASS Factura
    ::HasOne( mClientes():New( ::CODCLI ):Select( ... ) , 'CODCLI' ) 
Return ( Self )
~~~

de este modo, se puede realizar la misma llamada que el ejemplo anterior pero indicando los campos que deseamos del modelo cliente en el mismo momento de la consulta:
~~~
oFactura:= Factura():New( xValorbusqueda ):Cliente( 'NOMBRE', 'DIRECCION' )
hFactura := oFactura:ToHash()
~~~

####LazyLoad
Se pueden configurar las relaciones con LazyLoad para mejorar el rendimiento de la aplicación mediante la caché. En el ejemplo anterior, podemos configurar el modelo de factura para que los clientes se aplique una carga Eager ya que pueden haber muchos y la tendencia a que hayan cambios habitualmente es más alta, y las formas de pago y representantes se aplique Lazy ya que apenas sufren cambios. La forma de configurarlo sería la siguiente:
~~~
METHOD Cliente() CLASS Factura
    ::HasOne( mClientes():New( ::CODCLI ) , 'CODCLI' )
Return ( Self )

METHOD Formapago() CLASS Factura
    ::HasOne( mFormaPagos():New( ::CODFPA ):LazyLoad(), 'CODFPA' ) 
Return ( Self )

METHOD Representante() CLASS Factura
    ::HasOne( mRepresentantes():New( ::CODREP ):LazyLoad(), 'CODREP' ) 
Return ( Self )
~~~

Un caso más complejo de relación HasOne, se podría dar en una tabla de artículos que tiene relacionada una tabla de stock por almacenes, un registro de artículo, puede tener tantos registros de stock por almacenes como almacenes existan.

El modelo del artículo sería el siguiente:
~~~
CREATE CLASS Articulo FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()
        METHOD StockAlmacen()

ENDCLASS 

METHOD StockAlmacen( cAlmacen ) CLASS Articulo

    ::HasOne( Stock():New( ::ALM + ::cAlmacen ):Select('ALMACEN AS ALM' + cAlmacen, 'CANTIDAD AS STK' + cAlmacen), TIndexMultiple():New( { 'CODIGO' => { '', 10, .t. }, 'ALMACEN' => { cAlmacen, 10 } } ) , 'alm'+cAlmacen ) 

Return ( Self )

METHOD CreateStructure() CLASS Articulo

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código del articulo'
        :AddFieldToModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName  := 'NOMBRE'
        :cType  := 'C'
        :nLenght:= 100
        :cDescription := 'Nombre del Artículo'
        :AddFieldToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO'
        :lIsPrimaryKey  := .T.
        :AddIndexToModel()
    END

    WITH OBJECT TORMForeignKey():New( Self )
        :cModel         := 'Stock'
        :cField         := 'ARTICULO'
        :AddForeignKeyToModel()
    END

Return ( Nil )
~~~

El modelo del stock por almacenes sería el siguiente:
~~~
CREATE CLASS Stock FROM TORMModel

    EXPORTED:
        METHOD CreateStructure()

ENDCLASS 

METHOD CreateStructure() CLASS  Stock

    WITH OBJECT TORMField():New( Self )
        :cName  := 'CODIGO'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código del articulo'
        :AddFieldToModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName  := 'ALMACEN'
        :cType  := 'C'
        :nLenght:= 10
        :cDescription := 'Código del Almacén'
        :AddFieldToModel()
    END

    WITH OBJECT TORMField():New( Self )
        :cName        := 'CANTIDAD'
        :cType        := 'N'
        :nLenght      := 10
        :nDecimals    := 2
        :cDescription := 'Stock articulo'
        :AddFieldToModel()
    END

    WITH OBJECT TORMIndex():New( Self )
        :cField         := 'CODIGO+ALMACEN'
        :lIsPrimaryKey  := .T.
        :AddIndexToModel()
    END

Return ( Nil )
~~~

Si queremos obtener una consulta con X artículos y los stocks de los almacenes 001, 002 y 003:
~~~
Articulo():New( ):Select('CODIGO AS COD','NOMBRE'):StockAlmacen( '001' ):StockAlmacen( '002' ):StockAlmacen( '003' ):All( TORM_HASH )
~~~

Esto nos devolverá un Hash con el contenido de todos los artículos y sus almacenes y stocks, por ejemplo:
~~~
COD NOMBRE ALM001 STK001 ALM002 STK002 ALM003 STK003
111 ART1      001     25    002      3    003      5
222 ART2                    002     50    003     10
333 ART3      001     15
~~~
Los nombres de las columnas los monta según lo indicado en el métod HasOne del modelo Articulo.



#### HasMany

Esta es una relación **1 a n** y se define en el modelo como un método más
~~~
METHOD Lineas() CLASS Factura
  ::HasMany( mLineas():New(), xValorRelacional )
Return ( Self )
~~~
El funcionamiento es igual que el método `HasOne()` pero en este caso cargará una colección en `oFactura:oLineas` con todas las coincidencias de xValorRelacional

De este modo, partiendo del siguiente código:
~~~
oFactura := Factura():New( xValordebusquda ):Lineas()
~~~

Tendremos disponibles todas las líneas de la factura en la colección del objeto oFactura:oLineas
~~~
for each oLinea in oFactura:oLineas
  ? oLinea:ARTICULO
next
~~~

Se pueden utilizar métodos `HasOne` y `HasMany` en la misma consulta:
~~~
oFactura := Factura():New( xValordebusquda ):Lineas():cliente()
~~~
Este código nos creará un objeto oFactura con los campos de la factura y a su vez un oLineas con todas las líneas y un oCliente con todos los datos del cliente


### Log
El modelo de datos hereda de la clase `TLog` que permite ver en tiempo real las acciones que se están realizando.
Para activar el log en un modelo hay que ejecutar el método `LogActivate()`
~~~
oFactura:LogActivate()
~~~
Esto creará un fichero `log.log` con todo el detalle de lo que se está realizando dentro del modelo `oFactura`

También se puede activar un log global que afecte a todos los modelos instanciados mediante el método `LogGlobalActivate()`

Se puede forzar un mensaje personalizado en el log mediante el método `logwrite()`
~~~
oFactura:LogWrite( 'Hola' )
~~~
Esto creará una línea en el log en el momento exacto que se ejecuta este método con el texto `Hola`

El método `LogDelete()` Elimina el fichero utilizado para almacenar el log.


### MÉTODOS DE BD
Se permite realizar algunas acciones con la base de datos mediante los siguiente métodos:

#### Elimina la tabla
El método `DropTable()` elimina la tabla de la base de datos:
~~~
Persona:New():DropTable()
~~~

#### Contar los registros de una tabla
El método `RecCount()` devuelve el número de TODOS registros que se encuentran an la tabla
~~~
Persona:New():RecCount()
~~~

Si se desea averiguar los registros de una consulta se puede utilizar la función `Count()` ya que tiene en cuenta los filtros indicados en `Where` y `WhereIn`
~~~
? oPersona:Where( 'PESO', '=>', 50 ):Count()
~~~

#### Chequear una tabla
El método `CheckSource()` comprueba que la tabla tenga todos los campos y que sean de tipo y ancho correcto, según las especificaciones del modelo.
Si hay algo incorrecto, cambiará el estado del modelo a Fail()
~~~
oPersona:CheckSource()
~~~

si hay algo mal, `oPersona:Fail()` pasaría a verdadero y `oPersona:Success()` a falso

#### Estructura de un modelo en String
Mediante el método `GetStructureStr()` obtenemos un array con los campos de un modelo y sus propiedades.
~~~
oPersona:GetStructureStr()
~~~
Devuelve un array con la siguiente información:
~~~
{ 'CODIGO,C,10,0,Código de la ficha,          ,{=>}','NOMBRE,C,100,0,Nombre de la ficha,          ,{=>}' }
~~~

Vemos que hay un espacio en blanco y una referencia a un hash, esto es por las propiedades `uDefault` y `hValid`

Se pueden indicar las propiedades que deseamos y el orden de las mismas:
~~~
oPersona:GetStructureStr( 'cDescription', 'cType', 'nLenght', 'nDecimals' )
~~~
Devuelve un array con la siguiente información:
~~~
{ 'Código de la ficha,C,10,0', 'Nombre de la ficha,C,100,0' }
~~~

#### Estructura de un modelo
El método `GetStructure()` devuelve un array de objetos TORMField con componen el modelo

~~~
oPersona:GetStructure()
~~~

### Saber si el modelo tien un campo en su estructura
El método `HasField( cField )` devuelve verdadero si el modelo contiene el campo cField

~~~
oPersona:HasField( 'CODIGO` )  // devuelve .T.
oPersona:HasField( 'NOEXISTE` )  // devuelve .F.
~~~

### Obtener el nombre del campo según su descripción
El método `GetORMFieldofDescription( cDescription )` devuelve el objeto TORMField del modelo según la descripción del campo. Si la descripción no corresponde a ningún campo, devuelve Nulo

~~~
oPersona:GetORMFieldofDescription( 'Código de la persona' )  // devuelve un objeto TORMField del campo CODIGO
~~~

~~~
oPersona:GetORMFieldofDescription( 'este campo no existe' )  // devuelve Nil
~~~
