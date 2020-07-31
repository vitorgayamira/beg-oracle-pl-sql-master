 create or replace PACKAGE TEXT_HELP as
 /*
 test_help.pkb
 by Donald J. Bales on 2014-10-20
 A package to produce text based help
 */

 /*
 The help text for this package.
 */
 PROCEDURE help;


 /*
 Generate help text for the specified object using its specification.
 */
 PROCEDURE process(
 aiv_object_name in varchar2);


 /*
 The test unit for this package.
 */
 PROCEDURE test;


 end text_help;
 /
 @https://raw.githubusercontent.com/vitorgayamira/beg-oracle-pl-sql-master/master/source_20150125/Chapter07/se.sql text_help;
