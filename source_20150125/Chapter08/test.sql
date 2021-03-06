 rem test.sql
 rem by Donald J. Bales on 2014-10-20
 rem An anonymous PL/SQL procedure to execute all test units
 rem and to report on the results of each test.

 declare

 -- Get the names of all packages and types that have a test unit
 cursor c_test is
 select p.object_name package_name
 from SYS.USER_PROCEDURES p
 where p.object_type = 'PACKAGE'
 and upper(p.procedure_name) = 'TEST'
 and not exists (
 select 1
 from SYS.USER_ARGUMENTS x
 where x.package_name = p.object_name
 and x.object_name = p.procedure_name)
 UNION
 select m.type_name package_name
 from SYS.USER_TYPE_METHODS m
 where upper(m.method_name) = 'TEST'
 and m.parameters = 0
 order by 1;

 -- Get the names of all packages and types that don't have a test unit
 cursor c_missing is
 (select p.object_name package_name
 from SYS.USER_PROCEDURES p
 where p.object_type = 'PACKAGE'
 UNION
 select m.type_name package_name
 from SYS.USER_TYPE_METHODS m )
 MINUS
 (select p.object_name package_name
 from SYS.USER_PROCEDURES p
 where upper(p.procedure_name) = 'TEST'
 and not exists (
 select 1
 from SYS.USER_ARGUMENTS x
 where x.package_name = p.object_name
 and x.object_name = p.procedure_name)
 UNION
 select m.type_name package_name
 from SYS.USER_TYPE_METHODS m
 where upper(m.method_name) = 'TEST'
 and m.parameters = 0)
 order by 1;

 -- Get the names of all packages and types that have test unit errors
 cursor c_error is
 select object_name||
 decode(substr(method_name, -1, 1), ')', '.', ' ')||
 method_name object_method,
 test_number,
 result
 from TESTS
 where result <> 'OK'
 and result <> 'SUCCESS'
 order by 1;

 TYPE error_message_table is table of varchar2(32767)
 index by binary_integer;

 n_error_message number := 0;
 n_object_method_width number := 39;
 n_result_width number := 29;
 n_status number;
 n_test_number_width number := 5;

 t_error_message error_message_table;

 v_line varchar2(32767);

 begin
 -- execute the test units
 for r_test in c_test loop
 begin
 execute immediate 'begin '||r_test.package_name||'.test(); end;';
 exception
 when OTHERS then
 n_error_message := n_error_message + 1;
 t_error_message(n_error_message) :=
 r_test.package_name||'.test() '||SQLERRM;
 end;
 end loop;
 -- Empty the output buffer
 loop
 SYS.DBMS_OUTPUT.get_line(v_line, n_status);
 if nvl(n_status, 0) < 1 then
 exit;
 end if;
 end loop;
 -- Show the test units that had errors
 for r_error in c_error loop
 if c_error%rowcount = 1 then
 pl(chr(9));
 pl('THE FOLLOWING OBJECT''S TEST UNITS HAD ERRORS:');
 pl(chr(9));
 pl(
 rpad(
 substr('OBJECT/METHOD',
 1, n_object_method_width),
 n_object_method_width, ' ')||
 ' '||
 lpad(
 substr('TEST#',
 1, n_test_number_width),
 n_test_number_width, ' ')||
 ' '||
 rpad(
 substr('ERROR',
 1, n_result_width),
 n_result_width, ' ')
 );
 pl(
 rpad(
 substr('-------------',
 1, n_object_method_width),
 n_object_method_width, '-')||
 ' '||
 lpad(
 substr('-----',
 1, n_test_number_width),
 n_test_number_width, '-')||
 ' '||
 rpad(
 substr('-----',
 1, n_result_width),
 n_result_width, '-')
 );
 end if;
 pl(
 rpad(
 substr(r_error.object_method,
 1, n_object_method_width),
 n_object_method_width, ' ')||
 ' '||
 lpad(
 substr(ltrim(to_char(r_error.test_number)),
 1, n_test_number_width),
 n_test_number_width, ' ')||
 ' '||
 rpad(
 substr(r_error.result,
 1, n_result_width),
 n_result_width, ' ')
 );
 end loop;
 -- Show the test units that failed to run
 if t_error_message.count > 0 then
 for i in t_error_message.first..t_error_message.last loop
 if i = t_error_message.first then
 pl(chr(9));
 pl('THE FOLLOWING OBJECT''S TEST UNITS FAILED:');
 end if;
 pl(chr(9));
 pl(t_error_message(i));
 end loop;
 end if;
 -- Show the object that missing test units
 for r_missing in c_missing loop
 if c_missing%rowcount = 1 then
 pl(chr(9));
 pl('THE FOLLOWING OBJECTS ARE MISSING TEST UNITS:');
 pl(chr(9));
 end if;
 pl(r_missing.package_name);
 end loop;
 end;
 /