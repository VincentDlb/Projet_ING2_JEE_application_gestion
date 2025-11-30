-- ================================================================
-- SCRIPT SQL COMPLET POUR L'INITIALISATION DE LA BASE DE DONNÉES
-- Application JEE - Gestion des Ressources Humaines
-- Base de données : projetjeeapp
-- ================================================================
-- Ce script crée toutes les tables nécessaires et insère des données de test
-- ================================================================

-- Créer la base de données si elle n'existe pas
CREATE DATABASE IF NOT EXISTS projetjeeapp;
USE projetjeeapp;

-- Désactiver temporairement les contraintes de clés étrangères
SET FOREIGN_KEY_CHECKS = 0;

-- ================================================================
-- SUPPRESSION DES TABLES EXISTANTES (pour réinitialisation complète)
-- ================================================================
DROP TABLE IF EXISTS fichedepaie;
DROP TABLE IF EXISTS projet;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS employe;
DROP TABLE IF EXISTS departement;

-- Réactiver les contraintes de clés étrangères
SET FOREIGN_KEY_CHECKS = 1;

-- ================================================================
-- CRÉATION DES TABLES
-- ================================================================

-- ----------------------------------------------------------------
-- Table : departement
-- Description : Stocke les départements de l'entreprise
-- ----------------------------------------------------------------
CREATE TABLE departement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    adresse VARCHAR(255),
    taille INT NOT NULL DEFAULT 0,
    presentation TEXT,
    role VARCHAR(100),
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nom (nom)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Table : employe
-- Description : Stocke les informations des employés
-- ----------------------------------------------------------------
CREATE TABLE employe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    adresse VARCHAR(255),
    typeContrat VARCHAR(50) NOT NULL,
    anciennete INT NOT NULL DEFAULT 0,
    grade VARCHAR(50),
    poste VARCHAR(100),
    matricule INT NOT NULL UNIQUE,
    statutCadre BOOLEAN NOT NULL DEFAULT FALSE,
    departementId INT,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (departementId) REFERENCES departement(id) ON DELETE SET NULL,
    INDEX idx_nom (nom),
    INDEX idx_prenom (prenom),
    INDEX idx_matricule (matricule),
    INDEX idx_departement (departementId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Table : user
-- Description : Stocke les utilisateurs pour l'authentification
-- ----------------------------------------------------------------
CREATE TABLE user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    passwordHash VARCHAR(64) NOT NULL,
    role VARCHAR(20) NOT NULL,
    employeId INT NULL,
    actif BOOLEAN NOT NULL DEFAULT TRUE,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employeId) REFERENCES employe(id) ON DELETE SET NULL,
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Table : fichedepaie
-- Description : Stocke les fiches de paie des employés
-- ----------------------------------------------------------------
CREATE TABLE fichedepaie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeId INT NOT NULL,
    mois INT NOT NULL CHECK (mois BETWEEN 1 AND 12),
    annee INT NOT NULL CHECK (annee BETWEEN 2020 AND 2030),
    salaireBrut FLOAT NOT NULL DEFAULT 0,
    bonus FLOAT NOT NULL DEFAULT 0,
    deduction FLOAT NOT NULL DEFAULT 0,
    numeroFiscal BIGINT NOT NULL,
    statutCadre BOOLEAN NOT NULL DEFAULT FALSE,
    heureSupp FLOAT NOT NULL DEFAULT 0,
    tauxHoraire FLOAT NOT NULL DEFAULT 0,
    heureSemaine FLOAT NOT NULL DEFAULT 35,
    heureDansLeMois FLOAT NOT NULL DEFAULT 151.67,
    heureAbsences FLOAT NOT NULL DEFAULT 0,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employeId) REFERENCES employe(id) ON DELETE CASCADE,
    UNIQUE KEY unique_fiche_periode (employeId, mois, annee),
    INDEX idx_employeId (employeId),
    INDEX idx_periode (annee, mois),
    INDEX idx_annee (annee)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Table : projet
