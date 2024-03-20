DROP TYPE IF EXISTS Televage CASCADE;
DROP TYPE IF EXISTS Tadresse CASCADE;
DROP TYPE IF EXISTS Televeur CASCADE;

DROP TABLE IF EXISTS Eleveur CASCADE;
DROP TABLE IF EXISTS Elevage CASCADE;
CREATE TYPE Televage AS(
        typeAnimal VARCHAR,
        ageMin INTEGER,
        nbrMax INTEGER
);

CREATE TYPE Tadresse AS(
    nRue INTEGER,
    rue VARCHAR,
    ville VARCHAR,
    code_postal INTEGER
);

CREATE TYPE Televeur AS(
    numLicence INTEGER,
    elevage Televage,
    adresse Tadresse
);

CREATE TABLE Elevage OF Televage;
CREATE TABLE Eleveur OF Televeur(PRIMARY KEY(numLicence));

CREATE OR REPLACE FUNCTION interditParis_F() RETURNS TRIGGER AS $$
BEGIN

    IF (NEW.adresse).ville = 'Paris' THEN
        RETURN NULL;
    ELSE 
        IF (NEW.adresse).ville = 'Angers' THEN
        
            IF (NEW.elevage).typeAnimal = 'Volaille' THEN 
                RETURN NEW;
            ELSE RETURN NULL;

            END IF;

        ELSE RETURN NEW;

        END IF;

    END IF;

END
$$LANGUAGE plpgsql;


CREATE TRIGGER interditParis_T 
  BEFORE INSERT
    ON Eleveur
  FOR EACH ROW
    EXECUTE PROCEDURE interditParis_F();

INSERT INTO ELEVAGE VALUES
	('Bovin', 2, 100),
	('Porcin', 3, 200),
	('Ovin', 4, 300),
	('Volaille', 5, 400),
	('Poisson', 6, 500)
;

INSERT INTO Eleveur VALUES 
	(100,(select e from elevage e where typeAnimal = 'Bovin'), row('1', 'Rue zéphir', 'Vitre', '35500')),
	(200,(select e from elevage e where typeAnimal = 'Porcin'), row('2', 'Rue des framboises', 'Saint Augustin des Bois', '49170')),
	(400,(select e from elevage e where typeAnimal = 'Volaille'), row('4', 'Rue des palombes', 'Bouzon Gellenave', '32290')),
	(600,(select e from elevage e where typeAnimal = 'Poisson'), row('5', 'Rue des fraises', 'Paris', '75000'));

INSERT INTO Eleveur VALUES (3, (select e from elevage e where typeAnimal = 'Ovin'), row('5', 'Rue des fraises', 'Angers', '49000'));
UPDATE Eleveur SET elevage = (select e from elevage e where typeAnimal = 'Porcin') WHERE numLicence = 200;

SELECT * FROM Eleveur;

UPDATE Eleveur e SET adresse.ville = 'Bordeaux', adresse.code_postal = 33000 WHERE (e.elevage).typeAnimal = 'Ovin';

SELECT * FROM Eleveur;
