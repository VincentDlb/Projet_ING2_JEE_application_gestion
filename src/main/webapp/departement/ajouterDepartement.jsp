<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Ajouter un Département");
    request.setAttribute("pageBreadcrumb", "Départements > Ajouter");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un Département - JEE RH</title>
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
                    <h3 class="card-title">➕ Créer un Nouveau Département</h3>
                </div>

                <form method="post" action="<%= request.getContextPath() %>/departements">
                    <input type="hidden" name="action" value="insert">

                    <div class="form-grid">
                        <!-- Nom du département -->
                        <div class="form-group">
                            <label class="form-label">Nom du département <span style="color: #ef4444;">*</span></label>
                            <input type="text" name="nom" class="form-control" required placeholder="Ex: Ressources Humaines">
                        </div>

                        <!-- Adresse -->
                        <div class="form-group">
                            <label class="form-label">Adresse <span style="color: #ef4444;">*</span></label>
                            <input type="text" name="adresse" class="form-control" required placeholder="Ex: Bâtiment A, 2ème étage">
                        </div>

                        <!-- Taille -->
                        <div class="form-group">
                            <label class="form-label">Taille (nombre de personnes) <span style="color: #ef4444;">*</span></label>
                            <input type="number" name="taille" class="form-control" required min="1" max="500" placeholder="Ex: 15">
                        </div>

                        <!-- Rôle -->
                        <div class="form-group">
                            <label class="form-label">Rôle / Fonction <span style="color: #ef4444;">*</span></label>
                            <input type="text" name="role" class="form-control" required placeholder="Ex: Gestion du personnel, recrutement">
                        </div>

                        <!-- Présentation -->
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label class="form-label">Présentation</label>
                            <textarea name="presentation" class="form-control" rows="4"
                                      placeholder="Décrivez brièvement les missions et objectifs du département..."></textarea>
                        </div>
                    </div>

                    <!-- Boutons -->
                    <div style="margin-top: 2rem; display: flex; gap: 1rem;">
                        <button type="submit" class="btn btn-success">✅ Créer le Département</button>
                        <a href="<%= request.getContextPath() %>/departements" class="btn btn-secondary">❌ Annuler</a>
                    </div>
                </form>
            </div>

        </div>

    </div>

</div>

</body>
</html>
