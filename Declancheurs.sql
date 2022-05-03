USE ressource_monstrueuse;
DROP TRIGGER IF EXISTS respect_contenu_coffre;
DELIMITER $$
CREATE TRIGGER respect_contenu_coffre BEFORE INSERT ON Coffre_tresor FOR EACH ROW 
BEGIN 
DECLARE _nombre_objet INTEGER;
DECLARE _poid_total FLOAT;

SET _nombre_objet = (
SELECT SUM(quantite) FROM Ligne_coffre 
INNER JOIN Coffre_tresor ON id_coffre_tresor = coffre
INNER JOIN Objet ON id_objet = objet
WHERE id_coffre_tresor = NEW.id_coffre_tresor
);  

SET _poid_total = (
SELECT SUM(quantite * masse) FROM Ligne_coffre 
INNER JOIN Coffre_tresor ON id_coffre_tresor = coffre
INNER JOIN Objet ON id_objet = objet
WHERE id_coffre_tresor = NEW.id_coffre_tresor
);

IF _nombre_objet > 15 THEN
SIGNAL SQLSTATE '03001' SET MESSAGE_TEXT = 'Il y a trop d\'objet dans le coffre';
END IF;

IF _poid_total > 300 THEN
SIGNAL SQLSTATE '03001' SET MESSAGE_TEXT = 'Le coffre est trop lourd';
END IF;

END $$

DELIMITER $$

CREATE TRIGGER elements_opposes BEFORE INSERT ON Affectation_salle FOR EACH ROW
BEGIN
DECLARE _id_salle INT;
DECLARE _debut_affectation DATETIME;
DECLARE _fin_affectation DATETIME;

SET _id_salle = (
SELECT salle FROM Affectation_salle
WHERE salle = NEW.salle
);
SET  _debut_affectation = (
SELECT debut_affectation FROM Affectation_salle
WHERE debut_affectation = NEW.debut_affectation

);
SET _fin_affectation = (
SELECT fin_affectation FROM Affectation_salle
WHERE fin_affectation = NEW.fin_affectation
);


IF elements_opposes_piece (_id_salle, _debut_affectation , _fin_affectation) 
THEN 
SIGNAL SQLSTATE '03015' SET MESSAGE_TEXT = 'Deux éléments opposées ne peuvent pas être dans la même salle';
END IF;

END $$

DELIMITER ;



/**
* Lorsqu'un monstre meurt, la fin de son affectation est devancée à l'instant actuel.
*
* @dependencies Monstre
*/
DELIMITER $$

CREATE TRIGGER declencheur_de_mortalite AFTER UPDATE ON Monstre FOR EACH ROW
BEGIN
    DECLARE _affectation_fin DATETIME;
    DECLARE _vie_monstre INTEGER;
    SET _affectation_fin = (
        SELECT fin_affectation FROM Affectation_salle
    );
    SET _vie_monstre = (
        SELECT point_vie FROM Monstre
    );

    IF _vie_monstre < 1 THEN
        UPDATE Affectation_salle
            SET _affectation_fin = current_date();
    END IF;

END $$

DELIMITER ;


/**
* Lorsqu’on insère ou modifie une valeur dans la table Coffre_tresor, le code secret (entré en clair dans la requête) doit être haché sur une chaîne de 256 bits.
*
* @dependencies Coffre_tresor
*/
DELIMITER $$

CREATE TRIGGER declencheur_de_hachage_insert BEFORE INSERT ON Coffre_tresor FOR EACH ROW
BEGIN

    UPDATE Coffre_tresor
    SET OLD.code_secret = (SHA2(NEW.code_secret, 256));

END $$

CREATE TRIGGER declencheur_de_hachage_update AFTER UPDATE ON Coffre_tresor FOR EACH ROW
BEGIN

    UPDATE Coffre_tresor 
    SET OLD.code_secret = (SHA2(NEW.code_secret, 256));

END $$

DELIMITER ;
