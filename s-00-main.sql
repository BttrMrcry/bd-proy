--@Autor(es): López Becerra Ricardo
--@Fecha creación: 27/12/2021
--@Descripción: Script de ejecución principal

prompt ejecutando script s-01-usuarios 
@s-01-usuarios.sql 

prompt ejecutando script s-02-entidades
@s-02-entidades.sql

prompt ejecutando script s-04-tablas-externas
@s-04-tablas-externas.sql

prompt ejecutando script s-03-tablas-temporales
@s-03-tablas-temporales.sql

prompt ejecutando script s-05-secuencias
@s-05-secuencias.sql

prompt ejecutando script s-06-indices
@s-06-indices.sql


prompt ejecutando script s-07-sinonimos
@s-07-sinonimos.sql

prompt ejecutando script s-08-vistas
@s-08-vistas.sql  

prompt ejecutando script s-09-carga-inicial 
@s-09-carga-inicial.sql