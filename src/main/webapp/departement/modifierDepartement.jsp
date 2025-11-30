<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Modifier un Département");
    request.setAttribute("pageBreadcrumb", "Départements > Modifier");

    Departement departement = (Departement) request.getAttribute("departement");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier un Département - JEE RH</title>
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

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">✏️ Modifier le Département</h3>
                </div>

                <% if (departement == null) { %>
                    <div style="padding: 2rem; text-align: center; color: #ef4444;">
                        ⚠️ Département non trouvé
                    </div>
                    <div style="padding: 1rem;">
                        <a href="<%= request.getContextPath() %>/departements" class="btn btn-secondary">← Retour à la liste</a>
                    </div>
                <% } else { %>
                    <form method="post" action="<%= request.getContextPath() %>/departements">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="<%= departement.getId() %>">

                        <div class="form-grid">
                            <!-- Nom du département -->
                            <div class="form-group">
                                <label class="form-label">Nom du département <span style="color: #ef4444;">*</span></label>
                                <input type="text" name="nom" class="form-control" required
                                       value="<%= departement.getNom() != null ? departement.getNom() : "" %>">
                            </div>

                            <!-- Adresse -->
                            <div class="form-group">
                                <label class="form-label">Adresse <span style="color: #ef4444;">*</span></label>
                                <input type="text" name="adresse" class="form-control" required
                                       value="<%= departement.getAdresse() != null ? departement.getAdresse() : "" %>">
                            </div>

                            <!-- Taille -->
                            <div class="form-group">
                                <label class="form-label">Taille (nombre de personnes) <span style="color: #ef4444;">*</span></label>
                                <input type="number" name="taille" class="form-control" required min="1" max="500"
                                       value="<%= departement.getTaille() %>">
                            </div>

                            <!-- Rôle -->
                            <div class="form-group">
                                <label class="form-label">Rôle / Fonction <span style="color: #ef4444;">*</span></label>
                                <input type="text" name="role" class="form-control" required
                                       value="<%= departement.getRole() != null ? departement.getRole() : "" %>">
                            </div>

                            <!-- Présentation -->
                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label class="form-label">Présentation</label>
                                <textarea name="presentation" class="form-control" rows="4"><%= departement.getPresentation() != null ? departement.getPresentation() : "" %></textarea>
                            </div>
                        </div>

                        <!-- Boutons -->
                        <div style="margin-top: 2rem; display: flex; gap: 1rem;">
                            <button type="submit" class="btn btn-success">💾 Enregistrer les Modifications</button>
                            <a href="<%= request.getContextPath() %>/departements" class="btn btn-secondary">❌ Annuler</a>
                        </div>
                    </form>
                <% } %>
            </div>

        </div>

    </div>

</div>

</body>
</html>
