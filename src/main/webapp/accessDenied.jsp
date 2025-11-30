<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
    if (errorMessage == null) {
        errorMessage = "Vous n'avez pas l'autorisation d'accéder à cette ressource.";
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accès Refusé - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🚫 Accès Refusé</h1>
            <p>RowTech - Gestion RH</p>
        </header>

        <div class="content" style="max-width: 700px; margin: 60px auto;">
            
            <!-- Message d'erreur -->
            <div style="text-align: center; padding: 60px 40px; background: var(--dark-light); border-radius: 16px; border: 2px solid #dc2626;">
                <div style="font-size: 100px; margin-bottom: 30px; opacity: 0.5;">🚫</div>
                
                <h2 style="color: var(--text-primary); margin-bottom: 20px;">
                    Accès Refusé
                </h2>
                
                <p style="color: var(--text-secondary); font-size: 1.1rem; margin-bottom: 30px;">
                    <%= errorMessage %>
                </p>
                
                <% if (nomComplet != null) { %>
                <div style="padding: 20px; background: rgba(220, 38, 38, 0.1); border-radius: 8px; margin-bottom: 30px;">
                    <p style="color: var(--text-muted); margin: 0;">
                        <strong>Utilisateur :</strong> <%= nomComplet %><br>
                        <strong>Rôle :</strong> <%= userRole %>
                    </p>
                </div>
                <% } %>
                
                <div style="display: flex; gap: 15px; justify-content: center; flex-wrap: wrap;">
                    <a href="<%= request.getContextPath() %>/accueil.jsp" class="btn btn-primary">
                        🏠 Retour à l'accueil
                    </a>
                    
                    <a href="javascript:history.back()" class="btn btn-secondary">
                        ← Retour
                    </a>
                </div>
            </div>

            <!-- Informations sur les permissions -->
            <div style="margin-top: 40px; padding: 25px; background: rgba(59, 130, 246, 0.1); border-radius: 12px; border: 1px solid rgba(59, 130, 246, 0.3);">
                <h3 style="color: var(--text-primary); margin-bottom: 15px;">
                    ℹ️ Vos permissions
                </h3>
                
                <% if ("ADMINISTRATEUR".equals(userRole)) { %>
                    <p style="color: var(--text-secondary); margin: 0;">
                        En tant qu'<strong>Administrateur</strong>, vous avez accès à toutes les fonctionnalités du système.
                    </p>
                <% } else if ("CHEF_DEPARTEMENT".equals(userRole)) { %>
                    <p style="color: var(--text-secondary); margin: 0;">
                        En tant que <strong>Chef de Département</strong>, vous pouvez :
                    </p>
                    <ul style="color: var(--text-muted); margin-top: 10px;">
                        <li>Gérer les employés de votre département</li>
                        <li>Créer et consulter les fiches de paie</li>
                        <li>Consulter les statistiques</li>
                    </ul>
                <% } else if ("CHEF_PROJET".equals(userRole)) { %>
                    <p style="color: var(--text-secondary); margin: 0;">
                        En tant que <strong>Chef de Projet</strong>, vous pouvez :
                    </p>
                    <ul style="color: var(--text-muted); margin-top: 10px;">
                        <li>Gérer vos projets</li>
                        <li>Affecter des employés aux projets</li>
                        <li>Consulter les statistiques</li>
                    </ul>
                <% } else if ("EMPLOYE".equals(userRole)) { %>
                    <p style="color: var(--text-secondary); margin: 0;">
                        En tant qu'<strong>Employé</strong>, vous pouvez uniquement :
                    </p>
                    <ul style="color: var(--text-muted); margin-top: 10px;">
                        <li>Consulter vos propres fiches de paie</li>
                    </ul>
                    <p style="color: var(--text-muted); margin-top: 15px; font-size: 0.9rem;">
                        Pour toute demande, contactez votre responsable ou le service RH.
                    </p>
                <% } %>
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>