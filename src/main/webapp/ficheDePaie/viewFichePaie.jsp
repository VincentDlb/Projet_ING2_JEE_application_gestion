<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.FicheDePaie" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%@ page import="java.time.LocalDate" %>
<%!
    public String getMonthName(int month) {
        String[] months = {"Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                          "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
        return months[month - 1];
    }

%>
<%
    FicheDePaie fiche = (FicheDePaie) request.getAttribute("fiche");
    String nomComplet = (String) session.getAttribute("nomComplet");
    String userRole = (String) session.getAttribute("userRole");
    
    // Récupérer l'origine pour le retour
    String returnTo = request.getParameter("returnTo");
    String projetId = request.getParameter("projetId");
    
    // Déterminer l'URL de retour
    String urlRetour = request.getContextPath() + "/fichesDePaie?action=mesFiches";
    String labelRetour = "Retour à mes fiches";
    
    if ("equipe".equals(returnTo) && projetId != null) {
        urlRetour = request.getContextPath() + "/mesProjets?action=fichesPaieEquipe&id=" + projetId;
        labelRetour = "Retour aux fiches de l'équipe";
    } else if ("admin".equals(returnTo)) {
        urlRetour = request.getContextPath() + "/fichesDePaie?action=lister";
        labelRetour = "Retour à la liste";
    }
    boolean isAdmin = RoleHelper.isAdmin(session);
    boolean isChefDept = RoleHelper.isChefDepartement(session);
    boolean isChefProjet = RoleHelper.isChefProjet(session);
    boolean isEmploye = RoleHelper.isEmploye(session);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiche de Paie - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        @media print {
            .no-print {
                display: none !important;
            }
            body {
                background: white;
            }
            .fiche-paie {
                box-shadow: none !important;
                border: 1px solid black !important;
            }
        }
        
        .fiche-paie {
            max-width: 800px;
            margin: var(--spacing-xl) auto;
            background: white;
            color: #1a1a1a;
            padding: var(--spacing-xl);
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .fiche-header {
            text-align: center;
            border-bottom: 3px solid #6366f1;
            padding-bottom: var(--spacing-lg);
            margin-bottom: var(--spacing-xl);
        }
        
        .fiche-section {
            margin-bottom: var(--spacing-lg);
            padding: var(--spacing-md);
            border: 1px solid #e2e8f0;
            border-radius: 4px;
        }
        
        .fiche-row {
            display: flex;
            justify-content: space-between;
            padding: var(--spacing-sm) 0;
            border-bottom: 1px solid #f1f5f9;
        }
        
        .fiche-row:last-child {
            border-bottom: none;
        }
        
        .label {
            font-weight: 600;
            color: #475569;
        }
        
        .value {
            color: #1e293b;
        }
        
        .montant {
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .section-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #6366f1;
            margin-bottom: var(--spacing-md);
            padding-bottom: var(--spacing-xs);
            border-bottom: 2px solid #e2e8f0;
        }
        
        .total-row {
            background-color: #f8fafc;
            font-weight: 700;
            font-size: 1.2rem;
            padding: var(--spacing-md);
            margin-top: var(--spacing-md);
            border-radius: 4px;
            border: 2px solid #6366f1;
        }
        
        /* Boutons d'action améliorés */
        .action-bar {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: var(--spacing-lg);
        }
        
        .btn-print {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4);
        }
        
        .btn-pdf {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-pdf:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.4);
            color: white;
        }
        
        .btn-back {
            background: linear-gradient(135deg, #64748b 0%, #475569 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(100, 116, 139, 0.4);
            color: white;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- NAVBAR EMPLOYÉ CORRECTE -->
        <header class="app-header no-print">
            <h1>💰 Fiche de Paie</h1>
            <p>RowTech - Système de Gestion RH</p>
        </header>

        <nav class="nav-menu">
            <a href="accueil.jsp">🏠 Accueil</a>
            
            <% if (RoleHelper.canManageEmployes(session)) { %>
                <a href="employes?action=lister">👥 Employés</a>
            <% } %>
            
            <% if (RoleHelper.canManageDepartements(session)) { %>
                <a href="departements?action=lister">🏛️ Départements</a>
            <% } %>
            
            <% if (RoleHelper.isChefDepartement(session)) { %>
                <a href="monDepartement?action=afficher">🏛️ Mon Département</a>
            <% } %>
            
            
            
            
            <% if (RoleHelper.canViewStatistics(session)) { %>
            	<a href="fichesDePaie?action=afficher">📁 Projets</a>
            <a href="projets?action=lister" class="active">💰 Fiches de Paie</a>
                <a href="statistiques?action=afficher">📊 Statistiques</a>
            <% } %>
            
            <%
               
                if (nomComplet != null) {
            %>
                <span style="color: var(--text-light); margin-left: auto; padding: 10px;">
                    👤 <%= nomComplet %> (<%= userRole %>)
                </span>
                <a href="auth?action=logout" style="background: var(--danger);">🚪 Déconnexion</a>
            <%
                } else {
            %>
                <a href="auth.jsp">🔒 Connexion</a>
            <%
                }
            %>
        </nav>

        <div class="content">
            <% if (fiche != null) { %>
            
            <!-- Barre d'actions améliorée -->
            <div class="action-bar no-print">
                <button onclick="window.print()" class="btn-print">
                    🖨️ Imprimer
                </button>
                
                
            </div>

            <div class="fiche-paie">
                <div class="fiche-header">
                    <h1 style="color: #6366f1; margin-bottom: var(--spacing-sm);">FICHE DE PAIE</h1>
                    <p style="font-size: 1.2rem; font-weight: 600; color: #64748b;">
                        <%= getMonthName(fiche.getMois()) %> <%= fiche.getAnnee() %>
                    </p>
                </div>

                <!-- Informations employeur -->
                <div class="fiche-section">
                    <h2 class="section-title">Employeur</h2>
                    <div class="fiche-row">
                        <span class="label">Raison sociale :</span>
                        <span class="value">RowTech SAS</span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">SIRET :</span>
                        <span class="value">XXX XXX XXX XXXXX</span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">Adresse :</span>
                        <span class="value">123 Avenue de l'Innovation, 75001 Paris</span>
                    </div>
                </div>

                <!-- Informations salarié -->
                <div class="fiche-section">
                    <h2 class="section-title">Salarié</h2>
                    <div class="fiche-row">
                        <span class="label">Nom :</span>
                        <span class="value"><%= fiche.getEmploye().getNom() %> <%= fiche.getEmploye().getPrenom() %></span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">Matricule :</span>
                        <span class="value"><%= fiche.getEmploye().getMatricule() %></span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">Poste :</span>
                        <span class="value"><%= fiche.getEmploye().getPoste() != null ? fiche.getEmploye().getPoste() : "N/A" %></span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">Grade :</span>
                        <span class="value"><%= fiche.getEmploye().getGrade() != null ? fiche.getEmploye().getGrade() : "N/A" %></span>
                    </div>
                </div>

                <!-- Rémunération brute -->
                <div class="fiche-section">
                    <h2 class="section-title">Rémunération Brute</h2>
                    <div class="fiche-row">
                        <span class="label">Salaire de base :</span>
                        <span class="value montant"><%= String.format("%.2f €", fiche.getSalaireDeBase()) %></span>
                    </div>
                    <% if (fiche.getPrimes() > 0) { %>
                    <div class="fiche-row">
                        <span class="label">Primes :</span>
                        <span class="value montant"><%= String.format("%.2f €", fiche.getPrimes()) %></span>
                    </div>
                    <% } %>
                    <% if (fiche.getHeuresSupp() > 0) { %>
                    <div class="fiche-row">
                        <span class="label">Heures supplémentaires :</span>
                        <span class="value montant"><%= String.format("%.2f €", fiche.getHeuresSupp()) %></span>
                    </div>
                    <% } %>
                    <div class="total-row fiche-row">
                        <span class="label">TOTAL BRUT :</span>
                        <span class="value montant" style="color: #6366f1;"><%= String.format("%.2f €", fiche.getSalaireBrut()) %></span>
                    </div>
                </div>

                <!-- Cotisations sociales -->
                <div class="fiche-section">
                    <h2 class="section-title">Cotisations Sociales Salariales</h2>
                    <div class="fiche-row">
                        <span class="label">Sécurité sociale (0,75%) :</span>
                        <span class="value montant">- <%= String.format("%.2f €", fiche.getCotisationSecu()) %></span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">Assurance vieillesse (11,45%) :</span>
                        <span class="value montant">- <%= String.format("%.2f €", fiche.getCotisationVieillesse()) %></span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">Assurance chômage (2,4%) :</span>
                        <span class="value montant">- <%= String.format("%.2f €", fiche.getCotisationChomage()) %></span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">Retraite complémentaire (7,87%) :</span>
                        <span class="value montant">- <%= String.format("%.2f €", fiche.getCotisationRetraite()) %></span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">CSG (9,2%) :</span>
                        <span class="value montant">- <%= String.format("%.2f €", fiche.getCotisationCSG()) %></span>
                    </div>
                    <div class="fiche-row">
                        <span class="label">CRDS (0,5%) :</span>
                        <span class="value montant">- <%= String.format("%.2f €", fiche.getCotisationCRDS()) %></span>
                    </div>
                    <div class="total-row fiche-row">
                        <span class="label">TOTAL COTISATIONS :</span>
                        <span class="value montant" style="color: #dc2626;">- <%= String.format("%.2f €", fiche.getTotalCotisations()) %></span>
                    </div>
                </div>

                <!-- Autres déductions -->
                <% if (fiche.getDeductions() > 0 || fiche.getJoursAbsence() > 0) { %>
                <div class="fiche-section">
                    <h2 class="section-title">Autres Déductions</h2>
                    <% if (fiche.getDeductions() > 0) { %>
                    <div class="fiche-row">
                        <span class="label">Diverses déductions :</span>
                        <span class="value montant">- <%= String.format("%.2f €", fiche.getDeductions()) %></span>
                    </div>
                    <% } %>
                    <% if (fiche.getJoursAbsence() > 0) { %>
                    <div class="fiche-row">
                        <span class="label">Absences (<%= fiche.getJoursAbsence() %> jours) :</span>
                        <span class="value montant">- <%= String.format("%.2f €", fiche.getDeductionAbsence()) %></span>
                    </div>
                    <% } %>
                </div>
                <% } %>

                <!-- Net à payer -->
                <div class="fiche-section" style="background-color: #eff6ff; border: 3px solid #6366f1;">
                    <div class="fiche-row" style="border: none;">
                        <span class="label" style="font-size: 1.4rem; color: #1e40af;">NET À PAYER :</span>
                        <span class="value montant" style="font-size: 1.8rem; color: #1e40af;">
                            <%= String.format("%.2f €", fiche.getNetAPayer()) %>
                        </span>
                    </div>
                </div>

                <!-- Pied de page -->
                <div style="margin-top: var(--spacing-xl); padding-top: var(--spacing-lg); border-top: 2px solid #e2e8f0; text-align: center; color: #64748b; font-size: 0.9rem;">
                    <p>Document généré automatiquement par le système RowTech RH</p>
                    <p style="margin-top: var(--spacing-xs);">Pour toute question, contactez le service RH : rh@rowtech.com</p>
                </div>
            </div>

            <% } else { %>
                <div class="alert alert-danger">
                    ⚠️ Fiche de paie introuvable
                </div>
                <a href="<%= request.getContextPath() %>/fichesDePaie?action=mesFiches" class="btn btn-secondary">
                    ← Retour à mes fiches
                </a>
            <% } %>
        </div>

        <footer class="no-print">
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
