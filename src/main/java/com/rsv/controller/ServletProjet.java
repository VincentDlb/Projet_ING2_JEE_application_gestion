package com.rsv.controller;

import com.rsv.bdd.ProjetDAO;
import com.rsv.bdd.EmployeDAO;
import com.rsv.model.Projet;
import com.rsv.model.Employe;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet qui gère toutes les opérations sur les projets
 */
@WebServlet("/projets")
@SuppressWarnings("serial")
public class ServletProjet extends HttpServlet {
    
    private ProjetDAO projetDAO;
    private EmployeDAO employeDAO;
    
    @Override
    public void init() {
        projetDAO = new ProjetDAO();
        employeDAO = new EmployeDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "lister";
        
        try {
            switch (action) {
                case "lister":
                    listerProjets(request, response);
                    break;
                case "nouveau":
                    afficherFormulaireCreation(request, response);
                    break;
                case "detail":
                    afficherDetailProjet(request, response);
                    break;
                case "voirMembres":
                    afficherPageAffectation(request, response);
                    break;
                case "modifier":
                    afficherFormulaireModification(request, response);
                    break;
                case "supprimer":
                    supprimerProjet(request, response);
                    break;
                default:
                    listerProjets(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Une erreur s'est produite : " + e.getMessage());
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "creer":
                    creerProjet(request, response);
                    break;
                case "modifier":
                    modifierProjet(request, response);
                    break;
                case "ajouterEmploye":
                    ajouterEmployeAuProjet(request, response);
                    break;
                case "retirerEmploye":
                    retirerEmployeDuProjet(request, response);
                    break;
                default:
                    response.sendRedirect("projets?action=lister");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("projets?action=lister&erreur=exception");
        }
    }
    
    /**
     * Liste tous les projets
     */
    private void listerProjets(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Projet> liste = projetDAO.listerTous();
        request.setAttribute("listeProjets", liste);
        request.getRequestDispatcher("/projet/listeProjets.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de création
     */
    private void afficherFormulaireCreation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Employe> listeEmployes = employeDAO.listerTous();
        request.setAttribute("listeEmployes", listeEmployes);
        request.getRequestDispatcher("/projet/formProjet.jsp").forward(request, response);
    }
    
    /**
     * NOUVELLE MÉTHODE: Affiche les détails complets d'un projet
     */
    private void afficherDetailProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            // Récupérer le projet avec ses employés
            Projet projet = projetDAO.getProjetAvecEmployes(id);
            
            if (projet == null) {
                response.sendRedirect("projets?action=lister&erreur=projet_introuvable");
                return;
            }
            
            request.setAttribute("projet", projet);
            request.getRequestDispatcher("/projet/detailProjet.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("projets?action=lister&erreur=exception");
        }
    }
    
    /**
     * Affiche le formulaire de modification
     */
    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            Projet projet = projetDAO.getProjetById(id);
            
            if (projet == null) {
                response.sendRedirect("projets?action=lister&erreur=projet_introuvable");
                return;
            }
            
            List<Employe> listeEmployes = employeDAO.listerTous();
            
            request.setAttribute("projet", projet);
            request.setAttribute("listeEmployes", listeEmployes);
            request.getRequestDispatcher("/projet/modifierProjet.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("projets?action=lister&erreur=exception");
        }
    }
    
    /**
     * Affiche la page d'affectation des employés
     */
    private void afficherPageAffectation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            // Récupérer le projet avec ses employés
            Projet projet = projetDAO.getProjetAvecEmployes(id);
            
            if (projet == null) {
                response.sendRedirect("projets?action=lister&erreur=projet_introuvable");
                return;
            }
            
            // Récupérer tous les employés pour afficher les disponibles
            List<Employe> tousLesEmployes = employeDAO.listerTous();
            
            request.setAttribute("projet", projet);
            request.setAttribute("tousLesEmployes", tousLesEmployes);
            request.getRequestDispatcher("/projet/affecterEmployes.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("projets?action=lister&erreur=exception");
        }
    }
    
    /**
     * Crée un nouveau projet
     */
    private void creerProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            String dateDebutStr = request.getParameter("dateDebut");
            String dateFinStr = request.getParameter("dateFin");
            String etat = request.getParameter("etat");
            String chefProjetIdStr = request.getParameter("chefProjetId");
            
            if (nom == null || nom.trim().isEmpty()) {
                response.sendRedirect("projets?action=nouveau&erreur=nom_vide");
                return;
            }
            
            Projet projet = new Projet();
            projet.setNom(nom.trim());
            projet.setDescription(description != null ? description.trim() : null);
            
            // Dates
            if (dateDebutStr != null && !dateDebutStr.isEmpty()) {
                projet.setDateDebut(LocalDate.parse(dateDebutStr));
            }
            if (dateFinStr != null && !dateFinStr.isEmpty()) {
                projet.setDateFin(LocalDate.parse(dateFinStr));
            }
            
