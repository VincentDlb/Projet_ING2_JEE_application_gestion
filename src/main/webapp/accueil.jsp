<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
    if (nomComplet == null) {
        response.sendRedirect("auth.jsp?erreur=non_connecte");
        return;
    }
    
    // Vérifier les permissions de l'utilisateur
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
    
    boolean canManageEmployes = RoleHelper.canManageEmployes(session);
    boolean canManageDepartements = RoleHelper.canManageDepartements(session);
    boolean canManageProjets = RoleHelper.canManageProjets(session);
    boolean canCreateFichesPaie = RoleHelper.canCreateFichesPaie(session);
    boolean canViewStatistics = RoleHelper.canViewStatistics(session);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>🏢 RowTech - Gestion RH</h1>
            <p>Système de Gestion des Ressources Humaines</p>
        </header>

        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp" class="active">🏠 Accueil</a>
            
            <%-- Admin voit tout --%>
            <% if (isAdmin) { %>
                <a href="<%= request.getContextPath() %>/employes?action=lister">👥 Employés</a>
                <a href="<%= request.getContextPath() %>/departements?action=lister">🏛️ Départements</a>
                <a href="<%= request.getContextPath() %>/projets?action=lister">📁 Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister">💰 Fiches de Paie</a>
                <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <%-- Chef de département --%>
            <% if (isChefDept) { %>
                <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister">📁 Mes Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
                <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <%-- Chef de projet --%>
            <% if (isChefProjet) { %>
                <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister">📁 Mes Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
                <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <%-- Employé simple --%>
            <% if (isEmploye) { %>
                <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister">📁 Mes Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
            <% } %>
            
            <span style="margin-left: auto; color: var(--text-secondary);">
                 <%= nomComplet %> (<%= userRole %>)
            </span>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                 Déconnexion
            </a>
        </nav>

        <div class="content">
            <h2 class="page-title">Bienvenue, <%= nomComplet %> !</h2>

            <div style="text-align: center; margin: 40px 0;">
                <p style="font-size: 1.2rem; color: var(--text-secondary);">
                    Vous êtes connecté en tant que : <strong style="color: var(--accent-light);"><%= userRole %></strong>
                </p>
            </div>

            <!-- Modules disponibles selon les permissions -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-top: 40px;">
                
                <%-- ============================================= --%>
                <%-- MODULES ADMIN --%>
                <%-- ============================================= --%>
                <% if (isAdmin) { %>
                
                <!-- Gestion des Employés -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">👥</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Gestion des Employés</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Ajouter, modifier, consulter les employés
                    </p>
                    
                </div>
                
                <!-- Gestion des Départements -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">🏛️</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Gestion des Départements</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Créer, gérer les départements
                    </p>
                    
                </div>
                
                <!-- Gestion des Projets -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📁</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Gestion des Projets</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Créer, suivre les projets internes
                    </p>
                    
                </div>
                
                <!-- Fiches de Paie -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">💰</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Fiches de Paie</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Générer, consulter toutes les fiches de paie
                    </p>
                    
                </div>
                
                <!-- Statistiques -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📊</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Statistiques</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les rapports et analyses
                    </p>
                    
                </div>
                
                <% } %>
                
                <%-- ============================================= --%>
                <%-- MODULES CHEF DE DÉPARTEMENT --%>
                <%-- ============================================= --%>
                <% if (isChefDept) { %>
                
                <!-- Mon Département -->
                <div class="card" style="border: 2px solid var(--accent);">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">🏛️</div>
                    <h3 style="color: var(--accent-light); text-align: center; margin-bottom: 10px;">Mon Département</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Gérer votre département et ses membres
                    </p>
                    <a href="<%= request.getContextPath() %>/monDepartement?action=afficher" class="btn btn-primary" style="width: 100%;">
                        Accéder
                    </a>
                </div>
                
                <!-- Mes Projets -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📁</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Mes Projets</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les projets auxquels vous participez
                    </p>
                    
                </div>
                
                <!-- Fiches de Paie Équipe -->
                <div class="card" style="border: 2px solid var(--accent);">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">💰</div>
                    <h3 style="color: var(--accent-light); text-align: center; margin-bottom: 10px;">Fiches de Paie</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Gérer les fiches de votre équipe
                    </p>

                </div>
                
                <!-- Statistiques -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📊</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Statistiques</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les rapports de votre département
                    </p>
                    
                </div>
                
                <% } %>
                
                <%-- ============================================= --%>
                <%-- MODULES CHEF DE PROJET --%>
                <%-- ============================================= --%>
                <% if (isChefProjet) { %>
                
                <!-- Mon Département (lecture seule) -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">🏛️</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Mon Département</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir votre département
                    </p>
                    <a href="<%= request.getContextPath() %>/monDepartement?action=afficher" class="btn btn-primary" style="width: 100%;">
                        Accéder
                    </a>
                </div>
                
                <!-- Mes Projets -->
                <div class="card" style="border: 2px solid var(--accent);">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📁</div>
                    <h3 style="color: var(--accent-light); text-align: center; margin-bottom: 10px;">Mes Projets</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Gérer vos projets et leurs membres
                    </p>
                    
                </div>
                
                <!-- Fiches de Paie Équipe -->
                <div class="card" style="border: 2px solid var(--accent);">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">💰</div>
                    <h3 style="color: var(--accent-light); text-align: center; margin-bottom: 10px;">Fiches de Paie</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Gérer les fiches de votre équipe projet
                    </p>
                    
                </div>
                
                <!-- Statistiques -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📊</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Statistiques</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les rapports de vos projets
                    </p>
                    
                </div>
                
                <% } %>
                
                <%-- ============================================= --%>
                <%-- MODULES EMPLOYÉ SIMPLE --%>
                <%-- ============================================= --%>
                <% if (isEmploye) { %>
                
                <!-- Mon Département (lecture seule) -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">🏛️</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Mon Département</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir votre département et collègues
                    </p>
                    
                </div>
                
                <!-- Mes Projets (lecture seule) -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">📁</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Mes Projets</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Voir les projets auxquels vous participez
                    </p>
                    
                </div>
                
                <!-- Mes Fiches de Paie -->
                <div class="card">
                    <div style="font-size: 50px; text-align: center; margin-bottom: 15px;">💰</div>
                    <h3 style="color: var(--text-primary); text-align: center; margin-bottom: 10px;">Fiches de Paie</h3>
                    <p style="color: var(--text-muted); text-align: center; margin-bottom: 20px;">
                        Consulter vos fiches de paie
                    </p>
                    
                </div>
                
                <% } %>
                
            </div>

            <!-- Messages informatifs selon le rôle -->
            <% if (isEmploye) { %>
            <div style="margin-top: 40px; padding: 20px; background: rgba(59, 130, 246, 0.1); border-radius: 12px; border: 1px solid rgba(59, 130, 246, 0.3);">
                <p style="color: var(--text-secondary); margin: 0;">
                     <strong>Note :</strong> En tant qu'employé, vous avez accès uniquement à vos propres fiches de paie.
                </p>
            </div>
            <% } else if (isChefDept) { %>
            <div style="margin-top: 40px; padding: 20px; background: rgba(245, 158, 11, 0.1); border-radius: 12px; border: 1px solid rgba(245, 158, 11, 0.3);">
                <p style="color: var(--text-secondary); margin: 0;">
                     <strong>Chef de Département :</strong> Vous pouvez gérer votre département, ses membres et leurs fiches de paie.
                </p>
            </div>
            <% } else if (isChefProjet) { %>
            <div style="margin-top: 40px; padding: 20px; background: rgba(139, 92, 246, 0.1); border-radius: 12px; border: 1px solid rgba(139, 92, 246, 0.3);">
                <p style="color: var(--text-secondary); margin: 0;">
                     <strong>Chef de Projet :</strong> Vous pouvez gérer vos projets, leurs membres et leurs fiches de paie.
                </p>
            </div>
            <% } %>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
