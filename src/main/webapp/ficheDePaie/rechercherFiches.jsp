<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.FicheDePaie" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
    List<FicheDePaie> resultats = (List<FicheDePaie>) request.getAttribute("resultats");
    String erreur = (String) request.getAttribute("erreur");
    
    // Récupérer les valeurs sélectionnées pour les conserver après la recherche
    String selectedEmployeId = request.getParameter("employeId");
    String selectedMois = request.getParameter("mois");
    String selectedAnnee = request.getParameter("annee");
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
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
    <title>Rechercher Fiches de Paie - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .search-form {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 30px;
            border: 1px solid var(--border);
            margin-bottom: 30px;
        }
        
        .search-form h3 {
            color: var(--text-primary);
            margin-bottom: 20px;
            font-size: 1.2rem;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            color: var(--text-secondary);
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .form-group select,
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: var(--dark-light);
            color: var(--text-primary);
            font-size: 1rem;
        }
        
        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }
        
        .btn-pdf {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            color: white !important;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.3s ease;
        }
        
        .btn-pdf:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(220, 38, 38, 0.4);
        }
        
        .results-info {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.05) 100%);
            border: 1px solid rgba(99, 102, 241, 0.3);
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        
        .results-info p {
            margin: 0;
            color: var(--primary-light);
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Header -->
        <header class="app-header">
            <h1>🔍 Rechercher des Fiches de Paie</h1>
            <p>RowTech - Système de Gestion RH</p>
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
                
                <% if (RoleHelper.canManageProjets(session)) { %>
                    <a href="<%= request.getContextPath() %>/projets?action=lister">📁 Projets</a>
                <% } %>
                
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister" class="active">💰 Fiches de Paie</a>
                
                <% if (RoleHelper.canViewStatistics(session)) { %>
                    <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
                <% } %>
            <% } else { %>
                <!-- Navigation EMPLOYÉ / CHEF -->
                <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister">📁 Mes Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches" class="active">💰 Fiches de Paie</a>
            <% } %>
            
            <% if (nomComplet != null) { %>
                <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                    👤 <%= nomComplet %> (<%= userRole %>)
                </span>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                    🚪 Déconnexion
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/auth.jsp">🔒 Connexion</a>
            <% } %>
        </nav>

        <div class="content">
            <h2 class="page-title">🔍 Recherche de Fiches de Paie</h2>
            
            <!-- Messages d'erreur -->
            <% if (erreur != null) { %>
                <div class="alert alert-danger">
                    ⚠️ <%= erreur %>
                </div>
            <% } %>

            <!-- Formulaire de recherche -->
            <div class="search-form">
                <h3>📋 Critères de recherche</h3>
                
                <form action="<%= request.getContextPath() %>/fichesDePaie" method="get">
                    <input type="hidden" name="action" value="rechercher">
                    
                    <div class="form-row">
                        <!-- Sélection de l'employé -->
                        <div class="form-group">
                            <label for="employeId">👤 Employé</label>
                            <select name="employeId" id="employeId">
                                <option value="">-- Tous les employés --</option>
                                <% if (listeEmployes != null) {
                                    for (Employe emp : listeEmployes) {
                                        String selected = (selectedEmployeId != null && selectedEmployeId.equals(String.valueOf(emp.getId()))) ? "selected" : "";
                                %>
                                    <option value="<%= emp.getId() %>" <%= selected %>>
                                        <%= emp.getMatricule() %> - <%= emp.getPrenom() %> <%= emp.getNom() %>
                                    </option>
                                <% }} %>
                            </select>
                        </div>
                        
                        <!-- Sélection du mois -->
                        <div class="form-group">
                            <label for="mois">📅 Mois</label>
                            <select name="mois" id="mois">
                                <option value="">-- Tous les mois --</option>
                                <option value="1" <%= "1".equals(selectedMois) ? "selected" : "" %>>Janvier</option>
                                <option value="2" <%= "2".equals(selectedMois) ? "selected" : "" %>>Février</option>
                                <option value="3" <%= "3".equals(selectedMois) ? "selected" : "" %>>Mars</option>
                                <option value="4" <%= "4".equals(selectedMois) ? "selected" : "" %>>Avril</option>
                                <option value="5" <%= "5".equals(selectedMois) ? "selected" : "" %>>Mai</option>
                                <option value="6" <%= "6".equals(selectedMois) ? "selected" : "" %>>Juin</option>
                                <option value="7" <%= "7".equals(selectedMois) ? "selected" : "" %>>Juillet</option>
                                <option value="8" <%= "8".equals(selectedMois) ? "selected" : "" %>>Août</option>
                                <option value="9" <%= "9".equals(selectedMois) ? "selected" : "" %>>Septembre</option>
                                <option value="10" <%= "10".equals(selectedMois) ? "selected" : "" %>>Octobre</option>
                                <option value="11" <%= "11".equals(selectedMois) ? "selected" : "" %>>Novembre</option>
                                <option value="12" <%= "12".equals(selectedMois) ? "selected" : "" %>>Décembre</option>
                            </select>
                        </div>
                        
                        <!-- Sélection de l'année -->
                        <div class="form-group">
                            <label for="annee">📆 Année</label>
                            <input type="number" name="annee" id="annee" 
                                   value="<%= selectedAnnee != null ? selectedAnnee : "" %>" 
                                   min="2020" max="2030" 
                                   placeholder="Toutes les années">
                        </div>
                    </div>
                    
                    <div style="display: flex; gap: 10px; margin-top: 20px;">
                        <button type="submit" class="btn btn-primary">
                            🔍 Rechercher
                        </button>
                        <a href="<%= request.getContextPath() %>/fichesDePaie?action=rechercher" class="btn btn-secondary">
                            🔄 Réinitialiser
                        </a>
                        
                    </div>
                </form>
            </div>

            <!-- Résultats de la recherche -->
            <% if (resultats != null) { %>
                <div class="results-info">
                    <p>📊 <strong><%= resultats.size() %></strong> fiche(s) de paie trouvée(s)
                        <% if (selectedEmployeId != null && !selectedEmployeId.isEmpty()) { %>
                            pour l'employé sélectionné
                        <% } %>
                        <% if (selectedMois != null && !selectedMois.isEmpty()) { %>
                            - Mois : <%= selectedMois %>
                        <% } %>
                        <% if (selectedAnnee != null && !selectedAnnee.isEmpty()) { %>
                            - Année : <%= selectedAnnee %>
                        <% } %>
                    </p>
                </div>
                
                <% if (!resultats.isEmpty()) { %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>EMPLOYÉ</th>
                                    <th>PÉRIODE</th>
                                    <th>SALAIRE DE BASE</th>
                                    <th>PRIMES</th>
                                    <th>COTISATIONS</th>
                                    <th>NET À PAYER</th>
                                    <th>ACTIONS</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (FicheDePaie fiche : resultats) { %>
                                <tr>
                                    <td>
                                        <strong><%= fiche.getEmploye().getPrenom() %> <%= fiche.getEmploye().getNom() %></strong><br>
                                        <small style="color: var(--text-muted);"><%= fiche.getEmploye().getMatricule() %></small>
                                    </td>
                                    <td>
                                        <span class="badge badge-primary">
                                            <%= fiche.getMois() %> / <%= fiche.getAnnee() %>
                                        </span>
                                    </td>
                                    <td><%= String.format("%.2f", fiche.getSalaireDeBase()) %> €</td>
                                    <td style="color: var(--success);">
                                        + <%= String.format("%.2f", fiche.getPrimes()) %> €
                                    </td>
                                    <td style="color: #f59e0b;">
                                        - <%= String.format("%.2f", fiche.getTotalCotisations()) %> €
                                    </td>
                                    <td style="font-weight: 800; color: var(--accent-light);">
                                        <%= String.format("%.2f", fiche.getNetAPayer()) %> €
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 5px; justify-content: center;">
                                            <a href="<%= request.getContextPath() %>/fichesDePaie?action=voir&id=<%= fiche.getId() %>" 
                                               class="btn btn-primary" 
                                               style="padding: 6px 12px; font-size: 0.8rem;">
                                                👁️ Voir
                                            </a>
                                            <a href="<%= request.getContextPath() %>/generatePdf?id=<%= fiche.getId() %>" 
                                               class="btn-pdf">
                                                📥 PDF
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div style="text-align: center; padding: 60px 20px; background: var(--card-bg); border-radius: 16px; border: 2px dashed var(--border);">
                        <div style="font-size: 60px; margin-bottom: 20px; opacity: 0.3;">🔍</div>
                        <h3 style="color: var(--text-primary); margin-bottom: 10px;">Aucun résultat</h3>
                        <p style="color: var(--text-muted);">Aucune fiche de paie ne correspond à vos critères de recherche.</p>
                    </div>
                <% } %>
            <% } else { %>
                <!-- Message initial -->
                <div style="text-align: center; padding: 60px 20px; background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border);">
                    <div style="font-size: 60px; margin-bottom: 20px;">🔍</div>
                    <h3 style="color: var(--text-primary); margin-bottom: 10px;">Effectuez une recherche</h3>
                    <p style="color: var(--text-muted);">Utilisez les filtres ci-dessus pour rechercher des fiches de paie.</p>
                </div>
            <% } %>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