            // État
            projet.setEtat(etat != null && !etat.isEmpty() ? etat : "EN_COURS");
            
            // Chef de projet
            if (chefProjetIdStr != null && !chefProjetIdStr.isEmpty() && !chefProjetIdStr.equals("")) {
                Integer chefProjetId = Integer.parseInt(chefProjetIdStr);
                Employe chefProjet = employeDAO.getEmployeById(chefProjetId);
                projet.setChefDeProjet(chefProjet);
            }
            
            boolean success = projetDAO.ajouterProjet(projet);
            
            if (success) {
                response.sendRedirect("projets?action=lister&message=creation_ok");
            } else {
                response.sendRedirect("projets?action=nouveau&erreur=echec_creation");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("projets?action=nouveau&erreur=exception");
        }
    }
    
    /**
     * Modifie un projet existant
     */
    private void modifierProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            String dateDebutStr = request.getParameter("dateDebut");
            String dateFinStr = request.getParameter("dateFin");
            String etat = request.getParameter("etat");
            String chefProjetIdStr = request.getParameter("chefProjetId");
            
            if (nom == null || nom.trim().isEmpty()) {
                response.sendRedirect("projets?action=modifier&id=" + id + "&erreur=nom_vide");
                return;
            }
            
            Projet projet = projetDAO.getProjetById(id);
            
            if (projet == null) {
                response.sendRedirect("projets?action=lister&erreur=projet_introuvable");
                return;
            }
            
            // Mise à jour des champs
            projet.setNom(nom.trim());
            projet.setDescription(description != null ? description.trim() : null);
            
            // Dates
            if (dateDebutStr != null && !dateDebutStr.isEmpty()) {
                projet.setDateDebut(LocalDate.parse(dateDebutStr));
            } else {
                projet.setDateDebut(null);
            }
            
            if (dateFinStr != null && !dateFinStr.isEmpty()) {
                projet.setDateFin(LocalDate.parse(dateFinStr));
            } else {
                projet.setDateFin(null);
            }
            
            // État
            projet.setEtat(etat != null && !etat.isEmpty() ? etat : "EN_COURS");
            
            // Chef de projet
            if (chefProjetIdStr != null && !chefProjetIdStr.isEmpty() && !chefProjetIdStr.equals("")) {
                Integer chefProjetId = Integer.parseInt(chefProjetIdStr);
                Employe chefProjet = employeDAO.getEmployeById(chefProjetId);
                projet.setChefDeProjet(chefProjet);
            } else {
                projet.setChefDeProjet(null);
            }
            
            boolean success = projetDAO.modifierProjet(projet);
            
            if (success) {
                response.sendRedirect("projets?action=lister&message=modification_ok");
            } else {
                response.sendRedirect("projets?action=modifier&id=" + id + "&erreur=echec_modification");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("projets?action=lister&erreur=exception");
        }
    }
    
    /**
     * Ajoute un employé à un projet
     */
    private void ajouterEmployeAuProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String projetIdStr = request.getParameter("projetId");
            String employeIdStr = request.getParameter("employeId");
            
            Integer projetId = Integer.parseInt(projetIdStr);
            Integer employeId = Integer.parseInt(employeIdStr);
            
            boolean success = projetDAO.ajouterEmployeAuProjet(projetId, employeId);
            
            if (success) {
                response.sendRedirect("projets?action=voirMembres&id=" + projetId + "&message=employe_ajoute");
            } else {
                response.sendRedirect("projets?action=voirMembres&id=" + projetId + "&erreur=echec_ajout");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("projets?action=lister&erreur=exception");
        }
    }
    
    /**
     * Retire un employé d'un projet
     */
    private void retirerEmployeDuProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String projetIdStr = request.getParameter("projetId");
            String employeIdStr = request.getParameter("employeId");
            
            Integer projetId = Integer.parseInt(projetIdStr);
            Integer employeId = Integer.parseInt(employeIdStr);
            
            boolean success = projetDAO.retirerEmployeDuProjet(projetId, employeId);
            
            if (success) {
                response.sendRedirect("projets?action=voirMembres&id=" + projetId + "&message=employe_retire");
            } else {
                response.sendRedirect("projets?action=voirMembres&id=" + projetId + "&erreur=echec_retrait");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("projets?action=lister&erreur=exception");
        }
    }
    
    /**
     * Supprime un projet
     */
    private void supprimerProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            boolean success = projetDAO.supprimerProjet(id);
            
            if (success) {
                response.sendRedirect("projets?action=lister&message=suppression_ok");
            } else {
                response.sendRedirect("projets?action=lister&erreur=echec_suppression");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("projets?action=lister&erreur=exception");
        }
    }
}