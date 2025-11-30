<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    List<Employe> membres = (List<Employe>) request.getAttribute("membres");
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
    
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Équipe du Projet - RowTech</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Header -->
        <header class="app-header">
            <h1>👥 Équipe du Projet</h1>
            <p><%= projet != null ? projet.getNom() : "Détails de l'équipe" %> - RowTech</p>
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
                    👤 <%= nomComplet %> (<%= userRole %>)
                </span>
                <a href="auth?action=logout" style="background: var(--danger);">🚪 Déconnexion</a>
            <%
                } else {
            %>
                <a href="auth.jsp">🔒 Connexion</a>
            <%
                }
            %>
        </nav>

        <!-- Contenu -->
        <div class="content">
            <% if (projet != null) { %>
            
            <div class="actions" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--spacing-lg);">
                <h2 class="page-title">👥 Équipe du Projet</h2>
                <div style="display: flex; gap: 10px;">
                    <% if (RoleHelper.isAdmin(session) || RoleHelper.isChefProjet(session)) { %>
                    <a href="projets?action=gererEquipe&id=<%= projet.getId() %>" class="btn btn-primary">⚙️ Gérer l'Équipe</a>
                    <% } %>
                    <a href="projets?action=detail&id=<%= projet.getId() %>" class="btn btn-secondary">📄 Détails</a>
                    <a href="projets?action=lister" class="btn btn-secondary">← Retour</a>
                </div>
            </div>

            <%
                String badgeClass = "";
                String badgeIcon = "";
                String etat = projet.getEtat() != null ? projet.getEtat() : "EN_COURS";
                
                switch(etat.toUpperCase()) {
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
                
                int nbMembres = membres != null ? membres.size() : 0;
            %>

            <!-- Info Projet -->
            <div style="margin-bottom: var(--spacing-xl); padding: var(--spacing-lg); background: var(--dark-light); border-radius: 16px; border: 2px solid var(--border);">
                <h3 style="color: var(--primary-light); margin-bottom: var(--spacing-md); font-size: 1.4rem; font-weight: 700;">
                    📁 <%= projet.getNom() %>
                </h3>
                
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--spacing-md); margin-bottom: var(--spacing-md);">
                    <div>
                        <p style="color: var(--text-muted); margin-bottom: 8px; font-size: 0.85rem; font-weight: 600;">ÉTAT</p>
                        <span class="badge <%= badgeClass %>" style="font-size: 1rem; padding: 8px 16px;">
                            <%= badgeIcon %> <%= etat.replace("_", " ") %>
                        </span>
                    </div>
                    
                    <div>
                        <p style="color: var(--text-muted); margin-bottom: 8px; font-size: 0.85rem; font-weight: 600;">CHEF DE PROJET</p>
                        <p style="color: var(--text-primary); font-weight: 700; margin: 0;">
                            <% if (projet.getChefDeProjet() != null) { %>
                                👑 <%= projet.getChefDeProjet().getPrenom() %> <%= projet.getChefDeProjet().getNom() %>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-weight: 400;">Non assigné</span>
                            <% } %>
                        </p>
                    </div>
                    
                    <div>
                        <p style="color: var(--text-muted); margin-bottom: 8px; font-size: 0.85rem; font-weight: 600;">TAILLE DE L'ÉQUIPE</p>
                        <p style="color: var(--primary-light); font-weight: 800; font-size: 1.3rem; margin: 0;">
                            👥 <%= nbMembres %> membre(s)
                        </p>
                    </div>
                    
                    <div>
                        <p style="color: var(--text-muted); margin-bottom: 8px; font-size: 0.85rem; font-weight: 600;">ÉCHÉANCE</p>
                        <p style="color: var(--text-primary); font-weight: 700; margin: 0;">
                            <% if (projet.getDateFin() != null) { %>
                                ⏰ <%= projet.getDateFin().toString() %>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-weight: 400;">Non définie</span>
                            <% } %>
                        </p>
                    </div>
                </div>
                
                <% if (projet.getDescription() != null && !projet.getDescription().trim().isEmpty()) { %>
                <div style="margin-top: var(--spacing-md); padding-top: var(--spacing-md); border-top: 1px solid var(--border);">
                    <p style="color: var(--text-muted); margin-bottom: 8px; font-size: 0.85rem; font-weight: 600;">DESCRIPTION</p>
                    <p style="color: var(--text-secondary); line-height: 1.7; margin: 0;">
                        <%= projet.getDescription() %>
                    </p>
                </div>
                <% } %>
            </div>

            <h3 style="color: var(--text-primary); margin: var(--spacing-xl) 0 var(--spacing-md); font-size: 1.5rem; font-weight: 700;">
                👥 Membres de l'Équipe (<%= nbMembres %>)
            </h3>
            
            <% if (nbMembres > 0) { %>
            
            <!-- Tableau des membres -->
            <div class="table-container" style="background: var(--dark-light); border-radius: 16px; padding: var(--spacing-lg); border: 2px solid var(--border); overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%); color: white;">
                            <th style="padding: 15px; text-align: left; border-bottom: 2px solid var(--border); font-weight: 700;">MATRICULE</th>
                            <th style="padding: 15px; text-align: left; border-bottom: 2px solid var(--border); font-weight: 700;">NOM COMPLET</th>
                            <th style="padding: 15px; text-align: left; border-bottom: 2px solid var(--border); font-weight: 700;">EMAIL</th>
                            <th style="padding: 15px; text-align: center; border-bottom: 2px solid var(--border); font-weight: 700;">POSTE</th>
                            <th style="padding: 15px; text-align: center; border-bottom: 2px solid var(--border); font-weight: 700;">GRADE</th>
                            <th style="padding: 15px; text-align: center; border-bottom: 2px solid var(--border); font-weight: 700;">DÉPARTEMENT</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Employe emp : membres) {
                                boolean isChef = (projet.getChefDeProjet() != null && 
                                                 emp.getId().equals(projet.getChefDeProjet().getId()));
                        %>
                        <tr style="border-bottom: 1px solid var(--border); transition: all 0.3s ease; <%= isChef ? "background: linear-gradient(135deg, rgba(251, 191, 36, 0.15) 0%, rgba(251, 191, 36, 0.05) 100%);" : "" %>" 
                            onmouseover="this.style.background='rgba(99, 102, 241, 0.1)'" 
                            onmouseout="this.style.background='<%= isChef ? "linear-gradient(135deg, rgba(251, 191, 36, 0.15) 0%, rgba(251, 191, 36, 0.05) 100%)" : "transparent" %>'">
                            <td style="padding: 15px;">
                                <span class="badge badge-primary" style="font-size: 0.85rem; padding: 6px 12px;">
                                    <%= emp.getMatricule() %>
                                </span>
                            </td>
                            <td style="padding: 15px; color: var(--text-primary); font-weight: 700; font-size: 1rem;">
                                <%= isChef ? "👑" : "👤" %> <%= emp.getPrenom() %> <%= emp.getNom() %>
                                <% if (isChef) { %>
                                    <span style="color: #fbbf24; font-size: 0.85rem; margin-left: 8px; font-weight: 600;">(Chef de Projet)</span>
                                <% } %>
                            </td>
                            <td style="padding: 15px; color: var(--text-secondary);">
                                <%= emp.getEmail() != null ? emp.getEmail() : "N/A" %>
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <span class="badge badge-info" style="font-size: 0.85rem; padding: 6px 12px;">
                                    <%= emp.getPoste() %>
                                </span>
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <span class="badge badge-primary" style="font-size: 0.85rem; padding: 6px 12px;">
                                    <%= emp.getGrade() %>
                                </span>
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <% if (emp.getDepartement() != null) { %>
                                    <span class="badge badge-secondary" style="font-size: 0.85rem; padding: 6px 12px;">
                                        <%= emp.getDepartement().getNom() %>
                                    </span>
                                <% } else { %>
                                    <span style="color: var(--text-muted); font-style: italic;">Non affecté</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- Statistiques -->
            <div style="margin-top: var(--spacing-lg); padding: var(--spacing-md); background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.05) 100%); border-radius: 12px; border: 2px solid rgba(99, 102, 241, 0.3); text-align: center;">
                <p style="color: var(--primary-light); margin: 0; font-size: 1.1rem; font-weight: 700;">
                    📊 Total : <span style="color: var(--accent); font-size: 1.3rem;"><%= nbMembres %></span> membre(s) dans l'équipe
                </p>
            </div>
            
            <% } else { %>
            
            <!-- État vide -->
            <div style="text-align: center; padding: var(--spacing-xl); background: linear-gradient(135deg, var(--dark-light) 0%, var(--dark-lighter) 100%); border-radius: 20px; border: 2px dashed var(--border);">
                <div style="font-size: 100px; margin-bottom: var(--spacing-lg); opacity: 0.6;">👥</div>
                <h3 style="color: var(--text-primary); margin-bottom: var(--spacing-sm); font-size: 1.8rem; font-weight: 700;">Aucun membre dans l'équipe</h3>
                <p style="color: var(--text-muted); margin-bottom: var(--spacing-lg); font-size: 1.05rem;">
                    Ce projet ne contient aucun membre pour le moment.
                </p>
                <% if (RoleHelper.isAdmin(session) || RoleHelper.isChefProjet(session)) { %>
                <a href="projets?action=gererEquipe&id=<%= projet.getId() %>" class="btn btn-primary" style="padding: 15px 30px; font-size: 1.05rem;">
                    ➕ Ajouter des Membres
                </a>
                <% } %>
            </div>
            
            <% } %>
            
            <% } else { %>
            
            <!-- Projet introuvable -->
            <div class="alert alert-danger">
                ⚠️ Projet introuvable
            </div>
            <div class="actions">
                <a href="projets?action=lister" class="btn btn-secondary">← Retour à la liste des projets</a>
            </div>
            
            <% } %>
        </div>

        <!-- Footer -->
        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
