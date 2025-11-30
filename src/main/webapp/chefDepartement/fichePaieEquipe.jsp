<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.FicheDePaie" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    // Cette page peut être appelée pour un projet OU un département
    Projet projet = (Projet) request.getAttribute("projet");
    Departement departement = (Departement) request.getAttribute("departement");
    List<Employe> membresEquipe = (List<Employe>) request.getAttribute("membresEquipe");
    
    // Map optionnel : employeId -> nombre de fiches
    Map<Integer, Integer> compteurFiches = (Map<Integer, Integer>) request.getAttribute("compteurFiches");
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
    // Déterminer le contexte (projet ou département)
    boolean isProjet = (projet != null);
    String nomEntite = isProjet ? projet.getNom() : (departement != null ? departement.getNom() : "Équipe");
    String retourUrl = isProjet ? "mesProjets?action=lister" : "monDepartement?action=afficher";
    String retourLabel = isProjet ? "Retour à mes projets" : "Retour à mon département";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiches de Paie Équipe - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .equipe-header {
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.1) 0%, rgba(212, 175, 55, 0.05) 100%);
            border: 2px solid var(--accent);
            border-radius: 16px;
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .equipe-header .icon {
            font-size: 3rem;
        }
        
        .equipe-header .info h2 {
            color: var(--accent);
            margin: 0 0 5px 0;
        }
        
        .equipe-header .info p {
            color: var(--text-muted);
            margin: 0;
        }
        
        .membre-card {
            background: var(--dark-light);
            border-radius: 12px;
            padding: var(--spacing-md);
            border: 1px solid var(--border);
            margin-bottom: var(--spacing-md);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s ease;
        }
        
        .membre-card:hover {
            border-color: var(--primary);
            transform: translateX(5px);
        }
        
        .membre-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .membre-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: white;
            font-size: 1rem;
        }
        
        .membre-avatar.chef {
            background: linear-gradient(135deg, var(--accent) 0%, #d4a800 100%);
            color: #000;
        }
        
        .membre-details h4 {
            color: var(--text-primary);
            margin: 0 0 5px 0;
        }
        
        .membre-details .meta {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .membre-details .meta span {
            color: var(--text-muted);
            font-size: 0.85rem;
        }
        
        .fiche-count {
            background: var(--dark);
            padding: 8px 15px;
            border-radius: 20px;
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-right: 15px;
        }
        
        .fiche-count strong {
            color: var(--accent);
        }
        
        .btn-voir-fiches {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white !important;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            transition: all 0.2s ease;
        }
        
        .btn-voir-fiches:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(99, 102, 241, 0.3);
        }
        
        .btn-creer-fiche {
            background: linear-gradient(135deg, var(--success) 0%, #059669 100%);
            color: white !important;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            margin-left: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--dark-light);
            border-radius: 16px;
            border: 2px dashed var(--border);
        }
        
        .empty-state .icon {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1> Fiches de Paie de l'Équipe</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            <a href="<%= request.getContextPath() %>/monDepartement?action=afficher" <%= !isProjet ? "class=\"active\"" : "" %>>🏛️ Mon Département</a>
            <a href="<%= request.getContextPath() %>/mesProjets?action=lister" <%= isProjet ? "class=\"active\"" : "" %>>📁 Mes Projets</a>
            <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
            
            <% if (RoleHelper.canViewStatistics(session)) { %>
                <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                👤 <%= nomComplet %> (<%= userRole %>)
            </span>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                Déconnexion
            </a>
        </nav>

        <div class="content">
            <!-- Header avec infos équipe -->
            <div class="equipe-header">
                <div class="icon"><%= isProjet ? "" : "" %></div>
                <div class="info">
                    <h2><%= nomEntite %></h2>
                    <p>
                        <%= isProjet ? "Projet" : "Département" %> • 
                        <%= membresEquipe != null ? membresEquipe.size() : 0 %> membre(s)
                    </p>
                </div>
            </div>
            
            <!-- Bouton retour -->
            <div style="margin-bottom: var(--spacing-lg);">
                <a href="<%= request.getContextPath() %>/<%= retourUrl %>" class="btn btn-secondary">
                    ← <%= retourLabel %>
                </a>
            </div>

            <h3 style="color: var(--text-primary); margin-bottom: var(--spacing-md);">
                 Membres de l'équipe
            </h3>

            <% if (membresEquipe != null && !membresEquipe.isEmpty()) { %>
                <% for (Employe membre : membresEquipe) {
                    String initiales = "";
                    if (membre.getPrenom() != null && membre.getPrenom().length() > 0) {
                        initiales += membre.getPrenom().charAt(0);
                    }
                    if (membre.getNom() != null && membre.getNom().length() > 0) {
                        initiales += membre.getNom().charAt(0);
                    }
                    
                    // Vérifier si c'est le chef
                    boolean estChef = false;
                    if (isProjet && projet.getChefDeProjet() != null) {
                        estChef = projet.getChefDeProjet().getId().equals(membre.getId());
                    } else if (!isProjet && departement != null && departement.getChefDepartement() != null) {
                        estChef = departement.getChefDepartement().getId().equals(membre.getId());
                    }
                    
                    // Nombre de fiches (si disponible)
                    Integer nbFiches = compteurFiches != null ? compteurFiches.get(membre.getId()) : null;
                %>
                <div class="membre-card">
                    <div class="membre-info">
                        <div class="membre-avatar <%= estChef ? "chef" : "" %>">
                            <%= initiales.toUpperCase() %>
                        </div>
                        <div class="membre-details">
                            <h4>
                                <%= membre.getPrenom() %> <%= membre.getNom() %>
                                <% if (estChef) { %>
                                    <span style="background: var(--accent); color: #000; padding: 2px 8px; border-radius: 10px; font-size: 0.7rem; font-weight: 700; margin-left: 8px;">
                                         <%= isProjet ? "CHEF PROJET" : "CHEF DEPT" %>
                                    </span>
                                <% } %>
                            </h4>
                            <div class="meta">
                                <span> <%= membre.getMatricule() %></span>
                                <% if (membre.getPoste() != null) { %>
                                    <span> <%= membre.getPoste() %></span>
                                <% } %>
                                <% if (membre.getGrade() != null) { %>
                                    <span> <%= membre.getGrade() %></span>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <div style="display: flex; align-items: center;">
                        <% if (nbFiches != null) { %>
                            <span class="fiche-count">
                                <strong><%= nbFiches %></strong> fiche(s)
                            </span>
                        <% } %>
                        
                        <a href="<%= request.getContextPath() %>/fichesDePaie?action=rechercher&employeId=<%= membre.getId() %>" 
                           class="btn-voir-fiches">
                             Voir fiches
                        </a>
                        
                        <% if (RoleHelper.canCreateFichesPaie(session)) { %>
                            <a href="<%= request.getContextPath() %>/fichesDePaie?action=nouvelle&employeId=<%= membre.getId() %>" 
                               class="btn-creer-fiche">
                                ➕ Créer
                            </a>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <!-- Résumé -->
                <div style="margin-top: var(--spacing-lg); padding: var(--spacing-md); background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.05) 100%); border-radius: 12px; border: 1px solid rgba(99, 102, 241, 0.3); text-align: center;">
                    <p style="color: var(--primary-light); margin: 0; font-weight: 600;">
                         Équipe de <strong><%= membresEquipe.size() %></strong> membre(s)
                        — Cliquez sur "Voir fiches" pour consulter les bulletins de paie
                    </p>
                </div>
                
            <% } else { %>
                <div class="empty-state">
                    <div class="icon"></div>
                    <h3 style="color: var(--text-primary); margin-bottom: 10px;">Aucun membre</h3>
                    <p style="color: var(--text-muted);">
                        <% if (isProjet) { %>
                            Ce projet n'a pas encore de membres. Ajoutez des membres pour gérer leurs fiches de paie.
                        <% } else { %>
                            Ce département n'a pas encore de membres assignés.
                        <% } %>
                    </p>
                </div>
            <% } %>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
