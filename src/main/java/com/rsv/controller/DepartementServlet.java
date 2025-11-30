package com.rsv.controller;

import com.rsv.bdd.DepartementDAO;
import com.rsv.bdd.EmployeDAO;
import com.rsv.model.Departement;
import com.rsv.model.Employe;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet qui gère toutes les opérations sur les départements.
 * Version 2.0 avec gestion du chef de département.
 * Architecture MVC : Ce servlet agit comme contrôleur
 * 
 * @author RowTech Team
 * @version 2.0
 */
@WebServlet("/departements")
@SuppressWarnings("serial")
public class DepartementServlet extends HttpServlet {
    
    // DAO pour accéder aux données des départements et employés
    private DepartementDAO departementDAO;
    private EmployeDAO employeDAO;
    
    /**
     * Initialisation du servlet : création des DAO
     */
    @Override
    public void init() {
        departementDAO = new DepartementDAO();
        employeDAO = new EmployeDAO();
    }
    
    /**
     * Traitement des requêtes GET (affichage, lecture)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération du paramètre action pour déterminer l'opération à effectuer
        String action = request.getParameter("action");
        if (action == null) action = "lister";
        
        try {
            // Switch pour diriger vers la bonne méthode selon l'action demandée
            switch (action) {
                case "lister":
                    listerDepartements(request, response);
                    break;
                case "nouveau":
                    afficherFormulaireAjout(request, response);
                    break;
                case "modifier":
                    afficherFormulaireModification(request, response);
                    break;
                case "supprimer":
                    supprimerDepartement(request, response);
                    break;
                case "voirMembres":
                    voirMembres(request, response);
                    break;
                default:
                    listerDepartements(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Une erreur s'est produite : " + e.getMessage());
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
        }
    }
    
    /**
     * Traitement des requêtes POST (ajout, modification)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("ajouter".equals(action)) {
            ajouterDepartement(request, response);
        } else if ("modifier".equals(action)) {
            modifierDepartement(request, response);
        } else {
            response.sendRedirect("departements?action=lister");
        }
    }
    
    /**
     * Liste tous les départements
     */
    private void listerDepartements(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération de la liste complète des départements depuis la base de données
        List<Departement> liste = departementDAO.listerTous();
        
        // Transmission de la liste à la JSP via l'attribut de requête
        request.setAttribute("listeDepartements", liste);
        request.getRequestDispatcher("/departement/listeDepartements.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire d'ajout d'un département.
     * AMÉLIORATION : Charge la liste des employés pour sélection du chef.
     */
    private void afficherFormulaireAjout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Charger tous les employés pour le select du chef
        List<Employe> listeEmployes = employeDAO.listerTous();
        request.setAttribute("listeEmployes", listeEmployes);
        
        request.getRequestDispatcher("/departement/formDepartement.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de modification d'un département.
     * AMÉLIORATION : Charge la liste des employés pour sélection du chef.
     */
    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            // Récupération du département à modifier
            Departement departement = departementDAO.getDepartementById(id);
            
            if (departement == null) {
                response.sendRedirect("departements?action=lister&erreur=departement_introuvable");
                return;
            }
            
            // Charger tous les employés pour le select du chef
            List<Employe> listeEmployes = employeDAO.listerTous();
            
            request.setAttribute("departement", departement);
            request.setAttribute("listeEmployes", listeEmployes);
            request.getRequestDispatcher("/departement/formDepartement.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("departements?action=lister&erreur=exception");
        }
    }
    
    /**
     * Ajoute un nouveau département.
     * AMÉLIORATION : Gère la sélection du chef de département.
     */
    private void ajouterDepartement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupération des données du formulaire
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            String chefIdStr = request.getParameter("chefDepartementId");
            
            // Validation basique
            if (nom == null || nom.trim().isEmpty()) {
                response.sendRedirect("departements?action=nouveau&erreur=nom_vide");
                return;
            }
            
            // Création de l'objet Departement
            Departement departement = new Departement();
            departement.setNom(nom.trim());
            departement.setDescription(description != null ? description.trim() : null);
            
            // NOUVEAU : Gestion du chef de département
            if (chefIdStr != null && !chefIdStr.trim().isEmpty() && !"".equals(chefIdStr)) {
                try {
                    Integer chefId = Integer.parseInt(chefIdStr);
                    Employe chef = employeDAO.getEmployeById(chefId);
                    
                    if (chef != null) {
                        departement.setChefDepartement(chef);
                        System.out.println("✅ Chef de département désigné : " + chef.getPrenom() + " " + chef.getNom());
                    }
                } catch (NumberFormatException e) {
                    System.out.println("⚠️ ID de chef invalide : " + chefIdStr);
                }
            }
            
            // Sauvegarde dans la base de données
            boolean success = departementDAO.ajouterDepartement(departement);
            
            if (success) {
                response.sendRedirect("departements?action=lister&message=ajout_ok");
            } else {
                response.sendRedirect("departements?action=nouveau&erreur=echec_ajout");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("departements?action=nouveau&erreur=exception");
        }
    }
    
    /**
     * Modifie un département existant.
     * AMÉLIORATION : Gère la modification du chef de département.
     */
    private void modifierDepartement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            // Récupération du département à modifier
            Departement departement = departementDAO.getDepartementById(id);
            
            if (departement == null) {
                response.sendRedirect("departements?action=lister&erreur=departement_introuvable");
                return;
            }
            
            // Mise à jour des champs
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            String chefIdStr = request.getParameter("chefDepartementId");
            
            if (nom == null || nom.trim().isEmpty()) {
                response.sendRedirect("departements?action=modifier&id=" + id + "&erreur=nom_vide");
                return;
            }
            
            departement.setNom(nom.trim());
            departement.setDescription(description != null ? description.trim() : null);
            
            // NOUVEAU : Gestion du chef de département
            if (chefIdStr != null && !chefIdStr.trim().isEmpty()) {
                if ("aucun".equals(chefIdStr) || "".equals(chefIdStr)) {
                    // Retirer le chef
                    departement.setChefDepartement(null);
                    System.out.println("🗑️ Chef de département retiré");
                } else {
                    try {
                        Integer chefId = Integer.parseInt(chefIdStr);
                        Employe chef = employeDAO.getEmployeById(chefId);
                        
                        if (chef != null) {
                            departement.setChefDepartement(chef);
                            System.out.println("✅ Chef de département modifié : " + chef.getPrenom() + " " + chef.getNom());
                        }
                    } catch (NumberFormatException e) {
                        System.out.println("⚠️ ID de chef invalide : " + chefIdStr);
                    }
                }
            }
            
            // Sauvegarde
            boolean success = departementDAO.modifierDepartement(departement);
            
            if (success) {
                response.sendRedirect("departements?action=lister&message=modification_ok");
            } else {
                response.sendRedirect("departements?action=modifier&id=" + id + "&erreur=echec_modification");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("departements?action=lister&erreur=exception");
        }
    }
    
