--@Autor(es): López Becerra Ricardo
--@Fecha creación: 12/01/2022
--@Descripción: Función que verifica conexión 




connect l_proy_admin/contrasenia

create or replace function ping (
	phostname varchar2, 
	pport number default 1000
) return varchar2 is
	tcpcnx utl_tcp.connection;
	cok    constant varchar2(2) := 'ok';
	cfail  constant varchar2(5) := 'error';
begin
	tcpcnx := utl_tcp.open_connection (phostname, pport);
	utl_tcp.close_connection(tcpcnx);
	return cok;
exception
	when utl_tcp.network_error then
	if (sqlerrm like '%host%') then
		return cfail;
	elsif (sqlerrm like '%listener%') then
		return cok;
	else
		raise;
	end if;
	when others then
	raise;
end;
/

