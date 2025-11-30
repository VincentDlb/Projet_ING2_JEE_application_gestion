# Gestion RH JEE

Ce projet fournit une application web JEE complète pour la gestion des ressources humaines : employés, départements, projets et fiches de paie.

## Périmètre fonctionnel
- Authentification avec rôles stockés sur l'entité `Employee`.
- Tableau de bord synthétique après connexion.
- CRUD complet pour les départements, employés, projets et fiches de paie.
- Affectation d'un employé à un département et à plusieurs projets.
- Calcul automatique du net à payer (salaire + primes – déductions) via les callbacks JPA.
- Recherche des employés par mot-clé et filtrage des fiches de paie par période.

## Démarrage rapide
1. Créez la base de données MySQL à l'aide du script [`WebContent/assets/sql/schema.sql`](WebContent/assets/sql/schema.sql) puis ajustez les identifiants dans `src/hibernate.cfg.xml`.
2. Importez le projet comme **Dynamic Web Project** (module 6.0) dans Eclipse et ajoutez les dépendances Hibernate 6/JPA, le connecteur MySQL et Jakarta Standard Tag Library (JSTL 3.0).
3. Déployez sur Apache Tomcat 10.1 avec Java 17.
4. Accédez à `http://localhost:8080/<contexte>/login` pour vous connecter.

Des comptes peuvent être insérés manuellement dans la base (le mot de passe est stocké en clair pour simplifier la démonstration, pensez à le sécuriser avant toute mise en production).
