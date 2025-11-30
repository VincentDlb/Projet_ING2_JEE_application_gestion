<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    List<Departement> listeDepartements = (List<Departement>) request.getAttribute("listeDepartements");
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Départements - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        /* Style spécifique pour les cartes de départements */
        .dept-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 25px;
            border: 1px solid var(--border);
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .dept-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(139, 92, 246, 0.2);
            border-color: var(--primary);
        }

        .dept-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--border);
        }

        .dept-name {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .dept-id-badge {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 700;
            box-shadow: 0 2px 5px rgba(139, 92, 246, 0.3);
        }

        .dept-chef-badge {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            padding: 10px 15px;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 600;
            margin: 15px 0;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);
        }

        .dept-no-chef {
            background: linear-gradient(135deg, #94a3b8 0%, #64748b 100%);
            color: white;
            padding: 10px 15px;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 600;
            margin: 15px 0;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .dept-description {
            color: var(--text-secondary);
            font-size: 0.95rem;
            line-height: 1.6;
            margin: 15px 0;
            flex-grow: 1;
            font-style: italic;
        }

        .dept-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid var(--border);
        }

        .grid-departments {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Header avec titre -->
        <header class="app-header">
            <h1>🏛️ Gestion des Départements</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <!-- Navigation (même style que Employés) -->
        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            
            <% if (RoleHelper.canManageEmployes(session)) { %>
                <a href="<%= request.getContextPath() %>/employes?action=lister">👥 Employés</a>
            <% } %>
            
            <% if (RoleHelper.canManageDepartements(session)) { %>
                <a href="<%= request.getContextPath() %>/departements?action=lister" class="active">🏛️ Départements</a>
            <% } %>
            
            <% if (RoleHelper.canManageProjets(session)) { %>
                <a href="<%= request.getContextPath() %>/projets?action=lister">📁 Projets</a>
            <% } %>
            
            <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister">💰 Fiches de Paie</a>
            
            <% if (RoleHelper.canViewStatistics(session)) { %>
                <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <% if (nomComplet != null) { %>
                <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                     <%= nomComplet %> (<%= userRole %>)
                </span>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                     Déconnexion
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/auth.jsp"> Connexion</a>
            <% } %>
        </nav>

        <!-- Contenu -->
        <div class="content">
            <h2 class="page-title">Liste des Départements (<%= listeDepartements != null ? listeDepartements.size() : 0 %>)</h2>

            <!-- Messages -->
            <% if (message != null) { %>
                <div class="alert alert-success">
                    <% if ("ajout_ok".equals(message)) { %>
                        ✅ Département ajouté avec succès !
                    <% } else if ("modification_ok".equals(message)) { %>
                        ✅ Département modifié avec succès !
                    <% } else if ("suppression_ok".equals(message)) { %>
                        ✅ Département supprimé avec succès !
                    <% } %>
                </div>
            <% } %>
            
            <% if (erreur != null) { %>
                <div class="alert alert-error">❌ <%= erreur %></div>
            <% } %>

            <!-- Actions -->
            <div class="actions" style="margin-bottom: 30px;">
                <a href="<%= request.getContextPath() %>/departements?action=nouveau" class="btn btn-primary">
                    ➕ Ajouter un département
                </a>
            </div>

            <!-- Grille des départements -->
            <% if (listeDepartements != null && !listeDepartements.isEmpty()) { %>
                <div class="grid-departments">
                    <%
                        for (Departement dept : listeDepartements) {
                            Employe chef = dept.getChefDepartement();
                    %>
                    <div class="dept-card">
                        <!-- En-tête du département -->
                        <div class="dept-card-header">
                            <h3 class="dept-name">
                                 <%= dept.getNom() %>
                            </h3>
                            <span class="dept-id-badge">#<%= dept.getId() %></span>
                        </div>

                        <!-- Chef du département -->
                        <% if (chef != null) { %>
                            <div class="dept-chef-badge">
                                 Chef : <%= chef.getPrenom() %> <%= chef.getNom() %>
                            </div>
                        <% } else { %>
                            <div class="dept-no-chef">
                                 Aucun chef désigné
                            </div>
                        <% } %>

                        <!-- Description -->
                        <div class="dept-description">
                            <% 
                                String description = dept.getDescription();
                                if (description != null && !description.trim().isEmpty()) { 
                                    String descCourte = (description.length() > 100) ? 
                                                        description.substring(0, 100) + "..." : 
                                                        description;
                            %>
                                <%= descCourte %>
                            <% } else { %>
                                <span style="color: var(--text-muted);">Aucune description disponible</span>
                            <% } %>
                        </div>

                        <!-- Actions -->
                        <div class="dept-actions">
                            <a href="<%= request.getContextPath() %>/departements?action=voirMembres&id=<%= dept.getId() %>"
                               class="btn btn-primary" 
                               style="flex: 1; text-align: center;"
                               title="Voir tous les membres">
                                 Membres
                            </a>
                            
                            <a href="<%= request.getContextPath() %>/departements?action=modifier&id=<%= dept.getId() %>"
                               class="btn btn-warning btn-icon"
                               title="Modifier le département">
                                ✏️
                            </a>
                            
                            <a href="<%= request.getContextPath() %>/departements?action=supprimer&id=<%= dept.getId() %>"
                               class="btn btn-danger btn-icon"
                               onclick="return confirm('⚠️ Êtes-vous sûr de vouloir supprimer ce département ?\\n\\nCette action est irréversible.');"
                               title="Supprimer le département">
                                🗑️
                            </a>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } else { %>
                <!-- État vide -->
                <div style="text-align: center; padding: 80px 20px; background: var(--card-bg); border-radius: 15px; border: 2px dashed var(--border);">
                    <div style="font-size: 5rem; margin-bottom: 20px; opacity: 0.2;"></div>
                    <h3 style="color: var(--text-secondary); margin-bottom: 15px; font-weight: 600;">
                        Aucun Département
                    </h3>
                    <p style="color: var(--text-muted); margin-bottom: 30px; font-size: 1.1rem;">
                        Aucun département n'a encore été créé dans le système.
                    </p>
                    <a href="<%= request.getContextPath() %>/departements?action=nouveau" 
                       class="btn btn-primary" 
                       style="padding: 15px 40px; font-size: 1.1rem;">
                        ➕ Créer le premier département
                    </a>
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
