--@Autor(es): López Becerra Ricardo
--@Fecha creación: 10/01/2022
--@Descripción: Bloque anónimo que verifica el  
--funcionamiento de la función calcula_distancia_vuelo
--La prueba simula un avion dando la vuelta al mundo
connect l_proy_admin/contrasenia 

set serveroutput on
declare 
	v_llave number := seq_vuelo.nextval;
	v_count number := 0;
	v_distancia_calculada number;
	v_distancia_esperada number := 40004;
begin

	insert into vuelo
	values(
		v_llave,sysdate,1,0,sysdate,sysdate + 1/24,99999,null,1,2,1,3
	);
	
	insert into vuelo_ubicacion
	values(1,v_llave,sysdate+1/96,0,0);
	insert into vuelo_ubicacion
	values(2,v_llave,sysdate+1/48,0,180);
	insert into vuelo_ubicacion
	values(3,v_llave,sysdate+1/24,0,0);

	v_distancia_calculada := calcula_distancia_vuelo(v_llave);
	dbms_output.put_line(v_distancia_calculada);
	
	if abs(v_distancia_calculada - v_distancia_esperada) > 200 then --Presicion del 0.5%
		
		dbms_output.put_line('Eliminando registros de pruebas anteriores');
		delete from vuelo_ubicacion where vuelo_id = (
			select vuelo_id from vuelo 
			where numero_vuelo = 99999
		);
		delete from vuelo where numero_vuelo = 99999;
		delete from vuelo_ubicacion where vuelo_id = v_llave;
		delete from vuelo where vuelo_id = v_llave;

		raise_application_error(-20003,'La distancia no es lo suficiente precisa');
	end if;    
	

	dbms_output.put_line('Eliminando registros de pruebas anteriores');
	delete from vuelo_ubicacion where vuelo_id = (
		select vuelo_id from vuelo 
		where numero_vuelo = 99999
	);
	delete from vuelo where numero_vuelo = 99999;
	delete from vuelo_ubicacion where vuelo_id = v_llave;
	delete from vuelo where vuelo_id = v_llave;

	dbms_output.put_line('Prueba exitosa!');
end;
/
