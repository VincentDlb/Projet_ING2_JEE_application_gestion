<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Dashboard - Tableau de Bord");
    request.setAttribute("pageBreadcrumb", "Accueil");

    // Récupérer l'utilisateur connecté depuis la session
    User user = (User) session.getAttribute("user");
    Role role = user != null ? user.getRole() : null;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Gestion RH</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
</head>
<body>

<!-- Layout principal -->
<div class="app-wrapper">

    <!-- Menu latéral -->
    <%@ include file="includes/menu.jsp" %>

    <!-- Contenu principal -->
    <div class="main-content">

        <!-- Header -->
        <jsp:include page="/includes/header.jsp" />


        <!-- Zone de contenu -->
        <div class="content-wrapper fade-in">

            <!-- Message de bienvenue -->
            <div class="card">
                <h2 style="margin-bottom: 1rem; color: #1f2937;">
                    👋 Bienvenue<% if (user != null) { %>, <%= user.getUsername() %><% } %> !
                </h2>
                <p style="color: #6b7280; font-size: 1rem; line-height: 1.6;">
                    Vous êtes connecté à l'application de gestion des ressources humaines de <strong>RowTech</strong>.
                    <br>
                    Utilisez le menu latéral pour accéder aux différentes fonctionnalités selon vos droits d'accès.
                </p>
            </div>

            <!-- Statistiques rapides -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Employés</h3>
                        <p>-</p>
                    </div>
                    <div class="stat-icon blue">
                        <span>👥</span>
                    </div>
                </div>

                <% if (role == Role.ADMIN || role == Role.CHEF_DEPARTEMENT) { %>
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Départements</h3>
                        <p>-</p>
                    </div>
                    <div class="stat-icon green">
                        <span>🏢</span>
                    </div>
                </div>
                <% } %>

                <% if (role == Role.ADMIN || role == Role.CHEF_PROJET) { %>
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Projets</h3>
                        <p>-</p>
                    </div>
                    <div class="stat-icon orange">
                        <span>📊</span>
                    </div>
                </div>
                <% } %>

                <% if (role == Role.ADMIN || role == Role.CHEF_DEPARTEMENT) { %>
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Fiches de Paie</h3>
                        <p>-</p>
                    </div>
                    <div class="stat-icon red">
                        <span>💰</span>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Actions rapides -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">⚡ Actions Rapides</h3>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                    <a href="<%= request.getContextPath() %>/employes" class="btn btn-primary" style="text-align: center;">
                        👥 Voir les Employés
                    </a>

                    <% if (role == Role.ADMIN || role == Role.CHEF_DEPARTEMENT) { %>
                    <a href="<%= request.getContextPath() %>/departements?action=list" class="btn btn-success" style="text-align: center;">
                        🏢 Gérer Départements
                    </a>
                    <% } %>

                    <% if (role == Role.ADMIN || role == Role.CHEF_PROJET) { %>
                    <a href="<%= request.getContextPath() %>/ServletProjet" class="btn btn-warning" style="text-align: center;">
                        📊 Gérer Projets
                    </a>
                    <% } %>

                    <% if (role == Role.ADMIN || role == Role.CHEF_DEPARTEMENT) { %>
                    <a href="<%= request.getContextPath() %>/fichesdepaie" class="btn btn-secondary" style="text-align: center;">
                        💰 Fiches de Paie
                    </a>
                    <% } %>

                    <% if (role == Role.ADMIN) { %>
                    <a href="<%= request.getContextPath() %>/rapports" class="btn btn-primary" style="text-align: center;">
                        📈 Statistiques
                    </a>
                    <% } %>
                </div>
            </div>

            <!-- Informations sur l'entreprise -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">ℹ️ Informations</h3>
                </div>
                <div style="color: #6b7280; line-height: 1.8;">
                    <p><strong>🏢 Entreprise :</strong> RowTech</p>
                    <p><strong>📅 Année de création :</strong> 2025</p>
                    <p><strong>👤 Votre rôle :</strong>
                        <%
                        if (role == Role.ADMIN) {
                            out.print("Administrateur");
                        } else if (role == Role.CHEF_DEPARTEMENT) {
                            out.print("Chef de Département");
                        } else if (role == Role.CHEF_PROJET) {
                            out.print("Chef de Projet");
                        } else if (role == Role.EMPLOYE) {
                            out.print("Employé");
                        }
                        %>
                    </p>
                </div>
            </div>

        </div>

    </div>

</div>

</body>
</html>
