--@Autor(es): López Becerra Ricardo
--@Fecha creación: 02/01/2022
--@Descripción: Código para generar los sinónimos solicitados

prompt Conectando con el usuario administrador
connect l_proy_admin/contrasenia


--Indices unique para verificar que algunas colunas tengas valores únicos
create unique index puesto_clave_iuk on puesto(clave);

create unique index equipaje_pase_abordaje_id_numero_equipaje_iuk
    on equipaje(pase_abordaje_id,numero_equipaje);

--Indices para mejorar el desempeño de búsquedas 
create index pasajero_nombre_ix on pasajero(lower(nombre));

create index pasajero_ap_paterno_ix on pasajero(lower(ap_paterno));

create index pasajero_ap_manterno_ix on pasajero(lower(ap_materno));

create index empleado_nombre_ix on empleado(lower(nombre));

create index empleado_ap_paterno_ix on empleado(lower(ap_paterno));

create index empleado_ap_materno_ix on empleado(lower(ap_materno));

create unique index vuelo_aeropuerto_origen_aeropuerto_destino_iuk 
on vuelo(aeropuerto_origen,aeropuerto_destino);
--Indices para mejorar el desempeño de joins 

--Este indice en específico complementa a 
--vuelo_aeropuerto_origen_aeropuerto_destino_iuk para hacer joins con 
--aeropuerto
create index vuelo_aeropuerto_destino_ix on vuelo(aeropuerto_destino);

create index vuelo_aeropuerto_aeronave_id_ix on vuelo(aeronave_id);

create index historico_status_vuelo_vuelo_id 
    on historico_status_vuelo(vuelo_id);

create index paquete_vuelo_id_ix on paquete(vuelo_id);

create index tripulacion_empleado_id_ix on tripulacion(empleado_id);

create index tripulacion_vuelo_id_ix on tripulacion(vuelo_id);

create index empleado_puesto_id_ix on empleado(puesto_id);

create index empleado_jefe_id_ix on empleado(jefe_id);
