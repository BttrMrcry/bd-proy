--@Autor(es): López Becerra Ricardo
--@Fecha creación: 27/12/2021
--@Descripción: Script de ejecución principal

prompt ejecutando script s-01-usuarios 
@s-01-usuarios.sql 

begin
dbms_session.sleep(3);
end;
/

prompt ejecutando script s-02-entidades
@s-02-entidades.sql

begin
dbms_session.sleep(3);
end;
/

prompt ejecutando script s-04-tablas-externas
@s-04-tablas-externas.sql

begin
dbms_session.sleep(3);
end;
/

prompt ejecutando script s-05-secuencias
@s-05-secuencias.sql

begin
dbms_session.sleep(3);
end;
/

prompt ejecutando script s-06-indices
@s-06-indices.sql

begin
dbms_session.sleep(3);
end;
/

prompt ejecutando script s-07-sinonimos
@s-07-sinonimos.sql

begin
dbms_session.sleep(3);
end;
/

prompt ejecutando script s-08-vistas
@s-08-vistas.sql  

begin
dbms_session.sleep(3);
end;
/

prompt ejecutando script s-09-carga-inicial 
@s-09-carga-inicial.sql

begin
dbms_session.sleep(1);
end;
/

prompt ejecutando script s-03-tablas-temporales
@s-03-tablas-temporales.sql

begin
dbms_session.sleep(1);
end;
/