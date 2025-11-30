<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    List<Employe> membres = (List<Employe>) request.getAttribute("membres");
    Boolean isChef = (Boolean) request.getAttribute("isChef");
    if (isChef == null) isChef = false;
    
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
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
    <title>Mon Département - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .info-card {
            background: linear-gradient(135deg, var(--dark-light) 0%, var(--dark-lighter) 100%);
            border-radius: 16px;
            padding: var(--spacing-lg);
            border: 2px solid var(--border);
            margin-bottom: var(--spacing-lg);
        }
        
        .info-card.chef-mode {
            border-color: var(--accent);
        }
        
        .info-card h3 {
            color: var(--text-primary);
            margin-bottom: var(--spacing-md);
            font-size: 1.3rem;
        }
        
        .chef-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, var(--accent) 0%, #d4a800 100%);
            color: #000;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9rem;
        }
        
        .membre-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px;
            background: var(--dark-lighter);
            border-radius: 12px;
            margin-bottom: 10px;
            border: 1px solid var(--border);
            transition: all 0.3s ease;
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
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: white;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: var(--spacing-lg);
        }
    </style>
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
                <div class="alert alert-success">✅ Les modifications ont été enregistrées avec succès !</div>
            <% } else if ("membre_ajoute".equals(message)) { %>
                <div class="alert alert-success">✅ Le membre a été ajouté au département !</div>
            <% } else if ("membre_retire".equals(message)) { %>
                <div class="alert alert-success">✅ Le membre a été retiré du département !</div>
            <% } %>
            
            <% if (erreur != null) { %>
                <div class="alert alert-danger">⚠ Erreur : <%= erreur %></div>
            <% } %>

            <!-- En-tête avec badge chef si applicable -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--spacing-lg);">
                <h2 class="page-title" style="margin: 0;">
                     <%= departement.getNom() %>
                </h2>
                
                <% if (isChef) { %>
                    <span class="chef-badge"> Vous êtes Chef de ce Département</span>
                <% } %>
            </div>

            <!-- Informations du département -->
            <div class="info-card <%= isChef ? "chef-mode" : "" %>">
                <h3> Informations</h3>
                
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                    <div>
                        <p style="color: var(--text-muted); margin-bottom: 5px;">Nom du département</p>
                        <p style="color: var(--text-primary); font-weight: 700; font-size: 1.1rem;"><%= departement.getNom() %></p>
                    </div>
                    
                    <div>
                        <p style="color: var(--text-muted); margin-bottom: 5px;">Chef de département</p>
                        <p style="color: var(--primary-light); font-weight: 700;">
                            <% if (departement.getChefDepartement() != null) { %>
                                 <%= departement.getChefDepartement().getPrenom() %> <%= departement.getChefDepartement().getNom() %>
                            <% } else { %>
                                <span style="color: var(--text-muted);">Non assigné</span>
                            <% } %>
                        </p>
                    </div>
                    
                    <div>
                        <p style="color: var(--text-muted); margin-bottom: 5px;">Nombre de membres</p>
                        <p style="color: var(--accent-light); font-weight: 700; font-size: 1.1rem;">
                             <%= membres != null ? membres.size() : 0 %> employé(s)
                        </p>
                    </div>
                </div>
                
                <div style="margin-top: 20px;">
                    <p style="color: var(--text-muted); margin-bottom: 5px;">Description</p>
                    <p style="color: var(--text-secondary); line-height: 1.6;">
                        <%= departement.getDescription() != null && !departement.getDescription().isEmpty() 
                            ? departement.getDescription() 
                            : "Aucune description disponible." %>
                    </p>
                </div>
            </div>

            <!-- Boutons d'action (visibles uniquement pour le chef) -->
            <% if (isChef) { %>
            <div class="action-buttons">
               
                <a href="<%= request.getContextPath() %>/monDepartement?action=gererMembres" class="btn btn-warning">
                     Gérer les membres
                </a>
                <a href="<%= request.getContextPath() %>/monDepartement?action=fichesPaieEquipe" class="btn btn-success">
                    Fiches de paie de l'équipe
                </a>
            </div>
            <% } %>

            <!-- Liste des membres -->
            <div class="info-card" style="margin-top: var(--spacing-lg);">
                <h3> Membres du département (<%= membres != null ? membres.size() : 0 %>)</h3>
                
                <% if (membres != null && !membres.isEmpty()) { %>
                    <div style="margin-top: var(--spacing-md);">
                        <% for (Employe membre : membres) {
                            String initiales = "";
                            if (membre.getPrenom() != null && membre.getPrenom().length() > 0) {
                                initiales += membre.getPrenom().charAt(0);
                            }
                            if (membre.getNom() != null && membre.getNom().length() > 0) {
                                initiales += membre.getNom().charAt(0);
                            }
                            
                            boolean estChef = departement.getChefDepartement() != null 
                                && membre.getId().equals(departement.getChefDepartement().getId());
                        %>
                        <div class="membre-card">
                            <div class="membre-info">
                                <div class="membre-avatar"><%= initiales.toUpperCase() %></div>
                                <div>
                                    <p style="color: var(--text-primary); font-weight: 700; margin: 0;">
                                        <%= membre.getPrenom() %> <%= membre.getNom() %>
                                        <% if (estChef) { %>
                                            <span style="color: var(--accent); margin-left: 10px;">👑 Chef</span>
                                        <% } %>
                                    </p>
                                    <p style="color: var(--text-muted); font-size: 0.9rem; margin: 3px 0 0 0;">
                                        <%= membre.getMatricule() %> • 
                                        <%= membre.getPoste() != null ? membre.getPoste() : "Poste non défini" %>
                                    </p>
                                </div>
                            </div>
                            
                            <div style="display: flex; gap: 8px; align-items: center;">
                                <span class="badge badge-primary"><%= membre.getGrade() != null ? membre.getGrade() : "N/A" %></span>
                                
                                <% if (isChef && !estChef) { %>
                                    <a href="<%= request.getContextPath() %>/fichesDePaie?action=rechercher&employeId=<%= membre.getId() %>" 
                                       class="btn btn-secondary" style="padding: 5px 10px; font-size: 0.8rem;">
                                         Fiches
                                    </a>
                                <% } %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                        <div style="font-size: 50px; margin-bottom: 15px; opacity: 0.5;">👥</div>
                        <p>Aucun membre dans ce département.</p>
                    </div>
                <% } %>
            </div>

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
