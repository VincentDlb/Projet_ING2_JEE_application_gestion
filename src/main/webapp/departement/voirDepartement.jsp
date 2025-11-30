<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%@ page import="java.util.List" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Détails du Département");
    request.setAttribute("pageBreadcrumb", "Départements > Détails");

    Departement departement = (Departement) request.getAttribute("departement");
    List<Employe> employes = (List<Employe>) request.getAttribute("employes");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du Département - JEE RH</title>
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

            <% if (departement == null) { %>
                <div class="card">
                    <div style="padding: 2rem; text-align: center; color: #ef4444;">
                        ⚠️ Département non trouvé
                    </div>
                    <div style="padding: 1rem;">
                        <a href="<%= request.getContextPath() %>/departements" class="btn btn-secondary">← Retour à la liste</a>
                    </div>
                </div>
            <% } else { %>
                <!-- Boutons d'action -->
                <div style="margin-bottom: 1.5rem; display: flex; gap: 1rem;">
                    <a href="<%= request.getContextPath() %>/departements" class="btn btn-secondary">
                        ← Retour à la liste
                    </a>
                    <a href="<%= request.getContextPath() %>/departements?action=edit&id=<%= departement.getId() %>" class="btn btn-warning">
                        ✏️ Modifier
                    </a>
                    <a href="<%= request.getContextPath() %>/departements?action=delete&id=<%= departement.getId() %>"
                       class="btn btn-danger"
                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce département ?');">
                        🗑️ Supprimer
                    </a>
                </div>

                <!-- Informations du département -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">🏢 Informations du Département</h3>
                    </div>

                    <div style="padding: 2rem;">
                        <h2 style="margin-bottom: 1.5rem; color: #1f2937; font-size: 1.5rem;">
                            <%= departement.getNom() %>
                        </h2>

                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem;">
                            <div>
                                <strong style="color: #6b7280; font-size: 0.9rem;">ID :</strong>
                                <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem;">
                                    <%= departement.getId() %>
                                </div>
                            </div>

                            <div>
                                <strong style="color: #6b7280; font-size: 0.9rem;">Adresse :</strong>
                                <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem;">
                                    <%= departement.getAdresse() != null ? departement.getAdresse() : "-" %>
                                </div>
                            </div>

                            <div>
                                <strong style="color: #6b7280; font-size: 0.9rem;">Taille :</strong>
                                <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem;">
                                    <%= departement.getTaille() %> personne(s)
                                </div>
                            </div>

                            <div>
                                <strong style="color: #6b7280; font-size: 0.9rem;">Rôle :</strong>
                                <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem;">
                                    <%= departement.getRole() != null ? departement.getRole() : "-" %>
                                </div>
                            </div>

                            <% if (departement.getPresentation() != null && !departement.getPresentation().trim().isEmpty()) { %>
                            <div style="grid-column: 1 / -1;">
                                <strong style="color: #6b7280; font-size: 0.9rem;">Présentation :</strong>
                                <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem; line-height: 1.6;">
                                    <%= departement.getPresentation() %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Liste des employés du département -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">👥 Employés du Département</h3>
                    </div>

                    <%
                        if (employes == null || employes.isEmpty()) {
                    %>
                        <div style="padding: 2rem; text-align: center; color: #6b7280;">
                            📭 Aucun employé dans ce département
                        </div>
                    <% } else { %>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Matricule</th>
                                        <th>Nom</th>
                                        <th>Prénom</th>
                                        <th>Poste</th>
                                        <th>Grade</th>
                                        <th>Statut Cadre</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Employe emp : employes) {
                                    %>
                                    <tr>
                                        <td><%= emp.getId() %></td>
                                        <td><%= emp.getMatricule() %></td>
                                        <td style="font-weight: 600;"><%= emp.getNom() %></td>
                                        <td><%= emp.getPrenom() %></td>
                                        <td><%= emp.getPoste() != null ? emp.getPoste() : "-" %></td>
                                        <td><%= emp.getGrade() != null ? emp.getGrade() : "-" %></td>
                                        <td style="text-align: center;">
                                            <% if (emp.isStatutCadre()) { %>
                                                <span class="badge badge-success">✓ Oui</span>
                                            <% } else { %>
                                                <span class="badge badge-danger">✗ Non</span>
                                            <% } %>
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
                            <span style="color: #1f2937;"><%= employes.size() %> employé(s)</span>
                        </div>
                    <% } %>
                </div>
            <% } %>

        </div>

    </div>

</div>

</body>
</html>
