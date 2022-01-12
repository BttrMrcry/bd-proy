--@Autor(es): López Becerra Ricardo
--@Fecha creación: 11/01/2022
--@Descripción: Bloque anónimo que verifica el trigger exporta_eliminacion_vuelo_pasajero

set serveroutput on
declare
    read_file utl_file.file_type;
    dummy_str varchar2(4000);
    v_lines_start number := 0;
    v_lines_end number := 0;
    k_vuelo_pasajero number := seq_vuelo_pasajero.nextval;
    k_vuelo number := seq_vuelo.nextval;
    k_pase_abordaje number := seq_pase_abordaje.nextval;
begin 
    dbms_output.put_line('Probando eliminación de un solo registro');
    begin
        read_file := utl_file.fopen('TMP_DIR','registro.txt','r');
        loop
            utl_file.get_line(read_file,dummy_str);
            v_lines_start := v_lines_start + 1;
        end loop;
    exception
        when no_data_found then 
            dbms_output.put_line('Al incio el archivo tiene '
            || v_lines_start||' lineas');
            utl_file.fclose(read_file);
        when others then
            dbms_output.put_line('Error inesperado leyendo el archivo');
            utl_file.fclose(read_file);
            raise;
    end;

    insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
        fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
        aeropuerto_destino, aeropuerto_origen, aeronave_id,
        status_vuelo_id)
    values(k_vuelo, sysdate, 1, 0, sysdate+ 1/24, sysdate + 1/12, 
    99999, null, 1, 2, 1, 1);
    
    insert into vuelo_pasajero(vuelo_pasajero_id, bandera_abordado, 
        indicaciones_especiales, numero_asiento, pasajero_id, vuelo_id)
    values (k_vuelo_pasajero, 0, null, 1, 1, k_vuelo); 
    
    delete from vuelo_pasajero where 
    vuelo_pasajero_id = k_vuelo_pasajero;


    begin
        read_file := utl_file.fopen('TMP_DIR','registro.txt','r');
        loop
            utl_file.get_line(read_file,dummy_str);
            v_lines_end := v_lines_end + 1;
        end loop;
    exception
        when no_data_found then 
            dbms_output.put_line('Al final el archivo tiene '
            || v_lines_end||' lineas');
            utl_file.fclose(read_file);
        when others then
            delete from vuelo where vuelo_id = k_vuelo;
            dbms_output.put_line('Error inesperado leyendo el archivo');
            utl_file.fclose(read_file);
            raise;
    end;

    if v_lines_end = v_lines_start + 1 then 
        dbms_output.put_line('Prueba exitosa');
    else
        delete from vuelo where vuelo_id = k_vuelo; 
        raise_application_error(-20030, 'No se generaron el número correcto de registros');
    end if;
    
    delete from vuelo where vuelo_id = k_vuelo;


    --Probando eliminar varios registros
    v_lines_start := 0;
    V_lines_end := 0;
    dbms_output.put_line('Probando eliminación de 10 registros');

    begin
        read_file := utl_file.fopen('TMP_DIR','registro.txt','r');
        loop
            utl_file.get_line(read_file,dummy_str);
            v_lines_start := v_lines_start + 1;
        end loop;
    exception
        when no_data_found then 
            dbms_output.put_line('Al incio el archivo tiene '
            || v_lines_start||' lineas');
            utl_file.fclose(read_file);
        when others then
            dbms_output.put_line('Error inesperado leyendo el archivo');
            utl_file.fclose(read_file);
            raise;
    end;

    for i in 0 .. 9 loop
        insert into vuelo(vuelo_id, fecha_estado, es_pasajeros, es_carga,
            fecha_salida, fecha_llegada, numero_vuelo, sala_abordaje,
            aeropuerto_destino, aeropuerto_origen, aeronave_id,
            status_vuelo_id)
        values(k_vuelo + i, sysdate, 1, 0, sysdate+ 1/24, sysdate + 1/12, 
        99990+i, null, 1, 2, 1, 1);
        
        insert into vuelo_pasajero(vuelo_pasajero_id, bandera_abordado, 
            indicaciones_especiales, numero_asiento, pasajero_id, vuelo_id)
        values (k_vuelo_pasajero + i, 0, null, 1, 1, k_vuelo + i); 
    end loop;    

    delete from vuelo_pasajero 
    where vuelo_pasajero_id <= k_vuelo_pasajero + 9
    and vuelo_pasajero_id >= k_vuelo_pasajero;

    begin
        read_file := utl_file.fopen('TMP_DIR','registro.txt','r');
        loop
            utl_file.get_line(read_file,dummy_str);
            v_lines_end := v_lines_end + 1;
        end loop;
    exception
        when no_data_found then 
            dbms_output.put_line('Al final el archivo tiene '
            || v_lines_end||' lineas');
            utl_file.fclose(read_file);
        when others then
            
            delete from vuelo where vuelo_id >= k_vuelo
            and vuelo_id <= k_vuelo + 9;

            dbms_output.put_line('Error inesperado leyendo el archivo');
            utl_file.fclose(read_file);
            raise;
    end;

    if v_lines_end = v_lines_start + 10 then 
        dbms_output.put_line('Prueba exitosa');
    else
        delete from vuelo where vuelo_id >= k_vuelo
        and vuelo_id <= k_vuelo + 9; 
        raise_application_error(-20030, 'No se generaron el número correcto de registros');
    end if;

    delete from vuelo where vuelo_id >= k_vuelo
    and vuelo_id <= k_vuelo + 9;


    --Trantando de eliminar un dato no válido 
    v_lines_start := 0;
    V_lines_end := 0;
    
    dbms_output.put_line('Probando eliminación de un registro inválido');
    begin
        read_file := utl_file.fopen('TMP_DIR','registro.txt','r');
        loop
            utl_file.get_line(read_file,dummy_str);
            v_lines_start := v_lines_start + 1;
        end loop;
    exception
        when no_data_found then 
            dbms_output.put_line('Al incio el archivo tiene '
            || v_lines_start||' lineas');
            utl_file.fclose(read_file);
        when others then
            dbms_output.put_line('Error inesperado leyendo el archivo');
            utl_file.fclose(read_file);
            raise;
    end;

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
    delete from vuelo_pasajero where 
    vuelo_pasajero_id = k_vuelo_pasajero;
    exception
        when others then 
            if sqlcode != -02292 then
                raise;
            else
                dbms_output.put_line('Continuando');
            end if;
    end;

    begin
        read_file := utl_file.fopen('TMP_DIR','registro.txt','r');
        loop
            utl_file.get_line(read_file,dummy_str);
            v_lines_end := v_lines_end + 1;
        end loop;
    exception
        when no_data_found then 
            dbms_output.put_line('Al final el archivo tiene '
            || v_lines_end||' lineas');
            utl_file.fclose(read_file);
        when others then
            delete from pase_abordaje 
            where pase_abordaje_id = k_pase_abordaje;
            
            delete from vuelo_pasajero 
            where vuelo_pasajero_id = k_vuelo_pasajero;

            delete from vuelo where vuelo_id = k_vuelo;
            dbms_output.put_line('Error inesperado leyendo el archivo');
            utl_file.fclose(read_file);
            raise;
    end;

    if v_lines_end = v_lines_start  then 
        dbms_output.put_line('Prueba exitosa');
    else
            delete from pase_abordaje 
            where pase_abordaje_id = k_pase_abordaje;
            
            delete from vuelo_pasajero 
            where vuelo_pasajero_id = k_vuelo_pasajero;

            delete from vuelo where vuelo_id = k_vuelo;
        raise_application_error(-20030, 'No se generaron el número correcto de registros');
    end if;

    delete from pase_abordaje 
    where pase_abordaje_id = k_pase_abordaje;
    
    delete from vuelo_pasajero 
    where vuelo_pasajero_id = k_vuelo_pasajero;

    delete from vuelo where vuelo_id = k_vuelo;

    dbms_output.put_line('Prueba exitosa!');
end;
/