--@Autor(es): López Becerra Ricardo
--@Fecha creación: 11/01/2022
--@Descripción: Procedimiento que prueba la funcion carga_bin

!cp /home/ricardolb/sql/bd-proy/prueba.pdf /tmp/bases/binfiles
set serveroutput on 
declare
    v_nombre_archivo varchar2(4000) := 'prueba.pdf';
    v_file bfile;
    v_blob blob;
begin 
    v_file := bfilename('BINFILES_DIR',v_nombre_archivo);
    v_blob := carga_bin('prueba.pdf');


    if dbms_lob.getlength(v_file) = dbms_lob.getlength(v_blob) then 
        dbms_output.put_line('Prueba exitosa, los tamaños del archivo y del bolb son iguales');
    else 
        dbms_output.put_line('Prueba faliida, los tamaños son diferentes');
    end if;

end;
/