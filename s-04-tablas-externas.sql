--@Autor(es): López Becerra Ricardo
--@Fecha creación: 02/01/2022
--@Descripción: Código para crear una tabla externa. Basado en el código proporcionado 
--en los apuntes del curso.


--Se requiere del usuario SYS para crear un objeto tipo
--directory y otorgar privilegios. 
prompt Conectando como sys
connect sys/system as sysdba
--Un objeto tipo directory es un objeto que se crea y almacena en el
-- diccionario de datos y se emplea para mapear directorios
-- reales en el sistema de archivos. En este caso tmp_dir es un
-- objeto que apunta al directorio /tmp/bases del servidor 
prompt creando directorio tmp_dir
create or replace directory tmp_dir as '/tmp/bases';
--se otorgan permisos para que el usuario l_proy_admin de la BD pueda leer
--el contenido del directorio
grant read, write on directory tmp_dir to l_proy_admin;
prompt Contectando con usuario l_proy_admin para crear la tabla externa
connect l_proy_admin/contrasenia
show user
prompt creando tabla externa
create table drugs(
  equipaje_id number(10,0),
  sustancia varchar2(20),
  cantidad_encontrada_kg number(10,4),
  fecha_incautacion date 
)
organization external (
 --En oracle existen 2 tipos de drivers para parsear el archivo:
 -- oracle_loader y oracle_datapump
  type oracle_loader
  default directory tmp_dir
  access parameters (
    records delimited by newline
    badfile tmp_dir:'equipaje_estupefacientes_bad.log'
    logfile tmp_dir:'equipaje_estupefacientes_ext.log'
    fields terminated by ','
    lrtrim
    missing field values are null 
    (
      equipaje_id, sustancia, cantidad_encontrada_kg,
      fecha_incautacion date mask "dd/mm/yyyy"
    )
  )
  location ('drugs.csv')
)
reject limit unlimited;

prompt creando el directorio /tmp/bases en caso de no existir
!mkdir -p /tmp/bases

prompt cambiando los permisos de /tmp/bases 
!chmod 777 /tmp/bases

prompt Copiando el archivo csv a /tmp/bases 
!cp /home/ricardolb/sql/bd-proy/scripts_llenado/drugs.csv /tmp/bases


prompt mostrando los datos 
 
 col sustancia format a20

 select * from drugs;
