<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    List<Departement> listeDepartements = (List<Departement>) request.getAttribute("listeDepartements");
    List<Projet> listeProjets = (List<Projet>) request.getAttribute("listeProjets");
    Employe employe = (Employe) request.getAttribute("employe");
    
    // Récupérer les erreurs de validation s'il y en a
    List<String> erreurs = (List<String>) request.getAttribute("erreurs");
    
    if (employe == null) {
        response.sendRedirect(request.getContextPath() + "/employes?action=lister&erreur=employe_introuvable");
        return;
    }
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
            
            
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                    🚪 Déconnexion
                </a>
            
        </nav>

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
                
                <input type="hidden" name="action" value="modifier">
                <input type="hidden" name="id" value="<%= employe.getId() %>">

                <!-- Informations personnelles -->
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend style="color: var(--text-primary); font-weight: 600; padding: 0 10px;"> Informations personnelles</legend>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Nom *</label>
                            <input type="text" name="nom" 
                                   value="<%= employe.getNom() %>" 
                                   placeholder="Dupont"
                                   required>
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Seulement des lettres, espaces, tirets et apostrophes
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Prénom *</label>
                            <input type="text" name="prenom" 
                                   value="<%= employe.getPrenom() %>" 
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
                                   value="<%= employe.getEmail() %>" 
                                   placeholder="jean.dupont@example.com"
                                   required>
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Format : exemple@domaine.com
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Téléphone</label>
                            <input type="text" name="telephone" 
                                   value="<%= employe.getTelephone() != null ? employe.getTelephone() : "" %>" 
                                   placeholder="+33 1 23 45 67 89">
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Au moins 10 chiffres
                            </small>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Adresse</label>
                        <textarea name="adresse" rows="2" 
                                  placeholder="12 rue de la République, 75001 Paris"><%= employe.getAdresse() != null ? employe.getAdresse() : "" %></textarea>
                    </div>
                </fieldset>

                <!-- Informations professionnelles -->
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend style="color: var(--text-primary); font-weight: 600; padding: 0 10px;"> Informations professionnelles</legend>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Matricule * (non modifiable)</label>
                            <input type="text" name="matricule" 
                                   value="<%= employe.getMatricule() %>" 
                                   readonly
                                   style="background-color: var(--dark-light); cursor: not-allowed;"
                                   required>
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Le matricule ne peut pas être modifié
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Poste *</label>
                            <input type="text" name="poste" 
                                   value="<%= employe.getPoste() %>" 
                                   placeholder="Développeur Java"
                                   required>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Grade *</label>
                            <select name="grade" required>
                                <option value="">-- Sélectionner un grade --</option>
                                <option value="JUNIOR" <%= "JUNIOR".equals(employe.getGrade()) ? "selected" : "" %>>Junior</option>
                                <option value="CONFIRME" <%= "CONFIRME".equals(employe.getGrade()) ? "selected" : "" %>>Confirmé</option>
                                <option value="SENIOR" <%= "SENIOR".equals(employe.getGrade()) ? "selected" : "" %>>Senior</option>
                                <option value="EXPERT" <%= "EXPERT".equals(employe.getGrade()) ? "selected" : "" %>>Expert</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Salaire (€) *</label>
                            <input type="number" name="salaire" step="0.01" 
                                   value="<%= employe.getSalaire() %>" 
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
                                   value="<%= employe.getDateEmbauche() != null ? employe.getDateEmbauche().toString() : "" %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Département</label>
                            <select name="departementId">
                                <option value="">-- Aucun département --</option>
                                <% if (listeDepartements != null) {
                                    for (Departement dept : listeDepartements) { %>
                                        <option value="<%= dept.getId() %>" 
                                                <%= employe.getDepartement() != null && employe.getDepartement().getId().equals(dept.getId()) ? "selected" : "" %>>
                                            <%= dept.getNom() %>
                                        </option>
                                <%  }
                                } %>
                            </select>
                        </div>
                    </div>
                </fieldset>

                <!-- NOUVELLE SECTION: Affectation aux projets -->
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend style="color: var(--text-primary); font-weight: 600; padding: 0 10px;"> Affecter à des projets</legend>
                    
                    <% if (listeProjets != null && !listeProjets.isEmpty()) { %>
                        <div style="margin-bottom: 15px; padding: 15px; background: rgba(99, 102, 241, 0.1); border-left: 4px solid var(--primary); border-radius: 8px;">
                            <p style="color: var(--text-secondary); margin: 0; font-size: 0.9rem;">
                                💡 Cochez les projets auxquels vous souhaitez affecter cet employé. 
                                Les modifications seront appliquées lors de l'enregistrement.
                            </p>
                        </div>

                        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 15px;">
                            <% for (Projet projet : listeProjets) { 
                                
                                boolean estAffecte = employe.getProjets() != null && 
                                                     employe.getProjets().stream()
                                                     .anyMatch(p -> p.getId().equals(projet.getId()));
                            %>
                                <div style="padding: 15px; background: var(--dark-light); border-radius: 8px; border: 2px solid <%= estAffecte ? "var(--primary)" : "var(--border)" %>;">
                                    <label style="display: flex; align-items: start; cursor: pointer; gap: 12px;">
                                        <input type="checkbox" 
                                               name="projetIds" 
                                               value="<%= projet.getId() %>" 
                                               <%= estAffecte ? "checked" : "" %>
                                               style="margin-top: 3px; width: 18px; height: 18px; cursor: pointer;">
                                        <div style="flex: 1;">
                                            <div style="font-weight: 600; color: var(--text-primary); margin-bottom: 5px;">
                                                <%= projet.getNom() %>
                                            </div>
                                            
                                        </div>
                                    </label>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div style="text-align: center; padding: 40px; background: var(--dark-light); border-radius: 12px;">
                            <div style="font-size: 3rem; margin-bottom: 15px;">📁</div>
                            <p style="color: var(--text-muted); margin: 0;">
                                Aucun projet disponible. Créez d'abord des projets pour pouvoir y affecter des employés.
                            </p>
                        </div>
                    <% } %>
                </fieldset>

                <!-- Boutons d'action -->
                <div style="display: flex; gap: 10px; justify-content: center; margin-top: 30px;">
                    <button type="submit" class="btn btn-primary">
                         Enregistrer les modifications
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
            if (typeof activerValidationTempsReel === 'function') {
                activerValidationTempsReel(form);
            }
        });
    </script>
</body>
</html>
