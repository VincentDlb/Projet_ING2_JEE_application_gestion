package com.rsv.util;

import jakarta.servlet.http.HttpSession;

/**
 * Classe utilitaire pour gérer les permissions selon les rôles.
 *
 * @author RowTech Team
 * @version 2.0
 */
public class RoleHelper {
    
    // Constantes pour les rôles
    public static final String ROLE_ADMIN = "ADMINISTRATEUR";
    public static final String ROLE_CHEF_DEPT = "CHEF_DEPARTEMENT";
    public static final String ROLE_CHEF_PROJET = "CHEF_PROJET";
    public static final String ROLE_EMPLOYE = "EMPLOYE";
    
    // =========================================================================
    // MÉTHODES DE VÉRIFICATION DE RÔLE
    // =========================================================================
    
    /**
     * Vérifie si l'utilisateur est administrateur
     */
    public static boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return ROLE_ADMIN.equals(role);
    }
    
    /**
     * Vérifie si l'utilisateur est chef de département
     */
    public static boolean isChefDepartement(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return ROLE_CHEF_DEPT.equals(role);
    }
    
    /**
     * Vérifie si l'utilisateur est chef de projet
     */
    public static boolean isChefProjet(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return ROLE_CHEF_PROJET.equals(role);
    }
    
    /**
     * Vérifie si l'utilisateur est un employé simple
     */
    public static boolean isEmploye(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return ROLE_EMPLOYE.equals(role);
    }
    
    /**
     * Vérifie si l'utilisateur est un chef (département ou projet)
     */
    public static boolean isChef(HttpSession session) {
        return isChefDepartement(session) || isChefProjet(session);
    }
    
    // =========================================================================
    // PERMISSIONS POUR LA GESTION DES EMPLOYÉS
    // =========================================================================
    
    /**
     * Vérifie si l'utilisateur peut gérer tous les employés (CRUD complet)
     * Seul l'admin peut gérer tous les employés
     */
    public static boolean canManageAllEmployes(HttpSession session) {
        return isAdmin(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut voir la liste des employés
     * Admin et Chef de département peuvent voir les employés
     */
    public static boolean canManageEmployes(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session);
    }
    
    // =========================================================================
    // PERMISSIONS POUR LES DÉPARTEMENTS
    // =========================================================================
    
    /**
     * Vérifie si l'utilisateur peut gérer tous les départements (CRUD complet)
     * Seul l'admin peut créer/supprimer des départements
     */
    public static boolean canManageDepartements(HttpSession session) {
        return isAdmin(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut voir son propre département
     * Tous les utilisateurs connectés peuvent voir leur département
     */
    public static boolean canViewOwnDepartement(HttpSession session) {
        return session.getAttribute("userRole") != null;
    }
    
    /**
     * Vérifie si l'utilisateur peut modifier son département
     * Seuls Admin et Chef de département peuvent modifier
     */
    public static boolean canEditOwnDepartement(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session);
    }
    
    // =========================================================================
    // PERMISSIONS POUR LES PROJETS
    // =========================================================================
    
    /**
     * Vérifie si l'utilisateur peut gérer tous les projets (CRUD complet)
     * Admin peut tout faire, Chef de projet peut gérer ses projets
     */
    public static boolean canManageProjets(HttpSession session) {
        return isAdmin(session) || isChefProjet(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut voir ses propres projets
     * Tous les utilisateurs connectés peuvent voir leurs projets
     */
    public static boolean canViewOwnProjets(HttpSession session) {
        return session.getAttribute("userRole") != null;
    }
    
    /**
     * Vérifie si l'utilisateur peut créer des projets
     * Seul l'admin peut créer des projets
     */
    public static boolean canCreateProjets(HttpSession session) {
        return isAdmin(session);
    }
    
    // =========================================================================
    // PERMISSIONS POUR LES FICHES DE PAIE
    // =========================================================================
    
    /**
     * Vérifie si l'utilisateur peut créer des fiches de paie
     * Admin et Chef de département peuvent créer des fiches
     */
    public static boolean canCreateFichesPaie(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session) || isChefProjet(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut voir toutes les fiches de paie
     * Seul l'admin peut voir TOUTES les fiches
     */
    public static boolean canViewAllFichesPaie(HttpSession session) {
        return isAdmin(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut voir les fiches de son équipe
     * Admin, Chef département et Chef projet peuvent voir les fiches de leur équipe
     */
    public static boolean canViewTeamFichesPaie(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session) || isChefProjet(session);
    }
    
    /**
     * Vérifie si l'utilisateur peut rechercher des fiches
     * Admin, Chef département et Chef projet peuvent rechercher
     */
    public static boolean canSearchFichesPaie(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session) || isChefProjet(session);
    }
    
    // =========================================================================
    // PERMISSIONS POUR LES STATISTIQUES
    // =========================================================================
    
    /**
     * Vérifie si l'utilisateur peut voir les statistiques
     * Admin, Chef département et Chef projet peuvent voir les stats
     */
    public static boolean canViewStatistics(HttpSession session) {
        return isAdmin(session) || isChefDepartement(session) || isChefProjet(session);
    }
    
    // =========================================================================
    // MÉTHODES UTILITAIRES
    // =========================================================================
    
    /**
     * Récupère l'ID de l'employé connecté depuis la session
     */
    public static Integer getEmployeIdFromSession(HttpSession session) {
        return (Integer) session.getAttribute("employeId");
    }
    
    /**
     * Récupère l'ID de l'utilisateur connecté depuis la session
     */
    public static Integer getUserIdFromSession(HttpSession session) {
        return (Integer) session.getAttribute("userId");
    }
    
    /**
     * Récupère le rôle de l'utilisateur depuis la session
     */
    public static String getUserRole(HttpSession session) {
        return (String) session.getAttribute("userRole");
    }
    
    /**
     * Vérifie si l'utilisateur est connecté
     */
    public static boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("userId") != null;
    }
}