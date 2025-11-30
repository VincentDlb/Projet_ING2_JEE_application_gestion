<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    List<Employe> resultats = (List<Employe>) request.getAttribute("resultats");
    List<Departement> departements = (List<Departement>) request.getAttribute("departements");
    
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recherche Employés</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🔍 Recherche d'Employés</h1>
            <p>RowTech - Gestion RH</p>
        </header>

        <div class="content">
            <h2 class="page-title">Recherche Avancée</h2>

            <!-- FORMULAIRE DE RECHERCHE -->
            <div style="background: var(--card-bg); padding: 25px; border-radius: 10px; margin-bottom: 30px; border: 1px solid var(--border);">
                <form action="<%= request.getContextPath() %>/employes" method="get">
                    <input type="hidden" name="action" value="rechercher">
                    
                    <div style="display: grid; grid-template-columns: 200px 1fr auto; gap: 15px; align-items: end;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label>Rechercher par</label>
                            <select name="critere">
                                <option value="nom">Nom</option>
                                <option value="prenom">Prénom</option>
                                <option value="matricule">Matricule</option>
                                <option value="poste">Poste</option>
                                <option value="grade">Grade</option>
                            </select>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label>Valeur</label>
                            <input type="text" name="valeur" placeholder="Entrez votre recherche..." required>
                        </div>

                        <button type="submit" class="btn btn-primary" style="height: 45px;">
                            🔍 Rechercher
                        </button>
                    </div>
                </form>
            </div>

            <!-- RÉSULTATS -->
            <% if (resultats != null) { %>
                <h3 style="color: var(--primary); margin-bottom: 20px;">
                    📊 Résultats : <%= resultats.size() %> employé(s) trouvé(s)
                </h3>
                
                <% if (resultats.isEmpty()) { %>
                    <div style="padding: 40px; text-align: center; background: rgba(107, 114, 128, 0.1); border-radius: 10px; border: 2px dashed var(--border);">
                        <p style="font-size: 1.2rem; color: var(--text-muted); margin: 0;">
                            😕 Aucun employé trouvé avec ces critères
                        </p>
                    </div>
                <% } else { %>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Matricule</th>
                                    <th>Nom</th>
                                    <th>Prénom</th>
                                    <th>Poste</th>
                                    <th>Grade</th>
                                    <th>Département</th>
                                    <th>Salaire</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Employe emp : resultats) { %>
                                    <tr>
                                        <td><strong><%= emp.getMatricule() %></strong></td>
                                        <td><%= emp.getNom() %></td>
                                        <td><%= emp.getPrenom() %></td>
                                        <td><%= emp.getPoste() %></td>
                                        <td>
                                            <span class="badge 
                                                <% 
                                                    String badgeClass = "";
                                                    switch(emp.getGrade()) {
                                                        case "JUNIOR": badgeClass = "badge-info"; break;
                                                        case "CONFIRME": badgeClass = "badge-primary"; break;
                                                        case "SENIOR": badgeClass = "badge-success"; break;
                                                        case "EXPERT": badgeClass = "badge-warning"; break;
                                                    }
                                                %>
                                                <%= badgeClass %>">
                                                <%= emp.getGrade() %>
                                            </span>
                                        </td>
                                        <td>
                                            <% if (emp.getDepartement() != null) { %>
                                                <%= emp.getDepartement().getNom() %>
                                            <% } else { %>
                                                <span style="color: var(--text-muted);">Non assigné</span>
                                            <% } %>
                                        </td>
                                        <td><%= String.format("%.2f", emp.getSalaire()) %>€</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            <% } %>

            <div style="margin-top: 30px;">
                <a href="<%= request.getContextPath() %>/employes?action=lister" class="btn btn-secondary">
                    ← Retour à la liste complète
                </a>
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech</p>
        </footer>
    </div>
</body>
</html>