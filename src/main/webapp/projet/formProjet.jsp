<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    // Détecter si on est en mode création ou modification
    Projet projet = (Projet) request.getAttribute("projet");
    boolean isModification = (projet != null);
    
    String pageTitle = isModification ? "Modifier le Projet" : "Nouveau Projet";
    String action = isModification ? "modifier" : "creer";
    String buttonText = isModification ? "💾 Enregistrer les modifications" : "✅ Créer le projet";
    String buttonIcon = isModification ? "✏️" : "➕";
    
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
    %>
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - RowTech</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Header -->
        <header class="app-header">
            <h1><%= buttonIcon %> <%= pageTitle %></h1>
            <p>RowTech - Système de Gestion RH</p>
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
            <div class="actions" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--spacing-lg);">
                <h2 class="page-title"><%= buttonIcon %> <%= pageTitle %></h2>
                <a href="projets?action=lister" class="btn btn-secondary">← Retour à la liste</a>
            </div>

            <%
                String erreur = request.getParameter("erreur");
                if (erreur != null) {
            %>
                <div class="alert alert-danger">
                    ⚠️ 
                    <% if ("nom_vide".equals(erreur)) { %>
                        Le nom du projet est obligatoire !
                    <% } else if ("projet_introuvable".equals(erreur)) { %>
                        Projet introuvable !
                    <% } else if ("echec_creation".equals(erreur)) { %>
                        Échec de la création du projet.
                    <% } else if ("echec_modification".equals(erreur)) { %>
                        Échec de la modification du projet.
                    <% } else { %>
                        Une erreur s'est produite : <%= erreur %>
                    <% } %>
                </div>
            <%
                }
            %>

            <!-- Formulaire -->
            <div style="max-width: 800px; margin: 0 auto; background: var(--dark-light); border-radius: 16px; padding: var(--spacing-xl); border: 2px solid var(--border);">
                <form action="projets" method="post">
                    <input type="hidden" name="action" value="<%= action %>">
                    
                    <% if (isModification) { %>
                        <input type="hidden" name="id" value="<%= projet.getId() %>">
                    <% } %>
                    
                    <!-- Nom du projet -->
                    <div class="form-group">
                        <label for="nom" style="display: block; color: var(--text-primary); font-weight: 700; margin-bottom: 8px; font-size: 0.95rem;">
                            📁 Nom du Projet *
                        </label>
                        <input type="text" 
                               id="nom" 
                               name="nom" 
                               value="<%= isModification ? projet.getNom() : "" %>"
                               placeholder="Ex: Refonte Site Web, Migration Cloud, Application Mobile..."
                               required 
                               autofocus
                               style="width: 100%; padding: 12px; background: var(--dark); border: 2px solid var(--border); border-radius: 8px; color: var(--text-primary); font-size: 1rem;">
                        <small style="color: var(--text-muted); display: block; margin-top: 5px;">
                            Choisissez un nom clair et descriptif pour votre projet
                        </small>
                    </div>

                    <!-- Description -->
                    <div class="form-group" style="margin-top: var(--spacing-lg);">
                        <label for="description" style="display: block; color: var(--text-primary); font-weight: 700; margin-bottom: 8px; font-size: 0.95rem;">
                            📝 Description
                        </label>
                        <textarea 
                            id="description" 
                            name="description" 
                            rows="5"
                            placeholder="Décrivez les objectifs, le périmètre et les livrables attendus du projet..."
                            style="width: 100%; padding: 12px; background: var(--dark); border: 2px solid var(--border); border-radius: 8px; color: var(--text-primary); font-family: inherit; font-size: 1rem; resize: vertical; min-height: 120px;"
                        ><%= isModification && projet.getDescription() != null ? projet.getDescription() : "" %></textarea>
                        <small style="color: var(--text-muted); display: block; margin-top: 5px;">
                            Facultatif - Une bonne description aide l'équipe à comprendre les enjeux
                        </small>
                    </div>

                    <!-- Chef de Projet -->
                    <div class="form-group" style="margin-top: var(--spacing-lg);">
                        <label for="chefProjetId" style="display: block; color: var(--text-primary); font-weight: 700; margin-bottom: 8px; font-size: 0.95rem;">
                            👑 Chef de Projet
                        </label>
                        <select id="chefProjetId" name="chefProjetId"
                                style="width: 100%; padding: 12px; background: var(--dark); border: 2px solid var(--border); border-radius: 8px; color: var(--text-primary); font-size: 1rem;">
                            <option value="">-- Non assigné --</option>
                            <%
                                List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
                                Integer chefIdActuel = (isModification && projet.getChefDeProjet() != null) ? projet.getChefDeProjet().getId() : null;
                                
                                if (listeEmployes != null) {
                                    for (Employe emp : listeEmployes) {
                                        boolean selected = (chefIdActuel != null && chefIdActuel.equals(emp.getId()));
                            %>
                                <option value="<%= emp.getId() %>" <%= selected ? "selected" : "" %>>
                                    <%= emp.getMatricule() %> - <%= emp.getPrenom() %> <%= emp.getNom() %> (<%= emp.getPoste() %> - <%= emp.getGrade() %>)
                                </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <small style="color: var(--warning); display: block; margin-top: 5px;">
                            ⚠️ Le chef de projet sera automatiquement ajouté aux membres de l'équipe
                        </small>
                    </div>

                    <!-- Dates -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-lg); margin-top: var(--spacing-lg);">
                        <div class="form-group">
                            <label for="dateDebut" style="display: block; color: var(--text-primary); font-weight: 700; margin-bottom: 8px; font-size: 0.95rem;">
                                📅 Date de Début
                            </label>
                            <input type="date" 
                                   id="dateDebut" 
                                   name="dateDebut"
                                   value="<%= isModification && projet.getDateDebut() != null ? projet.getDateDebut().toString() : "" %>"
                                   style="width: 100%; padding: 12px; background: var(--dark); border: 2px solid var(--border); border-radius: 8px; color: var(--text-primary); font-size: 1rem;">
                        </div>

                        <div class="form-group">
                            <label for="dateFin" style="display: block; color: var(--text-primary); font-weight: 700; margin-bottom: 8px; font-size: 0.95rem;">
                                ⏰ Date de Fin (Échéance)
                            </label>
                            <input type="date" 
                                   id="dateFin" 
                                   name="dateFin"
                                   value="<%= isModification && projet.getDateFin() != null ? projet.getDateFin().toString() : "" %>"
                                   style="width: 100%; padding: 12px; background: var(--dark); border: 2px solid var(--border); border-radius: 8px; color: var(--text-primary); font-size: 1rem;">
                        </div>
                    </div>

                    <!-- État -->
                    <div class="form-group" style="margin-top: var(--spacing-lg);">
                        <label for="etat" style="display: block; color: var(--text-primary); font-weight: 700; margin-bottom: 8px; font-size: 0.95rem;">
                            🎯 État du Projet *
                        </label>
                        <select id="etat" name="etat" required
                                style="width: 100%; padding: 12px; background: var(--dark); border: 2px solid var(--border); border-radius: 8px; color: var(--text-primary); font-size: 1rem;">
                            <option value="EN_COURS" <%= isModification && "EN_COURS".equals(projet.getEtat()) ? "selected" : "" %>>
                                🔵 En Cours
                            </option>
                            <option value="TERMINE" <%= isModification && "TERMINE".equals(projet.getEtat()) ? "selected" : "" %>>
                                ✅ Terminé
                            </option>
                            <option value="ANNULE" <%= isModification && "ANNULE".equals(projet.getEtat()) ? "selected" : "" %>>
                                ❌ Annulé
                            </option>
                        </select>
                    </div>

                    <!-- Boutons d'action -->
                    <div style="display: flex; gap: var(--spacing-md); margin-top: var(--spacing-xl);">
                        <button type="submit" class="btn btn-primary" style="flex: 1; padding: 15px; font-size: 1.05rem; font-weight: 700;">
                            <%= buttonText %>
                        </button>
                        <a href="projets?action=lister" class="btn btn-secondary" style="flex: 1; padding: 15px; font-size: 1.05rem; text-align: center; text-decoration: none; display: flex; align-items: center; justify-content: center;">
                            ❌ Annuler
                        </a>
                    </div>
                </form>
            </div>

            <!-- Info box -->
            <% if (!isModification) { %>
            <div style="max-width: 800px; margin: var(--spacing-xl) auto 0; padding: var(--spacing-lg); background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.05) 100%); border: 2px solid rgba(99, 102, 241, 0.3); border-radius: 12px;">
                <h3 style="color: var(--primary-light); margin-bottom: var(--spacing-md); font-weight: 700; font-size: 1.2rem;">💡 Gestion de l'équipe</h3>
                <p style="color: var(--text-secondary); margin: 0; line-height: 1.7;">
                    Après avoir créé le projet, vous pourrez ajouter des membres à l'équipe en cliquant sur le bouton "👥 Équipe" dans la liste des projets, ou directement depuis la page de détails du projet.
                </p>
            </div>
            <% } else { %>
            <div style="max-width: 800px; margin: var(--spacing-xl) auto 0; padding: var(--spacing-lg); background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.05) 100%); border: 2px solid rgba(99, 102, 241, 0.3); border-radius: 12px;">
                <h3 style="color: var(--primary-light); margin-bottom: var(--spacing-md); font-weight: 700; font-size: 1.2rem;">💡 Gestion de l'équipe</h3>
                <p style="color: var(--text-secondary); margin-bottom: var(--spacing-md); line-height: 1.7;">
                    Pour ajouter ou retirer des membres de l'équipe du projet, utilisez le bouton ci-dessous ou accédez à la page de détails du projet.
                </p>
                <a href="projets?action=gererEquipe&id=<%= projet.getId() %>" class="btn btn-primary" style="padding: 12px 24px;">
                    👥 Gérer l'équipe du projet
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
