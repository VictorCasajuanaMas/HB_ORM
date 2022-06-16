#DEFINE TORM_DATASOURCE_DBF            'DBF'
#DEFINE TORM_DATASOURCE_ADODBF         'ADODBF'
#DEFINE TORM_DATASOURCE_COLLECTION     'COLLECTION'
#DEFINE TORM_DATASOURCEDEFAULT         TORM_DATASOURCE_DBF
#DEFINE TORM_PRIMARYKEYDEFAULT  TORMField():New():Set( 'CODIGO', 'C', 10, , 'LLave Primaria' )

#DEFINE TORM_MODEL                     'MODEL'
#DEFINE TORM_HASH                      'HASH'

#DEFINE TORM_INTERNALDBID              'INTERNALDBID'

#DEFINE TORM_DESC                      'DESC'
#DEFINE TORM_ASC                       'ASC'

#DEFINE TORM_PREFIX_RELATION           'o'
#DEFINE TORM_RELATION_HASONE           'HASONE'
#DEFINE TORM_RELATION_HASMANY          'HASMANY'

#DEFINE TORM_SELECT_INTERNALDBID       'TORM_SELECT_INTERNALDBID'

#DEFINE TORM_AS                        ' AS '

#DEFINE TORM_SOFTSEEK                  .T.

#DEFINE TORM_WHERE_FIELD               1
#DEFINE TORM_WHERE_CONDITION           2
#DEFINE TORM_WHERE_VALUE               3

#DEFINE TORM_LAZYSHARED               '__OLAZYLOADSHARED'

#DEFINE TORM_OR                       'OR'
#DEFINE TORM_AND                      'AND'

#DEFINE TORM_LOG_LEVEL_INFO         'INFO'
#DEFINE TORM_LOG_LEVEL_PERSISTENCE  'WARN'
#DEFINE TORM_LOG_LEVEL_DEBUG        'DEBUG'
#DEFINE TORM_LOG_LEVEL_ERROR        'ERROR'

#DEFINE TORM_WARNING_MESSAGE    {;
                                    01 => {'[Warning] 001 No se ha encontrado el registro $1 en la colección de $2',{'$1','$2'}},;
                                    02 => {'[Warning] 002 No se ha encontrado el registro $1 en la colección de $2',{'$1','$2'}},;
                                    03 => {'[Warning] 003 No se ha encontrado el primer registro en la colección $1',{'$1'}},;
                                    04 => {'[Warning] 004 No se ha encontrado el primer registro en la colección $1',{'$1'}};
                                }