-- Description : Stocke les projets de l'entreprise
-- ----------------------------------------------------------------
CREATE TABLE projet (
    id_projet INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    chefDeProjetId INT,
    echeance DATE,
    id_domaine INT,
    etat VARCHAR(50) NOT NULL DEFAULT 'En cours',
    equipeList TEXT,
    retard INT NOT NULL DEFAULT 0,
    dateCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chefDeProjetId) REFERENCES employe(id) ON DELETE SET NULL,
    FOREIGN KEY (id_domaine) REFERENCES departement(id) ON DELETE SET NULL,
    INDEX idx_nom (nom),
    INDEX idx_etat (etat),
    INDEX idx_chef (chefDeProjetId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- INSERTION DES DONNÉES DE TEST
-- ================================================================

-- ----------------------------------------------------------------
-- Départements
-- ----------------------------------------------------------------
INSERT INTO departement (nom, adresse, taille, presentation, role) VALUES
('Informatique', '123 Rue de la Tech, Paris 75001', 25, 'Département en charge du développement logiciel et de l''infrastructure IT', 'Développement et maintenance des systèmes informatiques'),
('Ressources Humaines', '456 Avenue des RH, Paris 75002', 10, 'Département de gestion des ressources humaines', 'Recrutement, formation et gestion du personnel'),
('Finance', '789 Boulevard Finance, Paris 75003', 15, 'Département financier et comptable', 'Gestion financière et comptabilité'),
('Marketing', '321 Rue Marketing, Paris 75004', 20, 'Département marketing et communication', 'Stratégie marketing et communication'),
('Commercial', '654 Avenue Vente, Paris 75005', 30, 'Département commercial et vente', 'Développement commercial et vente');

-- ----------------------------------------------------------------
-- Employés
-- ----------------------------------------------------------------
INSERT INTO employe (nom, prenom, age, adresse, typeContrat, anciennete, grade, poste, matricule, statutCadre, departementId) VALUES
-- Département Informatique
('Dupont', 'Jean', 35, '10 Rue de Paris, 75001 Paris', 'CDI', 8, 'Senior', 'Développeur Full-Stack', 1001, TRUE, 1),
('Martin', 'Sophie', 28, '20 Avenue Victor Hugo, 75002 Paris', 'CDI', 4, 'Intermédiaire', 'Développeuse Front-End', 1002, FALSE, 1),
('Bernard', 'Luc', 42, '30 Boulevard Saint-Michel, 75003 Paris', 'CDI', 15, 'Expert', 'Architecte Logiciel', 1003, TRUE, 1),
('Dubois', 'Marie', 26, '40 Rue de Rivoli, 75004 Paris', 'CDD', 2, 'Junior', 'Développeuse Back-End', 1004, FALSE, 1),
('Thomas', 'Pierre', 38, '50 Rue de la Paix, 75005 Paris', 'CDI', 10, 'Senior', 'DevOps Engineer', 1005, TRUE, 1),

-- Département RH
('Petit', 'Claire', 32, '60 Avenue des Champs, 75006 Paris', 'CDI', 6, 'Senior', 'Responsable RH', 2001, TRUE, 2),
('Robert', 'Julie', 29, '70 Rue Montmartre, 75007 Paris', 'CDI', 3, 'Intermédiaire', 'Chargée de Recrutement', 2002, FALSE, 2),
('Richard', 'Antoine', 45, '80 Boulevard Haussmann, 75008 Paris', 'CDI', 18, 'Expert', 'Directeur RH', 2003, TRUE, 2),

-- Département Finance
('Durand', 'Isabelle', 34, '90 Rue Lafayette, 75009 Paris', 'CDI', 7, 'Senior', 'Contrôleuse de Gestion', 3001, TRUE, 3),
('Simon', 'Marc', 40, '100 Avenue de la République, 75010 Paris', 'CDI', 12, 'Expert', 'Directeur Financier', 3002, TRUE, 3),
('Moreau', 'Élodie', 27, '110 Rue du Faubourg, 75011 Paris', 'CDI', 3, 'Junior', 'Comptable', 3003, FALSE, 3),

-- Département Marketing
('Laurent', 'Nicolas', 31, '120 Boulevard Voltaire, 75012 Paris', 'CDI', 5, 'Intermédiaire', 'Chef de Produit', 4001, FALSE, 4),
('Lefebvre', 'Amélie', 36, '130 Rue de Belleville, 75013 Paris', 'CDI', 9, 'Senior', 'Responsable Marketing', 4002, TRUE, 4),
('Michel', 'Julien', 29, '140 Avenue Parmentier, 75014 Paris', 'CDD', 2, 'Junior', 'Chargé de Communication', 4003, FALSE, 4),

-- Département Commercial
('Garcia', 'Laura', 33, '150 Rue Oberkampf, 75015 Paris', 'CDI', 6, 'Senior', 'Directrice Commerciale', 5001, TRUE, 5),
('Roux', 'Maxime', 28, '160 Boulevard Richard Lenoir, 75016 Paris', 'CDI', 4, 'Intermédiaire', 'Commercial', 5002, FALSE, 5),
('Fournier', 'Camille', 25, '170 Rue de Charonne, 75017 Paris', 'CDD', 1, 'Junior', 'Assistante Commerciale', 5003, FALSE, 5);

-- ----------------------------------------------------------------
-- Utilisateurs (avec mots de passe hashés en SHA-256)
-- ----------------------------------------------------------------
-- Mots de passe :
--   admin / admin123
--   chef_dept / chef123
--   chef_proj / chef123
--   employe / emp123
-- ----------------------------------------------------------------
INSERT INTO user (username, passwordHash, role, employeId, actif) VALUES
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN', NULL, TRUE),
('chef_dept', '89e01536ac207279409d4de1e5253e01f4a1769e696db0d6062ca9b8f56767c8', 'CHEF_DEPARTEMENT', 6, TRUE),
('chef_proj', '89e01536ac207279409d4de1e5253e01f4a1769e696db0d6062ca9b8f56767c8', 'CHEF_PROJET', 1, TRUE),
('employe', '8c8c4e9d92b9c47e52c1e3f5ad1e5b1e9e9a2b1c3d4e5f6a7b8c9d0e1f2a3b4c', 'EMPLOYE', 2, TRUE);

-- ----------------------------------------------------------------
-- Fiches de Paie (quelques exemples pour Janvier et Février 2025)
-- ----------------------------------------------------------------
INSERT INTO fichedepaie (employeId, mois, annee, salaireBrut, bonus, deduction, numeroFiscal, statutCadre, heureSupp, tauxHoraire, heureSemaine, heureDansLeMois, heureAbsences) VALUES
-- Janvier 2025
(1, 1, 2025, 4500.00, 500.00, 1200.00, 1001234567890, TRUE, 5.0, 25.50, 35.0, 151.67, 0.0),
(2, 1, 2025, 3000.00, 200.00, 800.00, 1002234567891, FALSE, 3.0, 18.00, 35.0, 151.67, 0.0),
(3, 1, 2025, 5500.00, 800.00, 1500.00, 1003234567892, TRUE, 0.0, 30.00, 35.0, 151.67, 0.0),
(6, 1, 2025, 4000.00, 400.00, 1100.00, 2001234567893, TRUE, 2.0, 22.00, 35.0, 151.67, 0.0),
(10, 1, 2025, 5000.00, 600.00, 1400.00, 3002234567894, TRUE, 0.0, 28.00, 35.0, 151.67, 0.0),

-- Février 2025
(1, 2, 2025, 4500.00, 300.00, 1200.00, 1001234567890, TRUE, 8.0, 25.50, 35.0, 151.67, 0.0),
(2, 2, 2025, 3000.00, 150.00, 800.00, 1002234567891, FALSE, 0.0, 18.00, 35.0, 151.67, 3.5),
(3, 2, 2025, 5500.00, 1000.00, 1500.00, 1003234567892, TRUE, 0.0, 30.00, 35.0, 151.67, 0.0);

-- ----------------------------------------------------------------
-- Projets
-- ----------------------------------------------------------------
INSERT INTO projet (nom, chefDeProjetId, echeance, id_domaine, etat, equipeList, retard) VALUES
('Refonte Site Web', 1, '2025-06-30', 1, 'En cours', '1,2,4', 5),
('Migration Cloud', 3, '2025-08-15', 1, 'En cours', '3,5', 0),
('ERP Implementation', 1, '2025-12-31', 3, 'Planifié', '1,10', 0),
('Campagne Marketing Q2', 13, '2025-07-01', 4, 'En cours', '12,13,14', 3),
('Expansion Commerciale', 15, '2025-09-30', 5, 'En cours', '15,16', 2),
('Audit RH', 8, '2025-05-15', 2, 'Terminé', '6,7,8', 0);

-- ================================================================
-- VÉRIFICATIONS
-- ================================================================

-- Compter les enregistrements dans chaque table
SELECT 'Départements' AS Table_Name, COUNT(*) AS Count FROM departement
UNION ALL
SELECT 'Employés', COUNT(*) FROM employe
UNION ALL
SELECT 'Utilisateurs', COUNT(*) FROM user
UNION ALL
SELECT 'Fiches de Paie', COUNT(*) FROM fichedepaie
UNION ALL
SELECT 'Projets', COUNT(*) FROM projet;

-- Afficher un résumé des données
SELECT '=== RÉSUMÉ DE LA BASE DE DONNÉES ===' AS Message;
SELECT CONCAT('Base de données : ', DATABASE()) AS Info;
SELECT CONCAT('Tables créées : ', COUNT(*)) AS Info FROM information_schema.tables WHERE table_schema = 'projetjeeapp';

-- ================================================================
-- FIN DU SCRIPT
-- ================================================================
-- La base de données est maintenant prête à être utilisée !
-- Vous pouvez vous connecter avec les comptes suivants :
--   - admin / admin123 (Administrateur)
--   - chef_dept / chef123 (Chef de Département)
--   - chef_proj / chef123 (Chef de Projet)
--   - employe / emp123 (Employé)
-- ================================================================