    /**
     * Supprime un département
     */
    private void supprimerDepartement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            boolean success = departementDAO.supprimerDepartement(id);
            
            if (success) {
                response.sendRedirect("departements?action=lister&message=suppression_ok");
            } else {
                response.sendRedirect("departements?action=lister&erreur=echec_suppression");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("departements?action=lister&erreur=exception");
        }
    }
    
    /**
     * Affiche les membres d'un département
     */
    private void voirMembres(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupération de l'ID du département depuis l'URL
            String idStr = request.getParameter("id");
            Integer departementId = Integer.parseInt(idStr);
            
            // Récupération du département depuis la base de données
            Departement departement = departementDAO.getDepartementById(departementId);
            
            if (departement == null) {
                // Si le département n'existe pas, redirection avec message d'erreur
                response.sendRedirect("departements?action=lister&erreur=departement_introuvable");
                return;
            }
            
            // Récupération de tous les employés appartenant à ce département
            List<Employe> membres = employeDAO.listerParDepartement(departementId);
            
            // Transmission des données à la JSP
            request.setAttribute("departement", departement);
            request.setAttribute("membres", membres);
            
            // Forward vers la page d'affichage des membres
            request.getRequestDispatcher("/departement/viewMembres.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Gestion des erreurs de conversion (ID invalide)
            e.printStackTrace();
            response.sendRedirect("departements?action=lister&erreur=id_invalide");
        } catch (Exception e) {
            // Gestion des autres erreurs
            e.printStackTrace();
            response.sendRedirect("departements?action=lister&erreur=exception");
        }
    }
}