--@Autor(es): López Becerra Ricardo
--@Fecha creación: 02/01/2022
--@Descripción: Código para crear una tabla temporal para un reporte utilizando varias tablas.

--Reporte con los nombres de los pasajeros, su edad, su curp, si abordo su vuelo ,el número de vuelo, 
--el aueropuerto de salida de su vuelo,
--el aeropuerto de llegada, la sustancia y cantidad de sustancia detectada asi como el total de maletas 
--detectadas como el promedio de cantidad de sustancia detectada por sustancia.   


connect l_proy_admin/contrasenia
show user

create global temporary table reporte_pasajeros_estupefacientes 
  on commit preserve rows as
  select * 
  from(    
    select 
      p.nombre as nombre_sospechoso, 
      p.ap_paterno,
      p.ap_materno, 
      trunc((sysdate-p.fecha_nacimiento)/365) as edad,
      p.curp,
      v.numero_vuelo,
      ao.nombre as aeropuerto_origen,
      ad.nombre as aeropuerto_destino,
      ee.sustancia,
      ee.cantidad_encontrada_kg
    from pasajero p, aeropuerto ao, aeropuerto ad, equipaje_estupefacientes ee,
      vuelo_pasajero vp, vuelo v, pase_abordaje pa, equipaje e
    where ee.equipaje_id = e.equipaje_id
      and pa.pase_abordaje_id = e.pase_abordaje_id
      and vp.vuelo_pasajero_id = pa.vuelo_pasajero_id
      and p.pasajero_id = vp.pasajero_id
      and v.vuelo_id = vp.vuelo_id
      and ao.aeropuerto_id = v.aeropuerto_origen
      and ad.aeropuerto_id = v.aeropuerto_destino
  ) m,
  (
    select count(*), avg(cantidad_encontrada_kg)
      from equipaje_estupefacientes
      group by sustancia
  ) s;
  



            