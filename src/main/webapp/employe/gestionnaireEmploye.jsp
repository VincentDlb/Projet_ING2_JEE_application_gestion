<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Gestion des Employés");
    request.setAttribute("pageBreadcrumb", "Employés");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Employés - JEE RH</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
</head>
<body>

<!-- Layout principal -->
<div class="app-wrapper">

    <!-- Menu latéral -->
    <%@ include file="../includes/menu.jsp" %>

    <!-- Contenu principal -->
    <div class="main-content">

        <!-- Header -->
        <jsp:include page="/includes/header.jsp" />


        <!-- Zone de contenu -->
        <div class="content-wrapper fade-in">

            <!-- Actions rapides -->
            <div style="margin-bottom: 1.5rem;">
                <a href="<%= request.getContextPath() %>/employes?action=insert" class="btn btn-success">
                    ➕ Ajouter un employé
                </a>
            </div>

            <!-- Section de recherche et filtres -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">🔍 Rechercher / Filtrer les employés</h3>
                </div>

                <form action="<%= request.getContextPath() %>/employes" method="get">
                    <input type="hidden" name="action" value="search">
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Nom</label>
                            <input type="text" name="nom" class="form-control" placeholder="Ex: Dupont">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Prénom</label>
                            <input type="text" name="prenom" class="form-control" placeholder="Ex: Jean">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Matricule</label>
                            <input type="text" name="matricule" class="form-control" placeholder="Ex: 12345">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Grade</label>
                            <input type="text" name="grade" class="form-control" placeholder="Ex: Ingénieur">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Poste</label>
                            <input type="text" name="poste" class="form-control" placeholder="Ex: Développeur">
                        </div>
                    </div>
                    <div style="margin-top: 1rem; display: flex; gap: 1rem;">
                        <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                        <a href="<%= request.getContextPath() %>/employes" class="btn btn-secondary">
                            📋 Tout Afficher
                        </a>
                    </div>
                </form>
            </div>

            <!-- Messages -->
            <% String erreur = (String) request.getAttribute("erreur");
               if (erreur != null) { %>
                <div class="alert alert-error">
                    <strong>⚠️ Erreur :</strong> <%= erreur %>
                </div>
            <% } %>

            <!-- Liste des employés -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">📋 Liste des Employés</h3>
                </div>

                <%
                    List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");

                    if (listeEmployes == null || listeEmployes.isEmpty()) {
                %>
                    <div style="padding: 3rem; text-align: center; color: #6b7280;">
                        <div style="font-size: 1.25rem; margin-bottom: 0.5rem;">📭 Aucun employé trouvé</div>
                        <div style="font-size: 0.95rem;">Essayez de modifier vos critères de recherche ou ajoutez un nouvel employé</div>
                    </div>
                <%
                    } else {
                %>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Matricule</th>
                                    <th>Nom</th>
                                    <th>Prénom</th>
                                    <th>Âge</th>
                                    <th>Grade</th>
                                    <th>Poste</th>
                                    <th>Cadre</th>
                                    <th style="text-align: center;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Employe e : listeEmployes) {
                                %>
                                <tr>
                                    <td><%= e.getId() %></td>
                                    <td style="font-weight: 600;"><%= e.getMatricule() %></td>
                                    <td><%= e.getNom() %></td>
                                    <td><%= e.getPrenom() %></td>
                                    <td><%= e.getAge() %> ans</td>
                                    <td><%= e.getGrade() != null ? e.getGrade() : "-" %></td>
                                    <td><%= e.getPoste() != null ? e.getPoste() : "-" %></td>
                                    <td style="text-align: center;">
                                        <% if (e.isStatutCadre()) { %>
                                            <span class="badge badge-success">✓ Oui</span>
                                        <% } else { %>
                                            <span class="badge badge-danger">✗ Non</span>
                                        <% } %>
                                    </td>
                                    <td style="text-align: center;">
                                        <a href="<%= request.getContextPath() %>/employes?action=edit&id=<%= e.getId() %>"
                                           class="btn btn-warning"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem; margin-right: 0.5rem;">
                                            ✏️ Modifier
                                        </a>
                                        <a href="<%= request.getContextPath() %>/employes?action=delete&id=<%= e.getId() %>"
                                           class="btn btn-danger"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem;"
                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet employé ?');">
                                            🗑️ Supprimer
                                        </a>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <div style="margin-top: 1.5rem; padding: 1rem; background: #f9fafb; border-radius: 0.5rem; text-align: center;">
                        <strong style="color: #4b5563;">📊 Total :</strong>
                        <span style="color: #1f2937;"><%= listeEmployes.size() %> employé(s)</span>
                    </div>
                <%
                    }
                %>
            </div>

        </div>

    </div>

</div>

</body>
</html>
