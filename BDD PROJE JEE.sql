DROP DATABASE IF EXISTS projetjeeapp;
CREATE DATABASE projetjeeapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE projetjeeapp;


-- CRÉATION DES TABLES


CREATE TABLE departement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE employe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telephone VARCHAR(20),
    adresse VARCHAR(200),
    matricule VARCHAR(20) NOT NULL UNIQUE,
    poste VARCHAR(50) NOT NULL,
    grade VARCHAR(20) NOT NULL,
    salaire DOUBLE NOT NULL,
    date_embauche DATE NOT NULL,
    departement_id INT,
    FOREIGN KEY (departement_id) REFERENCES departement(id) ON DELETE SET NULL
);

CREATE TABLE projet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    date_debut DATE,
    date_fin DATE,
    statut VARCHAR(20) DEFAULT 'EN_COURS'
);

CREATE TABLE employe_projet (
    employe_id INT NOT NULL,
    projet_id INT NOT NULL,
    PRIMARY KEY (employe_id, projet_id),
    FOREIGN KEY (employe_id) REFERENCES employe(id) ON DELETE CASCADE,
    FOREIGN KEY (projet_id) REFERENCES projet(id) ON DELETE CASCADE
);

CREATE TABLE fiche_de_paie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employe_id INT NOT NULL,
    mois INT NOT NULL,
    annee INT NOT NULL,
    salaire_de_base DOUBLE NOT NULL,
    primes DOUBLE DEFAULT 0.0,
    heures_supp DOUBLE DEFAULT 0.0,
    deductions DOUBLE DEFAULT 0.0,
    jours_absence INT DEFAULT 0,
    net_a_payer DOUBLE NOT NULL,
    FOREIGN KEY (employe_id) REFERENCES employe(id) ON DELETE CASCADE
);

CREATE TABLE user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nom_complet VARCHAR(100),
    role VARCHAR(50) NOT NULL,
    employe_id INT,
    departement_id INT,
    FOREIGN KEY (employe_id) REFERENCES employe(id) ON DELETE SET NULL,
    FOREIGN KEY (departement_id) REFERENCES departement(id) ON DELETE SET NULL
);

-- ========================================
-- INSERTION DES DÉPARTEMENTS (8)
-- ========================================

INSERT INTO departement (nom, description) VALUES 
('Informatique', 'Développement et maintenance des systèmes informatiques'),
('Ressources Humaines', 'Gestion du personnel et recrutement'),
('Finance', 'Comptabilité, contrôle de gestion et audit'),
('Marketing', 'Communication, publicité et stratégie marketing'),
('Commercial', 'Vente et relation client'),
('Logistique', 'Gestion des stocks et expéditions'),
('Production', 'Fabrication et contrôle qualité'),
('Direction Générale', 'Management et stratégie d\'entreprise');

-- ========================================
-- INSERTION DES EMPLOYÉS (25)
-- ========================================

INSERT INTO employe (nom, prenom, email, telephone, matricule, poste, grade, salaire, date_embauche, departement_id) VALUES
-- Informatique (5 employés)
('Dupont', 'Jean', 'jean.dupont@rowtech.fr', '0123456789', 'EMP-001', 'Lead Developer', 'EXPERT', 6500.00, '2018-01-15', 1),
('Martin', 'Claire', 'claire.martin@rowtech.fr', '0123456790', 'EMP-002', 'Développeur Full Stack', 'SENIOR', 5200.00, '2019-03-20', 1),
('Bernard', 'Thomas', 'thomas.bernard@rowtech.fr', '0123456791', 'EMP-003', 'Développeur Backend', 'CONFIRME', 4200.00, '2021-06-10', 1),
('Petit', 'Laura', 'laura.petit@rowtech.fr', '0123456792', 'EMP-004', 'Développeur Frontend', 'JUNIOR', 3200.00, '2023-09-01', 1),
('Dubois', 'Alexandre', 'alexandre.dubois@rowtech.fr', '0123456793', 'EMP-005', 'DevOps Engineer', 'CONFIRME', 4800.00, '2020-11-12', 1),

-- Ressources Humaines (3 employés)
('Moreau', 'Sophie', 'sophie.moreau@rowtech.fr', '0123456794', 'EMP-006', 'Directeur RH', 'EXPERT', 6000.00, '2017-05-08', 2),
('Laurent', 'Marie', 'marie.laurent@rowtech.fr', '0123456795', 'EMP-007', 'Chargé de Recrutement', 'CONFIRME', 3800.00, '2021-02-15', 2),
('Simon', 'Julien', 'julien.simon@rowtech.fr', '0123456796', 'EMP-008', 'Assistant RH', 'JUNIOR', 2800.00, '2024-01-10', 2),

