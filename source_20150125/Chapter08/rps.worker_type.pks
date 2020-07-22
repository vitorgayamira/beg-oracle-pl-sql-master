 create or replace PACKAGE WORKER_TYPE as
 /*
 worker_type.pks
 by Don Bales on 2014-10-20
 Code Table WORKER_TYPES's methods.
 */


 -- Gets the code and decription values for the specified ain_id.
 PROCEDURE get_code_descr(
 ain_id in WORKER_TYPES.id%TYPE,
 aov_code out WORKER_TYPES.code%TYPE,
 aov_description out WORKER_TYPES.description%TYPE );


 -- Verifies the passed aiov_code value is an exact or like match on
 -- the date specified.
 PROCEDURE get_code_id_descr(
 aiov_code in out WORKER_TYPES.code%TYPE,
 aon_id out WORKER_TYPES.id%TYPE,
 aov_description out WORKER_TYPES.description%TYPE,
 aid_on in WORKER_TYPES.active_date%TYPE );


 -- Verifies the passed aiov_code value is currently an exact or like
 -- match.
 PROCEDURE get_code_id_descr(
 aiov_code in out WORKER_TYPES.code%TYPE,
 aon_id out WORKER_TYPES.id%TYPE,
 aov_description out WORKER_TYPES.description%TYPE );


 -- Returns a newly allocated id value.
 FUNCTION get_id
 return WORKER_TYPES.id%TYPE;


 -- Returns the id for the specified code value.
 FUNCTION get_id(
 aiv_code in WORKER_TYPES.code%TYPE )
 return WORKER_TYPES.id%TYPE;


 -- Test-based help for this package. "set serveroutput on" in
 -- SQL*Plus.
 PROCEDURE help;


 -- Test units for this package.
 PROCEDURE test;


 end WORKER_TYPE;
 /
 @se.sql WORKER_TYPE