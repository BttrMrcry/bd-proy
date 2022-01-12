--@Autor(es): López Becerra Ricardo
--@Fecha creación: 10/01/2022
--@Descripción: Procedimiento que registra una maleta
connect l_proy_admin/contrasenia 

create or replace procedure registra_maleta(
	p_pasajero_id number,
	p_vuelo_id number,
	p_peso_kg number
) is
  v_count_vp number;
  v_count_v number;
  v_count_pa number;
  v_num_quipaje number;
  v_pa_id number;
begin
	
	select count(*) into v_count_vp 
	from vuelo_pasajero vp
	where vp.vuelo_id = p_vuelo_id
	and vp.pasajero_id = p_pasajero_id;

	--verifica si el pasajero está en el vuelo
	if v_count_vp = 0 then 
		raise_application_error(-20007,'El pasajero no está regitrado '
		|| 'para el vuelo especificado');
	end if;

	--Verifica que el vuelo esté programado y que falten más de 10
	--minutos
	select count(*)  into v_count_v
	from vuelo v, status_vuelo sv 
	where v.status_vuelo_id = sv.status_vuelo_id
	and v.vuelo_id = p_vuelo_id
	and sv.nombre = 'PROGRAMADO'
	and (fecha_salida-sysdate) > 1/144;
 

	if v_count_v = 0 then 
		raise_application_error(-20007,'El vuelo no es válido');
	end if;

	--Verifica que se haya generado un pase de abordaje
	select count(*) into v_count_pa
	from vuelo_pasajero vp, pase_abordaje pa 
	where vp.vuelo_pasajero_id = pa.vuelo_pasajero_id
	and vp.vuelo_id = p_vuelo_id
	and vp.pasajero_id = p_pasajero_id;

	if v_count_pa = 0 then 
		raise_application_error(-20007,'Aún no se genera un pase '
		|| 'de abordar para este pasajero');
	end if;

	--verifica si se alcanzó el limite de equipajes
	select  pa.pase_abordaje_id, nvl(max(numero_equipaje),0) 
	into v_pa_id, v_num_quipaje
	from equipaje e, pase_abordaje pa, vuelo_pasajero vp 
	where vp.vuelo_pasajero_id = pa.vuelo_pasajero_id
	and pa.pase_abordaje_id = e.pase_abordaje_id(+)
	and vp.pasajero_id = p_pasajero_id
	and vp.vuelo_id = p_vuelo_id
	group by pa.pase_abordaje_id;

	
	if v_num_quipaje = 5 then 
		raise_application_error(-20007,'El pasajero ya registró '
		||' 5 equipajes');
	end if;

	insert into equipaje(equipaje_id, pase_abordaje_id, 
		numero_equipaje, peso_kg)
	values (seq_equipaje.nextval, v_pa_id, v_num_quipaje + 1,
	p_peso_kg);

end;
/
show errors;