package com.rsv.controller;

import com.rsv.bdd.FicheDePaieDAO;
import com.rsv.model.FicheDePaie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet temporaire pour recalculer toutes les fiches de paie existantes
 * À EXÉCUTER UNE SEULE FOIS après la migration SQL
 */
@WebServlet("/admin/recalculerFiches")
public class RecalculerFichesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html; charset=UTF-8");
        
        try {
            FicheDePaieDAO ficheDAO = new FicheDePaieDAO();
            List<FicheDePaie> fiches = ficheDAO.listerToutesLesFiches();
            
            int count = 0;
            StringBuilder log = new StringBuilder();
            log.append("<html><head><title>Recalcul des fiches</title></head><body>");
            log.append("<h1>Recalcul des fiches de paie</h1>");
            log.append("<p>Début du traitement...</p><ul>");
            
            for (FicheDePaie fiche : fiches) {
                double ancienNet = fiche.getNetAPayer();
                
                // Recalculer avec les cotisations sociales
                fiche.calculerTout();
                
                // Sauvegarder
                ficheDAO.modifierFicheDePaie(fiche);
                
                double nouveauNet = fiche.getNetAPayer();
                
                log.append("<li>Fiche #" + fiche.getId() + " - " + 
                          fiche.getEmploye().getNom() + " " + fiche.getEmploye().getPrenom() +
                          " : " + String.format("%.2f", ancienNet) + " € → " + 
                          String.format("%.2f", nouveauNet) + " €</li>");
                
                count++;
            }
            
            log.append("</ul>");
            log.append("<p><strong>✅ " + count + " fiches recalculées avec succès !</strong></p>");
            log.append("<p><a href='" + request.getContextPath() + "/ficheDePaie'>Retour aux fiches de paie</a></p>");
            log.append("</body></html>");
            
            response.getWriter().write(log.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<html><body>");
            response.getWriter().write("<h1>❌ Erreur lors du recalcul</h1>");
            response.getWriter().write("<p>" + e.getMessage() + "</p>");
            response.getWriter().write("</body></html>");
        }
    }
}