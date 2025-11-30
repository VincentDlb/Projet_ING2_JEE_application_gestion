<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    
    // État actuel du projet
    String etatActuel = projet.getEtat() != null ? projet.getEtat() : "EN_COURS";
    
    // Chef de projet actuel
    Integer chefActuelId = projet.getChefDeProjet() != null ? projet.getChefDeProjet().getId() : null;
    
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
    <title>Modifier - <%= projet.getNom() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .form-section {
            background: var(--dark-light);
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 25px;
            border: 1px solid var(--border);
        }
        
        .form-section h3 {
            color: var(--primary-light);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            color: var(--text-secondary);
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 14px 16px;
            border-radius: 10px;
            border: 2px solid var(--border);
            background: var(--dark);
            color: var(--text-primary);
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: var(--primary);
            outline: none;
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid var(--border);
        }
        
        .btn-submit {
            background: linear-gradient(135deg, var(--primary) 0%, #4f46e5 100%);
            color: white;
            border: none;
            padding: 14px 30px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 700;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
        }
        
        .etat-options {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .etat-option {
            flex: 1;
            min-width: 150px;
        }
        
        .etat-option input[type="radio"] {
            display: none;
        }
        
        .etat-option label {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 15px;
            border: 2px solid var(--border);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
        }
        
        .etat-option input[type="radio"]:checked + label {
            border-color: var(--primary);
            background: rgba(99, 102, 241, 0.1);
        }
        
        .etat-option.en-cours input[type="radio"]:checked + label {
            border-color: #3b82f6;
            background: rgba(59, 130, 246, 0.1);
        }
        
        .etat-option.termine input[type="radio"]:checked + label {
            border-color: var(--success);
            background: rgba(16, 185, 129, 0.1);
        }
        
        .etat-option.annule input[type="radio"]:checked + label {
            border-color: #ef4444;
            background: rgba(239, 68, 68, 0.1);
        }
        
        .info-box {
            background: rgba(59, 130, 246, 0.1);
            border: 1px solid rgba(59, 130, 246, 0.3);
            border-radius: 10px;
            padding: 15px;
            margin-top: 10px;
        }
        
        .info-box p {
            margin: 0;
            color: var(--text-secondary);
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>✏️ Modifier le Projet</h1>
            <p><%= projet.getNom() %> - RowTech</p>
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
                
                <a href="<%= request.getContextPath() %>/projets?action=lister" class="active">📊 Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister">💰 Fiches de Paie</a>
                
                <% if (RoleHelper.canViewStatistics(session)) { %>
                    <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
                <% } %>
            <% } else { %>
                <!-- Navigation EMPLOYÉ / CHEF -->
                <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="active">📊 Mes Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
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
            <% } %>
            
            <% if (erreur != null) { %>
                <div class="alert alert-danger">⚠️ Erreur : <%= erreur %></div>
            <% } %>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                <h2 class="page-title">Modifier - <%= projet.getNom() %></h2>
                <a href="<%= request.getContextPath() %>/projets?action=lister" class="btn btn-secondary">
                    ← Retour
                </a>
            </div>

            <!-- Formulaire -->
            <form action="<%= request.getContextPath() %>/projets" method="post">
                <input type="hidden" name="action" value="modifier">
                <input type="hidden" name="id" value="<%= projet.getId() %>">
                
                <div class="form-section">
                    <h3>Informations du Projet</h3>
                    
                    <div class="form-group">
                        <label for="nom"> Nom du projet *</label>
                        <input type="text" id="nom" name="nom" value="<%= projet.getNom() %>" required 
                               placeholder="Entrez le nom du projet">
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" 
                                  placeholder="Décrivez le projet..."><%= projet.getDescription() != null ? projet.getDescription() : "" %></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="dateDebut">Date de début</label>
                            <input type="date" id="dateDebut" name="dateDebut" 
                                   value="<%= projet.getDateDebut() != null ? projet.getDateDebut().toString() : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="dateFin"> Date de fin prévue</label>
                            <input type="date" id="dateFin" name="dateFin" 
                                   value="<%= projet.getDateFin() != null ? projet.getDateFin().toString() : "" %>">
                        </div>
                    </div>
                </div>

                <!-- NOUVELLE SECTION: Chef de Projet -->
                <div class="form-section">
                    <h3>Chef de Projet</h3>
                    
                    <div class="form-group">
                        <label for="chefProjetId"> Désigner un chef de projet</label>
                        <select id="chefProjetId" name="chefProjetId">
                            <option value="">-- Aucun chef de projet --</option>
                            <% if (listeEmployes != null) {
                                for (Employe emp : listeEmployes) { %>
                                    <option value="<%= emp.getId() %>" 
                                            <%= chefActuelId != null && chefActuelId.equals(emp.getId()) ? "selected" : "" %>>
                                        <%= emp.getMatricule() %> - <%= emp.getPrenom() %> <%= emp.getNom() %>
                                        <% if (emp.getDepartement() != null) { %>
                                            (<%= emp.getDepartement().getNom() %>)
                                        <% } %>
                                    </option>
                            <%  }
                            } %>
                        </select>
                        
                        
                    </div>
                </div>

                <div class="form-section">
                    <h3> État du Projet</h3>
                    
                    <div class="etat-options">
                        <div class="etat-option en-cours">
                            <input type="radio" id="etat_encours" name="etat" value="EN_COURS" 
                                   <%= "EN_COURS".equals(etatActuel) ? "checked" : "" %>>
                            <label for="etat_encours">🔵 En cours</label>
                        </div>
                        
                        <div class="etat-option termine">
                            <input type="radio" id="etat_termine" name="etat" value="TERMINE" 
                                   <%= "TERMINE".equals(etatActuel) ? "checked" : "" %>>
                            <label for="etat_termine">✅ Terminé</label>
                        </div>
                        
                        <div class="etat-option annule">
                            <input type="radio" id="etat_annule" name="etat" value="ANNULE" 
                                   <%= "ANNULE".equals(etatActuel) ? "checked" : "" %>>
                            <label for="etat_annule">❌ Annulé</label>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                         Enregistrer les modifications
                    </button>
                    <a href="<%= request.getContextPath() %>/projets?action=detail&id=<%= projet.getId() %>" class="btn btn-secondary">
                        Annuler
                    </a>
                </div>
            </form>

            
            
        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>