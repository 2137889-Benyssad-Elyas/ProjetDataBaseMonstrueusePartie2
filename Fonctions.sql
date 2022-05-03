USE ressource_monstrueuse;

 DROP FUNCTION IF EXISTS verifier_vie_monstre;
 
DELIMITER $$


CREATE FUNCTION cryptage(_mdp VARCHAR(255)) RETURNS BLOB DETERMINISTIC 
BEGIN 
DECLARE mdp_crypter BLOB;

SET mdp_crypter = AES_ENCRYPT(_mdp, 'mortauxheros');
 
 RETURN mdp_crypter;
END $$



CREATE FUNCTION decryptage(_mdp_crypter BLOB) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN 
DECLARE mdp_clair VARCHAR(255);

SET mdp_clair = AES_DECRYPT(_mdp_crypter, 'mortauxheros');
 
 RETURN CAST(mdp_clair AS CHAR);
END $$
 

 
 CREATE FUNCTION trouver_leader(_nom_expedition VARCHAR(255)) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN 
DECLARE _id_aventurier INTEGER;

SET _id_aventurier = (
SELECT id_aventurier FROM Aventurier 
NATURAL JOIN Expedition_aventurier 
NATURAL JOIN Expedition
WHERE nom_equipe = _nom_expedition
ORDER BY niveau DESC
LIMIT 1 
);
 
 RETURN _id_aventurier;
END $$


CREATE FUNCTION verifier_vie_monstre(_id_salle INTEGER, _moment DATETIME) RETURNS TINYINT DETERMINISTIC
BEGIN 
DECLARE _bool TINYINT;
DECLARE _vie INTEGER;

SET _vie = (
SELECT point_vie FROM Monstre 
INNER JOIN Affectation_salle ON id_monstre = monstre 
INNER JOIN Salle ON salle = id_salle
WHERE id_salle = _id_salle AND _moment BETWEEN debut_affectation AND fin_affectation
ORDER BY point_vie DESC
LIMIT 1
);

IF _vie < 1 
THEN  
SET _bool = 0;
ELSE 
SET _bool = 1;
END IF;
 
RETURN _bool;
END $$

/**
* La fonction vérifie si un aventurier est en vie dans une expédition donnée.
*
* @param _id_expedition L’identifiant de l’expédition pour laquelle faire la vérification 
* 
* @return  la valeur 0 si tous les aventuriers sont morts, la valeur 1 si un aventurier est encore vivant
*/

DELIMITER $$
CREATE FUNCTION verification_vitalite_aventuriers(_id_expedition INTEGER) RETURNS TINYINT NOT DETERMINISTIC READS SQL DATA
BEGIN

    DECLARE _aventurier_vitalite INTEGER;
    DECLARE _resultat TINYINT;

    SET _aventurier_vitalite = (
        SELECT point_vie FROM Aventurier
            NATURAL JOIN Expedition_aventurier
            NATURAL JOIN Expedition
            WHERE _id_expedition = id_expedition 
            ORDER BY point_vie DESC
            LIMIT 1
    );

        IF _aventurier_vitalite < 1 THEN 
            SET _resultat = 0;
        ELSE 
            SET _resultat = 1;
            END IF;

    RETURN _resultat;

END $$
DELIMITER ;


DELIMITER $$
/**
 * Vérifie si deux élémentaires d'éléments opposés (eau et feu) sont affectés en même temps 
 * dans une même salle.
 *
 * @param _id_salle 				l'identifiant de la salle dans laquelle vérifier s'il y a des élémentaires opposés
 * @param _debut_affectaion 		début de la période pendant laquelle vérifier s'il y a des élémentaires opposés
 * @param _fin_affectaion 			fin de la période pendant laquelle vérifier s'il y a des élémentaires opposés
 * @return 	1 s'il y a un conflit entre deux types d'élémentaires, 0 sinon
 */
CREATE FUNCTION elements_opposes_piece (_id_salle INT, _debut_affectation DATETIME, _fin_affectation DATETIME) RETURNS TINYINT READS SQL DATA
BEGIN
	DECLARE _nombre_elementaires_feu INTEGER;
    DECLARE _nombre_elementaires_eau INTEGER;
    
    SET _nombre_elementaires_feu = (
		SELECT count(*) FROM Elementaire
			INNER JOIN Famille_monstre ON id_famille = famille
            NATURAL JOIN Monstre
            INNER JOIN Affectation_salle ON id_monstre = monstre
            WHERE salle = _id_salle 
				AND element = 'feu'
				AND ( -- Vérifie l'intersection entre deux intervalles de date
					_debut_affectation BETWEEN debut_affectation AND fin_affectation
					OR _fin_affectation BETWEEN debut_affectation AND fin_affectation
					OR (_debut_affectation < debut_affectation AND _fin_affectation > fin_affectation)
				)
    );
    
    SET _nombre_elementaires_eau = (
		SELECT count(*) FROM Elementaire
			INNER JOIN Famille_monstre ON id_famille = famille
            NATURAL JOIN Monstre
            INNER JOIN Affectation_salle ON id_monstre = monstre
            WHERE salle = _id_salle 
                AND element = 'eau'
				AND ( -- Vérifie l'intersection entre deux intervalles de date
					_debut_affectation BETWEEN debut_affectation AND fin_affectation
					OR _fin_affectation BETWEEN debut_affectation AND fin_affectation
					OR (_debut_affectation < debut_affectation AND _fin_affectation > fin_affectation)
				)
    );
    
    RETURN _nombre_elementaires_feu > 0 AND _nombre_elementaires_eau > 0;
END $$

DELIMITER ;