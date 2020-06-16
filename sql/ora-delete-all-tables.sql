begin
    for tcur in (select table_name from user_tables)
    loop
        begin
            dbms_output.put_line('Dropping ' || tcur.table_name);
            execute immediate 'drop table ' || tcur.table_name || ' cascade constraints';
        exception
            when others then
                dbms_output.put_line('Failed to drop ' || tcur.table_name);
        end;
    end loop;

    for scur in (select sequence_name from user_sequences)
    loop
        begin
            dbms_output.put_line('Dropping ' || scur.sequence_name);
            execute immediate 'drop sequence ' || scur.sequence_name;
        exception
            when others then
                dbms_output.put_line('Failed to drop ' || scur.sequence_name);
        end;
    end loop;
end;
