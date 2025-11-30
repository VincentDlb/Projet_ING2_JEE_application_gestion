<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Gestion des Projets");
    request.setAttribute("pageBreadcrumb", "Projets");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Projets - JEE RH</title>
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
                <a href="<%= request.getContextPath() %>/ServletProjet?action=insert" class="btn btn-success">
                    ➕ Créer un Nouveau Projet
                </a>
            </div>

            <!-- Formulaire de recherche -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">🔍 Rechercher des Projets</h3>
                </div>

                <form action="<%= request.getContextPath() %>/ServletProjet" method="get">
                    <input type="hidden" name="action" value="search">
                    <div style="display: flex; gap: 1rem; align-items: flex-end;">
                        <div class="form-group" style="flex: 1;">
                            <label class="form-label">État du projet</label>
                            <select name="etat" class="form-control">
                                <option value="">-- Tous les états --</option>
                                <option value="Planifié">Planifié</option>
                                <option value="En cours">En cours</option>
                                <option value="Terminé">Terminé</option>
                                <option value="Annulé">Annulé</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                        <a href="<%= request.getContextPath() %>/ServletProjet" class="btn btn-secondary">
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

            <% String success = (String) request.getAttribute("success");
               if (success != null) { %>
                <div class="alert alert-success">
                    <strong>✓ Succès :</strong> <%= success %>
                </div>
            <% } %>

            <!-- Liste des projets -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">📋 Liste des Projets</h3>
                </div>

                <%
                    List<Projet> listeProjets = (List<Projet>) request.getAttribute("listeProjets");

                    if (listeProjets == null || listeProjets.isEmpty()) {
                %>
                    <div style="padding: 3rem; text-align: center; color: #6b7280;">
                        <div style="font-size: 1.25rem; margin-bottom: 0.5rem;">📭 Aucun projet trouvé</div>
                        <div style="font-size: 0.95rem;">Commencez par créer un nouveau projet</div>
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
                                    <th>Chef de Projet</th>
                                    <th>Département</th>
                                    <th>Échéance</th>
                                    <th>État</th>
                                    <th>Retard</th>
                                    <th style="text-align: center;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Projet projet : listeProjets) {
                                        String etatClass = "";
                                        if ("Terminé".equals(projet.getÉtat())) {
                                            etatClass = "badge-success";
                                        } else if ("En cours".equals(projet.getÉtat())) {
                                            etatClass = "badge-primary";
                                        } else if ("Planifié".equals(projet.getÉtat())) {
                                            etatClass = "badge-warning";
                                        } else {
                                            etatClass = "badge-danger";
                                        }
                                %>
                                <tr>
                                    <td><%= projet.getId() %></td>
                                    <td style="font-weight: 600;"><%= projet.getNom() %></td>
                                    <td>
                                        <% if (projet.getChefDeProjet() != null) { %>
                                            <%= projet.getChefDeProjet().getNom() %> <%= projet.getChefDeProjet().getPrenom() %>
                                        <% } else { %>
                                            -
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (projet.getDomaine() != null) { %>
                                            <%= projet.getDomaine().getNom() %>
                                        <% } else { %>
                                            -
                                        <% } %>
                                    </td>
                                    <td><%= projet.getEcheance() != null ? projet.getEcheance() : "-" %></td>
                                    <td>
                                        <span class="badge <%= etatClass %>">
                                            <%= projet.getÉtat() != null ? projet.getÉtat() : "-" %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (projet.getRetard() > 0) { %>
                                            <span style="color: #ef4444; font-weight: 600;"><%= projet.getRetard() %> j</span>
                                        <% } else { %>
                                            <span style="color: #10b981;">✓ À jour</span>
                                        <% } %>
                                    </td>
                                    <td style="text-align: center;">
                                        <a href="<%= request.getContextPath() %>/ServletProjet?action=view&id=<%= projet.getId() %>"
                                           class="btn btn-primary"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem; margin-right: 0.5rem;">
                                            👁️ Voir
                                        </a>
                                        <a href="<%= request.getContextPath() %>/ServletProjet?action=edit&id=<%= projet.getId() %>"
                                           class="btn btn-warning"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem; margin-right: 0.5rem;">
                                            ✏️ Modifier
                                        </a>
                                        <a href="<%= request.getContextPath() %>/ServletProjet?action=delete&id=<%= projet.getId() %>"
                                           class="btn btn-danger"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem;"
                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce projet ?');">
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
                        <span style="color: #1f2937;"><%= listeProjets.size() %> projet(s)</span>
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
