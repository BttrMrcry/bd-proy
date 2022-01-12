--@Autor(es): López Becerra Ricardo
--@Fecha creación: 11/01/2022
--@Descripción: Bloque anónimo que prueba el triger verifica_vuelo_aeronave


set serveroutput on
declare
    k_vuelo number := seq_vuelo.nextval;
    k_aeronave number := seq_aeronave.nextval;
begin

    --verificando vuelo de pasajeros con avión de carga
    dbms_output.put_line('Verificando avión de carga con vuelo de pasajeros');    
    insert into aeronave(aeronave_id, es_comercial, 
        es_carga, especificaciones_tecnicas, matricula, modelo)
    values (k_aeronave, 0, 1, empty_blob(), '123456789', 'modelo');
    
    
    begin    
        insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
            fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
            aeropuerto_destino, aeropuerto_origen, aeronave_id,
            status_vuelo_id)
        values(k_vuelo, sysdate, 1, 0, sysdate+ 1/24, sysdate + 1/12, 
        99999, null, 1, 2, k_aeronave, 1); 
        raise_application_error(-20020, 'La inserción se realizó');
    exception
        when others then
            if sqlcode = -20010 then 
                dbms_output.put_line(sqlerrm);
                dbms_output.put_line('Prueba exitosa');
            else 
                dbms_output.put_line('Prueba fallida');
                delete from vuelo where vuelo_id = k_vuelo;
                delete from aeronave where aeronave_id = k_aeronave;
                raise;
            end if;
    end;
    delete from vuelo where vuelo_id = k_vuelo;
    delete from aeronave where aeronave_id = k_aeronave;

    --Verificando cuando es un avión comercial y un vuelo de carga
    dbms_output.put_line('Verificando avión comercial con vuelo de carga');    
    insert into aeronave(aeronave_id, es_comercial, 
        es_carga, especificaciones_tecnicas, matricula, modelo)
    values (k_aeronave, 1, 0, empty_blob(), '123456789', 'modelo');
    
    
    begin    
        insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
            fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
            aeropuerto_destino, aeropuerto_origen, aeronave_id,
            status_vuelo_id)
        values(k_vuelo, sysdate, 0, 1, sysdate+ 1/24, sysdate + 1/12, 
        99999, null, 1, 2, k_aeronave, 1); 
        raise_application_error(-20020, 'La inserción se realizó');
    exception
        when others then
            if sqlcode = -20010 then 
                dbms_output.put_line(sqlerrm);
                dbms_output.put_line('Prueba exitosa');
            else 
                dbms_output.put_line('Prueba fallida');
                delete from vuelo where vuelo_id = k_vuelo;
                delete from aeronave where aeronave_id = k_aeronave;
                raise;
            end if;
    end;
    delete from vuelo where vuelo_id = k_vuelo;
    delete from aeronave where aeronave_id = k_aeronave;

        --Verificando cuando es un avión comercial y de carga con un vuelo de carga
    dbms_output.put_line('Verificando avión comercial y de carga con un vuelo de carga');    
    insert into aeronave(aeronave_id, es_comercial, 
        es_carga, especificaciones_tecnicas, matricula, modelo)
    values (k_aeronave, 1, 1, empty_blob(), '123456789', 'modelo');
    
    
    begin    
        insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
            fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
            aeropuerto_destino, aeropuerto_origen, aeronave_id,
            status_vuelo_id)
        values(k_vuelo, sysdate, 0, 1, sysdate+ 1/24, sysdate + 1/12, 
        99999, null, 1, 2, k_aeronave, 1); 
        dbms_output.put_line('Inserción realizada, Prueba exitosa');
    exception
        when others then
            dbms_output.put_line('Prueba fallida');
            delete from vuelo where vuelo_id = k_vuelo;
            delete from aeronave where aeronave_id = k_aeronave;
            raise;
    end;
    delete from vuelo where vuelo_id = k_vuelo;
    delete from aeronave where aeronave_id = k_aeronave;
    dbms_output.put_line('Prueba exitosa!');
end;
/