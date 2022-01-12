--@Autor(es): López Becerra Ricardo
--@Fecha creación: 02/01/2022
--@Descripción: Código para realizar las consultas requeridas

connect l_proy_admin/contrasenia
--Matricula del avión, numero de vuelo y fecha de salida en caso de que se haya 
--utilizado en algún vuelo durante enero de 2022
--outer join
create table consulta_1 as
select a.matricula, v.numero_vuelo, v.fecha_salida
from aeronave a left join vuelo v 
on a.aeronave_id = v.aeronave_id
and fecha_salida >= to_date('01/01/2022','dd/mm/yyyy')
and fecha_salida < to_date('01/02/2022','dd/mm/yyyy'); 


--Nombre apellido paterno y puesto de todos los empleados y 
--el RFC  de sus jefes
--inner join, natural join 
create table consulta_2 as
select 
  e.nombre, 
  e.ap_paterno, 
  p.nombre as puesto,
  j.rfc rfc_jefe
from empleado e join 
  puesto p using(puesto_id)
  left join empleado j 
    on e.jefe_id = j.empleado_id;


--mostrar la matricula de cada avion y el número de vuelos 
--realizados par esa unidad si son menores de 10
-- funciones de agregación
create table consulta_3 as
select a.matricula, count(*) vuelo_realizados
from aeronave a join vuelo v
    using(aeronave_id)
group by a.matricula
having count(*) < 3;

--Mostrar nombre y apellido paterno de pasajeros que viajaron del
--10 de septiempre de 2021 al 15 de septiembre de 2021 y pasajeros con 
--edad menor a 10 años que hayan viajado más de dos veces, menos
--los que hayan perdido algún vuelo alguna vez
--Algebra relacional
create table consulta_4 as
select p.nombre, p.ap_paterno 
from pasajero p
where trunc((sysdate-p.fecha_nacimiento)/365) < 10
intersect
select p.nombre, p.ap_paterno 
from pasajero p join vuelo_pasajero vp 
    on p.pasajero_id = vp.pasajero_id
group by p.nombre, p.ap_paterno, p.pasajero_id
having count(*) > 2
union
select p.nombre, p.ap_paterno 
from pasajero p join vuelo_pasajero vp 
    on p.pasajero_id = vp.pasajero_id
join vuelo v
    on vp.vuelo_id = v.vuelo_id
where v.fecha_salida >= to_date('10/09/2021','dd/mm/yyyy')
and v.fecha_salida < to_date('16/09/2021','dd/mm/yyyy')
minus 
select distinct p.nombre, p.ap_paterno 
from pasajero p join vuelo_pasajero vp 
    on p.pasajero_id = vp.pasajero_id
where vp.bandera_abordado = 0;    


--Número de vuelo, su estado y el número de vuelos en ese mismo estado
-- Subconsultas
create table consulta_5 as
select v.numero_vuelo, sv.nombre, co.numero_vuelos_estado
from vuelo v, status_vuelo sv,
(
  select status_vuelo_id, count(*) numero_vuelos_estado
  from vuelo v
  group by status_vuelo_id
) co
where v.status_vuelo_id = sv.status_vuelo_id
and sv.status_vuelo_id = co.status_vuelo_id;


--Consulta en una vista 
create table consulta_6 as
select * from v_vuelo_acientos_libres
where asientos_libres < 70;


--Consulta utilizando un sinónimo 
create table consulta_7 as
select numero_vuelo from xx_vuelo 
where es_carga = 1;

-- La tabla es temporal privada. A este punto ya se eliminó
-- create table consulta_8 as
-- select * from ora$ptt_reporte_pasajeros_estupefacientes;

--Consulta en una tabla externa
create table consulta_9 as
select * from drugs
where cantidad_encontrada_kg < 1;


