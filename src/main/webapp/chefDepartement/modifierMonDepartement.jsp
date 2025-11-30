<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    String erreur = request.getParameter("erreur");
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Mon Département - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>✏️ Modifier Mon Département</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            <a href="<%= request.getContextPath() %>/monDepartement?action=afficher" class="active">🏛️ Mon Département</a>
            <a href="<%= request.getContextPath() %>/mesProjets?action=lister">📁 Mes Projets</a>
            <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
            
            <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                 <%= nomComplet %> (<%= userRole %>)
            </span>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                 Déconnexion
            </a>
        </nav>

        <div class="content">
            <h2 class="page-title">✏️ Modifier : <%= departement.getNom() %></h2>
            
            <% if (erreur != null) { %>
                <div class="alert alert-danger">⚠️ Erreur : <%= erreur %></div>
            <% } %>

            <div class="card" style="max-width: 600px; margin: 0 auto;">
                <form action="<%= request.getContextPath() %>/monDepartement" method="post">
                    <input type="hidden" name="action" value="modifier">
                    <input type="hidden" name="id" value="<%= departement.getId() %>">
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label for="nom" style="display: block; color: var(--text-secondary); margin-bottom: 8px; font-weight: 600;">
                            Nom du département
                        </label>
                        <input type="text" 
                               id="nom" 
                               value="<%= departement.getNom() %>" 
                               disabled
                               style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--border); background: var(--dark); color: var(--text-muted);">
                        <small style="color: var(--text-muted);">Le nom ne peut être modifié que par un administrateur.</small>
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label for="description" style="display: block; color: var(--text-secondary); margin-bottom: 8px; font-weight: 600;">
                            Description
                        </label>
                        <textarea id="description" 
                                  name="description" 
                                  rows="5"
                                  style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--border); background: var(--dark-light); color: var(--text-primary); resize: vertical;"><%= departement.getDescription() != null ? departement.getDescription() : "" %></textarea>
                    </div>
                    
                    <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 30px;">
                        <a href="<%= request.getContextPath() %>/monDepartement?action=afficher" class="btn btn-secondary">
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
