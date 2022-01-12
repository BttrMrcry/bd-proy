--@Autor(es): López Becerra Ricardo
--@Fecha creación: 09/01/2022
--@Descripción: Bloque anónimo que verifica el  
--funcionamiento de s-17-carga-fotos-empleados.sql

connect l_proy_admin/contrasenia 
set serveroutput on 

begin 
	sp_actualiza_foto_empleado(1,100);    
end;
/

declare 

cursor cur_empleado_foto is
select empleado_id, dbms_lob.getlength(foto) as tamanio
from empleado
where empleado_id <= 100
order by empleado_id;

begin
	for r in cur_empleado_foto loop 
	dbms_output.put_line('Verificando empleado con id = '
		|| r.empleado_id);
	
	if r.tamanio > 0 then 
		dbms_output.put_line('El tamaño del blob es: '
			||r.tamanio);
	else 
		raise_application_error(-20002,'El blob del empleado con id ' 
		||r.empleado_id 
		||' está vacío. La foto no se cargó');
	end if;
	end loop;
	dbms_output.put_line('Prueba exitosa!');

end;
/
show errors;