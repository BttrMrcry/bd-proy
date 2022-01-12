--@Autor(es): López Becerra Ricardo
--@Fecha creación: 11/01/2022
--@Descripción: Verifica si una aeronave y un vuelo son compatibles
connect l_proy_admin/contrasenia 

create or replace trigger verifica_vuelo_aeronave
    before insert or update of aeronave_id on vuelo
    for each row
    declare 
        v_es_comercial number;
        v_es_carga number;
    begin
        select es_comercial, es_carga into v_es_comercial, v_es_carga 
        from aeronave
        where aeronave_id = :new.aeronave_id;
        if :new.es_carga = 1 and v_es_carga = 0 then
            raise_application_error(-20010,'El vuelo es de tipo carga y el '
            || 'avión no');
        end if;

        if :new.es_pasajeros = 1 and v_es_comercial = 0 then 
            raise_application_error(-20010, 'El vuelo es de pasajeros pero '
            ||'el avión no');
        end if;       
    end;
    /
    show errors;