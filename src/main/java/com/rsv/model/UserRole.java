package com.rsv.model;

/**
 * Énumération des rôles utilisateur dans le système.
 * Définit les différents niveaux d'accès et permissions.
 * 
 * @author RowTech Team
 * @version 1.0
 */
public enum UserRole {
    
    /**
     * Administrateur - Accès complet au système
     */
    ADMIN("Administrateur", "Accès complet au système"),
    
    /**
     * Chef de département - Gestion d'un département
     */
    CHEF_DEPARTEMENT("Chef de Département", "Gestion d'un département spécifique"),
    
    /**
     * Chef de projet - Gestion d'un ou plusieurs projets
     */
    CHEF_PROJET("Chef de Projet", "Gestion de projets spécifiques"),
    
    /**
     * Employé - Accès basique
     */
    EMPLOYE("Employé", "Consultation de ses propres données");

    private final String displayName;
    private final String description;

    /**
     * Constructeur de l'énumération.
     * 
     * @param displayName Nom d'affichage du rôle
     * @param description Description du rôle
     */
    UserRole(String displayName, String description) {
        this.displayName = displayName;
        this.description = description;
    }

    /**
     * Retourne le nom d'affichage du rôle.
     * 
     * @return Le nom d'affichage
     */
    public String getDisplayName() {
        return displayName;
    }

    /**
     * Retourne la description du rôle.
     * 
     * @return La description
     */
    public String getDescription() {
        return description;
    }

    /**
     * Vérifie si le rôle a les privilèges d'administration.
     * 
     * @return true si c'est un administrateur
     */
    public boolean isAdmin() {
        return this == ADMIN;
    }

    /**
     * Vérifie si le rôle a des privilèges de gestion (Chef département ou projet).
     * 
     * @return true si c'est un chef
     */
    public boolean isChef() {
        return this == CHEF_DEPARTEMENT || this == CHEF_PROJET;
    }

    /**
     * Retourne le rôle à partir d'une chaîne de caractères.
     * Gère les différentes variantes comme ADMINISTRATEUR -> ADMIN
     * 
     * @param role La chaîne représentant le rôle
     * @return Le UserRole correspondant, ou EMPLOYE par défaut
     */
    public static UserRole fromString(String role) {
        if (role == null) {
            return EMPLOYE;
        }
        
        String roleUpper = role.toUpperCase().trim();
        
        // Gérer les alias courants
        switch (roleUpper) {
            case "ADMIN":
            case "ADMINISTRATEUR":
            case "ADMINISTRATOR":
                return ADMIN;
            case "CHEF_DEPARTEMENT":
            case "CHEF_DEPT":
            case "CHEFDEPARTEMENT":
                return CHEF_DEPARTEMENT;
            case "CHEF_PROJET":
            case "CHEFPROJET":
                return CHEF_PROJET;
            case "EMPLOYE":
            case "EMPLOYEE":
                return EMPLOYE;
            default:
                // Tenter la conversion directe
                try {
                    return UserRole.valueOf(roleUpper);
                } catch (IllegalArgumentException e) {
                    return EMPLOYE;
                }
        }
    }
}