-- Finance (4 employés)
('Lefebvre', 'Pierre', 'pierre.lefebvre@rowtech.fr', '0123456797', 'EMP-009', 'Directeur Financier', 'EXPERT', 7500.00, '2016-09-01', 3),
('Leroy', 'Isabelle', 'isabelle.leroy@rowtech.fr', '0123456798', 'EMP-010', 'Chef Comptable', 'SENIOR', 5000.00, '2019-04-22', 3),
('Roux', 'Nicolas', 'nicolas.roux@rowtech.fr', '0123456799', 'EMP-011', 'Comptable', 'CONFIRME', 3600.00, '2021-08-15', 3),
('Garnier', 'Amélie', 'amelie.garnier@rowtech.fr', '0123456800', 'EMP-012', 'Assistant Comptable', 'JUNIOR', 2700.00, '2023-11-05', 3),

-- Marketing (3 employés)
('Bonnet', 'Lucas', 'lucas.bonnet@rowtech.fr', '0123456801', 'EMP-013', 'Directeur Marketing', 'EXPERT', 6200.00, '2018-07-12', 4),
('Fontaine', 'Emma', 'emma.fontaine@rowtech.fr', '0123456802', 'EMP-014', 'Chef de Produit', 'SENIOR', 4800.00, '2020-10-03', 4),
('Rousseau', 'Hugo', 'hugo.rousseau@rowtech.fr', '0123456803', 'EMP-015', 'Community Manager', 'CONFIRME', 3400.00, '2022-03-18', 4),

-- Commercial (4 employés)
('Vincent', 'Maxime', 'maxime.vincent@rowtech.fr', '0123456804', 'EMP-016', 'Directeur Commercial', 'EXPERT', 6800.00, '2017-02-20', 5),
('Muller', 'Chloé', 'chloe.muller@rowtech.fr', '0123456805', 'EMP-017', 'Responsable Grands Comptes', 'SENIOR', 5500.00, '2019-06-15', 5),
('Girard', 'Antoine', 'antoine.girard@rowtech.fr', '0123456806', 'EMP-018', 'Commercial', 'CONFIRME', 3900.00, '2021-09-22', 5),
('Lambert', 'Sarah', 'sarah.lambert@rowtech.fr', '0123456807', 'EMP-019', 'Commercial Junior', 'JUNIOR', 2900.00, '2023-12-01', 5),

-- Logistique (2 employés)
('Dufour', 'Raphaël', 'raphael.dufour@rowtech.fr', '0123456808', 'EMP-020', 'Responsable Logistique', 'SENIOR', 4600.00, '2019-08-10', 6),
('Lopez', 'Léa', 'lea.lopez@rowtech.fr', '0123456809', 'EMP-021', 'Agent Logistique', 'CONFIRME', 3200.00, '2022-05-08', 6),

-- Production (2 employés)
('Fournier', 'David', 'david.fournier@rowtech.fr', '0123456810', 'EMP-022', 'Chef de Production', 'SENIOR', 5200.00, '2018-11-20', 7),
('Blanc', 'Manon', 'manon.blanc@rowtech.fr', '0123456811', 'EMP-023', 'Technicien Production', 'CONFIRME', 3500.00, '2021-07-14', 7),

-- Direction (2 employés)
('Renard', 'Philippe', 'philippe.renard@rowtech.fr', '0123456812', 'EMP-024', 'PDG', 'EXPERT', 12000.00, '2015-01-01', 8),
('Michel', 'Catherine', 'catherine.michel@rowtech.fr', '0123456813', 'EMP-025', 'Directeur Général Adjoint', 'EXPERT', 9000.00, '2016-06-15', 8);


-- INSERTION DES PROJETS (8)


