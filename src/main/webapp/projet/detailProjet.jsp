<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    Boolean isChef = (Boolean) request.getAttribute("isChef");
    if (isChef == null) isChef = false;
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
    
    
    // Comptage des grades
    Set<Employe> membres = projet.getEmployes();
    int nbMembres = membres != null ? membres.size() : 0;
    Set<String> gradesDistincts = new HashSet<>();
    if (membres != null) {
        for (Employe e : membres) {
            if (e.getGrade() != null) {
                gradesDistincts.add(e.getGrade());
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du Projet - <%= projet.getNom() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, var(--dark-light) 0%, var(--dark-lighter) 100%);
            border-radius: 16px;
            padding: 25px;
            text-align: center;
            border: 1px solid var(--border);
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
        }
        
        .stat-label {
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        
        .info-section {
            background: var(--dark-light);
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid var(--border);
        }
        
        .info-section h3 {
            color: var(--primary-light);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-item {
            background: var(--dark);
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 12px;
            border-left: 4px solid var(--primary);
        }
        
        .info-item label {
            display: block;
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-bottom: 5px;
        }
        
        .info-item span {
            color: var(--text-primary);
            font-weight: 600;
        }
        
        .membres-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .membres-table th,
        .membres-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }
        
        .membres-table th {
            background: var(--dark);
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
        }
        
        .membres-table td {
            color: var(--text-primary);
        }
        
        .membres-table tr:hover td {
            background: rgba(99, 102, 241, 0.05);
        }
        
        .action-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 30px;
        }
        
        .action-buttons .btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-outline {
            background: transparent;
            border: 2px solid var(--border);
            color: var(--text-secondary);
        }
        
        .btn-outline:hover {
            border-color: var(--primary);
            color: var(--primary-light);
            background: rgba(99, 102, 241, 0.1);
        }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1> <%= projet.getNom() %></h1>
            <p>Détails complets du projet - RowTech</p>
        </header>

        <!-- Navigation adaptée selon le rôle -->
        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            
            <% if (isAdmin) { %>
                <!-- Navigation ADMIN -->
                <% if (RoleHelper.canManageEmployes(session)) { %>
                    <a href="<%= request.getContextPath() %>/employes?action=lister">👥 Employés</a>
                <% } %>
                
                <% if (RoleHelper.canManageDepartements(session)) { %>
                    <a href="<%= request.getContextPath() %>/departements?action=lister">🏛️ Départements</a>
                <% } %>
                
                <a href="<%= request.getContextPath() %>/projets?action=lister" class="active">📁 Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister">💰 Fiches de Paie</a>
                
                <% if (RoleHelper.canViewStatistics(session)) { %>
                    <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
                <% } %>
            <% } else { %>
                <!-- Navigation EMPLOYÉ / CHEF -->
                <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="active">📁 Mes Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
            <% } %>
            
            <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                 <%= nomComplet %> (<%= userRole %>)
            </span>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                 Déconnexion
            </a>
        </nav>

        <div class="content">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                <h2 class="page-title"> Détails du Projet</h2>
                <% if (isAdmin) { %>
                    <a href="<%= request.getContextPath() %>/projets?action=lister" class="btn btn-outline">
                        ← Retour
                    </a>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="btn btn-outline">
                        ← Retour
                    </a>
                <% } %>
            </div>

            <!-- Statistiques rapides -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon"></div>
                    <div class="stat-value"><%= nbMembres %></div>
                    <div class="stat-label">Membres</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <% if ("TERMINE".equals(projet.getEtat())) { %>✅
                        <% } else if ("ANNULE".equals(projet.getEtat())) { %>❌
                        <% } else { %>🔵<% } %>
                    </div>
                    <div class="stat-value" style="font-size: 1.2rem;"><%= projet.getEtat() != null ? projet.getEtat().replace("_", " ") : "EN COURS" %></div>
                    <div class="stat-label">État du Projet</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon"></div>
                    <div class="stat-value"><%= gradesDistincts.size() %></div>
                    <div class="stat-label">Grades Différents</div>
                </div>
            </div>

            <!-- Informations générales -->
            <div class="info-section">
                <h3> Informations Générales
                    <span class="badge <%= "TERMINE".equals(projet.getEtat()) ? "badge-success" : ("ANNULE".equals(projet.getEtat()) ? "badge-danger" : "badge-primary") %>" style="margin-left: auto;">
                        <% if ("TERMINE".equals(projet.getEtat())) { %>✅<% } else if ("ANNULE".equals(projet.getEtat())) { %>❌<% } else { %>🔵<% } %>
                        <%= projet.getEtat() != null ? projet.getEtat().replace("_", " ") : "EN COURS" %>
                    </span>
                </h3>
                
                <div class="info-item">
                    <label> Nom du Projet :</label>
                    <span><%= projet.getNom() %></span>
                </div>
                
                <div class="info-item">
                    <label> Description :</label>
                    <span><%= projet.getDescription() != null ? projet.getDescription() : "Aucune description" %></span>
                </div>
                
                <div class="info-item">
                    <label> Chef de Projet :</label>
                    <span>
                        <% if (projet.getChefDeProjet() != null) { %>
                            <%= projet.getChefDeProjet().getPrenom() %> <%= projet.getChefDeProjet().getNom() %>
                            (<%= projet.getChefDeProjet().getPoste() != null ? projet.getChefDeProjet().getPoste() : "N/A" %>)
                        <% } else { %>
                            Non assigné
                        <% } %>
                    </span>
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="info-item">
                        <label> Date de début :</label>
                        <span><%= projet.getDateDebut() != null ? projet.getDateDebut().toString() : "Non définie" %></span>
                    </div>
                    <div class="info-item">
                        <label> Date de fin :</label>
                        <span><%= projet.getDateFin() != null ? projet.getDateFin().toString() : "Non définie" %></span>
                    </div>
                </div>
            </div>

            <!-- Membres de l'équipe -->
            <div class="info-section">
                <h3> Membres de l'Équipe (<%= nbMembres %>)</h3>
                
                <% if (membres != null && !membres.isEmpty()) { %>
                    <div style="overflow-x: auto;">
                        <table class="membres-table">
                            <thead>
                                <tr>
                                    <th>Matricule</th>
                                    <th>Nom Complet</th>
                                    <th>Poste</th>
                                    <th>Grade</th>
                                    <th>Département</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Employe membre : membres) { %>
                                    <tr>
                                        <td><%= membre.getMatricule() != null ? membre.getMatricule() : "N/A" %></td>
                                        <td><strong><%= membre.getPrenom() %> <%= membre.getNom() %></strong></td>
                                        <td><%= membre.getPoste() != null ? membre.getPoste() : "N/A" %></td>
                                        <td>
                                            <span class="badge badge-info"><%= membre.getGrade() != null ? membre.getGrade() : "N/A" %></span>
                                        </td>
                                        <td><%= membre.getDepartement() != null ? membre.getDepartement().getNom() : "N/A" %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <p style="text-align: center; color: var(--text-muted); padding: 30px;">
                        Aucun membre dans ce projet
                    </p>
                <% } %>
            </div>

            <!-- Boutons d'action -->
            <div class="action-buttons">
                <% if (isAdmin) { %>
                    <a href="<%= request.getContextPath() %>/projets?action=lister" class="btn btn-secondary">
                        ← Retour aux projets
                    </a>
                    
                    
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="btn btn-secondary">
                        ← Retour à mes projets
                    </a>
                    <% if (isChef) { %>
                        <a href="<%= request.getContextPath() %>/mesProjets?action=modifier&id=<%= projet.getId() %>" class="btn btn-warning">
                             Modifier
                        </a>
                        <a href="<%= request.getContextPath() %>/mesProjets?action=gererEquipe&id=<%= projet.getId() %>" class="btn btn-info">
                             Gérer l'équipe
                        </a>
                    <% } %>
                <% } %>
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
