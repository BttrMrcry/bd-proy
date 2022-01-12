--@Autor(es): López Becerra Ricardo
--@Fecha creación: 02/01/2022
--@Descripción: Código para generar las secuencias necesarias 

prompt Conectando con el usuario administrador
connect l_proy_admin/contrasenia
show user

create sequence seq_aeronave
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence seq_pasajero
  start with 1
  increment by 1
  nocycle
  cache 5;

create sequence seq_vuelo_pasajero
  start with 1
  increment by 1
  nocycle
  cache 10;

create sequence seq_vuelo
  start with 1
  increment by 1
  nocycle
  cache 5;

create sequence seq_aeropuerto
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence seq_equipaje
  start with 1
  increment by 1
  nocycle
  cache 10;

create sequence seq_pase_abordaje
  start with 1
  increment by 1
  nocycle
  cache 10;

create sequence seq_rol_empleado
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence seq_tripulacion
  start with 1
  increment by 1
  nocycle
  cache 10;

create sequence seq_paquete
  start with 1
  increment by 1
  nocycle
  cache 10;

create sequence seq_status_vuelo
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence seq_historico_status_vuelo
  start with 1
  increment by 1
  nocycle
  cache 10;

create sequence seq_puesto
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence seq_empleado
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence seq_tipo_paquete
  start with 1
  increment by 1
  nocycle
  nocache;

