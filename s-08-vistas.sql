--@Autor(es): López Becerra Ricardo
--@Fecha creación: 02/01/2022
--@Descripción: Código para generar vistas de algumnas consultas

prompt conectando con el usaurio administrador
connect l_proy_admin/contrasenia 
show user

--Vista con los vuelos y la cantidad de paquetes 
--en ese vuelo si es que hay.
create or replace view v_vuelo_numero_paquete(
    numero_vuelo,
    status,
    numero_paquetes_vuelo
)as 
    select v.numero_vuelo, sv.nombre, count(p.paquete_id)
    from vuelo v join status_vuelo sv 
        on v.status_vuelo_id = sv.status_vuelo_id 
    left join paquete p
        on v.vuelo_id = p.vuelo_id 
    group by v.numero_vuelo,sv.nombre;


--Vista con que para cada vuelo de pasajeros programado
--  muestra su número de vuelo, su origen, su destino y 
-- la cantidad de asientos libres totales

create or replace view v_vuelo_acientos_libres(
    numero_vuelo,
    origen,
    destino,
    asientos_libres
) as 
    select 
        v.numero_vuelo, 
        ao.nombre, 
        ad.nombre, 
        (ac.capacidad_pasajeros_ordinarios + ac.capacidad_pasajeros_vip 
        + ac.capacidad_pasajeros_discapacitados - count(vp.pasajero_id)) 
        as asiento_libres
    from vuelo v join aeropuerto ao
        on v.aeropuerto_origen = ao.aeropuerto_id
    join aeropuerto ad 
        on v.aeropuerto_destino = ad.aeropuerto_id
    join status_vuelo sv 
        on v.status_vuelo_id = sv.status_vuelo_id
    join aeronave n 
        on v.aeronave_id = n.aeronave_id
    join aeronave_comercial ac 
        on n.aeronave_id = ac.aeronave_id
    left join vuelo_pasajero vp 
        on vp.vuelo_id = v.vuelo_id 
    where sv.nombre = 'PROGRAMADO'
    group by v.numero_vuelo, ao.nombre, ad.nombre, ac.capacidad_pasajeros_ordinarios,
        ac.capacidad_pasajeros_vip, ac.capacidad_pasajeros_discapacitados;


--vista que muestra el numero de vuelo, los nombres y la foto de cada miembro
--de la tripulación de cada vuelo.
create or replace view vuelo_tripulacion(
    numero_vuelo,
    nombre, 
    ap_paterno,
    ap_materno,
    foto,
    rol
) as 
    select 
    v.numero_vuelo,
    e.nombre,
    e.ap_paterno,
    e.ap_materno,
    e.foto, 
    r.nombre 
    from vuelo v, empleado e, tripulacion t, rol_empleado r
    where v.vuelo_id = t.vuelo_id 
    and e.empleado_id = t.empleado_id 
    and t.rol_empleado_id = r.rol_empleado_id;
    

        