#DEFINE TORM_ERROR_MESSAGE    {;
                                01 => { '[Error] 001 Parámetros incorrectos en WhereIn de $1', '$1' },;
                                02 => { '[Error] 002 cargando hash al modelo $1 $2', '$1 $2' },;
                                03 => { '[Error] 003 El valor que se le ha pasado no es un Hash $1', '$1' },;
                                04 => { '[Error] 004 Ocurrió un problema cargando los Hashes a la colección de modelos $1', '$1' },;
                                05 => { '[Error] 005 El valor que se le ha pasado no es un array $1', '$1' },;
                                09 => { '[Error] 009 No se puede cerrar el alias: $1', {'$1'}},;
                                10 => { '[Error] 010 Indice no se ha creado: $1 $2', {'$1','$2'}},;
                                11 => { '[Error] 011 No se ha creado la tabla: $1', {'$1'}},;
                                12 => { '[Error] 012 No se ha podido crear el registro nuevo (Append) $1', {'$1'}},;
                                13 => { '[Error] 013 No se puede desbloquear el registro $1 - $2 $3', {'$1','$2','$3'}},;
                                14 => { '[Error] 014 No se puede bloquear el registro: $1', {'$1'}},;
                                15 => { '[Error] 015 No se ha eliminado el registro: $1 ', {'$1'}},;
                                16 => { '[Error] 016 No se encuentra el registro para borrar: $1', {'$1'}},;
                                17 => { '[Error] 017 Nos e ha borrado el fichero $1 porque no existe', {'$1'}},;
                                18 => { '[Error] 018 Error eliminando $1 $2', {'$1','$2'}},;
                                19 => { '[Error] 019 No se ha encontrado el registro $1 en $2', {'$1','$2'}},;
                                20 => { '[Error] 020 OcurriÃ³ un problema posicionando al principio de la tabla $1', {'$1'}},;
                                21 => { '[Error] 021 Incongruencia en los datos buscando Get() de $1', {'$1'}},;
                                22 => { '[Error] 022 Error cargando Get() datos: $1', {'$1'}},;
                                24 => { '[Error] 024 Error buscando WhereIn() datos: $1', {'$1'}},;
                                25 => { '[Error] 025 OcurriÃ³ un problema posicionando el registro en la tabla $1, incongruencia en la base de datos', {'$1'}},;
                                26 => { '[Error] 026 OcurriÃ³ un problema posicionando el registro en la tabla $1, $2', {'$1','$2'}},;
                                27 => { '[Error] 027 027 No se puede posicionar la tabla $1 ya que no dispone de identificador interno de tabla', {'$1'}},;
                                28 => { '[Error] 028 Error cargando datos de $1. $2', {'$1','$2'}},;
                                29 => { '[Error] 029 Error cargando datos de $1. $2', {'$1','$2'}},;
                                30 => { '[Error] 030 Error moviendo posiciÃ³n en $1 $2', {'$1','$2'}},;
                                31 => { '[Error] 031 No se puede abrir el fichero $1 alias $2 $3', {'$1','$2','$3'}},;
                                32 => { '[Error] 032 Error Insertando los datos en $1 alias $2 $3', {'$1','$2','$3'}},;
                                33 => { '[Error] 033 No se han guardado los datos de $1 en alias $2 $3', {'$1','$2','$3'}},;
                                34 => { '[Error] 034 No se pueden volcar los datos de $1 al alias $2 por problemas bloqueando el registro $3', {'$1','$2','$3'}},;
                                35 => { '[Error] 035 Hubo un problema volcando datos al fichero de $1 alias $2 $3', {'$1','$2','$3'}},;
                                36 => { '[Error] 036 Error contando los registros de $1 alias $2 $3', {'$1','$2','$3'}},;
                                37 => { '[Error] 037 Error accediendo a la posiciÃ³n del alias $1 del modelo $2 $3', {'$1','$2','$3'}},;
                                38 => { '[Error] 038 Error posicionando al registro $1 en alias $2 de $3 $4', {'$1','$2','$3','$4'}},;
                                42 => { '[Error] 042 Error buscando (Seek) $1', {'$1'}},;
                                41 => { '[Error] 041 error bloqueando registro de $1 alias $2 $3', {'$1','$2','$3'}},;
                                43 => { '[Error] 043 Error Localizando (Locate) $1', {'$1'}},;
                                44 => { '[Error] 044 Error comprobando existencia de fichero $1 $2', {'$1','$2'}},;
                                45 => { '[Error] 045 Hubo un problema aplicando la condicion $1', {'$1'}},;
                                47 => { '[Error] 047 Error buscando getOrdCondSet() filtro: $1 $2', {'$1','$2'}},;
                                48 => { '[Error] 048 Error Posicionando Registro $1 en $2 $3', {'$1','$2','$3'}},;
                                49 => { '[Error] 049 Hubo un problema posicionando el registro $1 en $2', {'$1','$2'}},;
                                50 => { '[Error] 050 Error accediendo a la estructura del fichero $1 $2', {'$1','$2'}},;
                                51 => { '[Error] 051 la tabla $1 no tiene el campo $2', {'$1','$2'}},;
                                52 => { '[Error] 052 la tabla $1 no tiene el tipo correcto en el campo $2 . Tipo correcto : $3 . Tipo de la tabla: $4', {'$1','$2','$3','$4'}},;
                                53 => { '[Error] 053 la tabla $1 no tiene el ancho correcto en el campo $2 . Tipo correcto : $3 . Tipo de la tabla: $4', {'$1','$2','$3','$4'}},;
                                54 => { '[Error] 054 la tabla $1 no tiene el ancho de decimales correcto en el campo $2 . Tipo correcto : $3 . Tipo de la tabla: $4' , {'$1','$2','$3','$4'}},;
                                56 => { '[Error] 056 No se puede obtener la fecha y hora del fichero: $1', {'$1'}},;
                                57 => { '[Error] 057 un problema al acceder a la fecha y hora del fichero: $1 $2', {'$1','$2'}},;
                                58 => { '[Error] 058 un problema al acceder al tamaño del fichero: $1 $2', {'$1','$2'}},;
                                59 => { '[Error] 059 Update. No se puede bloquear el registro: $1 de $2 alias $3', {'$1','$2','$3'}},;
                                60 => { '[Error] 060 Update. Incongruencia en los datos buscando Get() $1', {'$1'}},;
                                62 => { '[Error] 062, Update.El parámetro pasado al update de $1 alias $2 no es un hash', {'$1','$2'}},;
                                63 => { '[Error] 063 Error contando Count() los registros de $1 ', {'$1'}},;
                                64 => { '[Error] 064 El valor que se le ha pasado no es un Json válido $1', {'$1'}},;
                                67 => { '[Error] 067 El valor que se le ha pasado no es un Array de JSon válido $1', {'$1'}},;
                                69 => { '[Error] 069 Hubo un problema al aplicar el orden $1 al fichero $2. $3', {'$1','$2'}},;
                                70 => { '[Error] 070 OcurriÃ³ un problema posicionando al final de la tabla $1, $2', {'$1','$2'}},;
                                71 => { '[Error] 071 Hubo un problema al aplicar el orden $1 al fichero $2. $3', {'$1','$2'}},;
                                72 => { '[Error] 072 OcurriÃ³ un problema posicionando en los límites de la tabla $1 según $2', {'$1','$2','$3'}},;
                                73 => { '[Error] 073 No se localiza la InternalID: $1' , {'$1'}},;
                                74 => { '[Error] 074 Hubo un problema al aplicar el orden $1 al fichero $2' , {'$1','$2'}};
                        }

