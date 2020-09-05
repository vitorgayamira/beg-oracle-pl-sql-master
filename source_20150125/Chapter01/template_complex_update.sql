UPDATE <table_name> U
SET (U.<column_name_1>,
U.<column_name_2>, ...
U.<column_name_N> ) = (
SELECT S.<subquery_column_name_1>,
S.<subquery_column_name_2>, ...
S.<subquery_column_name_N>
FROM <subquery_table_name> S
WHERE S.<column_name_N> = U.<column_name_N>
AND ...)
WHERE u.<column_name_N> = <some_value>...;
