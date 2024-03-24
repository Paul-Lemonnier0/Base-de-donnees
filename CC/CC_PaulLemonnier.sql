DROP TABLE IF EXISTS Projet CASCADE;
DROP TABLE IF EXISTS Employe CASCADE;
DROP TABLE IF EXISTS Tache CASCADE;
DROP TABLE IF EXISTS Realisation CASCADE;

DROP TYPE IF EXISTS Tprojet CASCADE;
DROP TYPE IF EXISTS Ttache CASCADE;
DROP TYPE IF EXISTS Temploye CASCADE;
DROP TYPE IF EXISTS Trealisation CASCADE;


/*
DROP SEQUENCE IF EXISTS projet_S;
DROP SEQUENCE IF EXISTS tache_S;
DROP SEQUENCE IF EXISTS employe_S;
DROP SEQUENCE IF EXISTS realisation_S;

CREATE SEQUENCE projet_S;
CREATE SEQUENCE tache_S;
CREATE SEQUENCE employe_S;
CREATE SEQUENCE realisation_S;
*/

CREATE TYPE Tprojet AS(
    Num_prj VARCHAR,
    Nom_prj VARCHAR,
    Date_fin DATE,
    Cout_Global INTEGER
);

CREATE TYPE Ttache AS(
    Num_tach VARCHAR,
    Nom_tach VARCHAR,
    Cout INTEGER,
    Projet Tprojet
);

CREATE TYPE Temploye AS(
    Num_emp VARCHAR,
    Nom_Prenom VARCHAR,
    Grade INTEGER
);

CREATE TYPE Trealisation AS(
    Num_real VARCHAR,
    Employe Temploye,
    Tache tTache,
    Nombre_heure INTEGER
);

CREATE TABLE Projet OF Tprojet (PRIMARY KEY(Num_prj));
CREATE TABLE Tache OF Ttache (PRIMARY KEY(Num_tach));
CREATE TABLE Employe OF Temploye (PRIMARY KEY(Num_emp));
CREATE TABLE Realisation OF Trealisation (PRIMARY KEY(Num_real));

--TRIGGERS


--Q7

CREATE OR REPLACE FUNCTION checkInsertionTache_F() RETURNS TRIGGER AS $$

DECLARE

    dateFinProjet DATE;

BEGIN


    IF(NOT EXISTS (SELECT * FROM Projet p WHERE p.Num_prj = (NEW.Projet).Num_prj)) THEN

        RAISE NOTICE 'Le projet associé à la tache % n existe pas. La tache n a pas été ajouté', NEW.Num_tach;
        RETURN NULL;

    ELSE

        dateFinProjet := (SELECT Date_fin FROM Projet p WHERE p.Num_prj = (NEW.Projet).Num_prj);

        IF (CURRENT_DATE > dateFinProjet) THEN

            RAISE NOTICE 'La date de fin du projet % est dépassée. La tâche % n a pas été ajoutée', (NEW.Projet).Num_prj, NEW.Num_tach;
            RETURN NULL;

        ELSE RETURN NEW;

        END IF;

    END IF;


END
$$LANGUAGE plpgsql;


CREATE TRIGGER checkInsertionTache_T 
  BEFORE INSERT OR UPDATE  
    ON Tache
  FOR EACH ROW
    EXECUTE PROCEDURE checkInsertionTache_F();

--Q8

/*

CREATE OR REPLACE FUNCTION updateCoutTacheWithNBHeureForQ8(numTache VARCHAR, numEmploye VARCHAR, nbHeure INTEGER) RETURNS INTEGER AS $$

DECLARE

    coutTache INTEGER;
    curs CURSOR FOR SELECT * FROM Realisation r WHERE (r.Tache).Num_tach = numTache; 

BEGIN

    coutTache := 0; --init pas utilise en soit mais au cas ou on veut sommer le couttache au moins il est la

    FOR enreg IN curs LOOP

        IF (enreg.Employe).Num_emp = numEmploye THEN

            coutTache := coutTache + (((enreg.Employe).Grade-1) * 20 + 40) * nbHeure;
        
        ELSE coutTache := coutTache + (((enreg.Employe).Grade-1) * 20 + 40) * enreg.Nombre_heure;

        END IF;

    END LOOP;

    RETURN coutTache;

END

$$language plpgsql;

CREATE OR REPLACE FUNCTION checkInsertionRealisation_F() RETURNS TRIGGER AS $$

DECLARE

    coutTotalTaches INTEGER;
    coutTotalProjet INTEGER;
    numTache VARCHAR = 
    --On récupère toute les tâches qui ont le même id projet que celle qui va peut-être être modifiée
    cursTache CURSOR FOR SELECT * FROM Tache t WHERE (t.Projet).Num_prj = ((NEW.Tache).Projet).Num_prj;

BEGIN

    --TEST SI LE CHANGEMENT A LIEU DANS LE NOMBRE D'HEURE (SINON ON FAIT RIEN)
    IF(OLD.Nombre_heure = NEW.Nombre_heure) THEN

        RETURN NEW;

    ELSE

        coutTotalTaches := 0;
        coutTotalProjet := (SELECT Cout_Global FROM Projet p WHERE p.Num_prj = ((NEW.Tache).Projet).Num_prj);

        FOR tache IN cursTache LOOP

            coutTotalTaches := coutTotalTaches + updateCoutTacheWithNBHeureForQ8(((NEW.Tache).Projet).Num_tach, (NEW.Employe).numEmploye, NEW.Nombre_heure);

        END LOOP;

        RAISE NOTICE 'Coup total : %', coutTotalTaches;
        RAISE NOTICE 'Coup projet : %', coutTotalProjet;

        IF (coutTotalTaches > coutTotalProjet) THEN

            RETURN NULL;

        ELSE RETURN NEW;    

        END IF;

    END IF;

END
$$LANGUAGE plpgsql;


CREATE TRIGGER checkInsertionRealisation_T 
  BEFORE INSERT OR UPDATE  
    ON Realisation
  FOR EACH ROW
    EXECUTE PROCEDURE checkInsertionRealisation_F();
*/
--INSERT

