<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    List<Employe> membres = (List<Employe>) request.getAttribute("membres");
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Membres du Département - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        /* Style pour l'info box du département */
        .dept-info-box {
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.1) 0%, rgba(124, 58, 237, 0.05) 100%);
            border: 2px solid var(--primary);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .dept-info-header {
            color: var(--primary);
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .dept-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .dept-info-item {
            background: var(--card-bg);
            padding: 15px;
            border-radius: 10px;
            border: 1px solid var(--border);
        }

        .dept-info-label {
            color: var(--text-secondary);
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .dept-info-value {
            color: var(--text-primary);
            font-size: 1.1rem;
            font-weight: 700;
        }

        /* Style pour les badges de grade */
        .grade-badge {
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-block;
        }

        .grade-junior { background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%); color: white; }
        .grade-confirme { background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%); color: white; }
        .grade-senior { background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; }
        .grade-expert { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); color: white; }

        /* Animation hover sur les lignes du tableau */
        .data-table tbody tr {
            transition: all 0.2s ease;
        }

        .data-table tbody tr:hover {
            background: rgba(139, 92, 246, 0.05);
            transform: scale(1.01);
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Header -->
        <header class="app-header">
            <h1>🏛️ Membres du Département</h1>
            <p>RowTech - Gestion des Ressources Humaines</p>
        </header>

        <!-- Navigation -->
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
                <span style="margin-left: auto; color: var(--text-secondary);">
                    <%= nomComplet %> (<%= userRole %>)
                </span>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                     Déconnexion
                </a>
            <% } %>
        </nav>

        <!-- Contenu -->
        <div class="content">
            <!-- Titre de la page -->
            <h2 class="page-title">
                Membres du département : 
                <% if (departement != null) { %>
                    <span style="color: var(--primary);"><%= departement.getNom() %></span>
                <% } %>
            </h2>

            <!-- Informations du département -->
            <% if (departement != null) { %>
                <div class="dept-info-box">
                    <h3 class="dept-info-header">
                         Informations du Département
                    </h3>
                    
                    <div class="dept-info-grid">
                        <div class="dept-info-item">
                            <div class="dept-info-label">Nom du Département</div>
                            <div class="dept-info-value"> <%= departement.getNom() %></div>
                        </div>
                        
                        <div class="dept-info-item">
                            <div class="dept-info-label">Nombre de Membres</div>
                            <div class="dept-info-value"> <%= membres != null ? membres.size() : 0 %> personne(s)</div>
                        </div>

                        <% if (departement.getChefDepartement() != null) { %>
                        <div class="dept-info-item">
                            <div class="dept-info-label">Chef de Département</div>
                            <div class="dept-info-value">
                                👨‍💼 <%= departement.getChefDepartement().getPrenom() %> 
                                <%= departement.getChefDepartement().getNom() %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    
                    <!-- Description -->
                    <% if (departement.getDescription() != null && !departement.getDescription().isEmpty()) { %>
                        <div style="margin-top: 20px; padding: 15px; background: var(--card-bg); border-radius: 10px; border: 1px solid var(--border);">
                            <div class="dept-info-label" style="margin-bottom: 10px;">Description</div>
                            <p style="color: var(--text-secondary); line-height: 1.6; margin: 0;">
                                <%= departement.getDescription() %>
                            </p>
                        </div>
                    <% } %>
                    
                    <!-- Bouton retour -->
                    <div style="margin-top: 25px;">
                        <a href="<%= request.getContextPath() %>/departements?action=lister" class="btn btn-secondary">
                            ← Retour à la liste des départements
                        </a>
                    </div>
                </div>
            <% } %>

            <!-- Tableau des membres -->
            <% if (membres != null && !membres.isEmpty()) { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Matricule</th>
                                <th>Nom Complet</th>
                                <th>Poste</th>
                                <th>Grade</th>
                                <th>Email</th>
                                <th>Téléphone</th>
                                <th>Salaire</th>
                                <th>Date d'embauche</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            for (Employe membre : membres) { 
                                // Déterminer la classe du badge de grade
                                String gradeClass = "grade-junior";
                                String grade = membre.getGrade() != null ? membre.getGrade() : "INCONNU";
                                
                                switch(grade) {
                                    case "JUNIOR": gradeClass = "grade-junior"; break;
                                    case "CONFIRME": gradeClass = "grade-confirme"; break;
                                    case "SENIOR": gradeClass = "grade-senior"; break;
                                    case "EXPERT": gradeClass = "grade-expert"; break;
                                }
                            %>
                                <tr>
                                    <td>
                                        <strong style="color: var(--primary);"><%= membre.getMatricule() %></strong>
                                    </td>
                                    <td>
                                        <strong><%= membre.getPrenom() %> <%= membre.getNom() %></strong>
                                    </td>
                                    <td><%= membre.getPoste() %></td>
                                    <td>
                                        <span class="grade-badge <%= gradeClass %>">
                                            <%= grade %>
                                        </span>
                                    </td>
                                    <td style="color: var(--text-secondary);">
                                        <%= membre.getEmail() %>
                                    </td>
                                    <td style="color: var(--text-secondary);">
                                        <%= membre.getTelephone() != null ? membre.getTelephone() : "Non renseigné" %>
                                    </td>
                                    <td>
                                        <strong style="color: var(--success);">
                                            <%= String.format("%,.2f", membre.getSalaire()) %> €
                                        </strong>
                                    </td>
                                    <td style="color: var(--text-secondary);">
                                        <%= membre.getDateEmbauche() != null ? membre.getDateEmbauche().toString() : "Non renseigné" %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Statistiques en bas -->
                <div style="margin-top: 30px; padding: 20px; background: var(--card-bg); border-radius: 12px; border: 1px solid var(--border);">
                    <h3 style="color: var(--primary); margin-bottom: 15px; font-size: 1.1rem; font-weight: 700;">
                         Statistiques du Département
                    </h3>
                    
                    <%
                        // Calculer les statistiques
                        int nbJunior = 0, nbConfirme = 0, nbSenior = 0, nbExpert = 0;
                        double salaireTotal = 0;
                        
                        for (Employe m : membres) {
                            String g = m.getGrade() != null ? m.getGrade() : "";
                            switch(g) {
                                case "JUNIOR": nbJunior++; break;
                                case "CONFIRME": nbConfirme++; break;
                                case "SENIOR": nbSenior++; break;
                                case "EXPERT": nbExpert++; break;
                            }
                            salaireTotal += m.getSalaire();
                        }
                        
                        double salaireMoyen = membres.size() > 0 ? salaireTotal / membres.size() : 0;
                    %>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 15px;">
                        <div style="text-align: center; padding: 15px; background: rgba(6, 182, 212, 0.1); border-radius: 10px;">
                            <div style="font-size: 2rem; font-weight: 800; color: #06b6d4;"><%= nbJunior %></div>
                            <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">Junior</div>
                        </div>
                        
                        <div style="text-align: center; padding: 15px; background: rgba(139, 92, 246, 0.1); border-radius: 10px;">
                            <div style="font-size: 2rem; font-weight: 800; color: #8b5cf6;"><%= nbConfirme %></div>
                            <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">Confirmé</div>
                        </div>
                        
                        <div style="text-align: center; padding: 15px; background: rgba(16, 185, 129, 0.1); border-radius: 10px;">
                            <div style="font-size: 2rem; font-weight: 800; color: #10b981;"><%= nbSenior %></div>
                            <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">Senior</div>
                        </div>
                        
                        <div style="text-align: center; padding: 15px; background: rgba(245, 158, 11, 0.1); border-radius: 10px;">
                            <div style="font-size: 2rem; font-weight: 800; color: #f59e0b;"><%= nbExpert %></div>
                            <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">Expert</div>
                        </div>
                        
                        <div style="text-align: center; padding: 15px; background: rgba(16, 185, 129, 0.1); border-radius: 10px; grid-column: span 2;">
                            <div style="font-size: 1.5rem; font-weight: 800; color: #10b981;">
                                <%= String.format("%,.2f", salaireMoyen) %> €
                            </div>
                            <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">Salaire Moyen</div>
                        </div>
                    </div>
                </div>
                
            <% } else { %>
                <!-- État vide -->
                <div style="text-align: center; padding: 60px 20px; background: var(--card-bg); border-radius: 15px; border: 2px dashed var(--border);">
                    <div style="font-size: 4rem; margin-bottom: 20px; opacity: 0.3;">👥</div>
                    <h3 style="color: var(--text-secondary); margin-bottom: 15px; font-weight: 600;">
                        Aucun Membre
                    </h3>
                    <p style="color: var(--text-muted); margin-bottom: 25px;">
                        Ce département ne contient actuellement aucun membre.
                    </p>
                    <a href="<%= request.getContextPath() %>/departements?action=lister" class="btn btn-primary">
                        ← Retour à la liste des départements
                    </a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
