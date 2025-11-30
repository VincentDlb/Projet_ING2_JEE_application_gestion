<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
    
    // Récupérer les erreurs de validation s'il y en a
    List<String> erreurs = (List<String>) request.getAttribute("erreurs");
    String erreur = request.getParameter("erreur");
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Créer Fiche de Paie - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script src="<%= request.getContextPath() %>/js/validation.js"></script>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>💰 Créer une Fiche de Paie</h1>
            <p>RowTech - Gestion RH</p>
        </header>

        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            
            <% if (RoleHelper.canManageEmployes(session)) { %>
                <a href="<%= request.getContextPath() %>/employes?action=lister">👥 Employés</a>
            <% } %>
            
            <% if (RoleHelper.canManageDepartements(session)) { %>
                <a href="<%= request.getContextPath() %>/departements?action=lister">🏛️ Départements</a>
            <% } %>
            
            <% if (RoleHelper.canManageProjets(session)) { %>
                <a href="<%= request.getContextPath() %>/projets?action=lister">📁 Projets</a>
            <% } %>
            
            <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister" class="active">💰 Fiches de Paie</a>
            
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
            <h2 class="page-title">Nouvelle Fiche de Paie</h2>

            <!-- Affichage des erreurs de validation -->
            <% if (erreurs != null && !erreurs.isEmpty()) { %>
                <div class="alert alert-danger" style="margin-bottom: 20px;">
                    <strong>⚠️ Erreurs de validation :</strong>
                    <ul style="margin: 10px 0 0 20px;">
                        <% for (String err : erreurs) { %>
                            <li><%= err %></li>
                        <% } %>
                    </ul>
                </div>
            <% } %>
            
            <!-- Affichage des erreurs via paramètre -->
            <% if (erreur != null) { %>
                <div class="alert alert-danger" style="margin-bottom: 20px;">
                    <strong>⚠️ Erreur :</strong>
                    <% if ("employe_introuvable".equals(erreur)) { %>
                        L'employé sélectionné n'existe pas.
                    <% } else if ("fiche_existe".equals(erreur)) { %>
                        Une fiche de paie existe déjà pour cet employé et cette période.
                    <% } else if ("echec_ajout".equals(erreur)) { %>
                        Échec de la création de la fiche de paie.
                    <% } else { %>
                        <%= erreur %>
                    <% } %>
                </div>
            <% } %>

            <% if (listeEmployes == null || listeEmployes.isEmpty()) { %>
                <div style="padding: 20px; background: #dc2626; color: white; border-radius: 8px; margin: 20px 0;">
                    ⚠️ ERREUR : Aucun employé disponible dans la base de données.
                </div>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister" class="btn btn-secondary">← Retour</a>
            <% } else { %>

            <form id="formFichePaie" action="<%= request.getContextPath() %>/fichesDePaie" method="post" 
                  style="max-width: 700px; margin: 20px auto;" onsubmit="return validerFormulaireFichePaie(this)">
                
                <!-- Action corrigée : utiliser "ajouter" -->
                <input type="hidden" name="action" value="ajouter">
                
                <!-- Sélection employé et période -->
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend style="color: var(--text-primary); font-weight: 600; padding: 0 10px;">👤 Employé et Période</legend>
                    
                    <div class="form-group">
                        <label>Employé * (<%= listeEmployes.size() %> disponibles)</label>
                        <select name="employeId" required>
                            <option value="">-- Sélectionner un employé --</option>
                            <% for (Employe emp : listeEmployes) { %>
                                <option value="<%= emp.getId() %>">
                                    <%= emp.getMatricule() %> - <%= emp.getPrenom() %> <%= emp.getNom() %> (Salaire: <%= String.format("%.2f", emp.getSalaire()) %>€)
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Mois *</label>
                            <select name="mois" required>
                                <option value="">--</option>
                                <option value="1">Janvier</option>
                                <option value="2">Février</option>
                                <option value="3">Mars</option>
                                <option value="4">Avril</option>
                                <option value="5">Mai</option>
                                <option value="6">Juin</option>
                                <option value="7">Juillet</option>
                                <option value="8">Août</option>
                                <option value="9">Septembre</option>
                                <option value="10">Octobre</option>
                                <option value="11">Novembre</option>
                                <option value="12">Décembre</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Année *</label>
                            <input type="number" name="annee" value="2025" min="2020" max="2030" required>
                        </div>
                    </div>
                </fieldset>

                <!-- Rémunération -->
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend style="color: var(--text-primary); font-weight: 600; padding: 0 10px;">💵 Rémunération</legend>
                    
                    <div class="form-group">
                        <label>Salaire de base (€) *</label>
                        <input type="number" name="salaireBase" step="0.01" min="500" max="1000000"
                               value="<%= request.getParameter("salaireBase") != null ? request.getParameter("salaireBase") : "" %>" 
                               placeholder="3500.00"
                               required>
                        <small style="color: var(--text-muted); font-size: 0.8rem;">
                            Entre 500€ et 1 000 000€
                        </small>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Primes (€)</label>
                            <input type="number" name="primes" step="0.01" min="0"
                                   value="<%= request.getParameter("primes") != null ? request.getParameter("primes") : "0" %>" 
                                   placeholder="0.00">
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Primes et bonus
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Heures supplémentaires (€)</label>
                            <input type="number" name="heuresSupp" step="0.01" min="0"
                                   value="<%= request.getParameter("heuresSupp") != null ? request.getParameter("heuresSupp") : "0" %>" 
                                   placeholder="0.00">
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Montant des heures sup
                            </small>
                        </div>
                    </div>
                </fieldset>

                <!-- Déductions -->
                <fieldset style="border: 1px solid var(--border); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                    <legend style="color: var(--text-primary); font-weight: 600; padding: 0 10px;">➖ Déductions</legend>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>Déductions (€)</label>
                            <input type="number" name="deductions" step="0.01" min="0"
                                   value="<%= request.getParameter("deductions") != null ? request.getParameter("deductions") : "0" %>" 
                                   placeholder="0.00">
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Avances, mutuelle, tickets resto...
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Jours d'absence</label>
                            <input type="number" name="joursAbsence" min="0" max="31"
                                   value="<%= request.getParameter("joursAbsence") != null ? request.getParameter("joursAbsence") : "0" %>" 
                                   placeholder="0">
                            <small style="color: var(--text-muted); font-size: 0.8rem;">
                                Déduction automatique (salaire/30 par jour)
                            </small>
                        </div>
                    </div>

                    <!-- Info calcul -->
                    <div style="margin-top: 20px; padding: 15px; background: rgba(59, 130, 246, 0.1); border-radius: 8px; border: 1px solid rgba(59, 130, 246, 0.3);">
                        <p style="color: var(--text-secondary); margin: 0; font-size: 0.9rem;">
                            💡 <strong>Calcul automatique :</strong><br>
                            Les cotisations sociales (sécu, vieillesse, chômage, retraite, CSG, CRDS) seront calculées automatiquement selon les taux en vigueur.
                        </p>
                    </div>
                </fieldset>

                <div style="display: flex; gap: 10px; margin-top: 30px;">
                    <button type="submit" class="btn btn-primary">✅ Créer la fiche</button>
                    <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister" class="btn btn-secondary">❌ Annuler</a>
                </div>
            </form>

            <% } %>
        </div>

        <footer>
            <p>© 2025 RowTech</p>
        </footer>
    </div>

    <!-- Script pour validation en temps réel -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('formFichePaie');
            if (form && typeof activerValidationTempsReel === 'function') {
                activerValidationTempsReel(form);
            }
        });
        
        function validerFormulaireFichePaie(form) {
            const employeId = form.employeId.value;
            const mois = form.mois.value;
            const annee = form.annee.value;
            const salaireBase = parseFloat(form.salaireBase.value);
            
            if (!employeId) {
                alert('Veuillez sélectionner un employé.');
                return false;
            }
            
            if (!mois) {
                alert('Veuillez sélectionner un mois.');
                return false;
            }
            
            if (!annee || annee < 2020 || annee > 2030) {
                alert('Veuillez entrer une année valide (2020-2030).');
                return false;
            }
            
            if (isNaN(salaireBase) || salaireBase < 500 || salaireBase > 1000000) {
                alert('Le salaire de base doit être compris entre 500€ et 1 000 000€.');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>