INSERT INTO projet (nom, description, date_debut, date_fin, statut) VALUES
('Migration Cloud AWS', 'Migration de l\'infrastructure vers AWS avec haute disponibilité', '2025-01-10', '2025-08-31', 'EN_COURS'),
('Refonte Site E-commerce', 'Nouvelle version du site avec React et Node.js', '2024-09-01', '2025-03-31', 'EN_COURS'),
('Application Mobile iOS/Android', 'Développement application mobile native', '2025-02-15', '2025-12-31', 'EN_COURS'),
('Campagne Marketing 2025', 'Stratégie marketing digital et acquisition', '2025-01-01', '2025-12-31', 'EN_COURS'),
('ERP Interne', 'Mise en place ERP pour gestion intégrée', '2024-03-01', '2024-12-31', 'TERMINE'),
('Optimisation Logistique', 'Automatisation des processus logistiques', '2024-06-01', '2025-02-28', 'EN_COURS'),
('Audit Financier', 'Audit complet des comptes 2024', '2024-11-01', '2025-01-31', 'TERMINE'),
('Projet Alpha (Annulé)', 'Projet expérimental abandonné', '2024-08-01', '2024-10-31', 'ANNULE');


-- AFFECTATION EMPLOYÉS AUX PROJETS


INSERT INTO employe_projet (employe_id, projet_id) VALUES
-- Migration Cloud AWS (Projet 1) - Équipe IT
(1, 1), (2, 1), (5, 1),

-- Refonte Site E-commerce (Projet 2) - Équipe IT + Marketing
(1, 2), (2, 2), (3, 2), (4, 2), (13, 2), (14, 2),

-- Application Mobile (Projet 3) - Équipe IT
(1, 3), (2, 3), (4, 3),

-- Campagne Marketing (Projet 4) - Marketing + Commercial
(13, 4), (14, 4), (15, 4), (16, 4), (17, 4),

-- ERP Interne (Projet 5 - Terminé) - IT + Finance
(1, 5), (3, 5), (9, 5), (10, 5),

-- Optimisation Logistique (Projet 6) - Logistique + IT
(20, 6), (21, 6), (5, 6),

-- Audit Financier (Projet 7 - Terminé) - Finance
(9, 7), (10, 7), (11, 7);


-- INSERTION DES FICHES DE PAIE (10 exemples)


INSERT INTO fiche_de_paie (employe_id, mois, annee, salaire_de_base, primes, heures_supp, deductions, jours_absence, net_a_payer) VALUES
-- Octobre 2025
(1, 10, 2025, 6500.00, 800.00, 0.00, 1200.00, 0, 6100.00),
(2, 10, 2025, 5200.00, 500.00, 200.00, 950.00, 1, 4776.67),
(6, 10, 2025, 6000.00, 1000.00, 0.00, 1100.00, 0, 5900.00),
(9, 10, 2025, 7500.00, 1500.00, 0.00, 1400.00, 0, 7600.00),
(13, 10, 2025, 6200.00, 600.00, 100.00, 1150.00, 2, 5336.67),

-- Novembre 2025
(1, 11, 2025, 6500.00, 1000.00, 0.00, 1200.00, 0, 6300.00),
(2, 11, 2025, 5200.00, 600.00, 150.00, 950.00, 0, 5000.00),
(4, 11, 2025, 3200.00, 200.00, 50.00, 600.00, 1, 2743.33),
(10, 11, 2025, 5000.00, 800.00, 0.00, 950.00, 0, 4850.00),
(16, 11, 2025, 6800.00, 2000.00, 0.00, 1300.00, 0, 7500.00);


-- INSERTION DES UTILISATEURS


INSERT INTO user (username, password, nom_complet, role, employe_id, departement_id) VALUES
('admin', 'admin123', 'Administrateur Système', 'ADMINISTRATEUR', NULL, NULL),
('sophie.moreau', 'rh123', 'Sophie Moreau - Directeur RH', 'CHEF_DEPARTEMENT', 6, 2),
('jean.dupont', 'dev123', 'Jean Dupont - Lead Developer', 'CHEF_PROJET', 1, NULL),
('laura.petit', 'emp123', 'Laura Petit - Développeur', 'EMPLOYE', 4, NULL),
('pierre.lefebvre', 'fin123', 'Pierre Lefebvre - Directeur Financier', 'CHEF_DEPARTEMENT', 9, 3);


-- VÉRIFICATIONS


SELECT '========== STATISTIQUES ==========' as '';
SELECT 'Départements' as Entité, COUNT(*) as Total FROM departement
UNION ALL
SELECT 'Employés', COUNT(*) FROM employe
UNION ALL
SELECT 'Projets', COUNT(*) FROM projet
UNION ALL
SELECT 'Fiches de Paie', COUNT(*) FROM fiche_de_paie
UNION ALL
SELECT 'Utilisateurs', COUNT(*) FROM user;

