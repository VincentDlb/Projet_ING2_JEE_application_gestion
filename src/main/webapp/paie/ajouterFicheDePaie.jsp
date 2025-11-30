<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Créer une Fiche de Paie");
    request.setAttribute("pageBreadcrumb", "Fiches de Paie / Ajouter");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer une Fiche de Paie - JEE RH</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
    <script>
    // Calcul automatique du salaire net
    function calculerSalaireNet() {
        var brut = parseFloat(document.getElementById('salaireBrut').value) || 0;
        var bonus = parseFloat(document.getElementById('bonus').value) || 0;
        var deduction = parseFloat(document.getElementById('deduction').value) || 0;
        var net = brut + bonus - deduction;
        document.getElementById('salaireNetDisplay').textContent = net.toFixed(2) + ' €';
    }
    </script>
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

            <!-- Bouton retour -->
            <div style="margin-bottom: 1.5rem;">
                <a href="<%= request.getContextPath() %>/fichesdepaie" class="btn btn-secondary">
                    ◀️ Retour à la liste
                </a>
            </div>

            <!-- Messages d'erreur -->
            <% String erreur = (String) request.getAttribute("erreur");
               if (erreur != null) { %>
                <div class="alert alert-error">
                    <strong>⚠️ Erreur :</strong> <%= erreur %>
                </div>
            <% } %>

            <!-- Formulaire de création -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">➕ Créer une Nouvelle Fiche de Paie</h3>
                </div>

                <form action="<%= request.getContextPath() %>/fichesdepaie" method="post" onsubmit="return confirm('Confirmer la création de cette fiche de paie ?');">
                    <input type="hidden" name="action" value="insert">

                    <!-- Informations de Base -->
                    <div style="margin-bottom: 2rem;">
                        <h4 style="color: #1f2937; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e5e7eb;">
                            📋 Informations de Base
                        </h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Employé <span style="color: #ef4444;">*</span></label>
                                <select name="employeId" class="form-control" required>
                                    <option value="">-- Sélectionner un employé --</option>
                                    <%
                                        List<Employe> employes = (List<Employe>) request.getAttribute("employes");
                                        if (employes != null) {
                                            for (Employe emp : employes) {
                                    %>
                                                <option value="<%= emp.getId() %>">
                                                    <%= emp.getNom() %> <%= emp.getPrenom() %> (Mat: <%= emp.getMatricule() %>)
                                                </option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Mois <span style="color: #ef4444;">*</span></label>
                                <select name="mois" class="form-control" required>
                                    <option value="">-- Sélectionner --</option>
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
                                <label class="form-label">Année <span style="color: #ef4444;">*</span></label>
                                <input type="number" name="annee" class="form-control" required min="2020" max="2030" value="2025">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Statut Cadre</label>
                                <select name="statutCadre" class="form-control">
                                    <option value="false">Non</option>
                                    <option value="true">Oui</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Rémunération -->
                    <div style="margin-bottom: 2rem;">
                        <h4 style="color: #1f2937; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e5e7eb;">
                            💰 Rémunération
                        </h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Salaire Brut (€) <span style="color: #ef4444;">*</span></label>
                                <input type="number" step="0.01" id="salaireBrut" name="salaireBrut" class="form-control" required min="0" placeholder="3000.00" onchange="calculerSalaireNet()">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Bonus / Primes (€)</label>
                                <input type="number" step="0.01" id="bonus" name="bonus" class="form-control" min="0" value="0" placeholder="500.00" onchange="calculerSalaireNet()">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Déductions (€)</label>
                                <input type="number" step="0.01" id="deduction" name="deduction" class="form-control" min="0" value="0" placeholder="600.00" onchange="calculerSalaireNet()">
                            </div>

                            <div style="padding: 1.5rem; background: linear-gradient(135deg, #dbeafe, #bfdbfe); border-radius: 0.75rem; display: flex; flex-direction: column; justify-content: center; align-items: center;">
                                <div style="font-weight: 600; color: #1e40af; margin-bottom: 0.5rem;">💰 Salaire Net</div>
                                <div id="salaireNetDisplay" style="font-size: 1.5rem; font-weight: bold; color: #1e3a8a;">0.00 €</div>
                            </div>
                        </div>
                    </div>

                    <!-- Heures de Travail -->
                    <div style="margin-bottom: 2rem;">
                        <h4 style="color: #1f2937; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e5e7eb;">
                            ⏰ Heures de Travail
                        </h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Heures Supplémentaires</label>
                                <input type="number" step="0.5" name="heureSupp" class="form-control" min="0" value="0" placeholder="10">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Taux Horaire (€/h)</label>
                                <input type="number" step="0.01" name="tauxHoraire" class="form-control" min="0" value="0" placeholder="15.50">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Heures / Semaine</label>
                                <input type="number" step="0.5" name="heureSemaine" class="form-control" min="0" value="35" placeholder="35">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Heures dans le Mois</label>
                                <input type="number" step="0.5" name="heureDansLeMois" class="form-control" min="0" value="151.67" placeholder="151.67">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Heures d'Absences</label>
                                <input type="number" step="0.5" name="heureAbsences" class="form-control" min="0" value="0" placeholder="7">
                            </div>
                        </div>
                    </div>

                    <!-- Informations Fiscales -->
                    <div style="margin-bottom: 2rem;">
                        <h4 style="color: #1f2937; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e5e7eb;">
                            🏛️ Informations Fiscales
                        </h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Numéro Fiscal <span style="color: #ef4444;">*</span></label>
                                <input type="number" name="numeroFiscal" class="form-control" required placeholder="1234567890123">
                            </div>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div style="display: flex; gap: 1rem; justify-content: flex-end; padding-top: 1.5rem; border-top: 2px solid #e5e7eb;">
                        <a href="<%= request.getContextPath() %>/fichesdepaie" class="btn btn-secondary">
                            Annuler
                        </a>
                        <button type="submit" class="btn btn-success">
                            ✅ Créer la Fiche de Paie
                        </button>
                    </div>
                </form>
            </div>

            <!-- Information -->
            <div class="alert alert-info" style="margin-top: 1.5rem;">
                <strong>ℹ️ Information :</strong> Les champs marqués d'un astérisque (<span style="color: #ef4444;">*</span>) sont obligatoires.
                Le salaire net est calculé automatiquement : <strong>Net = Brut + Bonus - Déductions</strong>
            </div>

        </div>

    </div>

</div>

</body>
</html>
