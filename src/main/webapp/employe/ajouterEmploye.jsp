<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    List<Departement> listeDepartements = (List<Departement>) request.getAttribute("listeDepartements");
    
    // Récupérer les erreurs de validation s'il y en a
    List<String> erreurs = (List<String>) request.getAttribute("erreurs");
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter un Employé - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script src="<%= request.getContextPath() %>/js/validation.js"></script>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>👥 Ajouter un Employé</h1>
            <p>RowTech - Gestion RH</p>
        </header>

        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            
            <% if (RoleHelper.canManageEmployes(session)) { %>
                <a href="<%= request.getContextPath() %>/employes?action=lister" class="active">👥 Employés</a>
            <% } %>
            
            <% if (RoleHelper.canManageDepartements(session)) { %>
                <a href="<%= request.getContextPath() %>/departements?action=lister">🏛️ Départements</a>
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
                    👤 <%= nomComplet %> (<%= userRole %>)
                </span>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                    🚪 Déconnexion
                </a>
            <% } %>
        </nav>

        <div class="content">
            <h2 class="page-title"> Nouvel Employé</h2>

            <!-- Affichage des erreurs de validation -->
            <% if (erreurs != null && !erreurs.isEmpty()) { %>
                <div class="alert alert-danger" style="margin-bottom: 20px;">
                    <strong>⚠️ Erreurs de validation :</strong>
                    <ul style="margin: 10px 0 0 20px;">
                        <% for (String erreur : erreurs) { %>
                            <li><%= erreur %></li>
                        <% } %>
                    </ul>
                </div>
            <% } %>

            <!-- Formulaire -->
            <form id="formEmploye" action="<%= request.getContextPath() %>/employes" method="post" 
                  style="max-width: 800px; margin: 20px auto;" onsubmit="return validerFormulaireEmploye(this)">
                
                <input type="hidden" name="action" value="ajouter">

                <!-- Informations personnelles -->
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend style="color: var(--text-primary); font-weight: 600; padding: 0 10px;"> Informations personnelles</legend>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Nom *</label>
                            <input type="text" name="nom" 
                                   value="<%= request.getParameter("nom") != null ? request.getParameter("nom") : "" %>" 
                                   placeholder="Dupont"
                                   required>
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Seulement des lettres, espaces, tirets et apostrophes
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Prénom *</label>
                            <input type="text" name="prenom" 
                                   value="<%= request.getParameter("prenom") != null ? request.getParameter("prenom") : "" %>" 
                                   placeholder="Jean"
                                   required>
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Seulement des lettres, espaces, tirets et apostrophes
                            </small>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Email *</label>
                            <input type="email" name="email" 
                                   value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" 
                                   placeholder="jean.dupont@example.com"
                                   required>
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Format : exemple@domaine.com
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Téléphone</label>
                            <input type="text" name="telephone" 
                                   value="<%= request.getParameter("telephone") != null ? request.getParameter("telephone") : "" %>" 
                                   placeholder="+33 1 23 45 67 89">
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Au moins 10 chiffres
                            </small>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Adresse</label>
                        <textarea name="adresse" rows="2" 
                                  placeholder="12 rue de la République, 75001 Paris"><%= request.getParameter("adresse") != null ? request.getParameter("adresse") : "" %></textarea>
                    </div>
                </fieldset>

                <!-- Informations professionnelles -->
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend style="color: var(--text-primary); font-weight: 600; padding: 0 10px;"> Informations professionnelles</legend>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Matricule *</label>
                            <input type="text" name="matricule" 
                                   value="<%= request.getParameter("matricule") != null ? request.getParameter("matricule") : "" %>" 
                                   placeholder="EMP-2025-001"
                                   required>
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Lettres majuscules, chiffres et tirets (3-20 caractères)
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Poste *</label>
                            <input type="text" name="poste" 
                                   value="<%= request.getParameter("poste") != null ? request.getParameter("poste") : "" %>" 
                                   placeholder="Développeur Java"
                                   required>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Grade *</label>
                            <select name="grade" required>
                                <option value="">-- Sélectionner un grade --</option>
                                <option value="JUNIOR">Junior</option>
                                <option value="CONFIRME">Confirmé</option>
                                <option value="SENIOR">Senior</option>
                                <option value="EXPERT">Expert</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Salaire (€) *</label>
                            <input type="number" name="salaire" step="0.01" 
                                   value="<%= request.getParameter("salaire") != null ? request.getParameter("salaire") : "" %>" 
                                   placeholder="3500.00"
                                   required>
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Entre 500€ et 1 000 000€
                            </small>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Date d'embauche *</label>
                            <input type="date" name="dateEmbauche" 
                                   value="<%= request.getParameter("dateEmbauche") != null ? request.getParameter("dateEmbauche") : "" %>" 
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Département</label>
                            <select name="departementId">
                                <option value="">-- Aucun département --</option>
                                <% if (listeDepartements != null) {
                                    for (Departement dept : listeDepartements) { %>
                                        <option value="<%= dept.getId() %>">
                                            <%= dept.getNom() %>
                                        </option>
                                <%  }
                                } %>
                            </select>
                        </div>
                    </div>
                </fieldset>

                <!-- Boutons d'action -->
                <div style="display: flex; gap: 10px; justify-content: center; margin-top: 30px;">
                    <button type="submit" class="btn btn-primary">
                        ➕ Ajouter l'employé
                    </button>
                    <a href="<%= request.getContextPath() %>/employes?action=lister" class="btn btn-secondary">
                        ❌ Annuler
                    </a>
                </div>
            </form>
        </div>

        <footer>
            <p>© 2025 RowTech</p>
        </footer>
    </div>

    <!-- Script pour activer la validation en temps réel -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('formEmploye');
            activerValidationTempsReel(form);
        });
    </script>
</body>
</html>