<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Détails du Projet");
    request.setAttribute("pageBreadcrumb", "Projets > Détails");

    Projet projet = (Projet) request.getAttribute("projet");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du Projet - JEE RH</title>
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

            <% if (projet == null) { %>
                <div class="card">
                    <div style="padding: 2rem; text-align: center; color: #ef4444;">
                        ⚠️ Projet non trouvé
                    </div>
                    <div style="padding: 1rem;">
                        <a href="<%= request.getContextPath() %>/ServletProjet" class="btn btn-secondary">← Retour à la liste</a>
                    </div>
                </div>
            <% } else { %>
                <!-- Boutons d'action -->
                <div style="margin-bottom: 1.5rem; display: flex; gap: 1rem;">
                    <a href="<%= request.getContextPath() %>/ServletProjet" class="btn btn-secondary">
                        ← Retour à la liste
                    </a>
                    <a href="<%= request.getContextPath() %>/ServletProjet?action=edit&id=<%= projet.getId() %>" class="btn btn-warning">
                        ✏️ Modifier
                    </a>
                    <a href="<%= request.getContextPath() %>/ServletProjet?action=delete&id=<%= projet.getId() %>"
                       class="btn btn-danger"
                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce projet ?');">
                        🗑️ Supprimer
                    </a>
                </div>

                <!-- Informations du projet -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">📋 Informations du Projet</h3>
                    </div>

                    <div style="padding: 2rem;">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">

                            <!-- Informations générales -->
                            <div>
                                <h4 style="color: #4b5563; font-size: 1.1rem; margin-bottom: 1rem; border-bottom: 2px solid #e5e7eb; padding-bottom: 0.5rem;">
                                    Informations Générales
                                </h4>
                                <div style="display: flex; flex-direction: column; gap: 1rem;">
                                    <div>
                                        <strong style="color: #6b7280; font-size: 0.9rem;">ID :</strong>
                                        <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem;">
                                            <%= projet.getId() %>
                                        </div>
                                    </div>
                                    <div>
                                        <strong style="color: #6b7280; font-size: 0.9rem;">Nom :</strong>
                                        <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem; font-weight: 600;">
                                            <%= projet.getNom() != null ? projet.getNom() : "-" %>
                                        </div>
                                    </div>
                                    <div>
                                        <strong style="color: #6b7280; font-size: 0.9rem;">État :</strong>
                                        <div style="margin-top: 0.25rem;">
                                            <%
                                                String etatClass = "";
                                                String etat = projet.getÉtat();
                                                if ("Terminé".equals(etat)) {
                                                    etatClass = "badge-success";
                                                } else if ("En cours".equals(etat)) {
                                                    etatClass = "badge-primary";
                                                } else if ("Planifié".equals(etat)) {
                                                    etatClass = "badge-warning";
                                                } else {
                                                    etatClass = "badge-danger";
                                                }
                                            %>
                                            <span class="badge <%= etatClass %>" style="font-size: 0.9rem;">
                                                <%= etat != null ? etat : "-" %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Dates et délais -->
                            <div>
                                <h4 style="color: #4b5563; font-size: 1.1rem; margin-bottom: 1rem; border-bottom: 2px solid #e5e7eb; padding-bottom: 0.5rem;">
                                    Dates et Délais
                                </h4>
                                <div style="display: flex; flex-direction: column; gap: 1rem;">
                                    <div>
                                        <strong style="color: #6b7280; font-size: 0.9rem;">Date d'échéance :</strong>
                                        <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem;">
                                            <%= projet.getEcheance() != null ? projet.getEcheance() : "-" %>
                                        </div>
                                    </div>
                                    <div>
                                        <strong style="color: #6b7280; font-size: 0.9rem;">Retard :</strong>
                                        <div style="margin-top: 0.25rem;">
                                            <% if (projet.getRetard() > 0) { %>
                                                <span style="color: #ef4444; font-weight: 600; font-size: 1rem;">
                                                    ⚠️ <%= projet.getRetard() %> jour(s) de retard
                                                </span>
                                            <% } else { %>
                                                <span style="color: #10b981; font-weight: 600; font-size: 1rem;">
                                                    ✓ À jour (0 jour de retard)
                                                </span>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Responsables -->
                            <div>
                                <h4 style="color: #4b5563; font-size: 1.1rem; margin-bottom: 1rem; border-bottom: 2px solid #e5e7eb; padding-bottom: 0.5rem;">
                                    Responsables
                                </h4>
                                <div style="display: flex; flex-direction: column; gap: 1rem;">
                                    <div>
                                        <strong style="color: #6b7280; font-size: 0.9rem;">Chef de projet :</strong>
                                        <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem;">
                                            <% if (projet.getChefDeProjet() != null) {
                                                Employe chef = projet.getChefDeProjet();
                                            %>
                                                <%= chef.getNom() %> <%= chef.getPrenom() %>
                                                <br>
                                                <small style="color: #6b7280;">
                                                    ID: <%= chef.getId() %> | Matricule: <%= chef.getMatricule() %>
                                                </small>
                                            <% } else { %>
                                                -
                                            <% } %>
                                        </div>
                                    </div>
                                    <div>
                                        <strong style="color: #6b7280; font-size: 0.9rem;">Département :</strong>
                                        <div style="color: #1f2937; font-size: 1rem; margin-top: 0.25rem;">
                                            <% if (projet.getDomaine() != null) { %>
                                                <%= projet.getDomaine().getNom() %>
                                            <% } else { %>
                                                -
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- Ajouter un employé au projet -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">➕ Ajouter un Employé au Projet</h3>
                    </div>

                    <form action="<%= request.getContextPath() %>/ServletProjet" method="get" style="padding: 1.5rem;">
                        <input type="hidden" name="action" value="addEmployee">
                        <input type="hidden" name="projetId" value="<%= projet.getId() %>">

                        <div style="display: flex; gap: 1rem; align-items: flex-end;">
                            <div class="form-group" style="flex: 1;">
                                <label class="form-label">Sélectionner un employé</label>
                                <%
                                    List<Employe> tousEmployes = (List<Employe>) request.getAttribute("tousEmployes");
                                    List<Employe> equipe = projet.getEquipe();
                                    List<Integer> equipeIds = new ArrayList<>();
                                    if (equipe != null) {
                                        for (Employe e : equipe) {
                                            equipeIds.add(e.getId());
                                        }
                                    }
                                %>
                                <select name="employeId" class="form-control" required>
                                    <option value="">-- Choisir un employé --</option>
                                    <%
                                        if (tousEmployes != null) {
                                            for (Employe emp : tousEmployes) {
                                                // Ne pas afficher les employés déjà dans l'équipe
                                                if (!equipeIds.contains(emp.getId())) {
                                    %>
                                        <option value="<%= emp.getId() %>">
                                            <%= emp.getNom() %> <%= emp.getPrenom() %> (ID: <%= emp.getId() %> - <%= emp.getPoste() %>)
                                        </option>
                                    <%
                                                }
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success">➕ Ajouter à l'Équipe</button>
                        </div>
                    </form>
                </div>

                <!-- Équipe du projet -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">👥 Équipe du Projet</h3>
                    </div>

                    <%
                        if (equipe == null || equipe.isEmpty()) {
                    %>
                        <div style="padding: 2rem; text-align: center; color: #6b7280;">
                            📭 Aucun membre d'équipe affecté à ce projet
                        </div>
                    <% } else { %>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nom</th>
                                        <th>Prénom</th>
                                        <th>Matricule</th>
                                        <th>Grade</th>
                                        <th>Poste</th>
                                        <th style="text-align: center;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Employe employe : equipe) {
                                    %>
                                    <tr>
                                        <td><%= employe.getId() %></td>
                                        <td><%= employe.getNom() %></td>
                                        <td><%= employe.getPrenom() %></td>
                                        <td><%= employe.getMatricule() %></td>
                                        <td><%= employe.getGrade() != null ? employe.getGrade() : "-" %></td>
                                        <td><%= employe.getPoste() != null ? employe.getPoste() : "-" %></td>
                                        <td style="text-align: center;">
                                            <a href="<%= request.getContextPath() %>/ServletProjet?action=removeEmployee&projetId=<%= projet.getId() %>&employeId=<%= employe.getId() %>"
                                               class="btn btn-danger"
                                               style="padding: 0.5rem 1rem; font-size: 0.8rem;"
                                               onclick="return confirm('Êtes-vous sûr de vouloir retirer <%= employe.getNom() %> <%= employe.getPrenom() %> de ce projet ?');">
                                                🗑️ Retirer
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
                            <span style="color: #1f2937;"><%= equipe.size() %> membre(s) d'équipe</span>
                        </div>
                    <% } %>
                </div>
            <% } %>

        </div>

    </div>

</div>

</body>
</html>
