--@Autor(es): López Becerra Ricardo, Martinez Reyes Javier
--@Fecha creación: 27/12/2021
--@Descripción: Creación de usuarios necesarios para la BD del proyecto final

whenever sqlerror exit rollback

connect sys/system as sysdba
--permite la salida de mensajes a consula empleabo dbms_output.put_line
set serveroutput on
--este bloque anómimo valida la existencia del usuario, si existe lo elimina.
declare 
    v_count number(1,0);
begin
    select count(*) into v_count
    from dba_users
    where username = 'LM_PROY_INVITADO';
    if v_count > 0 then
    dbms_output.put_line('Eliminando usuario existente');
    execute immediate 'drop user LM_PROY_INVITADO cascade';
    end if; 

    select count(*) into v_count
    from dba_users
    where username = 'LM_PROY_ADMIN';
    if v_count > 0 then
    dbms_output.put_line('Eliminando usuario existente');
    execute immediate 'drop user LM_PROY_ADMIN cascade';
    end if; 

    select count(*) into v_count
    from dba_roles
    where  role = 'ROL_ADMIN';
    if v_count > 0 then
    dbms_output.put_line('Eliminando rol_admin');
    execute immediate 'drop role ROL_ADMIN';
    end if; 

    select count(*) into v_count
    from dba_roles
    where role = 'ROL_INVITADO';
    if v_count > 0 then
    dbms_output.put_line('Eliminando rol_invitado');
    execute immediate 'drop role ROL_INVITADO';
    end if; 


end;
/
--creación de roles
PROMPT crando roles...

create role rol_admin;
grant create session, create table, create view, create sequence, create procedure
to rol_admin;

create role rol_invitado;
grant create session to rol_invitado;

--creación de usuarios
prompt creando usuarios...
create user lm_proy_admin identified by contrasenia quota unlimited on users;
create user lm_proy_invitado identified by contrasenia;

--Asignando roles
prompt asignando roles a los usuarios...
grant rol_admin to lm_proy_admin;
grant rol_invitado to lm_proy_invitado;

prompt script completado con exito!
whenever sqlerror continue none;