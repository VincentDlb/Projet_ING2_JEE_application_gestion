<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Projet" %>


<%@ page import="com.rsv.util.RoleHelper" %>
<%boolean isAdmin = RoleHelper.isAdmin(session);
boolean isChefDept = RoleHelper.isChefDepartement(session);
boolean isChefProjet = RoleHelper.isChefProjet(session);
boolean isEmploye = RoleHelper.isEmploye(session);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Projets - RowTech</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Header -->
        <header class="app-header">
            <h1>📁 Gestion des Projets</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <!-- Navigation -->
        <nav class="nav-menu">
            <a href="accueil.jsp">🏠 Accueil</a>
            
            <% if (RoleHelper.canManageEmployes(session)) { %>
                <a href="employes?action=lister">👥 Employés</a>
            <% } %>
            
            <% if (RoleHelper.canManageDepartements(session)) { %>
                <a href="departements?action=lister">🏛️ Départements</a>
            <% } %>
            
            <% if (RoleHelper.isChefDepartement(session)) { %>
                <a href="monDepartement?action=afficher">🏛️ Mon Département</a>
            <% } %>
            
            <a href="projets?action=lister" class="active">📁 Projets</a>
            <a href="fichesDePaie?action=lister">💰 Fiches de Paie</a>
            
            <% if (RoleHelper.canViewStatistics(session)) { %>
                <a href="statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <%
                String nomComplet = (String) session.getAttribute("nomComplet");
                String userRole = (String) session.getAttribute("userRole");
                
                if (nomComplet != null) {
            %>
                <span style="color: var(--text-light); margin-left: auto; padding: 10px;">
                     <%= nomComplet %> (<%= userRole %>)
                </span>
                <a href="auth?action=logout" style="background: var(--danger);"> Déconnexion</a>
            <%
                } else {
            %>
                <a href="auth.jsp"> Connexion</a>
            <%
                }
            %>
        </nav>

        <!-- Contenu -->
        <div class="content">
            <%
                String message = request.getParameter("message");
                String erreur = request.getParameter("erreur");
                
                if ("creation_ok".equals(message)) {
            %>
                <div class="alert alert-success">✅ Projet créé avec succès !</div>
            <%
                } else if ("modification_ok".equals(message)) {
            %>
                <div class="alert alert-success">✅ Projet modifié avec succès !</div>
            <%
                } else if ("suppression_ok".equals(message)) {
            %>
                <div class="alert alert-success">✅ Projet supprimé avec succès !</div>
            <%
                } else if ("affectation_ok".equals(message)) {
            %>
                <div class="alert alert-success">✅ Employés affectés avec succès !</div>
            <%
                } else if (erreur != null) {
            %>
                <div class="alert alert-danger">⚠️ Erreur : <%= erreur %></div>
            <%
                }
            %>

            <div class="actions" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--spacing-lg);">
                <h2 class="page-title"> Liste des Projets</h2>
                <div style="display: flex; gap: 10px;">
                    <% if (RoleHelper.isAdmin(session) || RoleHelper.isChefProjet(session)) { %>
                        <a href="projets?action=nouveau" class="btn btn-primary">➕ Nouveau Projet</a>
                    <% } %>
                </div>
            </div>

            <%
                List<Projet> listeProjets = (List<Projet>) request.getAttribute("listeProjets");
                
                if (listeProjets != null && !listeProjets.isEmpty()) {
            %>
            
            <div class="table-container" style="background: var(--dark-light); border-radius: 16px; padding: var(--spacing-lg); border: 2px solid var(--border); overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%); color: white;">
                            <th style="padding: 15px; text-align: left; border-bottom: 2px solid var(--border); font-weight: 700;">NOM DU PROJET</th>
                            <th style="padding: 15px; text-align: left; border-bottom: 2px solid var(--border); font-weight: 700;">DESCRIPTION</th>
                            <th style="padding: 15px; text-align: center; border-bottom: 2px solid var(--border); font-weight: 700;">ÉTAT</th>
                            <th style="padding: 15px; text-align: left; border-bottom: 2px solid var(--border); font-weight: 700;">CHEF DE PROJET</th>
                            <th style="padding: 15px; text-align: center; border-bottom: 2px solid var(--border); font-weight: 700;">DATE DÉBUT</th>
                            <th style="padding: 15px; text-align: center; border-bottom: 2px solid var(--border); font-weight: 700;">DATE FIN</th>
                            <th style="padding: 15px; text-align: center; border-bottom: 2px solid var(--border); font-weight: 700;">ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Projet projet : listeProjets) {
                                String badgeClass = "";
                                String badgeIcon = "";
                                
                                String etat = projet.getEtat() != null ? projet.getEtat() : "EN_COURS";
                                switch(etat) {
                                    case "EN_COURS":
                                        badgeClass = "badge-primary";
                                        badgeIcon = "🔵";
                                        break;
                                    case "TERMINE":
                                        badgeClass = "badge-success";
                                        badgeIcon = "✅";
                                        break;
                                    case "ANNULE":
                                        badgeClass = "badge-danger";
                                        badgeIcon = "❌";
                                        break;
                                    default:
                                        badgeClass = "badge-secondary";
                                        badgeIcon = "⚪";
                                }
                        %>
                        <tr style="border-bottom: 1px solid var(--border); transition: all 0.3s ease;" 
                            onmouseover="this.style.background='rgba(99, 102, 241, 0.1)'" 
                            onmouseout="this.style.background='transparent'">
                            <td style="padding: 15px; color: var(--primary-light); font-weight: 700; font-size: 1.05rem;">
                                <%= projet.getNom() %>
                            </td>
                            <td style="padding: 15px; color: var(--text-secondary); max-width: 300px;">
                                <%= projet.getDescription() != null ? (projet.getDescription().length() > 80 ? projet.getDescription().substring(0, 80) + "..." : projet.getDescription()) : "Aucune description" %>
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <span class="badge <%= badgeClass %>"><%= badgeIcon %> <%= projet.getEtat().replace("_", " ") %></span>
                            </td>
                            <td style="padding: 15px; color: var(--text-secondary);">
                                <% if (projet.getChefDeProjet() != null) { %>
                                    👤 <%= projet.getChefDeProjet().getPrenom() %> <%= projet.getChefDeProjet().getNom() %>
                                <% } else { %>
                                    <span style="color: var(--text-muted); font-style: italic;">Non assigné</span>
                                <% } %>
                            </td>
                            <td style="padding: 15px; text-align: center; color: var(--text-secondary);">
                                <%= projet.getDateDebut() != null ? projet.getDateDebut().toString() : "-" %>
                            </td>
                            <td style="padding: 15px; text-align: center; color: var(--text-secondary);">
                                <%= projet.getDateFin() != null ? projet.getDateFin().toString() : "-" %>
                            </td>
                            <td style="padding: 15px;">
                                <div style="display: flex; gap: 5px; justify-content: center; flex-wrap: wrap;">
                                    <a href="projets?action=detail&id=<%= projet.getId() %>" 
                                       class="btn btn-secondary" 
                                       title="Voir les détails"
                                       style="padding: 8px 12px; font-size: 0.85rem;">
                                         Détails
                                    </a>
                                    <% if (RoleHelper.isAdmin(session) || RoleHelper.isChefProjet(session)) { %>
                                    <a href="projets?action=modifier&id=<%= projet.getId() %>" 
                                       class="btn btn-warning" 
                                       title="Modifier le projet"
                                       style="padding: 8px 12px; font-size: 0.85rem;">
                                         Modifier
                                    </a>
                                    <% } %>
                                    <% if (RoleHelper.isAdmin(session)) { %>
                                    <a href="projets?action=supprimer&id=<%= projet.getId() %>" 
                                       class="btn btn-danger" 
                                       title="Supprimer le projet"
                                       style="padding: 8px 12px; font-size: 0.85rem;" 
                                       onclick="return confirm('⚠️ Êtes-vous sûr de vouloir supprimer ce projet ?\n\nCette action est irréversible.');">
                                        Supprimer
                                    </a>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            
            <!-- Compteur total -->
            <div style="margin-top: var(--spacing-lg); padding: var(--spacing-md); background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.05) 100%); border-radius: 12px; border: 2px solid rgba(99, 102, 241, 0.3); text-align: center;">
                <p style="color: var(--primary-light); margin: 0; font-size: 1.1rem; font-weight: 700;">
                     Total : <span style="color: var(--accent); font-size: 1.3rem;"><%= listeProjets.size() %></span> projet(s)
                </p>
            </div>
            
            <%
                } else {
            %>
            
            <!-- État vide -->
            <div style="text-align: center; padding: var(--spacing-xl) var(--spacing-lg); background: linear-gradient(135deg, var(--dark-light) 0%, var(--dark-lighter) 100%); border-radius: 20px; border: 2px dashed var(--border); margin-top: var(--spacing-xl);">
                <div style="font-size: 100px; margin-bottom: var(--spacing-lg); opacity: 0.6;"></div>
                <h3 style="color: var(--text-primary); margin-bottom: var(--spacing-sm); font-size: 1.8rem; font-weight: 700;">Aucun projet trouvé</h3>
                <p style="color: var(--text-muted); margin-bottom: var(--spacing-lg); font-size: 1.05rem;">Commencez par créer votre premier projet pour démarrer</p>
                <% if (RoleHelper.isAdmin(session) || RoleHelper.isChefProjet(session)) { %>
                    <a href="projets?action=nouveau" class="btn btn-primary" style="padding: 15px 30px; font-size: 1.05rem;">
                        ➕ Créer mon premier projet
                    </a>
                <% } %>
            </div>
            
            <%
                }
            %>
        </div>

        <!-- Footer -->
        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
