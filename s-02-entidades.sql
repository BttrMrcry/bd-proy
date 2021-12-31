--@Autor(es): López Becerra Ricardo, Martinez Reyes Javier
--@Fecha creación: 27/12/2021
--@Descripción: Código ddl de las entidades de la bd






prompt conectando con el usuario administrador
connect lm_proy_admin/contrasenia


--Aeropuerto
create table aeropuerto(
  aeropuerto_id number(10,0),
  clave varchar2(13) not null,
  nombre varchar2(40) not null,
  latitud number(5,2) not null,
  longitud number(5,2) not null,
  bandera_activo number(1,0) not null,
  constraint aeropuerto_pk primary key(aeropuerto_id)
);

--Aeronave
create table aeronave(
  aeronave_id number(10,0) not null,
  es_comercial number(1,0) not null,
  es_carga number(1,0) not null,
  especificaciones_tecnicas blob not null,
  matricula varchar2(10) not null,
  modelo varchar2(40) not null,
  constraint aeronave_pk primary key(aeronave_id),
  constraint aeronave_es_comercial_es_carga_chk 
  check(es_comercial = 1 or es_carga = 1)
);

--Aeronave_carga
create table aeronave_carga(
  aeronave_id number(10,0) not null,
  bodega_ancho number(4,0) not null,
  bodega_profundidad number(4,0) not null,
  bodega_alto number(4,0) not null,
  numero_bodegas number(3,0) not null,
  capacidad_carga_tons number(4,0) not null,
  aeropuerto_resguardo number(10,0) not null,
  constraint aeronave_carga_pk primary key(aeronave_id),
  constraint aeronave_carga_aeronave_id foreign key (aeronave_id) 
    references aeronave(aeronave_id),
  constraint aeronave_carga_aeropuerto_resguardo_fk 
    foreign key (aeropuerto_resguardo) references aeropuerto(aeropuerto_id)
);

--aeronave_comercial
create table aeronave_comercial(
  aeronave_id number(10,0) not null,
  capacidad_pasajeros_ordinarios number(4,0) not null,
  capacidad_pasajeros_vip number(4,0) not null,
  capacidad_pasajeros_discapacitados number(4,0) not null,
  constraint aeronave_comercial_pk primary key(aeronave_id),
  constraint aeronave_comercial_aeronave_id_fk foreign key(aeronave_id)
  references aeronave(aeronave_id)
);

--Estado

create table estado(
  estado_id number(10,0) not null,
  nombre varchar2(20) not null,
  constraint estado_pk primary key(estado_id),
  constraint estado_nombre_uk unique(nombre)
);

--vuelo
prompt creando vuelo

create table vuelo(
  vuelo_id number(10,0) not null,
  fecha_estado date not null,
  es_pasajeros number(1,0) not null,
  es_carga number(1,0) not null,
  fecha_salida date not null,
  fecha_llegada date not null,
  numero_vuelo number(5,0) not null,
  sala_abordaje number(4,0),
  aeropuerto_destino number(10,0) not null,
  aeropuerto_origen number(10,0) not null,
  aeronave_id number(10,0) not null,
  estado_id number(10,0) not null,
  constraint vuelo_pk primary key(vuelo_id),
  constraint vuelo_aeropuerto_destino_fk foreign key(aeropuerto_destino)
  references aeropuerto(aeropuerto_id),
  constraint vuelo_aeropuerto_origen_fk foreign key(aeropuerto_origen)
  references aeropuerto(aeropuerto_id),
  constraint vuelo_aeronave_id_fk foreign key(aeronave_id) 
  references aeronave(aeronave_id),
  constraint vuelo_estado_id_fk foreign key(estado_id)
  references estado(estado_id),
  constraint vuelo_aeropuerto_destino_aeropuesto_origen_chk 
    check(aeropuerto_origen <> aeropuerto_destino),
  constraint vuelo_fecha_salida_fecha_llegada_chk 
    check(fecha_salida < fecha_llegada),
  constraint vuelo_es_pasajeros_es_carga_chk 
    check(es_pasajeros = 1 or es_carga = 1)
);



--Historial_estado
prompt creando historial_estado
create table historial_estado(
  historial_estado_id number(10,0) not null,
  fecha date not null,
  estado_id number(10,0) not null,
  vuelo_id number(10,0) not null,
  constraint historial_estado_pk primary key(historial_estado_id),
  constraint historial_estado_estado_id foreign key(estado_id)
    references estado(estado_id),
  constraint historial_estado_vuelo_id foreign key(vuelo_id)
    references vuelo(vuelo_id)
);

--vuelo_ubicacion
prompt creando vuelo_ubicacion
create table vuelo_ubicacion(
  numero number(5,0) not null,
  vuelo_id number(10,0) not null,
  fecha date not null,
  latitud number(5,2) not null,
  longitud number(5,2) not null,
  constraint vuelo_ubicacion_pk primary key(vuelo_id,numero),
  constraint vuelo_ubicacion_vuelo_id_fk foreign key(vuelo_id)
  references vuelo(vuelo_id)
); 

