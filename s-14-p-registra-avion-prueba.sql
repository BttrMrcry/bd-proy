--@Autor(es): López Becerra Ricardo
--@Fecha creación: 10/01/2022
--@Descripción: Bloque anónimo 
--que prueba el procedimiento que regitra un avión
--regitra_aeronave
connect l_proy_admin/contrasenia 

set serveroutput on
declare
	v_aeronave_id number;
	v_count_aeronave number;
	v_count_comercial number;
	v_count_carga number;
begin 
	--Limpiando posibles pruebas anteriores
	select count(*) into v_count_aeronave 
	from aeronave 
	where matricula = '123456789';
	
	if v_count_aeronave > 0 then 
		select aeronave_id into v_aeronave_id 
		from aeronave 
		where matricula = '123456789';
		
		delete from aeronave_carga
		where aeronave_id = v_aeronave_id;

		delete from aeronave_comercial
		where aeronave_id = v_aeronave_id;
		
		delete from aeronave 
		where aeronave_id = v_aeronave_id;
	end if;
	

	--Prueba con avión comercial válido
	dbms_output.put_line('Probando ingresar un avión comercial válido');
	registra_aeronave(1,0,'123456789','my_modelo',
		1,1,1,null,null,null,null,null,null);
	
	select aeronave_id, count(*) into v_aeronave_id, 
		v_count_aeronave 
	from aeronave 
	where matricula = '123456789'
	group by aeronave_id;
	

	select count(*) into v_count_comercial
	from aeronave_comercial
	where aeronave_id = v_aeronave_id;

	
	if v_count_aeronave <> 1 or v_count_comercial <> 1 then
		raise_application_error(-20006,'No se encontró al registro o '
		||'está incompleto');
	else 
		dbms_output.put_line('Registro exitoso!');
	end if;
	
	
	delete from aeronave_comercial
	where aeronave_id = v_aeronave_id;


	delete from aeronave 
	where aeronave_id = v_aeronave_id;
	
	--Avión carga válido
	dbms_output.put_line('Probando ingresar un avión de carga válido');
	
	registra_aeronave(0,1,'123456789','my_modelo',
		null,null,null,1,1,1,1,1,1);
	
	select aeronave_id, count(*) into v_aeronave_id, 
		v_count_aeronave 
	from aeronave 
	where matricula = '123456789'
	group by aeronave_id;

	select count(*) into v_count_carga
	from aeronave_carga
	where aeronave_id = v_aeronave_id;

	if v_count_aeronave <> 1 or v_count_carga <> 1 then
		raise_application_error(-20006,'No se encontró al registro o ' 
		|| 'está incompleto');
	else 
		dbms_output.put_line('Registro exitoso!');
	end if;

	delete from aeronave_carga
	where aeronave_id = v_aeronave_id;

	delete from aeronave 
	where aeronave_id = v_aeronave_id;
	
 
	
	--Avión de carga y comercial válido
	dbms_output.put_line('Probando ingresar un avión de pasajeros y '
	||'carga válido');
	
	registra_aeronave(1,1,'123456789','my_modelo',
		1,1,1,1,1,1,1,1,1);
	
	select aeronave_id, count(*) into v_aeronave_id, 
		v_count_aeronave 
	from aeronave 
	where matricula = '123456789'
	group by aeronave_id;
	select count(*) into v_count_carga
	from aeronave_carga
	where aeronave_id = v_aeronave_id;

	select count(*) into v_count_comercial
	from aeronave_comercial
	where aeronave_id = v_aeronave_id;

	
	if v_count_aeronave <> 1 
		or v_count_carga <> 1 
		or v_count_comercial <> 1 then
		raise_application_error(-20006,'No se encontró al registro o está '
		||'incompleto');
	else 
		dbms_output.put_line('Registro exitoso!');
	end if;

	   
	delete from aeronave_carga
	where aeronave_id = v_aeronave_id;

	delete from aeronave_comercial
	where aeronave_id = v_aeronave_id;

	delete from aeronave 
	where aeronave_id = v_aeronave_id;


--Avión comercial inválido

	dbms_output.put_line('Probando ingresar un avión de pasajeros inválido');
	
	begin 
		registra_aeronave(1,0,'123456789','my_modelo',
			1,1,1,1,1,1,1,1,1);
		raise_application_error(-20006,'Fue posible ingresar los datos');
	exception
		when others then
			if sqlcode = -20004 then
				dbms_output.put_line(sqlerrm);
				dbms_output.put_line('Prueba exitosa ');
			elsif sqlcode = -20006 then   
					select aeronave_id into v_aeronave_id 
					from aeronave 
					where matricula = '123456789'
					group by aeronave_id;

					delete from aeronave_carga
					where aeronave_id = v_aeronave_id;

					delete from aeronave_comercial
					where aeronave_id = v_aeronave_id;

					delete from aeronave 
					where aeronave_id = v_aeronave_id;
				raise;
			end if;
	end;

--Ingresando un avión de carga inválido 

	dbms_output.put_line('Probando ingresar un avión de carga inválido');
	
	begin 
		registra_aeronave(0,1,'123456789','my_modelo',
			1,1,1,1,1,1,1,1,1);
		raise_application_error(-20006,'Fue posible ingresar los datos');
	exception
		when others then
			if sqlcode = -20004 then
				dbms_output.put_line(sqlerrm);
				dbms_output.put_line('Prueba exitosa');
			elsif sqlcode = -20006 then   
					select aeronave_id into v_aeronave_id 
					from aeronave 
					where matricula = '123456789'
					group by aeronave_id;

					delete from aeronave_carga
					where aeronave_id = v_aeronave_id;

					delete from aeronave_comercial
					where aeronave_id = v_aeronave_id;

					delete from aeronave 
					where aeronave_id = v_aeronave_id;
				raise;
			end if;
	end;

--ingresando un avión de carga y de pasajeros inválido

	dbms_output.put_line('Probando ingresar un avión de carga y pasajeros '
	|| 'inválido');
	
	begin 
		registra_aeronave(1,1,'123456789','my_modelo',
			1,1,1,1,1,1,1,1,300);
		raise_application_error(-20006,'Fue posible ingresar los datos');
	exception
		when others then
			if sqlcode = -20004 then
				dbms_output.put_line(sqlerrm);
				dbms_output.put_line('Prueba exitosa');
			elsif sqlcode = -20006 then   
					select aeronave_id into v_aeronave_id 
					from aeronave 
					where matricula = '123456789'
					group by aeronave_id;

					delete from aeronave_carga
					where aeronave_id = v_aeronave_id;

					delete from aeronave_comercial
					where aeronave_id = v_aeronave_id;

					delete from aeronave 
					where aeronave_id = v_aeronave_id;
				raise;
			end if;
	end;
	dbms_output.put_line('Prueba exitosa!');
end;
/