--@Autor(es): López Becerra Ricardo
--@Fecha creación: 11/01/2022
--@Descripción: función que dado el nombre de un archivo binario lo carga
--El archivo binario ya debe estar en la carpeta /tmp/bases/binfiles 

prompt Configurando directorio
conn sys/system as sysdba
create or replace directory binfiles_dir as '/tmp/bases/binfiles';
grant read, write on directory binfiles_dir to l_proy_admin;

prompt Creando procedimiento con usuario l_proy_admin
connect l_proy_admin/contrasenia

create or replace function carga_bin(
	v_nombre_archivo varchar2
) return blob is
	v_blob_res blob;
	v_bfile bfile;
	v_src_offset number;
	v_dest_offset number;
	v_src_length number;
	v_dest_length number;
begin 
	dbms_lob.createtemporary(v_blob_res,false);   --Esto es como un malloc. Reserva memoria para el blob 
	dbms_output.put_line('Cargando blob para '||v_nombre_archivo);
	--Validando si el archivo existe
	v_bfile := bfilename('BINFILES_DIR',v_nombre_archivo);
	if dbms_lob.fileexists(v_bfile) = 0 then
		raise_application_error(-20001, 'El archivo '||v_nombre_archivo||' no existe.');
	end if;
	--abrir archivo
	if dbms_lob.isopen(v_bfile) = 1 then
		raise_application_error(-20001, 'El archivo '||v_nombre_archivo||' está abierto. No se puede usar');
	end if;
	--abriendo archivo 
	dbms_lob.open(v_bfile,dbms_lob.lob_readonly);

	--Escribiendo bytes
	v_src_offset:=1;
	v_dest_offset:=1;
	dbms_lob.loadblobfromfile(
		dest_lob      => v_blob_res,
		src_bfile     => v_bfile,
		amount        => dbms_lob.getlength(v_bfile),
		dest_offset   => v_dest_offset,
		src_offset    => v_src_offset
	);
	--Cerrando archivo
	dbms_lob.close(v_bfile);
	--Validando carga
	v_src_length:=dbms_lob.getlength(v_bfile);
	v_dest_length:=dbms_lob.getlength(v_blob_res);
	if v_dest_length <> v_src_length then 
		raise_application_error(-20001,'El archivo '||v_nombre_archivo||' no se cargó correctamente');
	end if;
	return v_blob_res;
end;
/
show errors;


