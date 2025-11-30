<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%@ page import="java.util.List" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Modifier un Employé");
    request.setAttribute("pageBreadcrumb", "Employés / Modifier");

    Employe employe = (Employe) request.getAttribute("employe");
    List<Departement> departements = (List<Departement>) request.getAttribute("departements");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier un Employé - JEE RH</title>
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

            <!-- Bouton retour -->
            <div style="margin-bottom: 1.5rem;">
                <a href="<%= request.getContextPath() %>/employes" class="btn btn-secondary">
                    ◀️ Retour à la liste
                </a>
            </div>

            <% if (employe == null) { %>
                <!-- Message d'erreur si employé non trouvé -->
                <div class="card">
                    <div style="padding: 3rem; text-align: center; color: #ef4444;">
                        <div style="font-size: 1.5rem; margin-bottom: 1rem;">⚠️ Erreur</div>
                        <div style="font-size: 1rem;">L'employé demandé n'a pas été trouvé.</div>
                    </div>
                    <div style="padding: 1rem;">
                        <a href="<%= request.getContextPath() %>/employes" class="btn btn-secondary">
                            ◀️ Retour à la liste
                        </a>
                    </div>
                </div>
            <% } else { %>
                <!-- Formulaire de modification -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">✏️ Modifier l'Employé</h3>
                    </div>

                    <form action="<%= request.getContextPath() %>/employes" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="<%= employe.getId() %>">

                        <!-- Informations personnelles -->
                        <div style="margin-bottom: 2rem;">
                            <h4 style="color: #1f2937; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e5e7eb;">
                                👤 Informations Personnelles
                            </h4>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Nom <span style="color: #ef4444;">*</span></label>
                                    <input type="text" name="nom" class="form-control" required
                                           value="<%= employe.getNom() %>" placeholder="Entrez le nom">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Prénom <span style="color: #ef4444;">*</span></label>
                                    <input type="text" name="prenom" class="form-control" required
                                           value="<%= employe.getPrenom() %>" placeholder="Entrez le prénom">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Âge <span style="color: #ef4444;">*</span></label>
                                    <input type="number" name="age" class="form-control" required min="18" max="70"
                                           value="<%= employe.getAge() %>" placeholder="Ex: 30">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Adresse <span style="color: #ef4444;">*</span></label>
                                    <input type="text" name="adresse" class="form-control" required
                                           value="<%= employe.getAdresse() != null ? employe.getAdresse() : "" %>"
                                           placeholder="Ex: 123 Rue de Paris, 75001 Paris">
                                </div>
                            </div>
                        </div>

                        <!-- Informations professionnelles -->
                        <div style="margin-bottom: 2rem;">
                            <h4 style="color: #1f2937; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e5e7eb;">
                                💼 Informations Professionnelles
                            </h4>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Type de Contrat <span style="color: #ef4444;">*</span></label>
                                    <select name="typeContrat" class="form-control" required>
                                        <option value="">-- Sélectionner --</option>
                                        <option value="CDI" <%= "CDI".equals(employe.getTypeContrat()) ? "selected" : "" %>>CDI</option>
                                        <option value="CDD" <%= "CDD".equals(employe.getTypeContrat()) ? "selected" : "" %>>CDD</option>
                                        <option value="Stage" <%= "Stage".equals(employe.getTypeContrat()) ? "selected" : "" %>>Stage</option>
                                        <option value="Alternance" <%= "Alternance".equals(employe.getTypeContrat()) ? "selected" : "" %>>Alternance</option>
                                        <option value="Freelance" <%= "Freelance".equals(employe.getTypeContrat()) ? "selected" : "" %>>Freelance</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Ancienneté (années) <span style="color: #ef4444;">*</span></label>
                                    <input type="number" name="anciennete" class="form-control" required min="0" max="50"
                                           value="<%= employe.getAnciennete() %>" placeholder="Ex: 5">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Grade</label>
                                    <select name="grade" class="form-control">
                                        <option value="">-- Sélectionner --</option>
                                        <option value="Junior" <%= "Junior".equals(employe.getGrade()) ? "selected" : "" %>>Junior</option>
                                        <option value="Intermédiaire" <%= "Intermédiaire".equals(employe.getGrade()) ? "selected" : "" %>>Intermédiaire</option>
                                        <option value="Senior" <%= "Senior".equals(employe.getGrade()) ? "selected" : "" %>>Senior</option>
                                        <option value="Expert" <%= "Expert".equals(employe.getGrade()) ? "selected" : "" %>>Expert</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Poste <span style="color: #ef4444;">*</span></label>
                                    <input type="text" name="poste" class="form-control" required
                                           value="<%= employe.getPoste() != null ? employe.getPoste() : "" %>"
                                           placeholder="Ex: Développeur Full-Stack">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Matricule <span style="color: #ef4444;">*</span></label>
                                    <input type="number" name="matricule" class="form-control" required
                                           value="<%= employe.getMatricule() %>" placeholder="Ex: 1001">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Statut Cadre</label>
                                    <select name="statutCadre" class="form-control">
                                        <option value="false" <%= !employe.isStatutCadre() ? "selected" : "" %>>Non</option>
                                        <option value="true" <%= employe.isStatutCadre() ? "selected" : "" %>>Oui</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Département</label>
                                    <select name="departementId" class="form-control">
                                        <option value="">-- Aucun département --</option>
                                        <%
                                            if (departements != null) {
                                                for (Departement dept : departements) {
                                                    boolean isSelected = (employe.getDepartementId() != null &&
                                                                         employe.getDepartementId() == dept.getId());
                                        %>
                                            <option value="<%= dept.getId() %>" <%= isSelected ? "selected" : "" %>>
                                                <%= dept.getNom() %>
                                            </option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                    <small style="color: #6b7280; font-size: 0.875rem;">Sélectionnez un département pour affecter l'employé</small>
                                </div>
                            </div>
                        </div>

                        <!-- Boutons d'action -->
                        <div style="display: flex; gap: 1rem; justify-content: flex-end; padding-top: 1.5rem; border-top: 2px solid #e5e7eb;">
                            <a href="<%= request.getContextPath() %>/employes" class="btn btn-secondary">
                                Annuler
                            </a>
                            <button type="submit" class="btn btn-success">
                                💾 Enregistrer les Modifications
                            </button>
                        </div>
                    </form>
                </div>
            <% } %>

        </div>

    </div>

</div>

</body>
</html>
