<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="com.rsv.model.Projet" %>
 <%@ page import="java.util.List" %>
 <%@ page import="com.rsv.model.Employe" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
function index(){
	document.location.href="accueil.jsp";
}
</script>
<style>
.equipeList{
	background-color : grey;
	border : solid black;
}
button{
text-align : center;
color : black;
border-style: ridge;
border-width:2px;
border-color :#000080;
}
button :hover
{
color:red;
border-style:outset;
}
btn_valid:active
{
color:green;
padding-left:4px;
padding-right:2px;
padding-top:4px;
padding-bottom:2px;
border-style:inset;
}
</style>
</head>
<body>
<h1><strong>Modification du projet</strong></h1>
<button type="button" class="buttonStyle" onclick="index();">Boutton accueil</button>
<form action ="ModifyProjectServlet" method="post" class="styleForm">
<div class="information">
<% Projet projet =(Projet) request.getAttribute("projet"); %>

<label>id du projet:</label>
<input type="text" name="id" value=<%=projet.getId() %> readonly><br></br>
<label>nom du projet :</label>
<input type="text" name="nom" placeholder=<%=projet.getNom() %>>
<br></br>
<label>id du chef de projet :</label>
<input type="text" name="idchef" placeholder=<%=projet.getChefDeProjet().getNom()%>>
<br></br>
<label>echeance : </label>
<input type="date" name="echeance"> <p>ancinne échéance : <%=projet.getEcheance() %></p>
<label>nom du département :</label>
<input type="text" name="departement" placeholder=<%=projet.getDomaine().getNom() %>>
<br></br>
<label>etat :</label>
<input type ="text" name="etat" placeholder=<%=projet.getÉtat() %>>
<br></br>
</div>
<hr>
<label>liste de l'équipe :</label>
<input type="text" name="liste">
<div class="equipeList">
<%List<Employe> employes = projet.getEquipe(); %>
<ul>
	<%for(Employe employe : employes){
		
		%>
		<li>
		<%=employe.getNom() %>
		</li>
		<ul>
			<li><%=employe.getId() %></li>
			<li><%=employe.getPoste() %></li>
			<li><%=employe.getGrade() %></li>
		</ul>
	<%} %>
</ul>
</div>
<label>retard (en mois) :</label>
<input type="text" name="retard" placeholder=<%=projet.getRetard() %>>
<br></br>
<input type="submit" value="Exécuter la requête">
</form>
</body>
</html>