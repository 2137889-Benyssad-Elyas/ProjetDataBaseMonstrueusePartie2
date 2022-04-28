DROP DATABASE IF EXISTS ressource_monstrueuse;
CREATE DATABASE ressource_monstrueuse;
USE ressource_monstrueuse;

CREATE TABLE Aventurier (
	id_aventurier INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    classe VARCHAR(255) NOT NULL,
    niveau TINYINT NOT NULL,
    point_vie INTEGER NOT NULL,
    attaque INTEGER NOT NULL,
    CONSTRAINT niveau_superieur_zero CHECK (niveau > 0)
);

CREATE TABLE Expedition (
    id_expedition INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom_equipe VARCHAR(255) NOT NULL UNIQUE,
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
    fonction VARCHAR(255) NOT NULL UNIQUE,
    longueur FLOAT NOT NULL,
    largeur FLOAT NOT NULL,
    salle_suivante INTEGER UNIQUE,
    FOREIGN KEY (salle_suivante) REFERENCES Salle (id_salle),
    CONSTRAINT fonction_minimum_cinq_caracteres CHECK (fonction >= 5)
);

CREATE TABLE Visite_salle (
    salle INTEGER,
    expedition INTEGER,
    PRIMARY KEY(salle, expedition),
    FOREIGN KEY (expedition) REFERENCES Expedition (id_expedition),
    moment_visite DATETIME NOT NULL,
    appreciation TEXT
    );

CREATE TABLE Responsabilite (
    id_responsabilite INTEGER PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    niveau_responsabilite INTEGER NOT NULL,
    CONSTRAINT niveau_responsabilite_superieur_egale_zero CHECK (niveau_responsabilite >= 0)
    );
  
CREATE TABLE Famille_monstre (
	id_famille INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom_famille VARCHAR(255) NOT NULL UNIQUE,
    point_vie_maximal INTEGER NOT NULL,
    degat_base INTEGER NOT NULL,
    CONSTRAINT point_vie_max_superieur_zero CHECK (point_vie_maximal > 0),
    CONSTRAINT degat_base_superieur_zero CHECK (degat_base > 0)
);
  
CREATE TABLE Monstre (
	id_monstre INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    code_employe VARCHAR(4) NOT NULL,
    point_vie INTEGER NOT NULL,
    attaque INTEGER NOT NULL,
    numero_ass_maladie BLOB NOT NULL,
    id_famille INTEGER NOT NULL,
    FOREIGN KEY (id_famille) REFERENCES Famille_monstre (id_famille),
    experience INTEGER NOT NULL
);

CREATE TABLE Affectation_salle (
    id_affectation INTEGER PRIMARY KEY AUTO_INCREMENT,
    monstre INTEGER NOT NULL,
    responsabilite INTEGER NOT NULL,
    salle INTEGER NOT NULL,
    debut_affectation DATETIME NOT NULL,
    fin_affectation DATETIME,
    FOREIGN KEY (monstre) REFERENCES Monstre (id_monstre),
    FOREIGN KEY (responsabilite) REFERENCES Responsabilite (id_responsabilite),
    FOREIGN KEY (salle) REFERENCES Salle (id_salle)
    );

CREATE TABLE Humanoide (
	id_humanoide INTEGER PRIMARY KEY AUTO_INCREMENT,
    famille INTEGER NOT NULL,
    FOREIGN KEY (famille) REFERENCES Famille_monstre (id_famille),
    arme VARCHAR(255),
    intelligence INTEGER NOT NULL,
    CONSTRAINT intelligence_superieur_egale_deux CHECK (intelligence >= 2)
);

CREATE TABLE Mort_vivant (
	id_mort_vivant INTEGER PRIMARY KEY AUTO_INCREMENT,
    famille INTEGER NOT NULL,
    FOREIGN KEY (famille) REFERENCES Famille_monstre (id_famille),
    vulnerable_soleil TINYINT NOT NULL,
    infectieux TINYINT NOT NULL,
    CONSTRAINT vulnerable_soleil_egale_zero_ou_un CHECK (vulnerable_soleil = 0 OR vulnerable_soleil = 1),
    CONSTRAINT infectieux_egale_zero_ou_un CHECK (infectieux = 0 OR infectieux = 1)
);

CREATE TABLE Elementaire (
	id_elementaire INTEGER PRIMARY KEY AUTO_INCREMENT,
    famille INTEGER NOT NULL,
    FOREIGN KEY (famille) REFERENCES Famille_monstre (id_famille),
    element ENUM('air', 'feu','terre', 'eau') NOT NULL,
    taille ENUM('rikiki', 'moyen','grand', 'colossal') NOT NULL 
);

CREATE TABLE Coffre_tresor (
    id_coffre_tresor INTEGER PRIMARY KEY AUTO_INCREMENT,
    code_secret CHAR(64),
    salle INTEGER,
    FOREIGN KEY (salle) REFERENCES Salle (id_salle)
    );
    
CREATE TABLE Objet (
    id_objet INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL UNIQUE,
    valeur INT NOT NULL,
    masse FLOAT NOT NULL,
    CONSTRAINT valeur_superieur_zero CHECK (valeur > 0),
    CONSTRAINT masse_superieur_zero CHECK (masse > 0)
    );
    
CREATE TABLE Ligne_coffre (
    coffre INTEGER,
    objet INTEGER,
    quantite INTEGER NOT NULL,
    PRIMARY KEY (coffre, objet),
    FOREIGN KEY (coffre) REFERENCES Coffre_tresor (id_coffre_tresor),
    FOREIGN KEY (objet) REFERENCES Objet (id_objet),
    CONSTRAINT quantite_superieur_zero_coffre CHECK (quantite > 0)
    );

CREATE TABLE Inventaire_expedition (
	id_expedition INTEGER AUTO_INCREMENT,
    objet INTEGER,
    quantite INTEGER NOT NULL,
    PRIMARY KEY (id_expedition, objet),
    FOREIGN KEY (id_expedition) REFERENCES Expedition (id_expedition),
    FOREIGN KEY (objet) REFERENCES Objet (id_objet),
    CONSTRAINT quantite_superieur_zero_inventaire CHECK (quantite > 0)
);

