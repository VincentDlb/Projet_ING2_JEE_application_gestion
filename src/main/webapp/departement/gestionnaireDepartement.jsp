<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Gestion des Départements");
    request.setAttribute("pageBreadcrumb", "Départements");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Départements - JEE RH</title>
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

            <!-- Bouton d'ajout -->
            <div style="margin-bottom: 1.5rem;">
                <a href="<%= request.getContextPath() %>/departements?action=insert" class="btn btn-success">
                    ➕ Ajouter un Département
                </a>
            </div>

            <!-- Formulaire de recherche -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">🔍 Rechercher un Département</h3>
                </div>

                <form action="<%= request.getContextPath() %>/departements" method="get">
                    <input type="hidden" name="action" value="search">
                    <div style="display: flex; gap: 1rem; align-items: flex-end;">
                        <div class="form-group" style="flex: 1;">
                            <label class="form-label">Nom du département</label>
                            <input type="text" name="nom" class="form-control" placeholder="Ex: Ressources Humaines">
                        </div>
                        <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                        <a href="<%= request.getContextPath() %>/departements" class="btn btn-secondary">
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

            <!-- Liste des départements -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">📋 Liste des Départements</h3>
                </div>

                <%
                    List<Departement> listeDepartements = (List<Departement>) request.getAttribute("listeDepartements");

                    if (listeDepartements == null || listeDepartements.isEmpty()) {
                %>
                    <div style="padding: 3rem; text-align: center; color: #6b7280;">
                        <div style="font-size: 1.25rem; margin-bottom: 0.5rem;">📭 Aucun département trouvé</div>
                        <div style="font-size: 0.95rem;">Commencez par ajouter un nouveau département</div>
                    </div>
                <%
                    } else {
                %>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nom</th>
                                    <th>Adresse</th>
                                    <th>Taille</th>
                                    <th>Rôle</th>
                                    <th style="text-align: center;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Departement dept : listeDepartements) {
                                %>
                                <tr>
                                    <td><%= dept.getId() %></td>
                                    <td style="font-weight: 600;"><%= dept.getNom() %></td>
                                    <td><%= dept.getAdresse() != null ? dept.getAdresse() : "-" %></td>
                                    <td><%= dept.getTaille() %> pers.</td>
                                    <td><%= dept.getRole() != null ? dept.getRole() : "-" %></td>
                                    <td style="text-align: center;">
                                        <a href="<%= request.getContextPath() %>/departements?action=view&id=<%= dept.getId() %>"
                                           class="btn btn-primary"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem; margin-right: 0.5rem;">
                                            👁️ Voir
                                        </a>
                                        <a href="<%= request.getContextPath() %>/departements?action=edit&id=<%= dept.getId() %>"
                                           class="btn btn-warning"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem; margin-right: 0.5rem;">
                                            ✏️ Modifier
                                        </a>
                                        <a href="<%= request.getContextPath() %>/departements?action=delete&id=<%= dept.getId() %>"
                                           class="btn btn-danger"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem;"
                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce département ?');">
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
                        <span style="color: #1f2937;"><%= listeDepartements.size() %> département(s)</span>
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
