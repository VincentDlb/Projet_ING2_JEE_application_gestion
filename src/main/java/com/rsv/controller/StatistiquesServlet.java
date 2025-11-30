package com.rsv.controller;

import com.rsv.bdd.StatistiquesDAO;
import com.rsv.model.Statistiques;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet de gestion des statistiques et rapports.
 * 
 * @author RowTech Team
 * @version 1.0
 */
@WebServlet("/statistiques")
public class StatistiquesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private StatistiquesDAO statistiquesDAO;
    
    /**
     * Initialisation du servlet.
     */
    @Override
    public void init() {
        statistiquesDAO = new StatistiquesDAO();
    }
    
    /**
     * Gère les requêtes GET.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "afficher";
        }
        
        switch (action) {
            case "afficher":
                afficherStatistiques(request, response);
                break;
            case "departement":
                afficherStatistiquesDepartement(request, response);
                break;
            case "projet":
                afficherStatistiquesProjet(request, response);
                break;
            default:
                afficherStatistiques(request, response);
                break;
        }
    }
    
    /**
     * Affiche les statistiques globales.
     */
    private void afficherStatistiques(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer toutes les statistiques
            Statistiques stats = statistiquesDAO.getStatistiquesGlobales();
            
            // Passer les statistiques à la JSP
            request.setAttribute("statistiques", stats);
            
            // Forwarding vers la page JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/statistiques.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors du chargement des statistiques");
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
        }
    }
    
    /**
     * Affiche les statistiques d'un département spécifique.
     */
    private void afficherStatistiquesDepartement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect("statistiques?action=afficher");
                return;
            }
            
            Integer departementId = Integer.parseInt(idParam);
            var stats = statistiquesDAO.getStatistiquesDepartement(departementId);
            
            request.setAttribute("statsDepartement", stats);
            request.setAttribute("departementId", departementId);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/statistiques_departement.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("statistiques?action=afficher&erreur=format_invalide");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors du chargement des statistiques du département");
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
        }
    }
    
    /**
     * Affiche les statistiques d'un projet spécifique.
     */
    private void afficherStatistiquesProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect("statistiques?action=afficher");
                return;
            }
            
            Integer projetId = Integer.parseInt(idParam);
            var stats = statistiquesDAO.getStatistiquesProjet(projetId);
            
            request.setAttribute("statsProjet", stats);
            request.setAttribute("projetId", projetId);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/statistiques_projet.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("statistiques?action=afficher&erreur=format_invalide");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors du chargement des statistiques du projet");
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
        }
    }
}