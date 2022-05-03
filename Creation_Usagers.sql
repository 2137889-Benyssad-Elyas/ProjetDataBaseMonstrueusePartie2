USE ressource_monstrueuse;
 
DROP ROLE IF EXISTS administrateur_systeme;
CREATE ROLE administrateur_systeme;
GRANT ALL ON * TO administrateur_systeme;

DROP ROLE IF EXISTS responsable_visites;
CREATE ROLE responsable_visites;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Visite_salle TO responsable_visites;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Expedition TO responsable_visites;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Expedition_aventurier TO responsable_visites;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Inventaire_expedition TO responsable_visites;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Aventurier TO responsable_visites;

DROP ROLE IF EXISTS responsable_entretient;
CREATE ROLE responsable_entretient;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Coffre_tresor TO responsable_entretient;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Ligne_coffre TO responsable_entretient;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Objet TO responsable_entretient;

DROP ROLE IF EXISTS service_ressources_monstrueuses;
CREATE ROLE service_ressources_monstrueuses;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Humanoide TO service_ressources_monstrueuses;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Mort_vivant TO service_ressources_monstrueuses;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Elementaire TO service_ressources_monstrueuses;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Famille_monstre TO service_ressources_monstrueuses;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Monstre TO service_ressources_monstrueuses;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Responsabilite TO service_ressources_monstrueuses;
GRANT CREATE, UPDATE, REFERENCES, DELETE ON Affectation_salle TO service_ressources_monstrueuses;

DROP USER IF EXISTS daenerys;
CREATE USER daenerys IDENTIFIED BY 'dragons3'
DEFAULT ROLE administrateur_systeme;

DROP USER IF EXISTS jon;
CREATE USER jon IDENTIFIED BY 'Jenesaisrien'
DEFAULT ROLE responsable_visites, responsable_entretient;

DROP USER IF EXISTS baelish;
CREATE USER baelish IDENTIFIED BY 'lord'
DEFAULT ROLE service_ressources_monstrueuses;
