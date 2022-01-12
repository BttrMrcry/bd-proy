--@Autor(es): López Becerra Ricardo
--@Fecha creación: 12/01/2022
--@Descripción: Bloque anónimo que prueba la función ping




connect sys/system as sysdba 
set serveroutput on

declare
	v_count number := 0;
begin     

	select count(*) into v_count
	from dba_network_acls where acl like '%ping.xml';

	if v_count > 0 then
		dbms_output.put_line('Elimiando acl de ejecución anterior'); 
		DBMS_NETWORK_ACL_ADMIN.DROP_ACL (acl => 'ping.xml' );
	end if;

	dbms_output.put_line('Creando acl');
	DBMS_NETWORK_ACL_ADMIN.create_acl (
	acl          => 'ping.xml', 
	description  => 'hace_ping',
	principal    => 'L_PROY_ADMIN',
	is_grant     => TRUE, 
	privilege    => 'connect',
	start_date   => NULL,
	end_date     => NULL);
	COMMIT;

	DBMS_NETWORK_ACL_ADMIN.assign_acl (
	acl => 'ping.xml',
	host => '*', 
	lower_port => 80,
	upper_port => NULL); 


	DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
	acl => 'ping.xml',
	principal => 'L_PROY_ADMIN',  
	is_grant => true,
	privilege => 'connect');
	COMMIT;
end;
/

connect l_proy_admin/contrasenia
set serveroutput on 
begin 
	
	dbms_output.put_line('Probando con un sitio web que funciona');
	if ping('google.com',80) <> 'ok' then 
		raise_application_error(-20040,'No se pudo llegar a google.com');
	end if;
	dbms_output.put_line('Se obtuvo respuesta. Prueba exitosa');

	dbms_output.put_line('Probando con sitio web inexistente');
	if ping('ivlewruhbgvwpe.com',80) <> 'error' then 
		raise_application_error(-20040,'Se reportó conexión con un sitio que no existe');
	end if;
	dbms_output.put_line('No se obtivo respuesta. Prueba exitosa');
	dbms_output.put_line('Prueba exitosa!');

end;
/
show errors