<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.FicheDePaie" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    // Récupération des données
    List<FicheDePaie> listeFiches = (List<FicheDePaie>) request.getAttribute("listeFiches");
    String message = request.getParameter("message");
    String erreur = request.getParameter("erreur");
    
    // Vérification des permissions
    boolean canCreateFiches = RoleHelper.canCreateFichesPaie(session);
    boolean canViewAll = RoleHelper.canViewAllFichesPaie(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
    boolean isAdmin = RoleHelper.isAdmin(session);
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiches de Paie - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .btn-pdf {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            color: white !important;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.3s ease;
        }
        
        .btn-pdf:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(220, 38, 38, 0.4);
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Header -->
        <header class="app-header">
            <h1>💰 Fiches de Paie</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <!-- Navigation adaptée selon le rôle -->
        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            
            <% if (isAdmin) { %>
                <!-- Navigation ADMIN -->
                <% if (RoleHelper.canManageEmployes(session)) { %>
                    <a href="<%= request.getContextPath() %>/employes?action=lister">👥 Employés</a>
                <% } %>
                
                <% if (RoleHelper.canManageDepartements(session)) { %>
                    <a href="<%= request.getContextPath() %>/departements?action=lister">🏛️ Départements</a>
                <% } %>
                
                <% if (RoleHelper.canManageProjets(session)) { %>
                    <a href="<%= request.getContextPath() %>/projets?action=lister">📁 Projets</a>
                <% } %>
                
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister" class="active">💰 Fiches de Paie</a>
                
                <% if (RoleHelper.canViewStatistics(session)) { %>
                    <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
                <% } %>
            <% } else { %>
                <!-- Navigation EMPLOYÉ / CHEF -->
                <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister">📁 Mes Projets</a>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches" class="active">💰 Fiches de Paie</a>
            <% } %>
            
            <% if (nomComplet != null) { %>
                <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                     <%= nomComplet %> (<%= userRole %>)
                </span>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                     Déconnexion
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/auth.jsp"> Connexion</a>
            <% } %>
        </nav>

        <div class="content">
            <h2 class="page-title">
                <% if (isEmploye) { %>
                     Mes Fiches de Paie
                <% } else { %>
                     Liste des Fiches de Paie
                <% } %>
            </h2>

            <!-- Messages de succès -->
            <% if ("creation_ok".equals(message) || "ajout_ok".equals(message)) { %>
                <div class="alert alert-success">
                    ✅ La fiche de paie a été créée avec succès !
                </div>
            <% } else if ("suppression_ok".equals(message)) { %>
                <div class="alert alert-success">
                    ✅ La fiche de paie a été supprimée avec succès !
                </div>
            <% } %>
            
            <!-- Messages d'erreur -->
            <% if (erreur != null) { %>
                <div class="alert alert-danger">
                    ⚠️ Erreur : <%= erreur %>
                </div>
            <% } %>

            <!-- Boutons d'action (selon les permissions) -->
            <div class="actions" style="margin-bottom: 20px;">
                <% if (canCreateFiches) { %>
                    <a href="<%= request.getContextPath() %>/fichesDePaie?action=nouvelle" class="btn btn-primary">
                        ➕ Créer une fiche de paie
                    </a>
                <% } %>
                
                <% if (canViewAll) { %>
                    <a href="<%= request.getContextPath() %>/fichesDePaie?action=rechercher" class="btn btn-success">
                        🔍 Rechercher des fiches
                    </a>
                <% } %>
                
                <a href="<%= request.getContextPath() %>/accueil.jsp" class="btn btn-secondary">
                    ← Retour à l'accueil
                </a>
            </div>

            <!-- Tableau des fiches de paie -->
            <% if (listeFiches != null && !listeFiches.isEmpty()) { %>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <% if (!isEmploye) { %>
                                    <th>EMPLOYÉ</th>
                                <% } %>
                                <th>PÉRIODE</th>
                                <th>SALAIRE DE BASE</th>
                                <th>PRIMES</th>
                                <th>COTISATIONS</th>
                                <th>NET À PAYER</th>
                                <th>ACTIONS</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (FicheDePaie fiche : listeFiches) {
                                    String nomEmploye = fiche.getEmploye().getPrenom() + " " + fiche.getEmploye().getNom();
                                    String matricule = fiche.getEmploye().getMatricule();
                            %>
                            <tr>
                                <!-- Colonne Employé (masquée pour les employés) -->
                                <% if (!isEmploye) { %>
                                <td>
                                    <strong><%= nomEmploye %></strong><br>
                                    <small style="color: var(--text-muted);"><%= matricule %></small>
                                </td>
                                <% } %>
                                
                                <!-- Période -->
                                <td>
                                    <span class="badge badge-primary">
                                        <%= fiche.getMois() %> / <%= fiche.getAnnee() %>
                                    </span>
                                </td>
                                
                                <!-- Salaire de base -->
                                <td><%= String.format("%.2f", fiche.getSalaireDeBase()) %> €</td>
                                
                                <!-- Primes (en vert) -->
                                <td style="color: var(--success);">
                                    + <%= String.format("%.2f", fiche.getPrimes()) %> €
                                </td>
                                
                                <!-- Cotisations (en orange) -->
                                <td style="color: #f59e0b;">
                                    - <%= String.format("%.2f", fiche.getTotalCotisations()) %> €
                                </td>
                                
                                <!-- Net à payer (en gras) -->
                                <td style="font-weight: 800; color: var(--accent-light);">
                                    <%= String.format("%.2f", fiche.getNetAPayer()) %> €
                                </td>
                                
                                <!-- Boutons d'action -->
                                <td>
                                    <div style="display: flex; gap: 5px; justify-content: center; flex-wrap: wrap;">
                                        <!-- Bouton Voir -->
                                        <a href="<%= request.getContextPath() %>/fichesDePaie?action=voir&id=<%= fiche.getId() %>" 
                                           class="btn btn-primary" 
                                           style="padding: 6px 12px; font-size: 0.8rem;">
                                            👁️ Voir
                                        </a>
                                        
                                        <!-- Bouton PDF -->
                                        <a href="<%= request.getContextPath() %>/generatePdf?id=<%= fiche.getId() %>" 
                                           class="btn-pdf"
                                           title="Télécharger en PDF">
                                             PDF
                                        </a>
                                        
                                        <!-- Bouton Supprimer (uniquement admin) -->
                                        <% if (isAdmin) { %>
                                        <a href="<%= request.getContextPath() %>/fichesDePaie?action=supprimer&id=<%= fiche.getId() %>" 
                                           class="btn btn-danger" 
                                           style="padding: 6px 12px; font-size: 0.8rem;"
                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette fiche de paie ?');">
                                             Supprimer
                                        </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Compteur de fiches -->
                <div style="margin-top: var(--spacing-lg); padding: var(--spacing-md); background: var(--dark-light); border-radius: 12px; border: 1px solid var(--border);">
                    <p style="color: var(--text-secondary); margin: 0;">
                         <strong>Total :</strong> <%= listeFiches.size() %> fiche(s) de paie
                        <% if (isEmploye) { %>
                            pour vous
                        <% } %>
                    </p>
                </div>

            <% } else { %>
                <!-- Message si aucune fiche -->
                <div style="text-align: center; padding: var(--spacing-xl); background: var(--dark-light); border-radius: 16px; border: 2px dashed var(--border);">
                    <div style="font-size: 80px; margin-bottom: 20px; opacity: 0.3;"></div>
                    
                    <% if (isEmploye) { %>
                        <h3 style="color: var(--text-primary); margin-bottom: var(--spacing-sm);">Aucune fiche de paie</h3>
                        <p style="color: var(--text-muted); margin-bottom: var(--spacing-lg);">
                            Vous n'avez encore aucune fiche de paie. Contactez votre responsable RH.
                        </p>
                    <% } else { %>
                        <h3 style="color: var(--text-primary); margin-bottom: var(--spacing-sm);">Aucune fiche de paie</h3>
                        <p style="color: var(--text-muted); margin-bottom: var(--spacing-lg);">
                            Aucune fiche de paie n'a encore été créée.
                        </p>
                        <% if (canCreateFiches) { %>
                            <a href="<%= request.getContextPath() %>/fichesDePaie?action=nouvelle" class="btn btn-primary">
                                Créer la première fiche de paie
                            </a>
                        <% } %>
                    <% } %>
                </div>
            <% } %>

            <!-- Message info pour les employés -->
            <% if (isEmploye) { %>
            <div style="margin-top: 30px; padding: 20px; background: rgba(59, 130, 246, 0.1); border-radius: 12px; border: 1px solid rgba(59, 130, 246, 0.3);">
                <p style="color: var(--text-secondary); margin: 0;">
                     <strong>Information :</strong> Vous visualisez uniquement vos propres fiches de paie. Pour toute question, contactez le service RH.
                </p>
            </div>
            <% } %>
        </div>

        <!-- Pied de page -->
        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
