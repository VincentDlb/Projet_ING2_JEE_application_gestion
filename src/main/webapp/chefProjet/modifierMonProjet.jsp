<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    String erreur = request.getParameter("erreur");
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Mon Projet - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1> Modifier Mon Projet</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
            <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="active">📁 Mes Projets</a>
            <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
            
            <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                 <%= nomComplet %> (<%= userRole %>)
            </span>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                 Déconnexion
            </a>
        </nav>

        <div class="content">
            <h2 class="page-title">✏️ Modifier : <%= projet.getNom() %></h2>
            
            <% if (erreur != null) { %>
                <div class="alert alert-danger">⚠️ Erreur : <%= erreur %></div>
            <% } %>

            <div class="card" style="max-width: 700px; margin: 0 auto;">
                <form action="<%= request.getContextPath() %>/mesProjets" method="post">
                    <input type="hidden" name="action" value="modifier">
                    <input type="hidden" name="id" value="<%= projet.getId() %>">
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label for="nom" style="display: block; color: var(--text-secondary); margin-bottom: 8px; font-weight: 600;">
                            Nom du projet *
                        </label>
                        <input type="text" 
                               id="nom" 
                               name="nom"
                               value="<%= projet.getNom() %>" 
                               required
                               style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--border); background: var(--dark-light); color: var(--text-primary);">
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label for="description" style="display: block; color: var(--text-secondary); margin-bottom: 8px; font-weight: 600;">
                            Description
                        </label>
                        <textarea id="description" 
                                  name="description" 
                                  rows="4"
                                  style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--border); background: var(--dark-light); color: var(--text-primary); resize: vertical;"><%= projet.getDescription() != null ? projet.getDescription() : "" %></textarea>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                        <div class="form-group">
                            <label for="dateDebut" style="display: block; color: var(--text-secondary); margin-bottom: 8px; font-weight: 600;">
                                Date de début
                            </label>
                            <input type="date" 
                                   id="dateDebut" 
                                   name="dateDebut"
                                   value="<%= projet.getDateDebut() != null ? projet.getDateDebut().toString() : "" %>" 
                                   style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--border); background: var(--dark-light); color: var(--text-primary);">
                        </div>
                        
                        <div class="form-group">
                            <label for="dateFin" style="display: block; color: var(--text-secondary); margin-bottom: 8px; font-weight: 600;">
                                Date de fin
                            </label>
                            <input type="date" 
                                   id="dateFin" 
                                   name="dateFin"
                                   value="<%= projet.getDateFin() != null ? projet.getDateFin().toString() : "" %>" 
                                   style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--border); background: var(--dark-light); color: var(--text-primary);">
                        </div>
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label for="etat" style="display: block; color: var(--text-secondary); margin-bottom: 8px; font-weight: 600;">
                            État du projet
                        </label>
                        <select id="etat" 
                                name="etat"
                                style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--border); background: var(--dark-light); color: var(--text-primary);">
                            <option value="EN_COURS" <%= "EN_COURS".equals(projet.getEtat()) ? "selected" : "" %>>🔵 En cours</option>
                            <option value="TERMINE" <%= "TERMINE".equals(projet.getEtat()) ? "selected" : "" %>>✅ Terminé</option>
                            <option value="ANNULE" <%= "ANNULE".equals(projet.getEtat()) ? "selected" : "" %>>❌ Annulé</option>
                        </select>
                    </div>
                    
                    <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 30px;">
                        <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="btn btn-secondary">
                            Annuler
                        </a>
                        <button type="submit" class="btn btn-primary">
                             Enregistrer
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
