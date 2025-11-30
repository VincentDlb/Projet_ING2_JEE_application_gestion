<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    List<Projet> mesProjets = (List<Projet>) request.getAttribute("mesProjets");
    Set<Integer> projetsChefIds = (Set<Integer>) request.getAttribute("projetsChefIds");
    if (projetsChefIds == null) projetsChefIds = new java.util.HashSet<>();
    
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Projets - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .projet-card {
            background: linear-gradient(135deg, var(--dark-light) 0%, var(--dark-lighter) 100%);
            border-radius: 16px;
            padding: var(--spacing-lg);
            border: 2px solid var(--border);
            margin-bottom: var(--spacing-md);
            transition: all 0.3s ease;
        }
        
        .projet-card:hover {
            border-color: var(--primary);
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        
        .projet-card.chef-mode {
            border-color: var(--accent);
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.05) 0%, var(--dark-lighter) 100%);
        }
        
        .projet-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: var(--spacing-md);
        }
        
        .projet-title {
            color: var(--text-primary);
            font-size: 1.3rem;
            font-weight: 700;
            margin: 0;
        }
        
        .chef-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: linear-gradient(135deg, var(--accent) 0%, #d4a800 100%);
            color: #000;
            padding: 5px 12px;
            border-radius: 15px;
            font-weight: 700;
            font-size: 0.8rem;
        }
        
        .membre-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--primary);
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 0.8rem;
        }
        
        .projet-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin: var(--spacing-md) 0;
        }
        
        .projet-meta-item {
            padding: 10px;
            background: var(--dark);
            border-radius: 8px;
        }
        
        .projet-meta-item label {
            display: block;
            color: var(--text-muted);
            font-size: 0.8rem;
            margin-bottom: 3px;
        }
        
        .projet-meta-item span {
            color: var(--text-primary);
            font-weight: 600;
        }
        
        .projet-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: var(--spacing-md);
            padding-top: var(--spacing-md);
            border-top: 1px solid var(--border);
        }
        
        /* STYLES AMÉLIORÉS POUR LES BOUTONS */
        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 18px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-details {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
        }
        
        .btn-details:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4);
            color: white;
        }
        
        .btn-modifier {
            background: linear-gradient(135deg, var(--primary) 0%, #4f46e5 100%);
            color: white;
        }
        
        .btn-modifier:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
            color: white;
        }
        
        .btn-equipe {
            background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
            color: white;
        }
        
        .btn-equipe:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(6, 182, 212, 0.4);
            color: white;
        }
        
        .btn-fiches {
            background: linear-gradient(135deg, var(--accent) 0%, #d4a800 100%);
            color: #000;
        }
        
        .btn-fiches:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.4);
            color: #000;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--dark-light);
            border-radius: 16px;
            border: 2px dashed var(--border);
        }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>📁 Mes Projets</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
            <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="active">📁 Mes Projets</a>
            <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
            
            <% if (RoleHelper.canViewStatistics(session)) { %>
                <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                👤 <%= nomComplet %> (<%= userRole %>)
            </span>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                🚪 Déconnexion
            </a>
        </nav>

        <div class="content">
            <!-- Messages -->
            <% if ("modification_ok".equals(message)) { %>
                <div class="alert alert-success">✅ Le projet a été modifié avec succès !</div>
            <% } else if ("membre_ajoute".equals(message)) { %>
                <div class="alert alert-success">✅ Le membre a été ajouté au projet !</div>
            <% } else if ("membre_retire".equals(message)) { %>
                <div class="alert alert-success">✅ Le membre a été retiré du projet !</div>
            <% } %>
            
            <% if (erreur != null) { %>
                <div class="alert alert-danger">⚠️ Erreur : <%= erreur %></div>
            <% } %>

            <h2 class="page-title"> Mes Projets</h2>
            
            <p style="color: var(--text-secondary); margin-bottom: var(--spacing-lg);">
                Voici les projets auxquels vous participez en tant que membre ou chef.
            </p>

            <% if (mesProjets != null && !mesProjets.isEmpty()) { %>
                
                <% for (Projet projet : mesProjets) {
                    boolean estChef = projetsChefIds.contains(projet.getId());
                    String etat = projet.getEtat() != null ? projet.getEtat() : "EN_COURS";
                    
                    String badgeClass = "badge-primary";
                    String badgeIcon = "";
                    if ("TERMINE".equals(etat)) {
                        badgeClass = "badge-success";
                        badgeIcon = "";
                    } else if ("ANNULE".equals(etat)) {
                        badgeClass = "badge-danger";
                        badgeIcon = "";
                    }
                    
                    int nbMembres = projet.getEmployes() != null ? projet.getEmployes().size() : 0;
                %>
                <div class="projet-card <%= estChef ? "chef-mode" : "" %>">
                    <div class="projet-header">
                        <div>
                            <h3 class="projet-title"><%= projet.getNom() %></h3>
                            <p style="color: var(--text-muted); margin: 5px 0 0 0;">
                                <%= projet.getDescription() != null && projet.getDescription().length() > 100 
                                    ? projet.getDescription().substring(0, 100) + "..." 
                                    : (projet.getDescription() != null ? projet.getDescription() : "Aucune description") %>
                            </p>
                        </div>
                        
                        <div style="display: flex; flex-direction: column; gap: 8px; align-items: flex-end;">
                            <% if (estChef) { %>
                                <span class="chef-badge"> Chef de Projet</span>
                            <% } else { %>
                                <span class="membre-badge"> Membre</span>
                            <% } %>
                            <span class="badge <%= badgeClass %>"><%= badgeIcon %> <%= etat.replace("_", " ") %></span>
                        </div>
                    </div>
                    
                    <div class="projet-meta">
                        <div class="projet-meta-item">
                            <label>Date de début</label>
                            <span><%= projet.getDateDebut() != null ? projet.getDateDebut().toString() : "Non définie" %></span>
                        </div>
                        <div class="projet-meta-item">
                            <label>Date de fin</label>
                            <span><%= projet.getDateFin() != null ? projet.getDateFin().toString() : "Non définie" %></span>
                        </div>
                        <div class="projet-meta-item">
                            <label>Chef de projet</label>
                            <span>
                                <% if (projet.getChefDeProjet() != null) { %>
                                    <%= projet.getChefDeProjet().getPrenom() %> <%= projet.getChefDeProjet().getNom() %>
                                <% } else { %>
                                    Non assigné
                                <% } %>
                            </span>
                        </div>
                        <div class="projet-meta-item">
                            <label>Équipe</label>
                            <span> <%= nbMembres %> membre(s)</span>
                        </div>
                    </div>
                    
                    <div class="projet-actions">
                        <a href="<%= request.getContextPath() %>/mesProjets?action=detail&id=<%= projet.getId() %>" 
                           class="btn-action btn-details">
                            Voir les détails
                        </a>
                        
                        <% if (estChef) { %>
                            <a href="<%= request.getContextPath() %>/mesProjets?action=modifier&id=<%= projet.getId() %>" 
                               class="btn-action btn-modifier">
                                 Modifier
                            </a>
                            <a href="<%= request.getContextPath() %>/mesProjets?action=gererEquipe&id=<%= projet.getId() %>" 
                               class="btn-action btn-equipe">
                                 Gérer l'équipe
                            </a>
                            <a href="<%= request.getContextPath() %>/mesProjets?action=fichesPaieEquipe&id=<%= projet.getId() %>" 
                               class="btn-action btn-fiches">
                                 Fiches de paie
                            </a>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <!-- Compteur -->
                <div style="margin-top: var(--spacing-lg); padding: var(--spacing-md); background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.05) 100%); border-radius: 12px; border: 1px solid rgba(99, 102, 241, 0.3); text-align: center;">
                    <p style="color: var(--primary-light); margin: 0; font-weight: 600;">
                        Vous participez à <strong><%= mesProjets.size() %></strong> projet(s)
                        <% 
                            int nbProjetsChef = projetsChefIds.size();
                            if (nbProjetsChef > 0) {
                        %>
                        dont <strong style="color: var(--accent);"><%= nbProjetsChef %></strong> en tant que chef
                        <% } %>
                    </p>
                </div>
                
            <% } else { %>
                <div class="empty-state">
                    <div style="font-size: 80px; margin-bottom: 20px; opacity: 0.5;">📁</div>
                    <h3 style="color: var(--text-primary); margin-bottom: 10px;">Aucun projet</h3>
                    <p style="color: var(--text-muted); margin-bottom: 20px;">
                        Vous ne participez actuellement à aucun projet.
                    </p>
                </div>
            <% } %>

            <!-- Bouton retour -->
            <div style="margin-top: var(--spacing-lg);">
                <a href="<%= request.getContextPath() %>/accueil.jsp" class="btn btn-secondary">
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
