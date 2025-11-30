<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="java.util.List" %>
<%
    // Détection du mode : création ou modification
    Departement departement = (Departement) request.getAttribute("departement");
    boolean modeModification = (departement != null);
    
    // Liste des employés pour le select du chef
    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
    
    // Valeurs par défaut en mode création
    String nom = modeModification ? departement.getNom() : "";
    String description = modeModification ? (departement.getDescription() != null ? departement.getDescription() : "") : "";
    Integer chefId = modeModification && departement.getChefDepartement() != null ? departement.getChefDepartement().getId() : null;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= modeModification ? "Modifier" : "Nouveau" %> Département - RowTech</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🏛️ <%= modeModification ? "Modifier" : "Nouveau" %> Département</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <nav class="nav-menu">
            <a href="${pageContext.request.contextPath}/accueil.jsp">🏠 Accueil</a>
            <a href="${pageContext.request.contextPath}/employes?action=lister">👥 Employés</a>
            <a href="${pageContext.request.contextPath}/departements?action=lister" class="active">🏛️ Départements</a>
            <a href="${pageContext.request.contextPath}/projets?action=lister">📁 Projets</a>
            <a href="${pageContext.request.contextPath}/fichesDePaie?action=lister">💰 Fiches de Paie</a>
            <a href="${pageContext.request.contextPath}/statistiques?action=afficher">📊 Statistiques</a>
            
            <%
                String nomComplet = (String) session.getAttribute("nomComplet");
                String userRole = (String) session.getAttribute("userRole");
                
                if (nomComplet != null) {
            %>
                <span style="margin-left: auto;"> <%= nomComplet %> (<%= userRole %>)</span>
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-danger"> Déconnexion</a>
            <%
                } else {
            %>
                <a href="${pageContext.request.contextPath}/auth.jsp"> Connexion</a>
            <%
                }
            %>
        </nav>

        <div class="content">
            <h2 class="page-title"><%= modeModification ? "✏️ Modifier" : "➕ Créer" %> un Département</h2>

            <form action="${pageContext.request.contextPath}/departements" method="post" style="max-width: 700px; margin: 0 auto;">
                <input type="hidden" name="action" value="<%= modeModification ? "modifier" : "ajouter" %>">
                <% if (modeModification) { %>
                    <input type="hidden" name="id" value="<%= departement.getId() %>">
                <% } %>
                
                <!-- Nom du département -->
                <div class="form-group">
                    <label for="nom">Nom du département *</label>
                    <input type="text" id="nom" name="nom" value="<%= nom %>" 
                           placeholder="Ex: Ressources Humaines, Informatique, Finance..." required autofocus>
                    <small style="color: var(--text-muted); display: block; margin-top: 5px;">
                        Le nom du département doit être unique
                    </small>
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="4" 
                              placeholder="Décrivez les missions et responsabilités de ce département..."><%= description %></textarea>
                    <small style="color: var(--text-muted); display: block; margin-top: 5px;">
                         Optionnel - Maximum 500 caractères
                    </small>
                </div>

                <!-- Chef de département -->
                <div class="form-group" style="background: linear-gradient(135deg, rgba(99, 102, 241, 0.05) 0%, rgba(99, 102, 241, 0.02) 100%); padding: var(--spacing-lg); border-radius: 12px; border: 2px solid rgba(99, 102, 241, 0.2);">
                    <label for="chefDepartementId" style="display: flex; align-items: center; gap: 8px; font-weight: 700; color: var(--primary-light);">
                        <span style="font-size: 1.3em;"></span>
                        Chef de département
                    </label>
                    <select id="chefDepartementId" name="chefDepartementId" style="margin-top: var(--spacing-sm);">
                        <option value="">-- Aucun chef désigné --</option>
                        <%
                            if (listeEmployes != null && !listeEmployes.isEmpty()) {
                                for (Employe emp : listeEmployes) {
                                    boolean estChef = modeModification && chefId != null && chefId.equals(emp.getId());
                                    String selected = estChef ? "selected" : "";
                        %>
                            <option value="<%= emp.getId() %>" <%= selected %>>
                                <%= emp.getPrenom() %> <%= emp.getNom() %> 
                                - <%= emp.getPoste() != null ? emp.getPoste() : "N/A" %>
                                <% if (emp.getDepartement() != null) { %>
                                    (<%= emp.getDepartement().getNom() %>)
                                <% } %>
                            </option>
                        <%
                                }
                            } else {
                        %>
                            <option value="" disabled>Aucun employé disponible</option>
                        <%
                            }
                        %>
                    </select>
                    <small style="color: var(--text-muted); display: block; margin-top: 8px;">
                        Le chef de département sera responsable de la gestion et du suivi de l'équipe
                    </small>
                    
                    <!-- Info visuelle si chef désigné en mode modification -->
                    <% if (modeModification && departement.getChefDepartement() != null) { %>
                        <div style="margin-top: var(--spacing-md); padding: var(--spacing-md); background: rgba(16, 185, 129, 0.1); border-left: 4px solid var(--success); border-radius: 8px;">
                            <strong style="color: var(--success);">✓ Chef actuel :</strong> 
                            <%= departement.getChefDepartement().getPrenom() %> <%= departement.getChefDepartement().getNom() %>
                        </div>
                    <% } %>
                </div>

                <!-- Boutons d'action -->
                <div style="display: flex; gap: var(--spacing-sm); margin-top: var(--spacing-xl);">
                    <button type="submit" class="btn btn-primary" style="flex: 1;">
                        <%= modeModification ? " Enregistrer les modifications" : "Créer le département" %>
                    </button>
                    <a href="${pageContext.request.contextPath}/departements?action=lister" class="btn btn-secondary" style="flex: 1;">
                         Annuler
                    </a>
                </div>
            </form>

            
            
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
