<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Projet" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
    List<Projet> tousMesProjets = (List<Projet>) request.getAttribute("tousMesProjets");
    String employeNom = (String) request.getAttribute("employeNom");
    Integer employeId = (Integer) request.getAttribute("employeId");
    
    String ctx = request.getContextPath();
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
    <title>Tous Mes Projets - RowTech</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>
        .badge-chef {
            display: inline-block;
            padding: 4px 12px;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            border-radius: 12px;
            font-size: 0.85em;
            font-weight: 600;
        }
        
        .badge-membre {
            display: inline-block;
            padding: 4px 12px;
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            border-radius: 12px;
            font-size: 0.85em;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- HEADER -->
        <div class="header">
            <h1>📊 Tous Mes Projets</h1>
            <p class="subtitle">Projets de <%=employeNom%></p>
        </div>

        

        <!-- CONTENU PRINCIPAL -->
        <div class="content-section">
            
            <%-- Messages --%>
            <% if (request.getParameter("message") != null) { %>
                <div class="alert alert-success">
                    ✅ Opération réussie !
                </div>
            <% } %>
            
            <% if (request.getParameter("erreur") != null) { %>
                <div class="alert alert-danger">
                    ❌ Une erreur s'est produite.
                </div>
            <% } %>

            <!-- TABLEAU DES PROJETS -->
            <% if (tousMesProjets != null && !tousMesProjets.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Nom du Projet</th>
                            <th>Description</th>
                            <th>État</th>
                            <th>Rôle</th>
                            <th>Date Début</th>
                            <th>Date Fin</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Projet projet : tousMesProjets) { 
                            boolean estChef = projet.getChefDeProjet() != null && 
                                             projet.getChefDeProjet().getId().equals(employeId);
                        %>
                            <tr>
                                <td><strong><%=projet.getNom()%></strong></td>
                                <td><%=projet.getDescription() != null ? projet.getDescription() : "N/A"%></td>
                                <td>
                                    <% if ("en_cours".equals(projet.getEtat())) { %>
                                        <span class="badge badge-info">🔄 En cours</span>
                                    <% } else if ("termine".equals(projet.getEtat())) { %>
                                        <span class="badge badge-success">✅ Terminé</span>
                                    <% } else if ("annule".equals(projet.getEtat())) { %>
                                        <span class="badge badge-danger">❌ Annulé</span>
                                    <% } else { %>
                                        <span class="badge badge-secondary"><%=projet.getEtat()%></span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (estChef) { %>
                                        <span class="badge-chef">👑 Chef</span>
                                    <% } else { %>
                                        <span class="badge-membre">👤 Membre</span>
                                    <% } %>
                                </td>
                                <td><%=projet.getDateDebut() != null ? projet.getDateDebut() : "N/A"%></td>
                                <td><%=projet.getDateFin() != null ? projet.getDateFin() : "N/A"%></td>
                                <td>
                                    <a href="<%=ctx%>/tousMesProjets?action=details&id=<%=projet.getId()%>" 
                                       class="btn btn-info btn-sm">📋 Détails</a>
                                    
                                    <% if (estChef) { %>
                                        <a href="<%=ctx%>/mesProjets?action=modifier&id=<%=projet.getId()%>" 
                                           class="btn btn-warning btn-sm">✏️ Modifier</a>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="alert alert-info">
                    ℹ️ Vous n'appartenez à aucun projet.
                </div>
            <% } %>

        </div>

        <!-- FOOTER -->
        <footer>
            <p>&copy; 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>
