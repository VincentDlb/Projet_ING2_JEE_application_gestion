<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Ajouter un Projet");
    request.setAttribute("pageBreadcrumb", "Projets > Ajouter");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un Projet - JEE RH</title>
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

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">➕ Créer un Nouveau Projet</h3>
                </div>

                <form method="post" action="<%= request.getContextPath() %>/ServletProjet">
                    <input type="hidden" name="action" value="insert">

                    <div class="form-grid">
                        <!-- Nom du projet -->
                        <div class="form-group">
                            <label class="form-label">Nom du projet <span style="color: #ef4444;">*</span></label>
                            <input type="text" name="nom" class="form-control" required placeholder="Ex: Refonte du site web">
                        </div>

                        <!-- Chef de projet -->
                        <div class="form-group">
                            <label class="form-label">Chef de projet <span style="color: #ef4444;">*</span></label>
                            <select name="chefDeProjetId" class="form-control" required>
                                <option value="">-- Sélectionnez un chef de projet --</option>
                                <%
                                    List<Employe> employes = (List<Employe>) request.getAttribute("employes");
                                    if (employes != null) {
                                        for (Employe employe : employes) {
                                %>
                                    <option value="<%= employe.getId() %>">
                                        <%= employe.getNom() %> <%= employe.getPrenom() %> (ID: <%= employe.getId() %>)
                                    </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <!-- Département -->
                        <div class="form-group">
                            <label class="form-label">Département <span style="color: #ef4444;">*</span></label>
                            <select name="departementId" class="form-control" required>
                                <option value="">-- Sélectionnez un département --</option>
                                <%
                                    List<Departement> departements = (List<Departement>) request.getAttribute("departements");
                                    if (departements != null) {
                                        for (Departement dept : departements) {
                                %>
                                    <option value="<%= dept.getId() %>">
                                        <%= dept.getNom() %>
                                    </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <!-- Date d'échéance -->
                        <div class="form-group">
                            <label class="form-label">Date d'échéance <span style="color: #ef4444;">*</span></label>
                            <input type="date" name="echeance" class="form-control" required>
                        </div>

                        <!-- État du projet -->
                        <div class="form-group">
                            <label class="form-label">État du projet <span style="color: #ef4444;">*</span></label>
                            <select name="etat" class="form-control" required>
                                <option value="">-- Sélectionnez un état --</option>
                                <option value="Planifié">Planifié</option>
                                <option value="En cours">En cours</option>
                                <option value="Terminé">Terminé</option>
                                <option value="Annulé">Annulé</option>
                            </select>
                        </div>

                        <!-- Retard -->
                        <div class="form-group">
                            <label class="form-label">Retard (en jours)</label>
                            <input type="number" name="retard" class="form-control" placeholder="0" value="0" min="0">
                            <small style="color: #6b7280; font-size: 0.875rem;">Nombre de jours de retard par rapport à l'échéance</small>
                        </div>
                    </div>

                    <!-- Boutons -->
                    <div style="margin-top: 2rem; display: flex; gap: 1rem;">
                        <button type="submit" class="btn btn-success">✅ Créer le Projet</button>
                        <a href="<%= request.getContextPath() %>/ServletProjet" class="btn btn-secondary">❌ Annuler</a>
                    </div>
                </form>
            </div>

        </div>

    </div>

</div>

</body>
</html>
