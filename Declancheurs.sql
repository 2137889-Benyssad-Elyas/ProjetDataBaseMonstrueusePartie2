USE ressource_monstrueuse;

/**
* Si un coffre contient plus de 15 objets ou que leur masse excède 300 kg, alors une exception doit être lancée. L’exception doit indiquer laquelle des deux règles n’est pas respectée.
*
* @dependencies 
*/
DELIMITER $$

CREATE TRIGGER verification_capacite_coffre AFTER INSERT ON Coffre_tresor FOR EACH ROW
BEGIN
	DECLARE _nombre_etudiant INTEGER;
    DECLARE _quantite_objet INTEGER;
    DECLARE _masse_objet FLOAT;
    SET _quantite_objet = (
			SELECT count(objet) FROM Ligne_coffre
    );
    SET _masse_objet = (
			SELECT sum(masse * quantite) FROM Ligne_coffre
				INNER JOIN 
    );
    SET _nombre_etudiant = (
			SELECT count(etudiant) FROM Inscription
				WHERE groupe = NEW.groupe
	);
    IF _nombre_etudiant >= 4 OR  THEN
		SIGNAL SQLSTATE '02001' SET MESSAGE_TEXT = 'Il y a déjà 4 étudiants dans ce groupe';
	END IF;
    
END $$

DELIMITER ;
