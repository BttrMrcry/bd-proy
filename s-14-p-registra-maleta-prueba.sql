--@Autor(es): López Becerra Ricardo
--@Fecha creación: 11/01/2022
--@Descripción: Bloque anónimo que prueba el regitro de una maleta
--con el procedimiento registra_maleta.
connect l_proy_admin/contrasenia 

set serveroutput on
declare
    k_vuelo number := seq_vuelo.nextval;
    k_vuelo_pasajero number := seq_vuelo_pasajero.nextval;
    k_pase_abordaje number := seq_pase_abordaje.nextval;
    k_equipaje number := seq_equipaje.nextval;
begin

    --Cuando no existe el pase
    dbms_output.put_line('Probando el caso en el que aún no se genera un pase de abordaje');
    insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
        fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
        aeropuerto_destino, aeropuerto_origen, aeronave_id,
        status_vuelo_id)
    values(k_vuelo, sysdate, 1, 0, sysdate+ 1/24, sysdate + 1/12, 
    99999, null, 1, 2, 1, 1);
    insert into vuelo_pasajero(vuelo_pasajero_id, bandera_abordado, 
    indicaciones_especiales, numero_asiento, pasajero_id, vuelo_id)
    values (k_vuelo_pasajero, 0, null, 1, 1, k_vuelo); 
    
    begin
    registra_maleta(1,k_vuelo,10);
    exception
    when others then 
        if sqlcode = -20007 then 
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line('Prueba exitosa');
        else
            dbms_output.put_line('Error inesperado');
            delete from equipaje where pase_abordaje_id = k_pase_abordaje;

            delete from pase_abordaje where pase_abordaje_id = k_pase_abordaje;
            
            delete from vuelo_pasajero 
            where vuelo_pasajero_id = k_vuelo_pasajero;

            delete from vuelo 
            where vuelo_id = k_vuelo;
            
            raise;
        end if;
    end;

    delete from vuelo_pasajero 
    where vuelo_pasajero_id = k_vuelo_pasajero;

    delete from vuelo 
    where vuelo_id = k_vuelo;

    --cuando el vuelo no es válido

    dbms_output.put_line('Probando el caso en el que vuelo no es válido pero si se generó un pase de abordar');
    
    insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
        fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
        aeropuerto_destino, aeropuerto_origen, aeronave_id,
        status_vuelo_id)
    values(k_vuelo, sysdate, 1, 0, sysdate+ 1/24, sysdate + 1/12, 
    99999, null, 1, 2, 1, 2);
    
    insert into vuelo_pasajero(vuelo_pasajero_id, bandera_abordado, 
    indicaciones_especiales, numero_asiento, pasajero_id, vuelo_id)
    values (k_vuelo_pasajero, 0, null, 1, 1, k_vuelo); 
    
    insert into pase_abordaje(pase_abordaje_id, fecha_impresion, folio, vuelo_pasajero_id)
    values(k_pase_abordaje,sysdate,'ABCDEFGH',k_vuelo_pasajero);
    
    begin
    registra_maleta(1,k_vuelo,10);
    exception
    when others then 
        if sqlcode = -20007 then 
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line('Prueba exitosa');
        else
            dbms_output.put_line('Error inesperado');
            delete from equipaje where pase_abordaje_id = k_pase_abordaje;

            delete from pase_abordaje where pase_abordaje_id = k_pase_abordaje;
            
            delete from vuelo_pasajero 
            where vuelo_pasajero_id = k_vuelo_pasajero;

            delete from vuelo 
            where vuelo_id = k_vuelo;
            
            raise;
        end if;
    end;

    delete from equipaje where pase_abordaje_id = k_pase_abordaje;

    delete from pase_abordaje where pase_abordaje_id = k_pase_abordaje;
    
    delete from vuelo_pasajero 
    where vuelo_pasajero_id = k_vuelo_pasajero;

    delete from vuelo 
    where vuelo_id = k_vuelo;


    --cuando el cuando el pasajero no está registrado el el vuelo

    dbms_output.put_line('Probando el caso en el que el pasajero no está registrado en el vuelo');
    
    insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
        fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
        aeropuerto_destino, aeropuerto_origen, aeronave_id,
        status_vuelo_id)
    values(k_vuelo, sysdate, 1, 0, sysdate+ 1/24, sysdate + 1/12, 
    99999, null, 1, 2, 1, 2);
    
    begin
    registra_maleta(1,k_vuelo,10);
    exception
    when others then 
        if sqlcode = -20007 then 
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line('Prueba exitosa');
        else
            dbms_output.put_line('Error inesperado');
            delete from equipaje where pase_abordaje_id = k_pase_abordaje;

            delete from pase_abordaje where pase_abordaje_id = k_pase_abordaje;
            
            delete from vuelo_pasajero 
            where vuelo_pasajero_id = k_vuelo_pasajero;

            delete from vuelo 
            where vuelo_id = k_vuelo;
            
            raise;
        end if;
    end;
    
    delete from equipaje where pase_abordaje_id = k_pase_abordaje;

    delete from pase_abordaje where pase_abordaje_id = k_pase_abordaje;
    
    delete from vuelo_pasajero 
    where vuelo_pasajero_id = k_vuelo_pasajero;

    delete from vuelo 
    where vuelo_id = k_vuelo;

    --Caso donde ya hay 5 maletas registradas

     dbms_output.put_line('Probando el caso en el que ya hay 5 maletas registradas');
    
    insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
        fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
        aeropuerto_destino, aeropuerto_origen, aeronave_id,
        status_vuelo_id)
    values(k_vuelo, sysdate, 1, 0, sysdate+ 1/24, sysdate + 1/12, 
    99999, null, 1, 2, 1, 1);
    
    insert into vuelo_pasajero(vuelo_pasajero_id, bandera_abordado, 
    indicaciones_especiales, numero_asiento, pasajero_id, vuelo_id)
    values (k_vuelo_pasajero, 0, null, 1, 1, k_vuelo); 
    
    insert into pase_abordaje(pase_abordaje_id, fecha_impresion, folio, vuelo_pasajero_id)
    values(k_pase_abordaje,sysdate,'ABCDEFGH',k_vuelo_pasajero);

    insert into equipaje(equipaje_id, pase_abordaje_id, numero_equipaje, peso_kg) 
    values (seq_equipaje.nextval, k_pase_abordaje, 5, 10);
    
    begin
    registra_maleta(1,k_vuelo,10);
    exception
    when others then 
        if sqlcode = -20007 then 
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line('Prueba exitosa');
        else
            dbms_output.put_line('Error inesperado');
            delete from equipaje where pase_abordaje_id = k_pase_abordaje;

            delete from pase_abordaje where pase_abordaje_id = k_pase_abordaje;
            
            delete from vuelo_pasajero 
            where vuelo_pasajero_id = k_vuelo_pasajero;

            delete from vuelo 
            where vuelo_id = k_vuelo;
            
            raise;
        end if;
    end;
    
    delete from equipaje where pase_abordaje_id = k_pase_abordaje;

    delete from pase_abordaje where pase_abordaje_id = k_pase_abordaje;
    
    delete from vuelo_pasajero 
    where vuelo_pasajero_id = k_vuelo_pasajero;

    delete from vuelo 
    where vuelo_id = k_vuelo;



        --Caso cuando se pudo ingresar una maleta de manera exitosa

     dbms_output.put_line('Probando el caso en el que se deberia ingresar una maleta de forma exitosa');
    
    insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
        fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
        aeropuerto_destino, aeropuerto_origen, aeronave_id,
        status_vuelo_id)
    values(k_vuelo, sysdate, 1, 0, sysdate+ 1/24, sysdate + 1/12, 
    99999, null, 1, 2, 1, 1);
    
    insert into vuelo_pasajero(vuelo_pasajero_id, bandera_abordado, 
    indicaciones_especiales, numero_asiento, pasajero_id, vuelo_id)
    values (k_vuelo_pasajero, 0, null, 1, 1, k_vuelo); 
    
    insert into pase_abordaje(pase_abordaje_id, fecha_impresion, folio, vuelo_pasajero_id)
    values(k_pase_abordaje,sysdate,'ABCDEFGH',k_vuelo_pasajero);

    
    begin
    registra_maleta(1,k_vuelo,10);
    exception
    when others then 
        dbms_output.put_line('Prueba fallida');
        raise;
    end;
    
    delete from equipaje where pase_abordaje_id = k_pase_abordaje;

    delete from pase_abordaje where pase_abordaje_id = k_pase_abordaje;
    
    delete from vuelo_pasajero 
    where vuelo_pasajero_id = k_vuelo_pasajero;

    delete from vuelo 
    where vuelo_id = k_vuelo;

    dbms_output.put_line('Prueba exitosa!');
end;
/


