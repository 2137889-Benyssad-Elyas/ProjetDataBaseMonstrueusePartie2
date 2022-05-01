USE ressource_monstrueuse;
DROP FUNCTION IF EXISTS responsable;
/**
* Cette fonction décrypte un contenu crypté en utilisant la clé de cryptage définie ci-dessus. Elle retourne le texte clair prêt à être lu par un être humain.
*
* @param _donnees_cryptees 
* 
* @return le nombre d'étudiant inscrit dans un groupe 
*/
DELIMITER $$

CREATE FUNCTION responsable(_fonction_salle VARCHAR(255), _date_responsable DATETIME) RETURNS INTEGER DETERMINISTIC
BEGIN
	DECLARE _id_monstre_responsable INTEGER;
    SET _id_monstre_responsable = (
		SELECT monstre, responsabilite FROM Affectation_salle
            INNER JOIN Salle ON id_salle = salle
            INNER JOIN Responsabilite ON responsabilite = id_responsabilite
		WHERE _fonction_salle = fonction AND _date_responsable BETWEEN debut_affectation AND fin_affectation
        ORDER BY niveau_responsabilite LIMIT 1
	);

    RETURN _id_monstre_responsable;
    
END $$

DELIMITER ;

SELECT responsable('salle des explosifs', '1082-06-27 04:00:00');
