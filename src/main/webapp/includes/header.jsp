<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String pageTitle = (String) request.getAttribute("pageTitle");
    String pageBreadcrumb = (String) request.getAttribute("pageBreadcrumb");

    if (pageTitle == null) pageTitle = "Dashboard";
    if (pageBreadcrumb == null) pageBreadcrumb = "Accueil";

    // Get user initials for avatar
    String userInitials = "";
    if (currentUser != null && currentUser.getUsername() != null) {
        String username = currentUser.getUsername();
        if (username.length() >= 2) {
            userInitials = username.substring(0, 2).toUpperCase();
        } else {
            userInitials = username.toUpperCase();
        }
    }
%>

<!-- En-tête supérieur -->
<header class="top-header">
    <div class="header-title">
        <h2><%= pageTitle %></h2>
        <div class="breadcrumb">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            <% if (!pageBreadcrumb.equals("Accueil")) { %>
                <span> / <%= pageBreadcrumb %></span>
            <% } %>
        </div>
    </div>

    <div class="user-info">
        <% if (currentUser != null) { %>
        <div class="user-profile">
            <div class="user-avatar"><%= userInitials %></div>
            <div class="user-details">
                <div class="user-name"><%= currentUser.getUsername() %></div>
                <div class="user-role">
                    <%
                    String roleLabel = "";
                    if (currentUser.getRole() == Role.ADMIN) {
                        roleLabel = "Administrateur";
                    } else if (currentUser.getRole() == Role.CHEF_DEPARTEMENT) {
                        roleLabel = "Chef de Département";
                    } else if (currentUser.getRole() == Role.CHEF_PROJET) {
                        roleLabel = "Chef de Projet";
                    } else if (currentUser.getRole() == Role.EMPLOYE) {
                        roleLabel = "Employé";
                    }
                    %>
                    <%= roleLabel %>
                </div>
            </div>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">
            Déconnexion
        </a>
        <% } %>
    </div>
</header>
