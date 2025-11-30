<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aucun Département - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🏛️ Mon Département</h1>
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
            <div style="text-align: center; padding: 80px 20px;">
                <div style="font-size: 100px; margin-bottom: 30px; opacity: 0.5;"></div>
                <h2 style="color: var(--text-primary); margin-bottom: 15px;">Aucun département assigné</h2>
                <p style="color: var(--text-muted); margin-bottom: 30px; max-width: 500px; margin-left: auto; margin-right: auto;">
                    Vous n'êtes actuellement assigné à aucun département. 
                    Veuillez contacter votre administrateur ou service RH pour être affecté à un département.
                </p>
                <a href="<%= request.getContextPath() %>/accueil.jsp" class="btn btn-primary">
                    ← Retour à l'accueil
                </a>
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
