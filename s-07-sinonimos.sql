--@Autor(es): López Becerra Ricardo
--@Fecha creación: 02/01/2022
--@Descripción: Código para generar los sinónimos solicitados



prompt Conectando con l_proy_admin
connect l_proy_admin/contrasenia
show user 

create or replace public synonym vuelo for l_proy_admin.vuelo;

create or replace public synonym aeropuerto for l_proy_admin.aeropuerto;

create or replace public synonym vuelo_ubicacion for l_proy_admin.vuelo_ubicacion;

--para sinónimos de l_proy_admin
grant select on vuelo  to l_proy_invitado;

grant select on aeropuerto to l_proy_invitado;

grant select on vuelo_ubicacion to l_proy_invitado;


--para sinónimos de l_proy_invitado
grant select on status_vuelo to l_proy_invitado;

grant select on historico_status_vuelo to l_proy_invitado;

grant select on vuelo_pasajero to l_proy_invitado;



prompt conectando con el usuario l_proy_invitado para crear sinónimos privados

prompt Conectando con l_proy_invitado
connect l_proy_invitado/contrasenia
show user 

create or replace synonym estado for l_proy_admin.estado;

create or replace synonym historial_estado for l_proy_admin.historial_estado;

create or replace synonym vuelo_pasajero for l_proy_admin.vuelo_pasajero;


prompt Conectando con l_proy_admin
connect l_proy_admin/contrasenia
show user 


--sinónimos privados con el prefijo XX_
set serveroutput on 
declare
    v_prefijo varchar2(3) := 'XX_';
    v_nombre_sinonimo varchar2(200);
    v_instruccion varchar2(1000);
    v_nombre_tabla varchar2(200);
    cursor cur_tablas_l_proy_admin is 
    select table_name from user_tables; 
begin
    for r in cur_tablas_l_proy_admin loop
        v_nombre_tabla := r.table_name;
        v_nombre_sinonimo := v_prefijo || v_nombre_tabla;
        v_instruccion := 'create or replace synonym ';
        v_instruccion := v_instruccion || v_nombre_sinonimo;
        v_instruccion := v_instruccion || ' for ';
        v_instruccion := v_instruccion || v_nombre_tabla;
        
        dbms_output.put_line('Ejecutando: '||v_instruccion);
        execute immediate v_instruccion;
    end loop;
end;
/