SELECT '' as '';
SELECT '========== DÉTAILS ==========' as '';
SELECT 'Employés par département :' as '';
SELECT d.nom as Département, COUNT(e.id) as NbEmployes
FROM departement d
LEFT JOIN employe e ON d.id = e.departement_id
GROUP BY d.id, d.nom
ORDER BY NbEmployes DESC;



-- Système d'authentification


USE projetjeeapp;

-- TABLE : utilisateur

CREATE TABLE utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    role VARCHAR(50) NOT NULL 
        CHECK (role IN ('ADMIN', 'CHEF_DEPARTEMENT', 'CHEF_PROJET', 'EMPLOYE')),
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB;


-- DONNÉES DE TEST - Utilisateurs

-- Mot de passe pour tous : "password123"
-- BCrypt pour hasher les mots de passe

INSERT INTO utilisateur (username, password, nom, prenom, email, role, actif) VALUES
('admin', 'password123', 'Admin', 'Système', 'admin@rowtech.com', 'ADMIN', TRUE),
('marie.bernard', 'password123', 'Bernard', 'Marie', 'marie.bernard@rowtech.com', 'CHEF_DEPARTEMENT', TRUE),
('pierre.durand', 'password123', 'Durand', 'Pierre', 'pierre.durand@rowtech.com', 'CHEF_PROJET', TRUE),
('jean.dupont', 'password123', 'Dupont', 'Jean', 'jean.dupont@rowtech.com', 'EMPLOYE', TRUE);


-- VÉRIFICATION

SELECT 'Table utilisateur créée avec succès!' AS Message;
SELECT * FROM utilisateur;

USE projetjeeapp;

-- Ajouter la colonne chef_projet_id si elle n'existe pas
ALTER TABLE projet ADD COLUMN chef_projet_id INT;
ALTER TABLE projet ADD FOREIGN KEY (chef_projet_id) REFERENCES employe(id) ON DELETE SET NULL;

-- Affecter des chefs de projet aux projets existants
UPDATE projet SET chef_projet_id = 1 WHERE id = 1; -- Jean Dupont pour Migration Cloud
UPDATE projet SET chef_projet_id = 1 WHERE id = 2; -- Jean Dupont pour Refonte Site
UPDATE projet SET chef_projet_id = 2 WHERE id = 3; -- Claire Martin pour App Mobile
UPDATE projet SET chef_projet_id = 13 WHERE id = 4; -- Lucas Bonnet pour Marketing

-- Vérifier
SELECT * FROM projet;



USE projetjeeapp;

-- Ajouter les nouvelles colonnes pour les cotisations
ALTER TABLE fiche_de_paie 
ADD COLUMN cotisation_secu DOUBLE DEFAULT 0.0 AFTER jours_absence,
ADD COLUMN cotisation_vieillesse DOUBLE DEFAULT 0.0 AFTER cotisation_secu,
ADD COLUMN cotisation_chomage DOUBLE DEFAULT 0.0 AFTER cotisation_vieillesse,
ADD COLUMN cotisation_retraite DOUBLE DEFAULT 0.0 AFTER cotisation_chomage,
ADD COLUMN cotisation_csg DOUBLE DEFAULT 0.0 AFTER cotisation_retraite,
ADD COLUMN cotisation_crds DOUBLE DEFAULT 0.0 AFTER cotisation_csg;


DESCRIBE fiche_de_paie;


ALTER TABLE user MODIFY COLUMN password VARCHAR(255);



-- Ajouter la colonne chef_departement_id dans la table departement
ALTER TABLE departement 
ADD COLUMN chef_departement_id INT NULL;

-- Ajouter la contrainte de clé étrangère
ALTER TABLE departement 
ADD CONSTRAINT fk_departement_chef 
FOREIGN KEY (chef_departement_id) 
REFERENCES employe(id) 
ON DELETE SET NULL;

-- Créer un index pour améliorer les performances des requêtes
CREATE INDEX idx_departement_chef ON departement(chef_departement_id);

-- Afficher la structure de la table pour vérification
DESC departement;


-- Afficher tous les départements avec leur chef (si désigné)
SELECT 
    d.id AS dept_id,
    d.nom AS departement,
    d.description,
    CONCAT(e.prenom, ' ', e.nom) AS chef_departement
FROM departement d
LEFT JOIN employe e ON d.chef_departement_id = e.id
ORDER BY d.nom;

UPDATE user
SET password = '$2a$10$rHbHsww9bD8zCuzoUGhSR.H2bw6TfC2MIAFvKjPDZWXOw8xiVAnJ2'
WHERE username = 'admin';
