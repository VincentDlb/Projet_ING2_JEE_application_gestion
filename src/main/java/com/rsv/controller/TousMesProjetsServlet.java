package com.rsv.controller;

import com.rsv.bdd.*;
import com.rsv.model.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet pour gérer l'affichage de TOUS les projets d'un employé (chef + membre).
 * Accessible à tous les employés connectés.
 */
@WebServlet("/tousMesProjets")
@SuppressWarnings("serial")
public class TousMesProjetsServlet extends HttpServlet {
    
    private ProjetDAO projetDAO;
    private EmployeDAO employeDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() {
        projetDAO = new ProjetDAO();
        employeDAO = new EmployeDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Vérifier que l'utilisateur est connecté
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth?erreur=non_connecte");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "lister";
        
        try {
            switch (action) {
                case "lister":
                    listerTousMesProjets(request, response);
                    break;
                case "details":
                    afficherDetailsProjet(request, response);
                    break;
                default:
                    listerTousMesProjets(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "exception");
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
        }
    }
    
    /**
     * Liste TOUS les projets de l'employé connecté (chef + membre).
     */
    private void listerTousMesProjets(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Employe employeConnecte = getEmployeConnecte(request);
        
        if (employeConnecte == null) {
            response.sendRedirect("auth?erreur=non_connecte");
            return;
        }
        
        // Récupérer TOUS les projets (chef + membre)
        List<Projet> tousMesProjets = projetDAO.listerTousMesProjets(employeConnecte.getId());
        
        request.setAttribute("currentPage", "tousMesProjets");
        request.setAttribute("tousMesProjets", tousMesProjets);
        request.setAttribute("employeNom", employeConnecte.getNom() + " " + employeConnecte.getPrenom());
        request.setAttribute("employeId", employeConnecte.getId());
        
        request.getRequestDispatcher("/employe/tousMesProjets.jsp").forward(request, response);
    }
    
    /**
     * Affiche les détails d'un projet.
     * Vérifie que l'employé appartient bien au projet.
     */
    private void afficherDetailsProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Employe employeConnecte = getEmployeConnecte(request);
        
        if (employeConnecte == null) {
            response.sendRedirect("auth?erreur=non_connecte");
            return;
        }
        
        try {
            Integer projetId = Integer.parseInt(request.getParameter("id"));
            
            // Vérifier que l'employé appartient au projet
            if (!projetDAO.appartientAuProjet(projetId, employeConnecte.getId())) {
                request.setAttribute("erreur", "non_autorise");
                request.getRequestDispatcher("/erreur/accesRefuse.jsp").forward(request, response);
                return;
            }
            
            Projet projet = projetDAO.getProjetById(projetId);
            
            if (projet == null) {
                response.sendRedirect("tousMesProjets?erreur=projet_introuvable");
                return;
            }
            
            // Vérifier si l'employé est le chef du projet
            boolean estChef = projet.getChefDeProjet() != null && 
                             projet.getChefDeProjet().getId().equals(employeConnecte.getId());
            
            request.setAttribute("currentPage", "tousMesProjets");
            request.setAttribute("projet", projet);
            request.setAttribute("estChef", estChef);
            request.setAttribute("employeConnecte", employeConnecte);
            
            request.getRequestDispatcher("/employe/detailsProjet.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("tousMesProjets?erreur=invalid_id");
        }
    }
    
    /**
     * Récupère l'employé connecté depuis la session.
     */
    private Employe getEmployeConnecte(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return null;
        }
        
        User user = userDAO.getUserById(userId);
        return (user != null) ? user.getEmploye() : null;
    }
}