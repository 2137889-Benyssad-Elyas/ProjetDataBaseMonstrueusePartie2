DELIMITER $$

CREATE FUNCTION cryptage(_mdp CHAR) RETURNS BLOB NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN 
DECLARE mdp_crypter BLOB;

SET mdp_crypter = AES_ENCRYPT(_mdp, UNHEX(_cle));
 
 RETURN VALEUR;
END 

CREATE FUNCTION decryptage(mdp_crypter BLOB) RETURNS BLOB NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN 
DECLARE mdp_clair CHAR;

SET mdp_clair = AES_DECRYPT(mdp_crypter, UNHEX(_cle));
 
 RETURN VALEUR;
END 
 
 DELIMITER ;
