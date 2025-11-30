<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Departement departement = (Departement) request.getAttribute("departement");
    List<Employe> membresActuels = (List<Employe>) request.getAttribute("membresActuels");
    List<Employe> employesDisponibles = (List<Employe>) request.getAttribute("employesDisponibles");
    
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gérer les Membres - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .team-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-top: var(--spacing-lg);
        }
        
        @media (max-width: 900px) {
            .team-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .team-section {
            background: var(--dark-light);
            border-radius: 16px;
            padding: var(--spacing-lg);
            border: 2px solid var(--border);
        }
        
        .team-section.membres {
            border-color: var(--accent);
        }
        
        .team-section h3 {
            color: var(--text-primary);
            margin-bottom: var(--spacing-md);
            padding-bottom: var(--spacing-sm);
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .membre-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px;
            background: var(--dark);
            border-radius: 10px;
            margin-bottom: 10px;
            border: 1px solid var(--border);
            transition: all 0.2s ease;
        }
        
        .membre-item:hover {
            border-color: var(--primary);
            transform: translateX(3px);
        }
        
        .membre-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .membre-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: white;
            font-size: 0.9rem;
        }
        
        .membre-avatar.chef {
            background: linear-gradient(135deg, var(--accent) 0%, #d4a800 100%);
            color: #000;
        }
        
        .membre-avatar.disponible {
            background: linear-gradient(135deg, var(--success) 0%, #059669 100%);
        }
        
        .membre-details h4 {
            color: var(--text-primary);
            margin: 0;
            font-size: 1rem;
        }
        
        .membre-details p {
            color: var(--text-muted);
            margin: 3px 0 0 0;
            font-size: 0.85rem;
        }
        
        .chef-indicator {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            background: var(--accent);
            color: #000;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.7rem;
            font-weight: 700;
            margin-left: 8px;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-muted);
        }
        
        .empty-state .icon {
            font-size: 50px;
            margin-bottom: 15px;
            opacity: 0.5;
        }
        
        .stats-bar {
            display: flex;
            gap: 20px;
            margin-bottom: var(--spacing-lg);
            padding: var(--spacing-md);
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.1) 0%, rgba(212, 175, 55, 0.05) 100%);
            border-radius: 12px;
            border: 1px solid rgba(212, 175, 55, 0.3);
        }
        
        .stat-item {
            text-align: center;
            flex: 1;
        }
        
        .stat-item .value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent);
        }
        
        .stat-item .label {
            color: var(--text-muted);
            font-size: 0.85rem;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>👥 Gérer les Membres</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            <a href="<%= request.getContextPath() %>/monDepartement?action=afficher" class="active">🏛️ Mon Département</a>
            <a href="<%= request.getContextPath() %>/mesProjets?action=lister">📁 Mes Projets</a>
            <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
            
            <% if (RoleHelper.canViewStatistics(session)) { %>
                <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                👤 <%= nomComplet %> (<%= userRole %>)
            </span>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                🚪 Déconnexion
            </a>
        </nav>

        <div class="content">
            <!-- Messages -->
            <% if ("membre_ajoute".equals(message)) { %>
                <div class="alert alert-success">✅ L'employé a été ajouté au département avec succès !</div>
            <% } else if ("membre_retire".equals(message)) { %>
                <div class="alert alert-success">✅ L'employé a été retiré du département avec succès !</div>
            <% } %>
            
            <% if (erreur != null) { %>
                <div class="alert alert-danger">⚠️ Erreur : <%= erreur %></div>
            <% } %>

            <h2 class="page-title"> Gestion des membres : <%= departement.getNom() %></h2>
            
            <!-- Barre de statistiques -->
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="value"><%= membresActuels != null ? membresActuels.size() : 0 %></div>
                    <div class="label">Membres actuels</div>
                </div>
                <div class="stat-item">
                    <div class="value"><%= employesDisponibles != null ? employesDisponibles.size() : 0 %></div>
                    <div class="label">Employés disponibles</div>
                </div>
            </div>
            
            <!-- Bouton retour -->
            <div style="margin-bottom: var(--spacing-lg);">
                <a href="<%= request.getContextPath() %>/monDepartement?action=afficher" class="btn btn-secondary">
                    ← Retour à mon département
                </a>
            </div>

            <div class="team-grid">
                <!-- Membres actuels du département -->
                <div class="team-section membres">
                    <h3>
                        <span style="font-size: 1.3rem;"></span>
                        Membres du département (<%= membresActuels != null ? membresActuels.size() : 0 %>)
                    </h3>
                    
                    <% if (membresActuels != null && !membresActuels.isEmpty()) { %>
                        <% for (Employe membre : membresActuels) {
                            String initiales = "";
                            if (membre.getPrenom() != null && membre.getPrenom().length() > 0) {
                                initiales += membre.getPrenom().charAt(0);
                            }
                            if (membre.getNom() != null && membre.getNom().length() > 0) {
                                initiales += membre.getNom().charAt(0);
                            }
                            
                            // Vérifier si c'est le chef du département
                            boolean estChef = departement.getChefDepartement() != null && 
                                              departement.getChefDepartement().getId().equals(membre.getId());
                        %>
                        <div class="membre-item">
                            <div class="membre-info">
                                <div class="membre-avatar <%= estChef ? "chef" : "" %>">
                                    <%= initiales.toUpperCase() %>
                                </div>
                                <div class="membre-details">
                                    <h4>
                                        <%= membre.getPrenom() %> <%= membre.getNom() %>
                                        <% if (estChef) { %>
                                            <span class="chef-indicator">👑 CHEF</span>
                                        <% } %>
                                    </h4>
                                    <p>
                                        <%= membre.getMatricule() %> 
                                        <% if (membre.getPoste() != null) { %>
                                            • <%= membre.getPoste() %>
                                        <% } %>
                                        <% if (membre.getGrade() != null) { %>
                                            • <%= membre.getGrade() %>
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                            
                            <% if (!estChef) { %>
                                <form action="<%= request.getContextPath() %>/monDepartement" method="post" style="margin: 0;">
                                    <input type="hidden" name="action" value="retirerMembre">
                                    <input type="hidden" name="departementId" value="<%= departement.getId() %>">
                                    <input type="hidden" name="employeId" value="<%= membre.getId() %>">
                                    <button type="submit" 
                                            class="btn btn-danger" 
                                            style="padding: 6px 12px; font-size: 0.8rem;"
                                            onclick="return confirm('Êtes-vous sûr de vouloir retirer cet employé du département ?');">
                                        ❌ Retirer
                                    </button>
                                </form>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-size: 0.8rem; font-style: italic;">
                                    (vous)
                                </span>
                            <% } %>
                        </div>
                        <% } %>
                    <% } else { %>
                        <div class="empty-state">
                            <div class="icon"></div>
                            <p>Aucun membre dans ce département.</p>
                        </div>
                    <% } %>
                </div>
                
                <!-- Employés disponibles (sans département) -->
                <div class="team-section">
                    <h3>
                        <span style="font-size: 1.3rem;"></span>
                        Employés disponibles (<%= employesDisponibles != null ? employesDisponibles.size() : 0 %>)
                    </h3>
                    
                    <% if (employesDisponibles != null && !employesDisponibles.isEmpty()) { %>
                        <% for (Employe emp : employesDisponibles) {
                            String initiales = "";
                            if (emp.getPrenom() != null && emp.getPrenom().length() > 0) {
                                initiales += emp.getPrenom().charAt(0);
                            }
                            if (emp.getNom() != null && emp.getNom().length() > 0) {
                                initiales += emp.getNom().charAt(0);
                            }
                        %>
                        <div class="membre-item">
                            <div class="membre-info">
                                <div class="membre-avatar disponible">
                                    <%= initiales.toUpperCase() %>
                                </div>
                                <div class="membre-details">
                                    <h4><%= emp.getPrenom() %> <%= emp.getNom() %></h4>
                                    <p>
                                        <%= emp.getMatricule() %>
                                        <% if (emp.getPoste() != null) { %>
                                            • <%= emp.getPoste() %>
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                            
                            <form action="<%= request.getContextPath() %>/monDepartement" method="post" style="margin: 0;">
                                <input type="hidden" name="action" value="ajouterMembre">
                                <input type="hidden" name="departementId" value="<%= departement.getId() %>">
                                <input type="hidden" name="employeId" value="<%= emp.getId() %>">
                                <button type="submit" 
                                        class="btn btn-success" 
                                        style="padding: 6px 12px; font-size: 0.8rem;">
                                    ➕ Ajouter
                                </button>
                            </form>
                        </div>
                        <% } %>
                    <% } else { %>
                        <div class="empty-state">
                            <div class="icon"></div>
                            <p>Tous les employés sont déjà assignés à un département.</p>
                        </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Info box -->
            <div style="margin-top: var(--spacing-xl); padding: var(--spacing-md); background: var(--dark-light); border-radius: 12px; border-left: 4px solid var(--primary);">
                <p style="color: var(--text-secondary); margin: 0; font-size: 0.9rem;">
                     <strong>Note :</strong> Seuls les employés sans département peuvent être ajoutés. 
                    Pour transférer un employé d'un autre département, contactez un administrateur.
                </p>
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
