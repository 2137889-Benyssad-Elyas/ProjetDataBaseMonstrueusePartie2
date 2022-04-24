DROP DATABASE IF EXISTS ressource_monstrueuse;
CREATE DATABASE ressource_monstrueuse;
USE ressource_monstrueuse;

CREATE TABLE Aventurier (
	id_aventurier INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    classe VARCHAR(255),
    niveau TINYINT,
    point_vie INTEGER,
    attaque INTEGER
);

CREATE TABLE Expedition (
    id_expedition INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom_equipe VARCHAR(255),
    depart DATETIME,
    terminaison DATETIME
    );
    
CREATE TABLE Expedition_aventurier (
	id_expedition INTEGER,
    id_aventurier INTEGER,
    PRIMARY KEY(id_expedition, id_aventurier),
    FOREIGN KEY (id_expedition) REFERENCES Expedition (id_expedition),
    FOREIGN KEY (id_aventurier) REFERENCES Aventurier (id_aventurier)
);	

CREATE TABLE Salle (
	id_salle INTEGER PRIMARY KEY AUTO_INCREMENT,
    fonction VARCHAR(255),
    longueur FLOAT,
    largeur FLOAT,
    salle_suivante INTEGER,
    FOREIGN KEY (salle_suivante) REFERENCES Salle (id_salle)
);

CREATE TABLE Visite_salle (
    salle INTEGER,
    expedition INTEGER,
    PRIMARY KEY(salle, expedition),
    FOREIGN KEY (expedition) REFERENCES Expedition (id_expedition),
    moment_visite DATETIME,
    appreciation TEXT
    );

CREATE TABLE Responsabilite (
    id_responsabilite INTEGER PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255),
    niveau_responsabilite INTEGER
    );
  
CREATE TABLE Famille_monstre (
	id_famille INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom_famille VARCHAR(255),
    point_vie_maximal INTEGER,
    degat_base INTEGER
);
  
CREATE TABLE Monstre (
	id_monstre INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    code_employe VARCHAR(4),
    point_vie INTEGER,
    attaque INTEGER,
    numero_ass_maladie BLOB,
    id_famille INTEGER,
    FOREIGN KEY (id_famille) REFERENCES Famille_monstre (id_famille),
    experience INTEGER
);

CREATE TABLE Affectation_salle (
    id_affectation INTEGER PRIMARY KEY AUTO_INCREMENT,
    monstre INTEGER,
    responsabilite INTEGER,
    salle INTEGER,
    debut_affectation DATETIME,
    fin_affectation DATETIME,
    FOREIGN KEY (monstre) REFERENCES Monstre (id_monstre),
    FOREIGN KEY (responsabilite) REFERENCES Responsabilite (id_responsabilite),
    FOREIGN KEY (salle) REFERENCES Salle (id_salle)
    );

CREATE TABLE Humanoide (
	id_humanoide INTEGER PRIMARY KEY AUTO_INCREMENT,
    famille INTEGER,
    FOREIGN KEY (famille) REFERENCES Famille_monstre (id_famille),
    arme VARCHAR(255),
    intelligence INTEGER
);

CREATE TABLE Mort_vivant (
	id_mort_vivant INTEGER PRIMARY KEY AUTO_INCREMENT,
    famille INTEGER,
    FOREIGN KEY (famille) REFERENCES Famille_monstre (id_famille),
    vulnerable_soleil TINYINT,
    infectieux TINYINT
);

CREATE TABLE Elementaire (
	id_elementaire INTEGER PRIMARY KEY AUTO_INCREMENT,
    famille INTEGER,
    FOREIGN KEY (famille) REFERENCES Famille_monstre (id_famille),
    element ENUM('air', 'feu','terre', 'eau'),
    taille ENUM('rikiki', 'moyen','grand', 'colossal') 
);

CREATE TABLE Coffre_tresor (
    id_coffre_tresor INTEGER PRIMARY KEY AUTO_INCREMENT,
    code_secret CHAR(64),
    salle INTEGER,
    FOREIGN KEY (salle) REFERENCES Salle (id_salle)
    );
    
CREATE TABLE Objet (
    id_objet INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    valeur INT,
    masse FLOAT
    );
    
CREATE TABLE Ligne_coffre (
    coffre INTEGER,
    objet INTEGER,
    quantite INTEGER,
    PRIMARY KEY (coffre, objet),
    FOREIGN KEY (coffre) REFERENCES Coffre_tresor (id_coffre_tresor),
    FOREIGN KEY (objet) REFERENCES Objet (id_objet)
    );