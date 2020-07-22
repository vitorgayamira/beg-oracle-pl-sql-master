 create or replace PACKAGE BODY WORKER_TYPE as
 /*
 worker_type.pkb
 by Don Bales on 2014-10-20
 Table WORKER_TYPES's methods
 */


 PROCEDURE get_code_descr(
 ain_id in WORKER_TYPES.id%TYPE,
 aov_code out WORKER_TYPES.code%TYPE,
 aov_description out WORKER_TYPES.description%TYPE ) is

 begin
 select code,
 description
 into aov_code,
 aov_description
 from WORKER_TYPES
 where id = ain_id;
 end get_code_descr;


 PROCEDURE get_code_id_descr(
 aiov_code in out WORKER_TYPES.code%TYPE,
 aon_id out WORKER_TYPES.id%TYPE,
 aov_description out WORKER_TYPES.description%TYPE,
 aid_on in WORKER_TYPES.active_date%TYPE ) is

 v_code WORKER_TYPES.code%TYPE;

 begin
 select id,
 description
 into aon_id,
 aov_description
 from WORKER_TYPES
 where code = aiov_code
 and aid_on between active_date and nvl(inactive_date, DATE_.d_MAX);
 exception
 when NO_DATA_FOUND then
 select id,
 code,
 description
 into aon_id,
 v_code,
 aov_description
 from WORKER_TYPES
 where code like aiov_code||'%'
 and aid_on between active_date and nvl(inactive_date, DATE_.d_MAX);

 aiov_code := v_code;
 end get_code_id_descr;


 PROCEDURE get_code_id_descr(
 aiov_code in out WORKER_TYPES.code%TYPE,
 aon_id out WORKER_TYPES.id%TYPE,
 aov_description out WORKER_TYPES.description%TYPE ) is

 begin
 get_code_id_descr(
 aiov_code,
 aon_id,
 aov_description,
 SYSDATE );
 end get_code_id_descr;


 FUNCTION get_id
 return WORKER_TYPES.id%TYPE is

 n_id WORKER_TYPES.id%TYPE;

 begin
 select WORKER_TYPES_ID.nextval
 into n_id
 from SYS.DUAL;

 return n_id;
 end get_id;


 FUNCTION get_id(
 aiv_code in WORKER_TYPES.code%TYPE )
 return WORKER_TYPES.id%TYPE is

 n_id WORKER_TYPES.id%TYPE;

 begin
 select id
 into n_id
 from WORKER_TYPES
 where code = aiv_code;

 return n_id;
 end get_id;


 PROCEDURE help is

 begin
 -- 12345678901234567890123456789012345678901234567890123456789012345678901234567890
 pl('=================================== PACKAGE ====================================');
 pl(chr(9));
 pl('WORKER_TYPE');
 pl(chr(9));
 pl('----------------------------------- FUNCTIONS ----------------------------------');
 pl(chr(9));
 pl('WORKER_TYPE.get_id');
 pl('return WORKER_TYPES.id%TYPE;');
 pl(chr(9)||'Returns a newly allocated sequence value for id.');
 pl(chr(9));
 pl('WORKER_TYPE.get_id(');
 pl('aiv_code in WORKER_TYPES.code%TYPE )');
 pl('return WORKER_TYPES.id%TYPE;');
 pl(chr(9)||'Returns the corresponding id for the specified code.');
 pl(chr(9));
 pl('----------------------------------- PROCEDURES ---------------------------------');
 pl(chr(9));
 pl('WORKER_TYPE.get_code_descr(');
 pl('ain_id in WORKER_TYPES.id%TYPE,');
 pl('aov_code out WORKER_TYPES.code%TYPE,');
 pl('aov_description out WORKER_TYPES.description%TYPE );');
 pl(chr(9)||'Gets the corresponding code and description for the specified');
 pl(chr(9)||'id.');
 pl(chr(9));
 pl('WORKER_TYPE.get_code_id_descr(');
 pl('aiov_code in out WORKER_TYPES.code%TYPE,');
 pl('aon_id out WORKER_TYPES.id%TYPE,');
 pl('aov_description out WORKER_TYPES.description%TYPE,');
 pl('aid_on in WORKER_TYPES.active_date%TYPE );');
 pl(chr(9)||'Gets the corresponding code, id, and description for');
 pl(chr(9)||'the specified code. First it trys to find an exact match. If one');
 pl(chr(9)||'cannot be found, it trys to find a like match. It may throw a');
 pl(chr(9)||'NO_DATA_FOUND or a TOO_MANY_ROWS exception if a match cannot be');
 pl(chr(9)||'found for the specified code and point in time.');
 pl(chr(9));
 pl('WORKER_TYPE.get_code_id_descr(');
 pl('aiov_code in out WORKER_TYPES.code%TYPE,');
 pl('aon_id out WORKER_TYPES.id%TYPE,');
 pl('aov_description out WORKER_TYPES.description%TYPE );');
 pl(chr(9)||'Gets the corresponding code, id, and description for');
 pl(chr(9)||'the specified code. First it trys to find an exact match. If one');
 pl(chr(9)||'cannot be found, it trys to find a like match. It may throw a');
 pl(chr(9)||'NO_DATA_FOUND or a TOO_MANY_ROWS exception if a match cannot be');
 pl(chr(9)||'found for the specified code at the current point in time.');
 pl(chr(9));
 pl('WORKER_TYPE.help( );');
 pl(chr(9)||'Displays this help text if set serveroutput is on.');
 pl(chr(9));
 pl('WORKER_TYPE.test( );');
 pl(chr(9)||'Built-in test unit. It will report success or error for each test if set');
 pl(chr(9)||'serveroutput is on.');
 pl(chr(9));
 end help;


 PROCEDURE test is

 n_id WORKER_TYPES.id%TYPE;
 v_code WORKER_TYPES.code%TYPE;
 v_description WORKER_TYPES.description%TYPE;

 begin
 -- Send feedback that the test ran
 pl('WORKER_TYPE.test()');

 -- Clear the last set of test results
 &_USER..TEST.clear('WORKER_TYPE');

 -- First, we need some test values

 -- Let's make sure they don't already exist: DELETE
 &_USER..TEST.set_test('WORKER_TYPE', 'DELETE', 0,
 'Delete test entries');
 begin
 delete WORKER_TYPES
 where code in (
 &_USER..TEST.v_TEST_30,
 &_USER..TEST.v_TEST_30_1,
 &_USER..TEST.v_TEST_30_2);
 &_USER..TEST.ok();
 exception
 when OTHERS then
 &_USER..TEST.error(SQLERRM);
 end;

 -- Now let's add three test codes: INSERT
 &_USER..TEST.set_test('WORKER_TYPE', 'INSERT', 1,
 'Insert 3 test entries');
 begin
 insert into WORKER_TYPES (
 id,
 code,
 description,
 active_date,
 inactive_date )
 values (
 get_id(),
 &_USER..TEST.v_TEST_30,
 &_USER..TEST.v_TEST_80,
 &_USER..TEST.d_TEST_19000101,
 &_USER..TEST.d_TEST_99991231 );

 insert into WORKER_TYPES (
 id,
 code,
 description,
 active_date,
 inactive_date )
 values (
 get_id(),
 &_USER..TEST.v_TEST_30_1,
 &_USER..TEST.v_TEST_80,
 &_USER..TEST.d_TEST_19000101,
 &_USER..TEST.d_TEST_99991231 );

 insert into WORKER_TYPES (
 id,
 code,
 description,
 active_date,
 inactive_date )
 values (
 get_id(),
 &_USER..TEST.v_TEST_30_2,
 &_USER..TEST.v_TEST_80,
 &_USER..TEST.d_TEST_19000101,
 &_USER..TEST.d_TEST_99991231 );

 &_USER..TEST.ok();
 exception
 when OTHERS then
 &_USER..TEST.error(SQLERRM);
 end;

 -- Now that we have test entries,
 -- let's test the package methods
 &_USER..TEST.set_test('WORKER_TYPE', 'get_id()', 2,
 'Get the ID for the specified code');
 begin
 n_id := get_id(&_USER..TEST.v_TEST_30);

 if n_id > 0 then
 &_USER..TEST.ok();
 else
 &_USER..TEST.error();
 end if;
 exception
 when OTHERS then
 &_USER..TEST.error(SQLERRM);
 end;

 &_USER..TEST.set_test('WORKER_TYPE', 'get_code_descr()', 3,
 'Get the code and description for the specified ID');
 begin
 get_code_descr(
 n_id,
 v_code,
 v_description);
 if v_code = &_USER..TEST.v_TEST_30 and
 v_description = &_USER..TEST.v_TEST_80 then
 &_USER..TEST.ok();
 else
 &_USER..TEST.error();
 end if;
 exception
 when OTHERS then
 &_USER..TEST.error(SQLERRM);
 end;

 &_USER..TEST.set_test('WORKER_TYPE', 'get_code_id_descr()', 4,
 'Get the code, ID, and description for the specified code');
 begin
 v_code := &_USER..TEST.v_TEST_30;
 get_code_id_descr(
 v_code,
 n_id,
 v_description);
 if v_code = &_USER..TEST.v_TEST_30 and
 n_id > 0 and
 v_description = &_USER..TEST.v_TEST_80 then
 &_USER..TEST.ok();
 else
 &_USER..TEST.error();
 end if;
 exception
 when OTHERS then
 &_USER..TEST.error(SQLERRM);
 end;

 &_USER..TEST.set_test('WORKER_TYPE', 'get_code_id_descr()', 5,
 'Get the code, ID, and description for the specified date');
 begin
 v_code := 'TEST';
 -- This test should raise a TOO_MANY_ROWS exception
 -- because at least three duplicate values will
 -- on the date specified
 get_code_id_descr(
 v_code,
 n_id,
 v_description,
 &_USER..TEST.d_TEST_99991231);
 if v_code = &_USER..TEST.v_TEST_30 and
 n_id > 0 and
 v_description = &_USER..TEST.v_TEST_80 then
 &_USER..TEST.ok();
 else
 &_USER..TEST.error();
 end if;
 exception
 when TOO_MANY_ROWS then
 &_USER..TEST.ok();
 when OTHERS then
 &_USER..TEST.error(SQLERRM);
 end;

 &_USER..TEST.set_test('WORKER_TYPE', 'help()', 6,
 'Display help');
 begin
 help();
 &_USER..TEST.ok();
 exception
 when OTHERS then
 &_USER..TEST.error(SQLERRM);
 end;

 -- Let's make sure they don't already exist: DELETE
 &_USER..TEST.set_test('WORKER_TYPE', 'DELETE', 7,
 'Delete test entries');
 begin
 delete WORKER_TYPES
 where code in (
 &_USER..TEST.v_TEST_30,
 &_USER..TEST.v_TEST_30_1,
 &_USER..TEST.v_TEST_30_2);
 &_USER..TEST.ok();
 exception
 when OTHERS then
 &_USER..TEST.error(SQLERRM);
 end;

 &_USER..TEST.set_test('WORKER_TYPE', NULL, NULL, NULL);
 &_USER..TEST.success();
 end test;


 end WORKER_TYPE;
 /
 @be.sql WORKER_TYPE