#DEFINE TORM_INFO_MESSAGE {;
                            01 => {'[Info] 001 Obteniendo fecha de $1 ', {'$1'} },;
                            02 => {'[Info] 002 Obteniendo Tamaño de $1 ', {'$1'}},;
                            03 => {'[Info] 003 Creando fichero $1 ', {'$1'}},;
                            04 => {'[Info] 004 Cerrando Alias: $1', {'$1'}},;
                            05 => {'[Info] 005 Creando índice $1 nÂº $2 de $3', {'$1','$2','$3'}},;
                            06 => {'[Info] 006 Añadiendo registro $1 a $2 ', {'$1','$2'} },;
                            07 => {'[Info] 007 Desgloqueando registro de $1 - $2', {'$1','$2'}},;
                            08 => {'[Info] 008 Eliminando registro de $1 nÂº $2', {'$1','$2'}},;
                            09 => {'[Info] 009 Contando registro de $1 nÂº $2', {'$1','$2'}},;
                            10 => {'[Info] 010 Eliminando fichero $1', {'$1'}},;
                            11 => {'[Info] 011 Obteniendo registros de $1 según $2', {'$1','$2'}},;
                            12 => {'[Info] 012 Obteniendo recnos mediante WhereIN de $1 según $2', {'$1','$2'}},;
                            13 => {'[Info] 013 Posicionando registro $1 en $2', {'$1','$2'}},;
                            14 => {'[Info] 014 Posicionando al principio de la tabla $1 según $2', {'$1','$2'}},;
                            15 => {'[Info] 015 Posicionando al final de la tabla $1 según $2', {'$1','$2'}},;
                            16 => {'[Info] 016 LazyLoad chequeando cambios en tabla $1', {'$1'}},;
                            17 => {'[Info] 017 Cargando datos desde Alias $1 a tabla $2', {'$1','$2'}},;
                            18 => {'[Info] 018 Obteniendo límites de la tabla $1 según $2', {'$1','$2'}},;
                            19 => {'[Info] 019 Cargando múltiples datos desde Alias $1 a tabla $2', {'$1','$2'}},;
                            20 => {'[Info] 020 Cargando relaciones de $1', {'$1'}},;
                            21 => {'[Info] 021 Abriendo $1 alias $2', {'$1','$2'}},;
                            22 => {'[Info] 022 Almacenando info de hash a $1 alias $2', {'$1','$2'}},;
                            23 => {'[Info] 023 Almacenando modelo $1 en alias $2', {'$1','$2'}},;
                            24 => {'[Info] 024 Almacenando modelo $1 en alias $2', {'$1','$2'}},;
                            25 => {'[Info] 025 Cuento los registros de $1 alias $2 según el query', {'$1','$2'}},;
                            26 => {'[Info] 026 Recupero la posición del registro en $1 alias $2', {'$1','$2'}},;
                            27 => {'[Info] 027 Posicionando en registro $1 del alias $2 de $3', {'$1','$2','$3'}},;
                            28 => {'[Info] 028 Bloqueando registro $1 del alias $2 de $3', {'$1','$2','$3'}},;
                            29 => {'[Info] 029 Guardo el registro de $1 en alias $2', {'$1','$2'}},;
                            30 => {'[Info] 030 Guardando colección de $1 en alias $2', {'$1','$2'}},;
                            31 => {'[Info] 031 Buscando (Seek) $1 en $2 orden $3 alias $4', {'$1','$2','$3','$4'}},;
                            32 => {'[Info] 032 Localizando (Locate) $1 en $2 por $3 alias $4', {'$1','$2','$3','$4'}},;
                            33 => {'[Info] 033 Comprobando existencia de fichero $1', {'$1'}},;
                            34 => {'[Info] 034 Actualizando (Update) modelo $1 de alias $2', {'$1','$2'}},;
                            35 => {'[Info] 035 Localizando $1 en la colección de $2 según $3', {'$1','$2','$3'}};
                        }