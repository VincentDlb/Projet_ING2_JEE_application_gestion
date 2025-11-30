<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Employe" %>
<%@ page import="com.rsv.model.Departement" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%
   List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
   List<Departement> departements = (List<Departement>) request.getAttribute("departements");
  
   String nomComplet = (String) session.getAttribute("nomComplet");
   String userRole = (String) session.getAttribute("userRole");
  
   String message = request.getParameter("message");
   String erreur = request.getParameter("erreur");
   
   boolean isAdmin = RoleHelper.isAdmin(session);
   boolean isChefDept = RoleHelper.isChefDepartement(session);
   boolean isChefProjet = RoleHelper.isChefProjet(session);
   boolean isEmploye = RoleHelper.isEmploye(session);
%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>Gestion des Employés - RowTech</title>
   <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
   <div class="app-container">
       <!-- HEADER -->
       <header class="app-header">
           <h1>👥 Gestion des Employés</h1>
           <p>RowTech - Système de Gestion RH</p>
       </header>
       <!-- NAVIGATION -->
       <nav class="nav-menu">
           <a href="<%= request.getContextPath() %>/accueil.jsp">🏠 Accueil</a>
          
           <% if (RoleHelper.canManageEmployes(session)) { %>
               <a href="<%= request.getContextPath() %>/employes?action=lister" class="active">👥 Employés</a>
           <% } %>
          
           <% if (RoleHelper.canManageDepartements(session)) { %>
               <a href="<%= request.getContextPath() %>/departements?action=lister">🏛️ Départements</a>
           <% } %>
          
           <% if (RoleHelper.canManageProjets(session)) { %>
               <a href="<%= request.getContextPath() %>/projets?action=lister">📁 Projets</a>
           <% } %>
          
           <a href="<%= request.getContextPath() %>/fichesDePaie?action=lister">💰 Fiches de Paie</a>
          
           <% if (RoleHelper.canViewStatistics(session)) { %>
               <a href="<%= request.getContextPath() %>/statistiques?action=afficher">📊 Statistiques</a>
           <% } %>
          
           <% if (nomComplet != null) { %>
               <span style="margin-left: auto; color: var(--text-secondary);">
                   👤 <%= nomComplet %> (<%= userRole %>)
               </span>
               <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-danger" style="padding: 8px 16px;">
                   🚪 Déconnexion
               </a>
           <% } %>
       </nav>
       
       <!-- CONTENU PRINCIPAL -->
       <div class="content">
           <h2 class="page-title">Liste des Employés</h2>
           <!-- MESSAGES -->
           <% if (message != null) { %>
               <div class="alert alert-success">
                   <% if ("ajout_ok".equals(message)) { %>
                       ✅ Employé ajouté avec succès !
                   <% } else if ("modification_ok".equals(message)) { %>
                       ✅ Employé modifié avec succès !
                   <% } else if ("suppression_ok".equals(message)) { %>
                       ✅ Employé supprimé avec succès !
                   <% } %>
               </div>
           <% } %>
           <% if (erreur != null) { %>
               <div class="alert alert-error">
                   <% if ("employe_introuvable".equals(erreur)) { %>
                       ❌ Employé introuvable !
                   <% } else if ("echec_ajout".equals(erreur)) { %>
                       ❌ Échec de l'ajout de l'employé !
                   <% } else if ("echec_modification".equals(erreur)) { %>
                       ❌ Échec de la modification !
                   <% } else if ("echec_suppression".equals(erreur)) { %>
                       ❌ Échec de la suppression !
                   <% } else if ("exception".equals(erreur)) { %>
                       ❌ Une erreur s'est produite !
                   <% } %>
               </div>
           <% } %>
           <!-- BARRE D'ACTIONS ET FILTRES -->
           <div style="background: var(--card-bg); padding: 20px; border-radius: 10px; margin-bottom: 25px; border: 1px solid var(--border);">
               <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                   <div style="display: flex; gap: 10px;">
                       <a href="<%= request.getContextPath() %>/employes?action=nouveau" class="btn btn-primary">
                           ➕ Ajouter un employé
                       </a>
                       <a href="<%= request.getContextPath() %>/employes?action=rechercher" class="btn btn-success">
                           🔍 Recherche avancée
                       </a>
                   </div>
                  
                  <% if (request.getAttribute("filtresActifs") != null && (Boolean)request.getAttribute("filtresActifs")) { %>
   				<a href="<%= request.getContextPath() %>/employes?action=lister" class="btn btn-secondary">
      					 ❌ Réinitialiser les filtres
   				</a>
			<% } %>
               </div>
           
               <!-- FILTRES RAPIDES -->
