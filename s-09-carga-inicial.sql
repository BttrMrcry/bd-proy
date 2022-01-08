
prompt conectando con el usaurio administrador
connect l_proy_admin/contrasenia 
show user
alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';

--Tipos de paquetes 
insert into tipo_paquete(tipo_paquete_id,clave,descripcion,
    indicaciones_generales) values (seq_tipo_paquete.nextval,'ELECTRONICOS',
    'productos electronicos', 'Tratar con cuida por su valor');

insert into tipo_paquete(tipo_paquete_id,clave,descripcion,
    indicaciones_generales) values(seq_tipo_paquete.nextval,'INDUSTRIAL',
    'Equipo industrial para diferentes compañias','No abrir, contenido confidencia');


insert into tipo_paquete(tipo_paquete_id,clave,descripcion,
    indicaciones_generales) values(seq_tipo_paquete.nextval,'EXPRESS',
    'Paquete con prioridad','Asignado a vuelos más proximos');


--Status posibles en los vuelos

insert into status_vuelo(status_vuelo_id,nombre) 
    values(seq_status_vuelo.nextval, 'PROGRAMADO');

insert into status_vuelo(status_vuelo_id,nombre)
    values(seq_status_vuelo.nextval,'ABORDANDO');


insert into status_vuelo(status_vuelo_id,nombre)
    values(seq_status_vuelo.nextval,'A TIEMPO');


insert into status_vuelo(status_vuelo_id,nombre)
    values(seq_status_vuelo.nextval,'DEMORADO');


insert into status_vuelo(status_vuelo_id,nombre)
    values(seq_status_vuelo.nextval,'CANCELADO');

--rol empleado

insert into rol_empleado(rol_empleado_id,nombre,descripcion)
    values (seq_rol_empleado.nextval,'Piloto','Jefe y pricipal encargado
    de la aeronave');


insert into rol_empleado(rol_empleado_id,nombre,descripcion)
    values (seq_rol_empleado.nextval,'Copiloto','Apoyo al piloto y segundo 
    encargado');


insert into rol_empleado(rol_empleado_id,nombre,descripcion)
    values (seq_rol_empleado.nextval,'Jefe de sobrecargos','Encargado de los 
    sobrecargos en el vuelo');

insert into rol_empleado(rol_empleado_id,nombre,descripcion)
    values (seq_rol_empleado.nextval,'Sobrecargo','Sobrecargo encargado de 
    atender la seguridad y necesidades de los pasajeros');

 
insert into rol_empleado(rol_empleado_id,nombre,descripcion)
    values (seq_rol_empleado.nextval,'Tecnico',
    'Encargado de mantener la integridad de los paquetes en los vuelos de carga');

--Puestos

insert into puesto(puesto_id,clave,nombre,descripcion,sueldo_mensual)
values(seq_puesto.nextval,'P1','Navengante principiante',
'Profesinal en la operación de la aeronave novato',20000.00);


insert into puesto(puesto_id,clave,nombre,descripcion,sueldo_mensual)
values(seq_puesto.nextval,'P2','Navengante experimentado',
'Profesinal en la operación de la aeronave con años de experiencia',60000.00);

insert into puesto(puesto_id,clave,nombre,descripcion,sueldo_mensual)
values(seq_puesto.nextval,'P3','Sobrecargo principiante',
'Profesinal capacitado para atender cualquier situación en cabina novato',10000.00);


insert into puesto(puesto_id,clave,nombre,descripcion,sueldo_mensual)
values(seq_puesto.nextval,'P4','Sobrecargo experimentado',
'Profesinal capacitado para atender cualquier situación en cabina con experiencia',20000.00);

insert into puesto(puesto_id,clave,nombre,descripcion,sueldo_mensual)
values(seq_puesto.nextval,'P5','Técnico de transporte',
'Profesinal capacitado para atender cualquier situación en cabina de carga',20000.00);

--Llamando en orden a los scripts para llenar el resto de las tablas


prompt Llenando aeropuerto 
@scripts_llenado/aeropuerto_activo.sql
@scripts_llenado/aeropuerto_inactivo.sql 


--Aeronaves de pasajeros 1-10
prompt Llenando la tabla aeronave.  
@scripts_llenado/aeronave_pasajeros.sql
@scripts_llenado/aeronave_pasajeros_paquetes.sql
@scripts_llenado/aeronave_paquetes.sql

prompt Llenando aeronave_comercial
@scripts_llenado/aeronave_comercial.sql

prompt Llenando aeronave_carga
@scripts_llenado/aeronave_carga.sql

prompt Llenando empleado
@scripts_llenado/empleado_navegante.sql 
@scripts_llenado/empleado_sobrecargo.sql 
@scripts_llenado/empleado_ingeniero.sql 

prompt Llenando referencias_empleado 
@scripts_llenado/referencias_empleado.sql 

prompt Llenando pasajero 
@scripts_llenado/pasajero.sql 

prompt Llenando vuelo 
@scripts_llenado/vuelo_pasajeros.sql 
@scripts_llenado/vuelo_pasajeros_carga.sql 
@scripts_llenado/vuelo_carga.sql 

prompt Llenando vuelo_ubicacion
@scripts_llenado/vuelo_ubicacion

prompt Llenando vuelo_pasajero 
@scripts_llenado/vuelo_pasajero.sql 

prompt Llenando historico_status_vuelo
@scripts_llenado/historico_status_vuelo.sql 

prompt Llenando paquete 
@scripts_llenado/paquete.sql 

prompt Llenando pase_abordaje 
@scripts_llenado/pase_abordaje.sql 

prompt Llenando equipaje
@scripts_llenado/equipaje

prompt LLenando tripulacion 
@scripts_llenado/tripulacion_piloto.sql 
@scripts_llenado/tripulacion_copilotos_pasajeros.sql 
@scripts_llenado/tripulacion_copilotos_carga.sql 
@scripts_llenado/tripulacion_jefe_sobrecargos.sql
@scripts_llenado/tripulacion_sobrecargos.sql 
@scripts_llenado/tripulacion_tecnicos.sql

