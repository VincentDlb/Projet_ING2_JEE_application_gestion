<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    List<Projet> tousMesProjets = (List<Projet>) request.getAttribute("tousMesProjets");
    String employeNom = (String) request.getAttribute("employeNom");
    Integer employeId = (Integer) request.getAttribute("employeId");
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
    <title>Tous Mes Projets - RowTech</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .role-badge-chef {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            padding: 6px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.3);
        }
        
        .role-badge-membre {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            padding: 6px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            box-shadow: 0 2px 4px rgba(59, 130, 246, 0.3);
        }

        /* Animation pour les badges */
        .role-badge-chef, .role-badge-membre {
            transition: all 0.3s ease;
        }

        .role-badge-chef:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(16, 185, 129, 0.4);
        }

        .role-badge-membre:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(59, 130, 246, 0.4);
        }

        /* Style pour les statistiques */
        .stat-card {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 12px;
            border: 1px solid var(--border);
            text-align: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(139, 92, 246, 0.15);
        }

        .stat-value {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-top: 8px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Header -->
        <header class="app-header">
            <h1>📊 Tous Mes Projets</h1>
            <p>Vue d'ensemble de vos participations - <%= employeNom %></p>
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
            <%
                String message = request.getParameter("message");
                String erreur = request.getParameter("erreur");
                
                if (message != null) {
            %>
                <div class="alert alert-success" style="margin-bottom: 20px;">
                    <% if ("suppression_ok".equals(message)) { %>
                        ✅ Projet supprimé avec succès !
                    <% } else if ("modification_ok".equals(message)) { %>
                        ✅ Projet modifié avec succès !
                    <% } else if ("affectation_ok".equals(message)) { %>
                        ✅ Employé affecté au projet avec succès !
                    <% } else if ("retrait_ok".equals(message)) { %>
                        ✅ Employé retiré du projet avec succès !
                    <% } %>
                </div>
            <%
                }
                
                if (erreur != null) {
            %>
                <div class="alert alert-error" style="margin-bottom: 20px;">
                    ❌ <%= erreur %>
                </div>
            <%
                }
            %>

            <h2 class="page-title">📁 Mes Projets (<%= tousMesProjets != null ? tousMesProjets.size() : 0 %>)</h2>

            <% if (tousMesProjets != null && !tousMesProjets.isEmpty()) { %>
            
            <!-- Tableau des projets -->
            <div class="table-container" style="margin-bottom: 30px;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width: 5%;">ID</th>
                            <th style="width: 20%;">Nom du Projet</th>
                            <th style="width: 25%;">Description</th>
                            <th style="width: 10%;">État</th>
                            <th style="width: 10%;">Mon Rôle</th>
                            <th style="width: 10%;">Début</th>
                            <th style="width: 10%;">Fin</th>
                            <th style="width: 15%;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Projet projet : tousMesProjets) {
                                // Vérifier si l'utilisateur est chef de ce projet
                                boolean estChef = (projet.getChefDeProjet() != null && 
                                                  projet.getChefDeProjet().getId().equals(employeId));
                                
                                // Déterminer le badge de l'état
                                String etat = projet.getEtat() != null ? projet.getEtat() : "INCONNU";
                                String badgeClass = "";
                                String badgeIcon = "";
                                
                                switch(etat) {
                                    case "EN_COURS":
                                        badgeClass = "badge-success";
                                        badgeIcon = "🟢";
                                        break;
                                    case "TERMINE":
                                        badgeClass = "badge-info";
                                        badgeIcon = "✅";
                                        break;
                                    case "ANNULE":
                                        badgeClass = "badge-danger";
                                        badgeIcon = "❌";
                                        break;
                                    case "EN_ATTENTE":
                                        badgeClass = "badge-warning";
                                        badgeIcon = "⏳";
                                        break;
                                    default:
                                        badgeClass = "badge-neutral";
                                        badgeIcon = "❓";
                                }
                        %>
                        <tr>
                            <td style="padding: 15px; text-align: center; font-weight: 700; color: var(--primary);">
                                #<%= projet.getId() %>
                            </td>
                            <td style="padding: 15px;">
                                <strong style="color: var(--text-primary); font-size: 1rem;">
                                    <%= projet.getNom() %>
                                </strong>
                                <% if (projet.getChefDeProjet() != null) { %>
                                    <div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 5px;">
                                        👨‍💼 Chef: <%= projet.getChefDeProjet().getPrenom() %> <%= projet.getChefDeProjet().getNom() %>
                                    </div>
                                <% } %>
                            </td>
                            <td style="padding: 15px; color: var(--text-secondary); font-size: 0.9rem;">
                                <%= projet.getDescription() != null ? 
                                    (projet.getDescription().length() > 80 ? 
                                    projet.getDescription().substring(0, 80) + "..." : 
                                    projet.getDescription()) : 
                                    "Aucune description" %>
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <span class="badge <%= badgeClass %>"><%= badgeIcon %> <%= etat.replace("_", " ") %></span>
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <% if (estChef) { %>
                                    <span class="role-badge-chef">👑 Chef de Projet</span>
                                <% } else { %>
                                    <span class="role-badge-membre">👤 Membre</span>
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
                                    <!-- Bouton Détails - visible pour TOUT LE MONDE -->
                                    <a href="projets?action=detail&id=<%= projet.getId() %>" 
                                       class="btn btn-secondary" 
                                       title="Voir les détails"
                                       style="padding: 8px 12px; font-size: 0.85rem;">
                                        📄 Détails
                                    </a>
                                    
                                    <!-- Boutons Modifier et Équipe - Pour les CHEFS et ADMINS -->
                                    <% if (estChef || RoleHelper.isAdmin(session)) { %>
                                    <a href="projets?action=modifier&id=<%= projet.getId() %>" 
                                       class="btn btn-warning" 
                                       title="Modifier le projet"
                                       style="padding: 8px 12px; font-size: 0.85rem;">
                                        ✏️ Modifier
                                    </a>
                                    <a href="projets?action=gererEquipe&id=<%= projet.getId() %>" 
                                       class="btn btn-primary" 
                                       title="Gérer l'équipe"
                                       style="padding: 8px 12px; font-size: 0.85rem;">
                                        👥 Équipe
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
            
            <!-- Statistiques -->
            <div style="margin-top: var(--spacing-lg); display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--spacing-md);">
                <%
                    int nbProjetChef = 0;
                    int nbProjetMembre = 0;
                    int nbEnCours = 0;
                    int nbTermine = 0;
                    int nbAnnule = 0;
                    
                    for (Projet p : tousMesProjets) {
                        boolean isChef = (p.getChefDeProjet() != null && p.getChefDeProjet().getId().equals(employeId));
                        if (isChef) {
                            nbProjetChef++;
                        } else {
                            nbProjetMembre++;
                        }
                        
                        String etat = p.getEtat() != null ? p.getEtat() : "";
                        if ("EN_COURS".equals(etat)) nbEnCours++;
                        else if ("TERMINE".equals(etat)) nbTermine++;
                        else if ("ANNULE".equals(etat)) nbAnnule++;
                    }
                %>
                
                <div class="stat-card">
                    <div class="stat-value" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                        <%= nbProjetChef %>
                    </div>
                    <div class="stat-label">👑 Projets en tant que Chef</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-value" style="background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                        <%= nbProjetMembre %>
                    </div>
                    <div class="stat-label">👤 Projets en tant que Membre</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-value" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                        <%= nbEnCours %>
                    </div>
                    <div class="stat-label">🟢 Projets en cours</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-value" style="background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                        <%= nbTermine %>
                    </div>
                    <div class="stat-label">✅ Projets terminés</div>
                </div>
            </div>
            
            <% } else { %>
                <div style="text-align: center; padding: 60px 20px; background: var(--card-bg); border-radius: 15px; border: 2px dashed var(--border);">
                    <div style="font-size: 4rem; margin-bottom: 20px; opacity: 0.3;">📁</div>
                    <h3 style="color: var(--text-secondary); margin-bottom: 15px; font-weight: 600;">
                        Aucun Projet
                    </h3>
                    <p style="color: var(--text-muted); margin-bottom: 25px;">
                        Vous ne participez actuellement à aucun projet.
                    </p>
                    <% if (RoleHelper.canManageProjets(session)) { %>
                        <a href="projets?action=lister" class="btn btn-primary" style="padding: 12px 30px;">
                            📁 Voir tous les projets
                        </a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
