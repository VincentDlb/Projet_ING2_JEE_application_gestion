<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    User currentUser = (User) session.getAttribute("user");
    Role userRole = currentUser != null ? currentUser.getRole() : null;
    String currentPage = request.getRequestURI();
%>

<!-- Menu latéral noir -->
<aside class="sidebar">
    <div class="sidebar-header">
        <h1>💼 JEE RH App</h1>
        <p>Gestion des Ressources Humaines</p>
    </div>

    <nav class="sidebar-menu">
        <!-- Section Général -->
        <div class="menu-section">
            <div class="menu-section-title">Général</div>
            <a href="<%= request.getContextPath() %>/accueil.jsp" class="menu-item <%= currentPage.contains("accueil.jsp") ? "active" : "" %>">
                <i>🏠</i>
                <span>Accueil</span>
            </a>
        </div>

        <!-- Section Gestion -->
        <div class="menu-section">
            <div class="menu-section-title">Gestion</div>

            <a href="<%= request.getContextPath() %>/employes" class="menu-item <%= currentPage.contains("employes") ? "active" : "" %>">
                <i>👥</i>
                <span>Employés</span>
            </a>

            <% if (userRole == Role.ADMIN || userRole == Role.CHEF_DEPARTEMENT) { %>
            <a href="<%= request.getContextPath() %>/departements?action=list" class="menu-item <%= currentPage.contains("departement") ? "active" : "" %>">
                <i>🏢</i>
                <span>Départements</span>
            </a>
            <% } %>

            <% if (userRole == Role.ADMIN || userRole == Role.CHEF_PROJET) { %>
            <a href="<%= request.getContextPath() %>/ServletProjet" class="menu-item <%= currentPage.contains("projet") ? "active" : "" %>">
                <i>📊</i>
                <span>Projets</span>
            </a>
            <% } %>

            <% if (userRole == Role.ADMIN || userRole == Role.CHEF_DEPARTEMENT) { %>
            <a href="<%= request.getContextPath() %>/fichesdepaie" class="menu-item <%= currentPage.contains("paie") ? "active" : "" %>">
                <i>💰</i>
                <span>Fiches de Paie</span>
            </a>
            <% } %>
        </div>

        <!-- Section Rapports (Admin uniquement) -->
        <% if (userRole == Role.ADMIN) { %>
        <div class="menu-section">
            <div class="menu-section-title">Rapports</div>
            <a href="<%= request.getContextPath() %>/rapports" class="menu-item <%= currentPage.contains("rapport") ? "active" : "" %>">
                <i>📈</i>
                <span>Statistiques</span>
            </a>
        </div>
        <% } %>

        <!-- Section Compte -->
        <div class="menu-section">
            <div class="menu-section-title">Compte</div>
            <a href="<%= request.getContextPath() %>/logout" class="menu-item">
                <i>🚪</i>
                <span>Déconnexion</span>
            </a>
        </div>
    </nav>
</aside>