--tipo_paquete
create table tipo_paquete(
  tipo_paquete_id number(10,0) not null,
  clave varchar2(20) not null,
  descripcion varchar2(500) not null,
  indicaciones_generales varchar2(1000) not null,
  constraint tipo_paquete_pk primary key(tipo_paquete_id) 
);

--Paquete 

create table paquete(
  paquete_id number(10,0) not null,
  folio number(18,0) not null,
  peso_kg number(10,2) not null,
  tipo_paquete_id number(10,0) not null,
  vuelo_id number(10,0) not null,
  constraint paquete_pk primary key(paquete_id),
  constraint paquete_tipo_paquete_id_fk foreign key(tipo_paquete_id)
  references tipo_paquete(tipo_paquete_id),
  constraint paquete_vuelo_id_fk foreign key(vuelo_id)
  references vuelo(vuelo_id)
);

--Rol empleado 
create table rol_empleado(
  rol_empleado_id number(10,0) not null,
  nombre varchar2(40) not null,
  descripcion	varchar2(1000) not null,
  constraint rol_empleado_pk primary key(rol_empleado_id)
);

--Puesto
create table puesto(
  puesto_id number(6,0) not null,
  clave varchar2(20) not null,
  nombre varchar2(40) not null,
  descripcion varchar2(500) not null,
  sueldo_mensual number(10,2) not null,
  constraint puesto_pk primary key (puesto_id)
);
--empleado
create table empleado(
  empleado_id number(10,0) not null,
  puntos number(3,0) not null,
  nombre varchar2(20) not null,
  ap_paterno varchar2(20) not null,
  ap_materno varchar2(20) not null,
  RFC varchar2(20) not null,
  CURP varchar2(18) not null,
  foto blob not null,
  puesto_id number(6,0) not null,
  jefe_id number(10,0),
  constraint empleado_pk primary key(empleado_id),
  constraint empleado_puesto_id_fk foreign key(puesto_id)
  references puesto(puesto_id),
  constraint empleado_jefe_fk foreign key(jefe_id)
  references empleado(empleado_id)
);



--Referencias_empleado

create table referencias_empleado(
  numero number(1,0) not null,
  empleado_id number(10,0) not null,
  URL varchar2(1000) not null,
  constraint referencias_empleado_pk primary key(empleado_id,numero),
  constraint referencias_empleado_empleado_id_fk foreign key(empleado_id)
  references empleado(empleado_id),
  constraint referencias_empleado_URL unique(URL)
);


--tripulacion 
create table tripulacion(
  tripulacion_id number(10,0) not null,
  empleado_id number(10,0) not null,
  vuelo_id number(10,0) not null,
  rol_empleado_id number(10,0) not null,
  constraint tripulacion_pk primary key(tripulacion_id),
  constraint tripulacion_empleado_id_fk foreign key(empleado_id)
  references empleado(empleado_id),
  constraint tripulacion_vuelo_id_fk foreign key(vuelo_id)
  references vuelo(vuelo_id),
  constraint tripulacion_rol_empleado_id_fk foreign key(rol_empleado_id)
  references rol_empleado(rol_empleado_id)
);

--Tabla pasajero
create table pasajero(
  pasajero_id number(10,0) not null,
  nombre varchar2(20) not null,
  ap_paterno varchar2(40) not null,
  ap_materno varchar2(40),
  email varchar2(300),
  fecha_nacimiento date not null,
  CURP varchar2(18) not null,
  constraint pasajero_pk primary key(pasajero_id)
);

--Tabla vuelo_pasajero

create table vuelo_pasajero(
  vuelo_pasajero_id number(10,0) not null,
  bandera_abordado number(1,0) not null,
  indicaciones_especiales varchar2(2000) not null,
  numero_asiento varchar2(40) not null,
  pasajero_id number(10,0) not null,
  vuelo_id number(10,0) not null,
  constraint vuelo_pasajero_pk primary key(vuelo_pasajero_id),
  constraint vuelo_pasajero_pasajero_id_fk foreign key(pasajero_id)
  references pasajero(pasajero_id),
  constraint vuelo_pasajero_vuelo_id foreign key(vuelo_id)
  references vuelo(vuelo_id)
);

--Tabla pase_abordaje

create table pase_abordaje(
  pase_abordaje_id number(10,0) not null,
  fecha_impresion date not null,
  folio varchar2(8) not null,
  vuelo_pasajero_id number(10,0) not null,
  constraint pase_abordaje_pk primary key(pase_abordaje_id),
  constraint pase_abordaje_vuelo_pasajero_id_fk foreign key(vuelo_pasajero_id)
  references vuelo_pasajero(vuelo_pasajero_id)
);

--tabla equipaje

create table equipaje(
  equipaje_id number(10,0) not null,
  numero_equipaje number(2,0) not null,
  peso_kg number(6,0) not null,
  pase_abordaje_id number(10,0) not null,
  constraint equipaje_pk primary key(equipaje_id),
  constraint equipaje_pase_abordaje_id foreign key(pase_abordaje_id)
  references pase_abordaje(pase_abordaje_id)
);
