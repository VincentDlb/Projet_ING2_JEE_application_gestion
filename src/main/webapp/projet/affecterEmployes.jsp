<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    List<Employe> tousLesEmployes = (List<Employe>) request.getAttribute("tousLesEmployes");
    
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
   
    if (projet == null) {
        response.sendRedirect("projets?action=lister&erreur=projet_introuvable");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gérer l'Équipe - <%= projet.getNom() %></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Header -->
        <header class="app-header">
            <h1>👥 Gérer l'Équipe du Projet</h1>
            <p><%= projet.getNom() %> - RowTech</p>
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
                <h2 class="page-title">👥 Gérer l'Équipe</h2>
                <div style="display: flex; gap: 10px;">
                    <a href="projets?action=detail&id=<%= projet.getId() %>" class="btn btn-secondary">📄 Détails Projet</a>
                    <a href="projets?action=lister" class="btn btn-secondary">← Retour</a>
                </div>
            </div>

            <%
                String message = request.getParameter("message");
                String erreur = request.getParameter("erreur");
                
                if ("affectation_ok".equals(message)) {
            %>
                <div class="alert alert-success">✅ Employé ajouté avec succès à l'équipe !</div>
            <%
                } else if ("retrait_ok".equals(message)) {
            %>
                <div class="alert alert-success">✅ Employé retiré de l'équipe !</div>
            <%
                } else if (erreur != null) {
            %>
                <div class="alert alert-danger">⚠️ Erreur : <%= erreur %></div>
            <%
                }
            %>

            <!-- Info projet -->
            <div style="background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.05) 100%); padding: var(--spacing-md); border-radius: 12px; margin-bottom: var(--spacing-lg); border: 2px solid rgba(99, 102, 241, 0.3);">
                <h3 style="color: var(--primary-light); margin-bottom: 10px; font-size: 1.2rem; font-weight: 700;">
                    📁 <%= projet.getNom() %>
                </h3>
                <% if (projet.getDescription() != null && !projet.getDescription().trim().isEmpty()) { %>
                <p style="margin: 0; color: var(--text-secondary); line-height: 1.6;">
                    <%= projet.getDescription() %>
                </p>
                <% } %>
                <div style="margin-top: var(--spacing-sm); display: flex; gap: var(--spacing-md); flex-wrap: wrap;">
                    <span class="badge badge-primary">👥 <%= projet.getEmployes().size() %> membre(s)</span>
                    <% if (projet.getChefDeProjet() != null) { %>
                    <span class="badge badge-warning">👑 Chef: <%= projet.getChefDeProjet().getPrenom() %> <%= projet.getChefDeProjet().getNom() %></span>
                    <% } %>
                </div>
            </div>

            <!-- Grille à 2 colonnes -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: var(--spacing-xl); margin-top: var(--spacing-xl);">
                
                <!-- COLONNE GAUCHE : Équipe actuelle -->
                <div style="background: var(--dark-light); border-radius: 16px; padding: var(--spacing-lg); border: 2px solid var(--border);">
                    <h3 style="color: var(--primary-light); margin-bottom: var(--spacing-md); font-size: 1.3rem; font-weight: 700; display: flex; align-items: center; gap: 10px;">
                        👥 Équipe Actuelle
                        <span class="badge badge-primary" style="font-size: 0.9rem; padding: 6px 12px;">
                            <%= projet.getEmployes().size() %>
                        </span>
                    </h3>
                    
                    <% if (projet.getEmployes().isEmpty()) { %>
                        <div style="padding: var(--spacing-xl); text-align: center; background: var(--dark); border-radius: 12px; border: 2px dashed var(--border);">
                            <div style="font-size: 60px; margin-bottom: 15px; opacity: 0.5;">👥</div>
                            <p style="color: var(--text-muted); margin: 0; font-weight: 600;">Aucun membre dans l'équipe</p>
                            <small style="color: var(--text-muted); display: block; margin-top: 8px;">Ajoutez des employés pour démarrer</small>
                        </div>
                    <% } else { %>
                        <div style="display: flex; flex-direction: column; gap: 12px; max-height: 600px; overflow-y: auto; padding-right: 8px;">
                            <%
                                for (Employe emp : projet.getEmployes()) {
                                    boolean isChef = (projet.getChefDeProjet() != null && 
                                                     emp.getId().equals(projet.getChefDeProjet().getId()));
                            %>
                                <div style="display: flex; justify-content: space-between; align-items: center; padding: 15px; background: <%= isChef ? "linear-gradient(135deg, rgba(251, 191, 36, 0.15) 0%, rgba(251, 191, 36, 0.05) 100%)" : "var(--dark)" %>; border-radius: 12px; border: 2px solid <%= isChef ? "rgba(251, 191, 36, 0.3)" : "var(--border)" %>;">
                                    <div style="flex: 1;">
                                        <div style="font-weight: 700; color: var(--text-primary); font-size: 1rem; margin-bottom: 5px;">
                                            <%= isChef ? "👑" : "👤" %> <%= emp.getPrenom() %> <%= emp.getNom() %>
                                            <% if (isChef) { %>
                                                <span style="color: #fbbf24; font-size: 0.85rem; margin-left: 5px;">(Chef)</span>
                                            <% } %>
                                        </div>
                                        <div style="font-size: 0.85rem; color: var(--text-muted);">
                                            💼 <%= emp.getPoste() %> • 🏆 <%= emp.getGrade() %>
                                        </div>
                                    </div>
                                    <% if (!isChef) { %>
                                    <form action="projets" method="post" style="margin: 0;">
                                        <input type="hidden" name="action" value="retirerEmploye">
                                        <input type="hidden" name="projetId" value="<%= projet.getId() %>">
                                        <input type="hidden" name="employeId" value="<%= emp.getId() %>">
                                        <button type="submit" class="btn btn-danger" 
                                                style="padding: 8px 14px; font-size: 0.85rem;"
                                                onclick="return confirm('⚠️ Retirer <%= emp.getPrenom() %> <%= emp.getNom() %> de l\'équipe ?');">
                                            ❌ Retirer
                                        </button>
                                    </form>
                                    <% } else { %>
                                    <span class="badge badge-warning" style="font-size: 0.8rem; padding: 6px 12px;">Chef de Projet</span>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>

                <!-- COLONNE DROITE : Employés disponibles -->
                <div style="background: var(--dark-light); border-radius: 16px; padding: var(--spacing-lg); border: 2px solid var(--border);">
                    <h3 style="color: var(--success); margin-bottom: var(--spacing-md); font-size: 1.3rem; font-weight: 700;">
                        ➕ Ajouter des Employés
                    </h3>
                    
                    <% 
                        // Filtrer les employés déjà affectés
                        Set<Employe> employesDuProjet = projet.getEmployes();
                        boolean hasEmployesDisponibles = false;
                        for (Employe emp : tousLesEmployes) {
                            if (!employesDuProjet.contains(emp)) {
                                hasEmployesDisponibles = true;
                                break;
                            }
                        }
                    %>
                    
                    <% if (!hasEmployesDisponibles) { %>
                        <div style="padding: var(--spacing-xl); text-align: center; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1) 0%, rgba(16, 185, 129, 0.05) 100%); border-radius: 12px; border: 2px dashed rgba(16, 185, 129, 0.3);">
                            <div style="font-size: 60px; margin-bottom: 15px; opacity: 0.6;">✅</div>
                            <p style="color: var(--success); margin: 0; font-weight: 700; font-size: 1.1rem;">Tous les employés sont affectés !</p>
                            <small style="color: var(--text-muted); display: block; margin-top: 8px;">Tous les employés disponibles font déjà partie de l'équipe</small>
                        </div>
                    <% } else { %>
                        <div style="display: flex; flex-direction: column; gap: 12px; max-height: 600px; overflow-y: auto; padding-right: 8px;">
                            <% for (Employe emp : tousLesEmployes) { %>
                                <% if (!employesDuProjet.contains(emp)) { %>
                                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 15px; background: var(--dark); border-radius: 12px; border: 2px solid var(--border); transition: all 0.3s ease;" 
                                         onmouseover="this.style.borderColor='var(--success)'" 
                                         onmouseout="this.style.borderColor='var(--border)'">
                                        <div style="flex: 1;">
                                            <div style="font-weight: 700; color: var(--text-primary); font-size: 1rem; margin-bottom: 5px;">
                                                👤 <%= emp.getPrenom() %> <%= emp.getNom() %>
                                            </div>
                                            <div style="font-size: 0.85rem; color: var(--text-muted);">
                                                💼 <%= emp.getPoste() %> • 🏆 <%= emp.getGrade() %>
                                            </div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 3px;">
                                                📧 <%= emp.getEmail() != null ? emp.getEmail() : "N/A" %>
                                            </div>
                                        </div>
                                        <form action="projets" method="post" style="margin: 0;">
                                            <input type="hidden" name="action" value="ajouterEmploye">
                                            <input type="hidden" name="projetId" value="<%= projet.getId() %>">
                                            <input type="hidden" name="employeId" value="<%= emp.getId() %>">
                                            <button type="submit" class="btn btn-success" 
                                                    style="padding: 8px 14px; font-size: 0.85rem;">
                                                ➕ Ajouter
                                            </button>
                                        </form>
                                    </div>
                                <% } %>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Actions finales -->
            <div style="margin-top: var(--spacing-xl); display: flex; gap: 10px; justify-content: center;">
                <a href="projets?action=detail&id=<%= projet.getId() %>" class="btn btn-secondary">
                    📄 Voir les Détails du Projet
                </a>
                <a href="projets?action=lister" class="btn btn-primary">
                    📁 Retour aux Projets
                </a>
            </div>
        </div>

        <!-- Footer -->
        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
