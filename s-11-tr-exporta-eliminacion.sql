--@Autor(es): López Becerra Ricardo
--@Fecha creación: 11/01/2022
--@Descripción: Triggers que exporta a un documento del SO las eliminaciones en la tabla vuelo_pasajero


create or replace trigger exporta_eliminacion_vuelo_pasajero
for delete on vuelo_pasajero
compound trigger 
  type vuelo_pasajero_type is record (
    pasajero_id vuelo_pasajero.pasajero_id%type,
    vuelo_id vuelo_pasajero.vuelo_id%type,
    numero_asiento vuelo_pasajero.numero_asiento%type,
    usuario varchar2(2000),
    fecha date
  );

  type vuelo_pasajero_list_type is table of vuelo_pasajero_type;
  vp_list vuelo_pasajero_list_type := vuelo_pasajero_list_type();

  before each row is
    v_count number;
    v_index number;
    v_date date := sysdate;
    v_usuario varchar2(2000) := sys_context('USERENV','SESSION_USER');
  begin 
    vp_list.extend;
    v_index := vp_list.last;
    vp_list(v_index).pasajero_id := :old.pasajero_id;
    vp_list(v_index).vuelo_id := :old.vuelo_id;
    vp_list(v_index).numero_asiento := :old.numero_asiento;
    vp_list(v_index).usuario := v_usuario;
    vp_list(v_index).fecha := v_date;
  end before each row; 

  after statement is
    out_file utl_file.file_type;
    v_registro varchar2(2000);
  begin
    out_file := utl_file.fopen('TMP_DIR','registro.txt','a');
    for v_index in vp_list.first .. vp_list.last loop
      v_registro := 'Pasajero_id: '
      || vp_list(v_index).pasajero_id
      || ' vuelo_id: '
      || vp_list(v_index).vuelo_id
      || ' numero_asiento: '
      || vp_list(v_index).numero_asiento
      ||' usuario: '
      || vp_list(v_index).usuario
      ||' fecha: ' 
      || vp_list(v_index).fecha;
      utl_file.put_line(out_file,v_registro);
    end loop;
    utl_file.fclose(out_file);
  end after statement;
end;
/
show errors


