USE ressource_monstrueuse;

/**
* Cette fonction décrypte un contenu crypté en utilisant la clé de cryptage définie ci-dessus. Elle retourne le texte clair prêt à être lu par un être humain.
*
* @param _donnees_cryptees 
* 
* @return le nombre d'étudiant inscrit dans un groupe 
*/
DELIMITER $$

CREATE FUNCTION decryptage(_donnees_crytees BLOB) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE _nombre_etudiant INTEGER;
    SET _nombre_etudiant = (
		SELECT count(etudiant) FROM Inscription
			INNER JOIN Groupe ON groupe = id_groupe
            NATURAL JOIN Cours
            INNER JOIN Session ON session = id_session
		WHERE semestre = _semestre AND annee = _annee AND sigle = _sigle AND numero_groupe = _numero_groupe
	);
    
    RETURN _nombre_etudiant;
    
END $$

DELIMITER ;