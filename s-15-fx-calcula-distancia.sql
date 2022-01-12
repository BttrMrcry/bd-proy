--@Autor(es): López Becerra Ricardo
--@Fecha creación: 10/01/2022
--@Descripción: Función que calcula la distancia recorrida en un vuelo
connect l_proy_admin/contrasenia 

set serveroutput on
create or replace function calcula_distancia_vuelo
(
	p_vuelo_id in number
)return number is 

PI number := 3.1415926535;
v_lat1 number;
v_long1 number;
v_lat2 number;
v_long2 number;

v_numero1 number;
v_numero2 number;

v_lat1_rad number;
v_long1_rad number;
v_lat2_rad number;
v_long2_rad number;

dif_lat number;
dif_long number;

v_distancia number := 0;

R number := 6371; --Radio promedio de la tierra en kilometros
a number;
c number;

cursor cur_points is
	select numero,latitud,longitud 
	from vuelo_ubicacion
	where vuelo_id = p_vuelo_id
	order by numero; 

begin
	open cur_points;

	fetch cur_points into v_numero1, v_lat1, v_long1;
	if cur_points%notfound then 
		close cur_points;
		return -1;
	end if;
	
	loop
		fetch cur_points into v_numero2, v_lat2, v_long2;
	exit when cur_points%notfound;
	dbms_output.put_line(
		'Calculando disyancia entre los puntos' 
		||' numero: '||v_numero1
		||' latitud: '||v_lat1
		||' longitud: '||v_long1
		||' y'
		||' numero: '||v_numero2
		||' latitud: '||v_lat2
		||' longitud: '||v_long2 
	);
	
	v_lat1_rad := v_lat1 * PI/180;
	V_lat2_rad := v_lat2 * PI/180;
	
	--formula: http://www.movable-type.co.uk/scripts/latlong.html

	dif_lat := (v_lat2-v_lat1) * PI/180;
	dif_long := (v_long2-v_long1) * PI/180; 
	a := power(sin(dif_lat/2),2) + cos(v_lat1_rad)*cos(v_lat2_rad)*
		power(sin(dif_long/2),2);
	
	c := 2*atan2(sqrt(a),sqrt(1-a));

	v_distancia := v_distancia + R*c; --distancia en kilometros.

	v_numero1 := v_numero2;
	v_lat1 := v_lat2;
	v_long1 := v_long2;
	
	end loop;
	
	close cur_points; 
	return v_distancia;
end;
/
show errors