begin
    for cur in (select table_name from user_tables)
    loop
        begin
            dbms_output.put_line('Dropping ' || cur.table_name);
            execute immediate 'drop table ' || cur.table_name || ' cascade constraints;';
        exception
            when others then
                dbms_output.put_line('Failed to drop ' || cur.table_name);
        end;
    end loop;
end;
