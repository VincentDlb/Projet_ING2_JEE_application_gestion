#  RowTech (J2EE/MVC)

##  Présentation Générale

Ce dépôt contient une application **Java EE** complète, développée avec **Maven** et structurée autour d'une architecture **Modèle-Vue-Contrôleur (MVC)**.

L'objectif principal est de fournir une plateforme robuste et centralisée pour la **gestion complète des équipes, projets et départements** au sein d'une entreprise. Cela inclut la gestion des employés, des départements, des projets, ainsi que le cycle de vie de la **fiche de paie**.

L'application utilise des **Servlets** pour la logique de contrôle, des pages **JSP** pour la présentation et **MySQL** via **Hibernate** et JDBC pour la persistance des données.

---

##  Objectifs du Projet

* **Centraliser** la gestion des entités métiers : Employés, Chefs de Départements, Chefs de Projets, Départements et Projets.
* **Automatiser** le calcul, la génération et l'archivage des fiches de paie.
* Offrir une interface utilisateur **claire et sécurisée** (via authentification et filtres d'accès).
* Proposer un module de **reporting et statistiques** dynamique.
* Permettre l'export de documents administratifs (ex: fiches de paie) au format **PDF**.

---

##  Fonctionnalités Clés (CRUD & Modules)

### 1. Gestion Organisationnelle (CRUD)

| Entité | Description | Dossiers `webapp/` concernés |
| :--- | :--- | :--- |
| **Employés** | Création, Consultation, Modification et Suppression. | `employe/` |
| **Départements** | Gestion complète des départements de l'entreprise. | `departement/` |
| **Projets** | Suivi et mise à jour des projets en cours. | `projet/` |
| **Rôles Spécifiques** | Gestion des Chefs de Département et des Chefs de Projet. | `chefDepartement/`, `chefProjet/` |

### 2. Module Fiche de Paie

* **Calcul Automatique** des salaires, cotisations et déductions.
* Recalcul, archivage et consultation des fiches de paie passées (`ficheDePaie/`).
* **Export des fiches au format PDF** via une Servlet dédiée.

### 3. Reporting & Sécurité

* **Statistiques** : Affichage de tableaux de bord et de données agrégées dynamiques (`statistiques.jsp`).
* **Authentification** : Formulaire de connexion (`auth.jsp`) et d'inscription (`inscription.jsp`).
* **Contrôle d'Accès** : Utilisation d'un `AuthFilter` pour protéger les ressources sensibles.

---

##  Architecture du Projet : MVC et Utilisation d'Hibernate

L'application est rigoureusement organisée selon le pattern **MVC (Modèle-Vue-Contrôleur)**. La couche de persistance est implémentée avec l'**ORM Hibernate**.

| Couche | Rôle | Package (`src/main/java/com/rsv/`) | Fichiers `webapp/` |
| :--- | :--- | :--- | :--- |
| **C**ontrôleur | Logique de requête, appel métier et sélection de Vue. | `controller/` | N/A |
| **M**odèle & Métier | Classes métiers (`Employe`, `Projet`, etc.) et logique métier. | `model/`, `util/` | N/A |
| **Persistence (DAO)** | Accès et manipulation des données via **Hibernate**. | `jdbc/`, `model/` (classes DAO) | `resources/hibernate.cfg.xml` |
| **Filtres** | Gestion de la sécurité, authentification (`AuthFilter`). | `filter/` | N/A |
| **V**ue | Présentation des données à l'utilisateur. | N/A | Pages **JSP** dans `webapp/` |

---

##  Technologies et Outils

| Catégorie | Outils/Langages |
| :--- | :--- |
| **Core** | **Java 8+ (JDK)**, **Java EE** (Servlets, JSP, JSTL) |
| **Build & Déploiement** | **Maven**, Apache **Tomcat 10.1** (Serveur d'applications) |
| **Persistance** | **MySQL**, **Hibernate** (ORM/Mapping), **JDBC** |
| **Frontend** | HTML/CSS, JavaScript (dossiers `js/` et `css/`) |
| **Configuration** | **`hibernate.cfg.xml`** (Configuration de l'ORM) |

---

##  Installation et Configuration

### 1. Prérequis

Assurez-vous d'avoir installé les outils suivants :

* Java **JDK 8** ou supérieur
* **Maven 3** ou supérieur
* Serveur Apache **Tomcat 10.1**
* **MySQL 5.7** ou 8.x

### 2. Configuration de la Base de Données

1.  Créer une base de données MySQL vide.
2.  Importer le script SQL **`Base_SQL_Projet.sql`** pour créer les tables et peupler les données initiales.
3.  Modifier le fichier de configuration **`resources/hibernate.cfg.xml`** pour y inclure les identifiants de connexion MySQL corrects (URL, utilisateur, mot de passe).

### 3. Installation des Dépendances et Build

Depuis la racine du projet, utilisez Maven pour nettoyer et construire le projet :

```bash
mvn clean install
```

Cette commande télécharge les dépendances nécessaires et génère le fichier WAR (.war) de l'application dans le répertoire target/.

### 4. Déploiement
Copier le fichier .war généré dans le répertoire webapps/ de votre installation Tomcat.

Démarrer (ou redémarrer) le serveur Tomcat.

Accéder à l’application via : http://localhost:8080/ProjetJEE/

---

##  Sécurité
Le projet intègre plusieurs mécanismes de sécurité essentiels pour une application d'entreprise :

Gestion de Session : Sécurité stricte autour des sessions utilisateur pour prévenir l'usurpation.

Filtre d'Accès (AuthFilter) : Utilisation d'un filtre Servlet pour interdire l'accès aux ressources sensibles si l'utilisateur n'est pas authentifié.

Isolation des Vues : Les pages JSP critiques et les fichiers de configuration sont placés dans le répertoire sécurisé WEB-INF/, empêchant l'accès direct via l'URL.

Validation : Validation des données côté serveur pour prévenir les injections de formulaires.

---

##  Auteurs
Ce projet a été développé par l'équipe suivante :
```
David, Riyad, Yassir, Vincent, Ahmed, Rayane
```



