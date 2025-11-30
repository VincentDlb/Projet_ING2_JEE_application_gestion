<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.FicheDePaie" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Gestion des Fiches de Paie");
    request.setAttribute("pageBreadcrumb", "Fiches de Paie");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Fiches de Paie - JEE RH</title>
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

            <!-- Bouton d'ajout -->
            <div style="margin-bottom: 1.5rem;">
                <a href="<%= request.getContextPath() %>/fichesdepaie?action=insert" class="btn btn-success">
                    ➕ Créer une Fiche de Paie
                </a>
            </div>

            <!-- Formulaires de recherche -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">🔍 Rechercher des Fiches de Paie</h3>
                </div>

                <div class="form-grid">
                    <!-- Recherche par période -->
                    <div style="padding: 1.5rem; background: #f9fafb; border-radius: 0.5rem;">
                        <h4 style="margin-bottom: 1rem; color: #4b5563; font-size: 1rem;">📅 Par Période</h4>
                        <form action="<%= request.getContextPath() %>/fichesdepaie" method="get">
                            <input type="hidden" name="action" value="searchByPeriod">
                            <div class="form-group">
                                <select name="mois" class="form-control" required>
                                    <option value="">-- Mois --</option>
                                    <option value="1">Janvier</option>
                                    <option value="2">Février</option>
                                    <option value="3">Mars</option>
                                    <option value="4">Avril</option>
                                    <option value="5">Mai</option>
                                    <option value="6">Juin</option>
                                    <option value="7">Juillet</option>
                                    <option value="8">Août</option>
                                    <option value="9">Septembre</option>
                                    <option value="10">Octobre</option>
                                    <option value="11">Novembre</option>
                                    <option value="12">Décembre</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <input type="number" name="annee" class="form-control" placeholder="Année" required min="2020" max="2030" value="2025">
                            </div>
                            <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                        </form>
                    </div>

                    <!-- Recherche par année -->
                    <div style="padding: 1.5rem; background: #f9fafb; border-radius: 0.5rem;">
                        <h4 style="margin-bottom: 1rem; color: #4b5563; font-size: 1rem;">📆 Par Année</h4>
                        <form action="<%= request.getContextPath() %>/fichesdepaie" method="get">
                            <input type="hidden" name="action" value="searchByYear">
                            <div class="form-group">
                                <input type="number" name="annee" class="form-control" placeholder="Année" required min="2020" max="2030" value="2025">
                            </div>
                            <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                        </form>
                    </div>

                    <!-- Recherche par employé -->
                    <div style="padding: 1.5rem; background: #f9fafb; border-radius: 0.5rem;">
                        <h4 style="margin-bottom: 1rem; color: #4b5563; font-size: 1rem;">👤 Par Employé</h4>
                        <form action="<%= request.getContextPath() %>/fichesdepaie" method="get">
                            <input type="hidden" name="action" value="searchByEmployee">
                            <div class="form-group">
                                <input type="number" name="employeId" class="form-control" placeholder="ID Employé" required>
                            </div>
                            <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                        </form>
                    </div>
                </div>

                <div style="margin-top: 1rem; text-align: center;">
                    <a href="<%= request.getContextPath() %>/fichesdepaie" class="btn btn-secondary">
                        📋 Afficher Toutes les Fiches
                    </a>
                </div>
            </div>

            <!-- Messages -->
            <% String erreur = (String) request.getAttribute("erreur");
               if (erreur != null) { %>
                <div class="alert alert-error">
                    <strong>⚠️ Erreur :</strong> <%= erreur %>
                </div>
            <% } %>

            <% String filtre = (String) request.getAttribute("filtre");
               if (filtre != null) { %>
                <div class="alert alert-info">
                    <strong>🔍 Filtre actif :</strong> <%= filtre %>
                </div>
            <% } %>

            <!-- Liste des fiches de paie -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">📋 Liste des Fiches de Paie</h3>
                </div>

                <%
                    List<FicheDePaie> listeFiches = (List<FicheDePaie>) request.getAttribute("listeFiches");

                    if (listeFiches == null || listeFiches.isEmpty()) {
                %>
                    <div style="padding: 3rem; text-align: center; color: #6b7280;">
                        <div style="font-size: 1.25rem; margin-bottom: 0.5rem;">📭 Aucune fiche de paie trouvée</div>
                        <div style="font-size: 0.95rem;">Commencez par créer une fiche de paie pour un employé</div>
                    </div>
                <%
                    } else {
                %>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Employé</th>
                                    <th>Période</th>
                                    <th style="text-align: right;">Salaire Brut</th>
                                    <th style="text-align: right;">Bonus</th>
                                    <th style="text-align: right;">Déductions</th>
                                    <th style="text-align: right;">Salaire Net</th>
                                    <th style="text-align: center;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (FicheDePaie fiche : listeFiches) {
                                        float salaireNet = fiche.calculerSalaireNet();
                                %>
                                <tr>
                                    <td><%= fiche.getId() %></td>
                                    <td style="font-weight: 600;">
                                        <% if (fiche.getEmploye() != null) { %>
                                            <%= fiche.getEmploye().getNom() %> <%= fiche.getEmploye().getPrenom() %>
                                        <% } else { %>
                                            Employé ID <%= fiche.getEmployeId() %>
                                        <% } %>
                                    </td>
                                    <td><%= fiche.getNomMois() %> <%= fiche.getAnnee() %></td>
                                    <td style="text-align: right;"><%= String.format("%.2f €", fiche.getSalaireBrut()) %></td>
                                    <td style="text-align: right; color: #059669;"><%= String.format("%.2f €", fiche.getBonus()) %></td>
                                    <td style="text-align: right; color: #dc2626;"><%= String.format("%.2f €", fiche.getDeduction()) %></td>
                                    <td style="text-align: right; font-weight: bold; color: #1e40af;"><%= String.format("%.2f €", salaireNet) %></td>
                                    <td style="text-align: center;">
                                        <a href="<%= request.getContextPath() %>/fichesdepaie?action=view&id=<%= fiche.getId() %>"
                                           target="_blank"
                                           class="btn btn-primary"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem; margin-right: 0.5rem;">
                                            👁️ Voir/Imprimer
                                        </a>
                                        <a href="<%= request.getContextPath() %>/fichesdepaie?action=delete&id=<%= fiche.getId() %>"
                                           class="btn btn-danger"
                                           style="padding: 0.5rem 1rem; font-size: 0.8rem;"
                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette fiche de paie ?');">
                                            🗑️ Supprimer
                                        </a>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <div style="margin-top: 1.5rem; padding: 1rem; background: #f9fafb; border-radius: 0.5rem; text-align: center;">
                        <strong style="color: #4b5563;">📊 Total :</strong>
                        <span style="color: #1f2937;"><%= listeFiches.size() %> fiche(s) de paie</span>
                    </div>
                <%
                    }
                %>
            </div>

        </div>

    </div>

</div>

</body>
</html>
