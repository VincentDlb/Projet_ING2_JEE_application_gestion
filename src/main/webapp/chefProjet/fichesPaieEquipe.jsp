<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.FicheDePaie" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    Projet projet = (Projet) request.getAttribute("projet");
    List<FicheDePaie> fichesDePaie = (List<FicheDePaie>) request.getAttribute("fichesDePaie");
    
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
    // Noms des mois en français
    String[] nomsMois = {"", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", 
                         "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
    
    int nbFiches = fichesDePaie != null ? fichesDePaie.size() : 0;
    Set<Employe> membres = projet.getEmployes();
    int nbMembres = membres != null ? membres.size() : 0;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiches de Paie - <%= projet.getNom() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .fiches-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .fiches-table th,
        .fiches-table td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }
        
        .fiches-table th {
            background: var(--dark);
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
        }
        
        .fiches-table td {
            color: var(--text-primary);
        }
        
        .fiches-table tr:hover td {
            background: rgba(99, 102, 241, 0.05);
        }
        
        .montant {
            font-weight: 700;
            color: var(--success);
        }
        
        .btn-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn-voir {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            padding: 8px 14px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }
        
        .btn-voir:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
            color: white;
        }
        
        .btn-pdf {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            padding: 8px 14px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }
        
        .btn-pdf:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
            color: white;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.85rem;
            border-radius: 6px;
        }
        
        .info-banner {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(99, 102, 241, 0.05) 100%);
            border: 1px solid rgba(99, 102, 241, 0.3);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .info-banner-item {
            text-align: center;
        }
        
        .info-banner-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-light);
        }
        
        .info-banner-label {
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--dark-light);
            border-radius: 16px;
            border: 2px dashed var(--border);
        }
        
        .content-card {
            background: var(--dark-light);
            border-radius: 16px;
            padding: 25px;
            border: 1px solid var(--border);
        }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1> Fiches de Paie de l'Équipe</h1>
            <p><%= projet.getNom() %> - RowTech</p>
        </header>

        <!-- NAVBAR EMPLOYÉ CORRECTE -->
        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
            <a href="<%= request.getContextPath() %>/monDepartement?action=afficher">🏛️ Mon Département</a>
            <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="active">📁 Mes Projets</a>
            <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches">💰 Fiches de Paie</a>
            
            <% if (RoleHelper.canViewStatistics(session)) { %>
                <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <span style="margin-left: auto; color: var(--text-secondary); padding: 10px;">
                 <%= nomComplet %> (<%= userRole %>)
            </span>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                 Déconnexion
            </a>
        </nav>

        <div class="content">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                <h2 class="page-title"> Fiches de Paie - <%= projet.getNom() %></h2>
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="btn btn-secondary">
                    ← Retour
                </a>
            </div>

            <!-- Bannière d'information -->
            <div class="info-banner">
                <div class="info-banner-item">
                    <div class="info-banner-value"></div>
                    <div class="info-banner-label"><%= projet.getNom() %></div>
                </div>
                <div class="info-banner-item">
                    <div class="info-banner-value"><%= nbMembres %></div>
                    <div class="info-banner-label">Membres</div>
                </div>
                <div class="info-banner-item">
                    <div class="info-banner-value"><%= nbFiches %></div>
                    <div class="info-banner-label">Fiches de paie</div>
                </div>
            </div>

            <div class="content-card">
                <% if (fichesDePaie != null && !fichesDePaie.isEmpty()) { %>
                    <div style="overflow-x: auto;">
                        <table class="fiches-table">
                            <thead>
                                <tr>
                                    <th>Employé</th>
                                    <th>Période</th>
                                    <th>Salaire de base</th>
                                    <th>Primes</th>
                                    <th>Net à payer</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (FicheDePaie fiche : fichesDePaie) { 
                                    Employe emp = fiche.getEmploye();
                                    String nomEmploye = emp != null ? emp.getPrenom() + " " + emp.getNom() : "N/A";
                                    String periode = nomsMois[fiche.getMois()] + " " + fiche.getAnnee();
                                %>
                                    <tr>
                                        <td><strong><%= nomEmploye %></strong></td>
                                        <td><%= periode %></td>
                                        <td><%= String.format("%,.2f €", fiche.getSalaireDeBase()) %></td>
                                        <td><%= String.format("%,.2f €", fiche.getPrimes()) %></td>
                                        <td class="montant"><%= String.format("%,.2f €", fiche.getNetAPayer()) %></td>
                                        <td>
                                            <div class="btn-actions">
                                                <a href="<%= request.getContextPath() %>/fichesDePaie?action=voir&id=<%= fiche.getId() %>&returnTo=equipe&projetId=<%= projet.getId() %>" 
                                                   class="btn-voir">
                                                    👁️ Voir
                                                </a>
                                                <a href="<%= request.getContextPath() %>/generatePdf?ficheId=<%= fiche.getId() %>" 
                                                   class="btn-pdf" target="_blank">
                                                     PDF
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    
                    <div style="margin-top: 20px; padding: 15px; background: var(--dark); border-radius: 10px; text-align: center;">
                        <p style="color: var(--text-muted); margin: 0;">
                             Total : <strong style="color: var(--primary-light);"><%= nbFiches %></strong> fiche(s) de paie pour <strong style="color: var(--primary-light);"><%= nbMembres %></strong> membre(s)
                        </p>
                    </div>
                    
                <% } else if (nbMembres == 0) { %>
                    <div class="empty-state">
                        <div style="font-size: 60px; margin-bottom: 15px; opacity: 0.5;"></div>
                        <h3 style="color: var(--text-primary); margin-bottom: 10px;">Aucun membre dans ce projet</h3>
                        <p style="color: var(--text-muted);">
                            Ajoutez des membres au projet pour voir leurs fiches de paie.
                        </p>
                        <a href="<%= request.getContextPath() %>/mesProjets?action=gererEquipe&id=<%= projet.getId() %>" class="btn btn-primary" style="margin-top: 15px;">
                             Gérer l'équipe
                        </a>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <div style="font-size: 60px; margin-bottom: 15px; opacity: 0.5;"></div>
                        <h3 style="color: var(--text-primary); margin-bottom: 10px;">Aucune fiche de paie</h3>
                        <p style="color: var(--text-muted);">
                            Les membres de ce projet n'ont pas encore de fiches de paie générées.
                        </p>
                    </div>
                <% } %>
            </div>

            <!-- Boutons d'action -->
            <div style="margin-top: 25px; display: flex; gap: 12px; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/mesProjets?action=lister" class="btn btn-secondary">
                    ← Retour à mes projets
                </a>
               
               
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
