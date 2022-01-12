--@Autor(es): López Becerra Ricardo
--@Fecha creación: 09/01/2022
--@Descripción: procedimiento que carga las fotos de n empleados 
--dado el id del empleado inicial

prompt Configurando directorio
conn sys/system as sysdba
create or replace directory fotos_dir as '/tmp/bases/fotos';
grant read, write on directory fotos_dir to l_proy_admin;

prompt Creando procedimiento con usuario l_proy_admin
connect l_proy_admin/contrasenia

prompt Copiando las imagenes a /tmp/bases
!cp -r /home/ricardolb/sql/bd-proy/fotos /tmp/bases

set serveroutput on
create or replace procedure sp_actualiza_foto_empleado
(p_empleado_id in number, p_num_imagenes in number) is

v_bfile bfile;
v_src_offset number;
v_dest_offset number;
v_blob blob;
v_src_length number;
v_dest_length number;
v_nombre_archivo varchar2(50);

begin
	for v_index in p_empleado_id..p_empleado_id+p_num_imagenes-1 loop
	v_nombre_archivo:='empleado-'||v_index||'.jpg';
	dbms_output.put_line('Cargando foto para '||v_nombre_archivo);
	--Validando si el archivo existe
	v_bfile:=bfilename('FOTOS_DIR',v_nombre_archivo);
	if dbms_lob.fileexists(v_bfile)=0 then
		raise_application_error(-20001,'El archivo '||v_nombre_archivo||' no existe.');
	end if;
	--abrir archivo
	if dbms_lob.isopen(v_bfile)=1 then
		raise_application_error(-20001,'El archivo '||v_nombre_archivo||' está abierto. No se puede usar');
	end if;
	--abriendo archivo 
	dbms_lob.open(v_bfile,dbms_lob.lob_readonly);
	--Actualizando blob en la tabla
	--Asegurarse que la tabla auto contenga datos y la columna foto debe tener un blob vacío.
	--Asignar v_blob
	select foto into v_blob
	from empleado
	where empleado_id=v_index 
	for update;
	--Escribiendo bytes
	v_src_offset:=1;
	v_dest_offset:=1;
	dbms_lob.loadblobfromfile(
		dest_lob      => v_blob,
		src_bfile     => v_bfile,
		amount        => dbms_lob.getlength(v_bfile),
		dest_offset   => v_dest_offset,
		src_offset    => v_src_offset
	);
	--Cerrando archivo
	dbms_lob.close(v_bfile);
	--Validando carga
	v_src_length:=dbms_lob.getlength(v_bfile);
	v_dest_length:=dbms_lob.getlength(v_blob);
	if v_dest_length<>v_src_length then 
		raise_application_error(-20001,'El archivo '||v_nombre_archivo||' no se cargó correctamente');
	end if;
	end loop;
end;
/
show errors