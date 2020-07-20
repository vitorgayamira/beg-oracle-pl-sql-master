 create or replace package body TEST as
 /*
 test.pkb
 by Donald J. Bales on 2014-10-20
 A Testing package
 */

 -- Hold this value across calls to test() and result()
 n_id TESTS.id%TYPE;


 PROCEDURE clear(
 aiv_object_name TESTS.object_name%TYPE) is

 pragma autonomous_transaction;

 begin
 delete TESTS
 where object_name = aiv_object_name
 and unique_session_id = SYS.DBMS_SESSION.unique_session_id;

 commit;
 end clear;


 PROCEDURE error is

 begin
 set_result(v_TEST_ERROR);
 end error;


 PROCEDURE error(
 aiv_result in TESTS.result%TYPE) is

 begin
 set_result(aiv_result);
 end error;


 FUNCTION get_id
 return TESTS.id%TYPE is

 n_id TESTS.id%TYPE;

 begin
 select TESTS_ID.nextval
 into n_id
 from SYS.DUAL;

 return n_id;
 end get_id;


 PROCEDURE help is
 begin
 pl('You''re on your own buddy.');
 end help;


 PROCEDURE initialize is
 begin
 null;
 end;


 PROCEDURE ok is

 begin
 set_result(v_TEST_OK);
 end ok;


 PROCEDURE set_result(
 aiv_result in TESTS.result%TYPE) is

 pragma autonomous_transaction;

 begin
 update TESTS
 set result = aiv_result
 where id = n_id;

 if nvl(sql%rowcount, 0) = 0 then
 raise_application_error(-20000, 'Can''t find test'||
 to_char(n_id)||
 ' on update TEST'||
 ' in TEST.test');
 end if;

 n_id := NULL;

 commit;
 end set_result;


 PROCEDURE set_test(
 aiv_object_name in TESTS.object_name%TYPE,
 aiv_method_name in TESTS.method_name%TYPE,
 ain_test_number in TESTS.test_number%TYPE,
 aiv_description in TESTS.description%TYPE) is

 pragma autonomous_transaction;

 begin
 n_id := get_id();

 begin
 insert into TESTS (
 id,
 object_name,
 method_name,
 test_number,
 description,
 result,
 unique_session_id,
 insert_user,
 insert_date )
 values (
 n_id,
 upper(aiv_object_name),
 upper(aiv_method_name),
 ain_test_number,
 aiv_description,
 NULL,
 SYS.DBMS_SESSION.unique_session_id,
 USER,
 SYSDATE );
 exception
 when OTHERS then
 raise_application_error(-20000, SQLERRM||
 ' on insert TEST'||
 ' in TEST.test');
 end;
 commit;
 end set_test;


 PROCEDURE success is

 begin
 set_result(v_TEST_SUCCESS);
 end success;


 PROCEDURE test is

 n_number number;

 begin
 pl('TESTS.test()');
 clear('TEST');

 set_test('TEST', NULL, 1,
 'Is v_TEST_N equal to N?');
 if v_TEST_N = 'N' then
 ok();
 else
 error();
 end if;

 set_test('TEST', NULL, 2,
 'Is the length of v_TEST_N equal to 1?');
 if nvl(length(v_TEST_N), 0) = 1 then
 ok();
 else
 error();
 end if;

 set_test('TEST', NULL, 3,
 'Is v_TEST_Y equal to Y?');
 if v_TEST_Y = 'Y' then
 ok();
 else
 error();
 end if;

 set_test('TEST', NULL, 4,
 'Is the length of v_TEST_Y equal to 1?');
 if nvl(length(v_TEST_Y), 0) = 1 then
 ok();
 else
 error();
 end if;

 set_test('TEST', NULL, 5,
 'Is the length of v_TEST_30 equal to 30?');
 if nvl(length(v_TEST_30), 0) = 30 then
 ok();
 else
 error();
 end if;

 set_test('TEST', NULL, 6,
 'Is the length of v_TEST_30_1 equal to 30?');
 if nvl(length(v_TEST_30_1), 0) = 30 then
 ok();
 else
 error();
 end if;

 set_test('TEST', NULL, 7,
 'Is the length of v_TEST_30_2 equal to 30?');
 if nvl(length(v_TEST_30_2), 0) = 30 then
 ok();
 else
 error();
 end if;

 set_test('TEST', NULL, 8,
 'Is the length of v_TEST_80 equal to 80?');
 if nvl(length(v_TEST_80), 0) = 80 then
 ok();
 else
 error();
 end if;

 set_test('TEST', NULL, 9,
 'Is the length of v_TEST_100 equal to 100?');
 if nvl(length(v_TEST_100), 0) = 100 then
 ok();
 else
 error();
 end if;

 set_test('TEST', NULL, 10,
 'Is the length of v_TEST_2000 equal to 2000?');
 if nvl(length(v_TEST_2000), 0) = 2000 then
 ok();
 else
 error();
 end if;

 set_test('TEST', 'get_id', 11,
 'Does get_id() work?');
 begin
 n_number := get_id();
 if n_number > 0 then
 ok();
 else
 error();
 end if;
 exception
 when OTHERS then
 error(SQLERRM);
 end;

 set_test('TEST', 'help', 12,
 'Does help() work?');
 begin
 help();
 -- raise_application_error(-20999, 'Testing test unit report');
 ok();
 exception
 when OTHERS then
 error(SQLERRM);
 end;

 set_test('TEST', NULL, NULL, NULL);
 success();
 end test;


 end TEST;
 /
 @be.sql TESTS