<div style="border-top: 1px solid var(--border); padding-top: 20px;">
   <h3 style="margin-bottom: 15px; color: var(--primary); font-size: 1rem;">
        Filtres rapides
   </h3>
  
   <form action="<%= request.getContextPath() %>/employes" method="get">
       <input type="hidden" name="action" value="filtrer">
      
       <div style="display: grid; grid-template-columns: repeat(3, 1fr) auto; gap: 15px; align-items: end;">
           <!-- FILTRE DÉPARTEMENT -->
           <div class="form-group" style="margin-bottom: 0;">
               <label> Département</label>
               <select name="departement">
                   <option value="">-- Tous --</option>
                   <%
                       String filtreDepartement = (String) request.getAttribute("filtreDepartement");
                      
                       if (departements != null) {
                           for (Departement dept : departements) {
                   %>
                               <option value="<%= dept.getId() %>"
                                   <%= String.valueOf(dept.getId()).equals(filtreDepartement) ? "selected" : "" %>>
                                   <%= dept.getNom() %>
                               </option>
                   <%      }
                       }
                   %>
               </select>
           </div>
          
           <!-- FILTRE GRADE -->
           <div class="form-group" style="margin-bottom: 0;">
               <label> Grade</label>
               <select name="grade">
                   <% String filtreGrade = (String) request.getAttribute("filtreGrade"); %>
                   <option value="">-- Tous --</option>
                   <option value="JUNIOR" <%= "JUNIOR".equals(filtreGrade) ? "selected" : "" %>>JUNIOR</option>
                   <option value="CONFIRME" <%= "CONFIRME".equals(filtreGrade) ? "selected" : "" %>>CONFIRMÉ</option>
                   <option value="SENIOR" <%= "SENIOR".equals(filtreGrade) ? "selected" : "" %>>SENIOR</option>
                   <option value="EXPERT" <%= "EXPERT".equals(filtreGrade) ? "selected" : "" %>>EXPERT</option>
               </select>
           </div>
          
           <!-- FILTRE POSTE -->
           <div class="form-group" style="margin-bottom: 0;">
               <label> Poste</label>
               <select name="poste">
                   <% String filtrePoste = (String) request.getAttribute("filtrePoste"); %>
                   <option value="">-- Tous --</option>
                   <%
                       // Liste des postes uniques
                       java.util.Set<String> postes = new java.util.HashSet<>();
                       if (listeEmployes != null) {
                           for (Employe emp : listeEmployes) {
                               if (emp.getPoste() != null && !emp.getPoste().isEmpty()) {
                                   postes.add(emp.getPoste());
                               }
                           }
                       }
                       java.util.List<String> postesList = new java.util.ArrayList<>(postes);
                       java.util.Collections.sort(postesList);
                      
                       for (String poste : postesList) {
                   %>
                           <option value="<%= poste %>" <%= poste.equals(filtrePoste) ? "selected" : "" %>>
                               <%= poste %>
                           </option>
                   <%  } %>
               </select>
           </div>
          
           <!-- BOUTON APPLIQUER -->
           <button type="submit" class="btn btn-primary" style="height: 45px; white-space: nowrap;">
               ✓ Appliquer les filtres
           </button>
       </div>
   </form>
  
   <!-- INDICATEUR DES FILTRES ACTIFS -->
   <%
       Boolean filtresActifs = (Boolean) request.getAttribute("filtresActifs");
       if (filtresActifs != null && filtresActifs) {
   %>
       <div style="margin-top: 15px; padding: 15px; background: rgba(59, 130, 246, 0.1); border-radius: 5px; border-left: 4px solid var(--primary);">
           <p style="margin: 0 0 10px 0; color: var(--primary); font-weight: bold; font-size: 0.9rem;">
               ✓ Filtres actifs :
           </p>
           <div style="display: flex; gap: 10px; flex-wrap: wrap;">
               <% if (filtreDepartement != null && !filtreDepartement.isEmpty() && departements != null) {
                   for (Departement d : departements) {
                       if (String.valueOf(d.getId()).equals(filtreDepartement)) { %>
                           <span class="badge badge-primary">
                               📍 Département : <%= d.getNom() %>
                           </span>
               <%          break;
                       }
                   }
               } %>
              
               <% if (filtreGrade != null && !filtreGrade.isEmpty()) { %>
                   <span class="badge badge-success">
                       🏅 Grade : <%= filtreGrade %>
                   </span>
               <% } %>
              
               <% if (filtrePoste != null && !filtrePoste.isEmpty()) { %>
                   <span class="badge badge-info">
                       💼 Poste : <%= filtrePoste %>
                   </span>
               <% } %>
           </div>
       </div>
   <% } %>
