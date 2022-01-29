\set c2 md5(random())
BEGIN;
SELECT * FROM index_test WHERE c2 = :c2;
END;