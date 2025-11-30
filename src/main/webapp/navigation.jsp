<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    String currentPage = request.getRequestURI();
%>

<!-- HEADER MODERNE -->
<header class="modern-header">
    <div class="header-content">
        <div class="logo-section">
            <h1 class="logo-title">🏢 RowTech</h1>
            <p class="logo-subtitle">Système de Gestion RH</p>
        </div>
        
        <% if (nomComplet != null) { %>
        <div class="user-info">
            <div class="user-badge">
                <span class="user-icon">👤</span>
                <div class="user-details">
                    <span class="user-name"><%= nomComplet %></span>
                    <span class="user-role"><%= userRole %></span>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</header>

<!-- NAVIGATION MODERNE -->
<nav class="modern-navbar">
    <div class="nav-container">
        <a href="<%= request.getContextPath() %>/accueil.jsp" 
           class="nav-item <%= currentPage.contains("accueil.jsp") ? "active" : "" %>">
            <span class="nav-icon">🏠</span>
            <span class="nav-text">Accueil</span>
        </a>

        <% if (RoleHelper.canManageEmployes(session)) { %>
        <a href="<%= request.getContextPath() %>/employes?action=lister" 
           class="nav-item <%= currentPage.contains("Employe") || currentPage.contains("employe") ? "active" : "" %>">
            <span class="nav-icon">👥</span>
            <span class="nav-text">Employés</span>
        </a>
        <% } %>

        <% if (RoleHelper.canManageDepartements(session)) { %>
        <a href="<%= request.getContextPath() %>/departements?action=lister" 
           class="nav-item <%= currentPage.contains("Departement") || currentPage.contains("departement") ? "active" : "" %>">
            <span class="nav-icon">🏛️</span>
            <span class="nav-text">Départements</span>
        </a>
        <% } %>
        
        <% if (RoleHelper.isChefDepartement(session)) { %>
        <a href="<%= request.getContextPath() %>/monDepartement?action=afficher" 
           class="nav-item <%= currentPage.contains("monDepartement") ? "active" : "" %>">
            <span class="nav-icon">🏛️</span>
            <span class="nav-text">Mon Département</span>
        </a>
        <% } %>

        <% if (RoleHelper.canManageProjets(session) || RoleHelper.isEmploye(session)) { %>
        <a href="<%= request.getContextPath() %>/projets?action=lister" 
           class="nav-item <%= currentPage.contains("Projet") || currentPage.contains("projet") ? "active" : "" %>">
            <span class="nav-icon">📁</span>
            <span class="nav-text">Projets</span>
        </a>
        <% } %>

        <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister" 
           class="nav-item <%= currentPage.contains("Fiche") || currentPage.contains("fiche") ? "active" : "" %>">
            <span class="nav-icon">💰</span>
            <span class="nav-text">Fiches de Paie</span>
        </a>

        <% if (RoleHelper.canViewStatistics(session)) { %>
        <a href="<%= request.getContextPath() %>/statistiques?action=afficher" 
           class="nav-item <%= currentPage.contains("statistiques") ? "active" : "" %>">
            <span class="nav-icon">📊</span>
            <span class="nav-text">Statistiques</span>
        </a>
        <% } %>

        <div class="nav-spacer"></div>

        <% if (nomComplet != null) { %>
        <a href="<%= request.getContextPath() %>/auth?action=logout" class="nav-item nav-logout">
            <span class="nav-icon">🚪</span>
            <span class="nav-text">Déconnexion</span>
        </a>
        <% } %>
    </div>
</nav>

<style>
/* ==================== HEADER MODERNE ==================== */
.modern-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 1.5rem 2rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.header-content {
    max-width: 1400px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.logo-section {
    flex: 1;
}

.logo-title {
    font-size: 1.8rem;
    font-weight: 700;
    margin: 0;
    letter-spacing: -0.5px;
}

.logo-subtitle {
    margin: 0.25rem 0 0 0;
    font-size: 0.9rem;
    opacity: 0.95;
    font-weight: 300;
}

.user-info {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.user-badge {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    background: rgba(255, 255, 255, 0.15);
    padding: 0.5rem 1rem;
    border-radius: 50px;
    backdrop-filter: blur(10px);
}

.user-icon {
    font-size: 1.5rem;
}

.user-details {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

.user-name {
    font-weight: 600;
    font-size: 0.95rem;
}

.user-role {
    font-size: 0.75rem;
    opacity: 0.9;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    font-weight: 500;
}

/* ==================== NAVBAR MODERNE ==================== */
.modern-navbar {
    background: linear-gradient(to bottom, #2d3748, #1a202c);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    position: sticky;
    top: 0;
    z-index: 100;
}

.nav-container {
    max-width: 1400px;
    margin: 0 auto;
    display: flex;
    align-items: center;
    padding: 0 1rem;
}

.nav-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 1rem 1.25rem;
    color: #e2e8f0;
    text-decoration: none;
    transition: all 0.3s ease;
    border-bottom: 3px solid transparent;
    font-weight: 500;
    position: relative;
}

.nav-item:hover {
    background: rgba(255, 255, 255, 0.05);
    color: white;
    border-bottom-color: #667eea;
}

.nav-item.active {
    background: rgba(102, 126, 234, 0.15);
    color: white;
    border-bottom-color: #667eea;
}

.nav-icon {
    font-size: 1.2rem;
}

.nav-text {
    font-size: 0.95rem;
}

.nav-spacer {
    flex: 1;
}

.nav-logout {
    color: #fc8181 !important;
    margin-left: 1rem;
}

.nav-logout:hover {
    background: rgba(252, 129, 129, 0.1) !important;
    border-bottom-color: #fc8181 !important;
}

/* ==================== RESPONSIVE ==================== */
@media (max-width: 768px) {
    .modern-header {
        padding: 1rem;
    }
    
    .header-content {
        flex-direction: column;
        gap: 1rem;
    }
    
    .nav-container {
        flex-wrap: wrap;
        padding: 0;
    }
    
    .nav-item {
        padding: 0.75rem 1rem;
        font-size: 0.9rem;
    }
    
    .nav-text {
        display: none;
    }
    
    .nav-icon {
        font-size: 1.5rem;
    }
    
    .user-details {
        display: none;
    }
}
</style>
