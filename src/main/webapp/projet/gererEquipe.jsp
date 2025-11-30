<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    List<Employe> employesDisponibles = (List<Employe>) request.getAttribute("employesDisponibles");
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    
    Set<Employe> membresActuels = projet.getEmployes();
    int nbMembres = membresActuels != null ? membresActuels.size() : 0;
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
    <title>Gérer l'Équipe - <%= projet.getNom() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .team-section {
            background: var(--dark-light);
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid var(--border);
        }
        
        .team-section h3 {
            color: var(--primary-light);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
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
        
        .btn-remove {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-remove:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
        }
        
        .add-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .add-form select {
            flex: 1;
            min-width: 250px;
            padding: 12px 15px;
            border-radius: 10px;
            border: 2px solid var(--border);
            background: var(--dark);
            color: var(--text-primary);
            font-size: 1rem;
        }
        
        .add-form select:focus {
            border-color: var(--primary);
            outline: none;
        }
        
        .btn-add {
            background: linear-gradient(135deg, var(--success) 0%, #059669 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-muted);
        }
        
        .chef-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: linear-gradient(135deg, var(--accent) 0%, #d4a800 100%);
            color: #000;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.75rem;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1> Gérer l'Équipe</h1>
            <p><%= projet.getNom() %> - RowTech</p>
        </header>

        <!-- NAVBAR EMPLOYÉ CORRECTE -->
        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
            <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="active">📁 Mes Projets</a>
            <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
            
            <% if (RoleHelper.canViewStatistics(session)) { %>
                <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                 <%= nomComplet %> (<%= userRole %>)
            </span>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                 Déconnexion
            </a>
        </nav>

        <div class="content">
            <!-- Messages -->
            <% if ("membre_ajoute".equals(message)) { %>
                <div class="alert alert-success">✅ Le membre a été ajouté avec succès !</div>
            <% } else if ("membre_retire".equals(message)) { %>
                <div class="alert alert-success">✅ Le membre a été retiré du projet.</div>
            <% } %>
            
            <% if (erreur != null) { %>
                <div class="alert alert-danger">⚠️ Erreur : <%= erreur %></div>
            <% } %>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                <h2 class="page-title"> Gestion de l'Équipe - <%= projet.getNom() %></h2>
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="btn btn-secondary">
                    ← Retour
                </a>
            </div>

            <!-- Chef de projet -->
            <div class="team-section">
                <h3> Chef de Projet</h3>
                <% if (projet.getChefDeProjet() != null) { %>
                    <div style="display: flex; align-items: center; gap: 15px; padding: 15px; background: var(--dark); border-radius: 10px;">
                        <div style="width: 50px; height: 50px; background: var(--accent); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                            
                        </div>
                        <div>
                            <strong style="color: var(--text-primary); font-size: 1.1rem;">
                                <%= projet.getChefDeProjet().getPrenom() %> <%= projet.getChefDeProjet().getNom() %>
                            </strong>
                            <p style="color: var(--text-muted); margin: 5px 0 0 0;">
                                <%= projet.getChefDeProjet().getPoste() != null ? projet.getChefDeProjet().getPoste() : "N/A" %>
                                - <%= projet.getChefDeProjet().getDepartement() != null ? projet.getChefDeProjet().getDepartement().getNom() : "N/A" %>
                            </p>
                        </div>
                        <span class="chef-badge" style="margin-left: auto;"> Chef</span>
                    </div>
                <% } else { %>
                    <p style="color: var(--text-muted);">Aucun chef de projet assigné</p>
                <% } %>
            </div>

            <!-- Membres actuels -->
            <div class="team-section">
                <h3> Membres Actuels (<%= nbMembres %>)</h3>
                
                <% if (membresActuels != null && !membresActuels.isEmpty()) { %>
                    <div style="overflow-x: auto;">
                        <table class="membres-table">
                            <thead>
                                <tr>
                                    <th>Matricule</th>
                                    <th>Nom Complet</th>
                                    <th>Poste</th>
                                    <th>Département</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Employe membre : membresActuels) { %>
                                    <tr>
                                        <td><%= membre.getMatricule() != null ? membre.getMatricule() : "N/A" %></td>
                                        <td><strong><%= membre.getPrenom() %> <%= membre.getNom() %></strong></td>
                                        <td><%= membre.getPoste() != null ? membre.getPoste() : "N/A" %></td>
                                        <td><%= membre.getDepartement() != null ? membre.getDepartement().getNom() : "N/A" %></td>
                                        <td>
                                            <form action="<%= request.getContextPath() %>/mesProjets" method="post" style="display: inline;" 
                                                  onsubmit="return confirm('Êtes-vous sûr de vouloir retirer ce membre ?');">
                                                <input type="hidden" name="action" value="retirerMembre">
                                                <input type="hidden" name="projetId" value="<%= projet.getId() %>">
                                                <input type="hidden" name="employeId" value="<%= membre.getId() %>">
                                                <button type="submit" class="btn-remove"> Retirer</button>
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <div style="font-size: 60px; margin-bottom: 15px; opacity: 0.5;"></div>
                        <p>Aucun membre dans ce projet. Ajoutez des membres ci-dessous.</p>
                    </div>
                <% } %>
            </div>

            <!-- Ajouter un membre -->
            <div class="team-section">
                <h3>➕ Ajouter un Membre</h3>
                
                <% if (employesDisponibles != null && !employesDisponibles.isEmpty()) { %>
                    <form action="<%= request.getContextPath() %>/mesProjets" method="post" class="add-form">
                        <input type="hidden" name="action" value="ajouterMembre">
                        <input type="hidden" name="projetId" value="<%= projet.getId() %>">
                        
                        <select name="employeId" required>
                            <option value="">-- Sélectionner un employé --</option>
                            <% for (Employe emp : employesDisponibles) { %>
                                <option value="<%= emp.getId() %>">
                                    <%= emp.getPrenom() %> <%= emp.getNom() %> 
                                    (<%= emp.getPoste() != null ? emp.getPoste() : "N/A" %>) 
                                    - <%= emp.getDepartement() != null ? emp.getDepartement().getNom() : "N/A" %>
                                </option>
                            <% } %>
                        </select>
                        
                        <button type="submit" class="btn-add">➕ Ajouter au projet</button>
                    </form>
                <% } else { %>
                    <p style="color: var(--text-muted); text-align: center; padding: 20px;">
                         Tous les employés disponibles sont déjà membres de ce projet !
                    </p>
                <% } %>
            </div>

            <!-- Boutons d'action -->
            <div style="margin-top: 25px; display: flex; gap: 12px; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="btn btn-secondary">
                    ← Retour à mes projets
                </a>
                <a href="<%= request.getContextPath() %>/mesProjets?action=detail&id=<%= projet.getId() %>" class="btn btn-info">
                     Détails du projet
                </a>
                <a href="<%= request.getContextPath() %>/mesProjets?action=fichesPaieEquipe&id=<%= projet.getId() %>" class="btn btn-warning">
                     Fiches de paie équipe
                </a>
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
