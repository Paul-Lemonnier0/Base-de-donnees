--TABLE

DROP TABLE IF EXISTS myTable;
CREATE TABLE myTable(
  prop1 VARCHAR NOT NULL PRIMARY KEY,
  prop2 VARCHAR,
  FOREIGN KEY(props2) REFERENCES myTable2 ON DELETE CASCADE,
  CONSTRAINT prop2_myTable CHECK (prop2 IN ('M', 'F'))
);

ALTER TABLE myTable
DROP CONSTRAINT prop2_myTable;

ALTER TABLE myTable
ADD CONSTRAINT prop2_myTable CHECK (prop2 IN ('N1', 'N2', 'N3', 'N4'));

--TRIGGER

CREATE OR REPLACE FUNCTION funModif() RETURNS TRIGGER AS $$
BEGIN

  IF TG_OP = 'INSERT' THEN

  ELSE
    IF TG_OP = 'DELETE' THEN
    END IF;

  END IF;

END
$$LANGUAGE plpgsql;


CREATE TRIGGER myTrigger 
  AFTER INSERT OR DELETE  
    ON myTable
  FOR EACH ROW
    EXECUTE PROCEDURE funModif();

--DATE 'YYYY-MM-JJ

SELECT EXTRACT('Year' FROM CURRENT_DATE);

--FUNCTION

CREATE OR REPLACE FUNCTION testFUN RETURNS SETOF resultat AS $$

DECLARE

  curs CURSOR FOR SELECT * FROM myTable2;

BEGIN

  FOR enreg IN curs LOOP 

    IF(enreg.maProp = 2) THEN
      RAISE NOTICE "Hello %", monArg;

    END IF;

  END LOOP;

END

$$language plpgsql;

--TYPE

DROP TYPE IF EXISTS monType;
CREATE TYPE monType AS(
  maProp INTEGER,
  maProp2 VARCHAR
)

CREATE TABLE maTable OF monType (PRIMARY KEY (maProp));

--EXCEPTION

CREATE OR REPLACE myFun() RETURNS VOID AS $$

DECLARE

BEGIN

EXCEPTION

    WHEN unique_violation THEN RAISE NOTICE '';
    WHEN no_data_violation THEN RAISE NOTICE '';
    WHEN division_by_zero THEN RAISE NOTICE '';
    WHEN integrity_constraint_Violation THEN RAISE NOTICE '';
    WHEN privilege_not_granted THEN RAISE NOTICE '';
    WHEN others THEN RAISE NOTICE '';

END;


$$language plpgsql;

--QUERY

SELECT NomNag, PrenomNag, Type, Niveau, AVG(Note)
FROM (NAGEUR N JOIN RESULTAT R ON N.NumeroNag = R.NumeroNag) JOIN CATEGORIE_EPREUVE C ON R.NumeroEp = C.NumeroEp
GROUP BY NomNag, PrenomNag, Type, Niveau
HAVING AVG(Note) >= 5;