INSERT INTO Projet VALUES 
    ('Proj1', 'e_com ATOLL ', '2024-03-31', 10000), 
    ('Proj2', 'Migration cluster ACP', '2023-02-25', 30000);

INSERT INTO Tache VALUES 
    ('tach001', 'Col_Don', null, (SELECT p FROM Projet p WHERE p.Num_prj = 'Proj1')), 
    ('tach254', 'valid_MCD', null, (SELECT p FROM Projet p WHERE p.Num_prj = 'Proj1')),
    ('testQ7_projetExistePas', 'testQ7__projetExistePas', null, (SELECT p FROM Projet p WHERE p.Num_prj = 'Proj5')),
    ('testQ7_dateTroptard', 'testQ7_dateTroptard', null, (SELECT p FROM Projet p WHERE p.Num_prj = 'Proj2'));

INSERT INTO Employe VALUES  
    ('Emp01', 'Dupond_Daniel', 1),
    ('Emp17', 'Cheff_Anna', 4);

INSERT INTO Realisation VALUES
    ('R150',(SELECT e FROM Employe e WHERE e.Num_emp='Emp17'),(SELECT t FROM Tache t WHERE t.Num_tach='tach254'), 1),
    ('R002',(SELECT e FROM Employe e WHERE e.Num_emp='Emp01'),(SELECT t FROM Tache t WHERE t.Num_tach='tach001'), 9);

/*
SELECT * FROM Projet;
SELECT * FROM Tache;
SELECT * FROM Employe;
SELECT * FROM Realisation;*/

--Q3

INSERT INTO Employe VALUES ('Emp73', 'Morin_Olivier', 2);
UPDATE Realisation r SET Employe = (SELECT e FROM Employe e WHERE e.Num_emp='Emp73'), Nombre_heure = 6 WHERE r.Num_real = 'R002';

SELECT * FROM Employe;
SELECT * FROM Realisation;

--Q4

CREATE OR REPLACE FUNCTION updateCoutTache(numTache VARCHAR) RETURNS void AS $$

DECLARE

    coutTache INTEGER;
    curs CURSOR FOR SELECT * FROM Realisation r WHERE (r.Tache).Num_tach = numTache; 

BEGIN

    coutTache := 0;

    FOR enreg IN curs LOOP
    
        coutTache := coutTache + ((((enreg.Employe).Grade-1) * 20 + 40) * enreg.Nombre_heure);

    END LOOP;

    UPDATE Tache t SET Cout = coutTache WHERE t.Num_tach = numTache;
    RETURN;

END

$$language plpgsql;

SELECT updateCoutTache('tach001');
SELECT * FROM Tache;

--Q5

DROP TYPE IF EXISTS TresultatQ5 CASCADE;
CREATE TYPE TresultatQ5 AS (
    nbTaches INTEGER,
    coutTotal INTEGER
);

CREATE OR REPLACE FUNCTION nbTacheEtCoutProjet(numProj VARCHAR) RETURNS SETOF TresultatQ5 AS $$ ---sous forme de setof / type pour plus de lisibilité

DECLARE

    --POUR CET EXO JE NE SAVAIS PAS SI ON DEVAIT RECALCULER TOUTES LE COUT DES TACHES. DANS LE DOUTE JE L'AI FAIT ET C'EST CE QU'IL Y A EN COMMENTAIRE ET QUI CONCERNE coutTotal

    cursProj CURSOR FOR SELECT * FROM Tache t WHERE (t.Projet).Num_prj = numProj;

    nbTaches INTEGER;
    coutTotal INTEGER;

BEGIN

    nbTaches := 0;

    --coutTotal := 0;
    coutTotal := (SELECT Cout_Global FROM Projet p WHERE p.Num_prj = numProj);

    FOR enreg IN cursProj LOOP

        nbTaches := nbTaches + 1;

        --PERFORM updateCoutTache(enreg.Num_tach); SOIT ON CALCUL TOUT LE COUT DES TACHES MAIS VU QU'ON A DEJA REMPLI LA VALEUR DE COUT GLOBAL JE ME SUIS DIS QUE C'ETAIT PLUS SIMPLE DE LA RECUPERER DIRECT
        --coutTotal := coutTotal + (SELECT Cout FROM Tache t WHERE t.Num_tach = enreg.Num_tach);

    END LOOP;

    RETURN NEXT (nbTaches, coutTotal);
    RETURN;

END

$$language plpgsql;

SELECT * FROM nbTacheEtCoutProjet('Proj1');

--Q6

CREATE OR REPLACE FUNCTION listeEmployeProjet(numProj VARCHAR) RETURNS SETOF Temploye AS $$

DECLARE

    curs CURSOR FOR SELECT * FROM Realisation r WHERE ((r.Tache).Projet).Num_prj = numProj; 

BEGIN

    FOR enreg IN curs LOOP

        RETURN NEXT enreg.Employe;

    END LOOP;

    RETURN;

END

$$language plpgsql;

SELECT * FROM listeEmployeProjet('Proj1');

/* TEST Q8
SELECT * FROM Realisation;
UPDATE Realisation r SET Nombre_heure=1000000 WHERE (r.Tache).Num_tach = 'tach254';
SELECT * FROM Realisation;
*/