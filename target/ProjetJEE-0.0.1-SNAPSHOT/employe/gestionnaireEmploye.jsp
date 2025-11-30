<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.Employe" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gestion des Employés</title>
<script>
function index(){
    document.location.href="accueil.jsp";
}
</script>
</head>
<body class="bg-light">

<div class="container mt-5">

    <h1>Gestion des Employés</h1>

    <div >
        <form action="employes" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="nom" class="form-control" placeholder="Nom" style="width: 150px;">
            <input type="text" name="prenom" class="form-control" placeholder="Prénom" style="width: 150px;">
            <input type="text" name="matricule" class="form-control" placeholder="Matricule" style="width: 120px;">
            <input type="text" name="departement" class="form-control" placeholder="Département" style="width: 150px;">
            <button type="submit">Rechercher</button>
        </form>

        <a href="employes?action=insert" class="btn btn-success">Ajouter un employé</a>
    </div>

    <div>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Âge</th>
                <th>Grade</th>
                <th>Poste</th>
                <th>Matricule</th>
                <th>Cadre</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody class="text-center">

            <%
                List<Employe> listeEmployes = (List<Employe>) request.getAttribute("listeEmployes");
                if (listeEmployes != null && !listeEmployes.isEmpty()) {
                    for (Employe e : listeEmployes) {
            %>
                        <tr>
                            <td><%= e.getId() %></td>
                            <td><%= e.getNom() %></td>
                            <td><%= e.getPrenom() %></td>
                            <td><%= e.getAge() %></td>
                            <td><%= e.getGrade() %></td>
                            <td><%= e.getPoste() %></td>
                            <td><%= e.getMatricule() %></td>
                            <td><%= e.isStatutCadre() ? "Oui" : "Non" %></td>
                            <td>
                                <a href="employes?action=edit&id=<%= e.getId() %>">Modifier</a>
                                <a href="employes?action=delete&id=<%= e.getId() %>">Supprimer</a>
                            </td>
                        </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="9" class="text-muted text-center">Aucun employé trouvé</td>
                </tr>
            <%
                }
            %>

            </tbody>
        </table>
    </div>

</div>

</body>
</html>