</div>
                      
                       
           <!-- TABLEAU DES EMPLOYÉS -->
           <% if (listeEmployes != null && !listeEmployes.isEmpty()) { %>
               <div class="table-container">
                   <table class="data-table">
                       <thead>
                           <tr>
                               <th>Matricule</th>
                               <th>Nom</th>
                               <th>Prénom</th>
                               <th>Email</th>
                               <th>Poste</th>
                               <th>Grade</th>
                               <th>Département</th>
                               <th>Salaire</th>
                               <th>Actions</th>
                           </tr>
                       </thead>
                       <tbody>
                           <% for (Employe employe : listeEmployes) { %>
                               <tr>
                                   <td><strong><%= employe.getMatricule() %></strong></td>
                                   <td><%= employe.getNom() %></td>
                                   <td><%= employe.getPrenom() %></td>
                                   <td><%= employe.getEmail() %></td>
                                   <td><%= employe.getPoste() %></td>
                                   <td>
                                       <span class="badge
                                           <%
                                               String badgeClass = "";
                                               switch(employe.getGrade()) {
                                                   case "JUNIOR": badgeClass = "badge-info"; break;
                                                   case "CONFIRME": badgeClass = "badge-primary"; break;
                                                   case "SENIOR": badgeClass = "badge-success"; break;
                                                   case "EXPERT": badgeClass = "badge-warning"; break;
                                               }
                                           %>
                                           <%= badgeClass %>">
                                           <%= employe.getGrade() %>
                                       </span>
                                   </td>
                                   <td>
                                       <% if (employe.getDepartement() != null) { %>
                                           <%= employe.getDepartement().getNom() %>
                                       <% } else { %>
                                           <span style="color: var(--text-muted);">Non assigné</span>
                                       <% } %>
                                   </td>
                                   <td><%= String.format("%.2f", employe.getSalaire()) %>€</td>
                                   <td>
                                       <div style="display: flex; gap: 5px; flex-wrap: wrap;">
                                           <a href="<%= request.getContextPath() %>/employes?action=modifier&id=<%= employe.getId() %>"
                                              class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">
                                               ✏️ Modifier
                                           </a>
                                           <a href="<%= request.getContextPath() %>/employes?action=supprimer&id=<%= employe.getId() %>"
                                              class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;"
                                              onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet employé ?');">
                                               🗑️ Supprimer
                                           </a>
                                       </div>
                                   </td>
                               </tr>
                           <% } %>
                       </tbody>
                   </table>
               </div>
           <% } else { %>
               <div style="padding: 40px; text-align: center; background: rgba(107, 114, 128, 0.1); border-radius: 10px; border: 2px dashed var(--border);">
                   <p style="font-size: 1.2rem; color: var(--text-muted); margin: 0;">
                       😕 Aucun employé trouvé
                   </p>
                   <% if (request.getAttribute("filtreActif") != null) { %>
                       <p style="margin-top: 10px;">
                           <a href="<%= request.getContextPath() %>/employes?action=lister" class="btn btn-secondary">
                               Voir tous les employés
                           </a>
                       </p>
                   <% } %>
               </div>
           <% } %>
           <!-- STATISTIQUES -->
           <% if (listeEmployes != null && !listeEmployes.isEmpty()) { %>
               <div style="margin-top: 30px; padding: 20px; background: var(--card-bg); border-radius: 10px; border: 1px solid var(--border);">
                   <h3 style="margin-bottom: 10px; color: var(--primary);">📊 Statistiques</h3>
                   <p style="margin: 5px 0; color: var(--text-secondary);">
                       <strong>Total :</strong> <%= listeEmployes.size() %> employé(s)
                   </p>
               </div>
           <% } %>
       </div>
       <!-- FOOTER -->
       <footer>
           <p>© 2025 RowTech - Système de Gestion des Ressources Humaines</p>
       </footer>
   </div>
</body>
</html>