--@Autor(es): López Becerra Ricardo
--@Fecha creación: 10/01/2022
--@Descripción: Procedimiento que regitra un avión
connect l_proy_admin/contrasenia

create or replace procedure registra_aeronave(
  p_es_comercial in number,
  p_es_carga in number,
  p_matricula in varchar2,
  p_modelo in varchar2,
  p_capacidad_pasajeros_ordinarios in number,
  p_capacidad_pasajeros_vip in number,
  p_capacidad_pasajeros_discapacitados in number,
  p_bodega_ancho in number,
  p_bodega_profundidad in number,
  p_bodega_alto in number,
  p_numero_bodegas in number,
  p_capacidad_carga_tons in number,
  p_aeropuerto_resguardo in number
) is
	v_aeropuerto_valido number(1,0) := 0;
	v_llave_aeronave number(10,0);
begin
	if length(p_matricula) > 10 then
		raise_application_error(-20004,'La matricula tiene mas caracteres de ' 
		|| 'los permitidos');  
	elsif p_es_comercial = 1 and p_es_carga = 1 then
		if p_matricula is null 
			or p_modelo is null
			or p_capacidad_pasajeros_ordinarios is null
			or p_capacidad_pasajeros_vip is null 
			or p_capacidad_pasajeros_discapacitados is null 
			or p_bodega_ancho is null 
			or p_bodega_profundidad is null 
			or p_bodega_alto is null
			or p_numero_bodegas is null 
			or p_capacidad_carga_tons is null
			or p_aeropuerto_resguardo is null then
			raise_application_error(-20004,'Falta alguno de los '
			||'argumentos necesarios para registrar un avión de '
			||'carga-pasajeros.');
		else 
			select bandera_activo into v_aeropuerto_valido
			from aeropuerto
			where aeropuerto_id = p_aeropuerto_resguardo; 
			
			if v_aeropuerto_valido = 0 then 
				raise_application_error(-20004,'El aeropuerto ' 
				|| 'especificado actualmente no puede alvergar aeronaves');
			end if;

			v_llave_aeronave := seq_aeronave.nextval;
			insert into aeronave(aeronave_id, es_comercial, 
				es_carga, especificaciones_tecnicas, matricula, modelo)
			values (v_llave_aeronave, 1, 1, empty_blob(), p_matricula, p_modelo);

			insert into aeronave_comercial(aeronave_id, 
				capacidad_pasajeros_ordinarios,
				capacidad_pasajeros_vip, capacidad_pasajeros_discapacitados)
			values(v_llave_aeronave, p_capacidad_pasajeros_ordinarios,
			p_capacidad_pasajeros_vip, p_capacidad_pasajeros_discapacitados);

			insert into aeronave_carga(aeronave_id, bodega_ancho, 
				bodega_profundidad,
				bodega_alto, numero_bodegas, capacidad_carga_tons, 
				aeropuerto_resguardo)
			values(v_llave_aeronave, p_bodega_ancho, p_bodega_profundidad,
				p_bodega_alto,p_numero_bodegas, p_capacidad_carga_tons, 
				p_aeropuerto_resguardo);   
		end if;

	elsif p_es_comercial = 1 and p_es_carga = 0 then
		if p_matricula is null 
			or p_modelo is null
			or p_capacidad_pasajeros_ordinarios is null
			or p_capacidad_pasajeros_vip is null 
			or p_capacidad_pasajeros_discapacitados is null 
			or p_bodega_ancho is not null 
			or p_bodega_profundidad is not null 
			or p_bodega_alto is not null
			or p_numero_bodegas is not null 
			or p_capacidad_carga_tons is not null
			or p_aeropuerto_resguardo is not null then
			raise_application_error(-20004,'Falta alguno de los '
			|| 'argumentos necesarios para registrar un avión de '
			|| 'pasajeros o se ingreso un argumento para una aeronave ' 
			|| 'de tipo carga.');
		else 
			v_llave_aeronave := seq_aeronave.nextval;
			insert into aeronave(aeronave_id, es_comercial, 
				es_carga, especificaciones_tecnicas, matricula, modelo)
			values (v_llave_aeronave, 1, 0, empty_blob(), p_matricula, p_modelo);

			insert into aeronave_comercial(aeronave_id, 
				capacidad_pasajeros_ordinarios,
				capacidad_pasajeros_vip, capacidad_pasajeros_discapacitados)
			values(v_llave_aeronave, p_capacidad_pasajeros_ordinarios,
			p_capacidad_pasajeros_vip, p_capacidad_pasajeros_discapacitados);
		end if;
	elsif p_es_comercial = 0 and p_es_carga = 1 then
		if p_matricula is null 
			or p_modelo is null
			or p_capacidad_pasajeros_ordinarios is not null
			or p_capacidad_pasajeros_vip is not null 
			or p_capacidad_pasajeros_discapacitados is not null 
			or p_bodega_ancho is null 
			or p_bodega_profundidad is null 
			or p_bodega_alto is null
			or p_numero_bodegas is null 
			or p_capacidad_carga_tons is null
			or p_aeropuerto_resguardo is null then
			raise_application_error(-20004,'Falta alguno de los '
			||'argumentos necesarios para registrar un avión de ' 
			||'carga o se ingreso un argumento para un avión de tipo '
			||'pasajeros.');
		else 
			select bandera_activo into v_aeropuerto_valido
			from aeropuerto
			where aeropuerto_id = p_aeropuerto_resguardo; 
			
			if v_aeropuerto_valido = 0 then 
				raise_application_error(-20004,'El aeropuerto ' 
				||'especificado actualmente no puede alvergar aeronaves');
			end if;

			v_llave_aeronave := seq_aeronave.nextval;
			insert into aeronave(aeronave_id, es_comercial, 
				es_carga, especificaciones_tecnicas, matricula, modelo)
			values (v_llave_aeronave, 0, 1, empty_blob(), p_matricula, p_modelo);

			insert into aeronave_carga(aeronave_id, bodega_ancho, 
				bodega_profundidad,
				bodega_alto, numero_bodegas, capacidad_carga_tons, 
				aeropuerto_resguardo)
			values(v_llave_aeronave, p_bodega_ancho, p_bodega_profundidad,
				p_bodega_alto,p_numero_bodegas, p_capacidad_carga_tons, 
				p_aeropuerto_resguardo);   
		end if;
	end if;
end;
/
show errors;