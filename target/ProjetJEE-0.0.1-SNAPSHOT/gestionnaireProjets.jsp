<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.form-get{
	float : right;
	text-align: center;
	background-color : grey;
	width : 600px;
	height : 30%;
}
label{
	position : relative;
	display : inline-block;
	overflow : auto;
}
</style>
<script>
function index(){
	document.location.href="accueil.jsp";
}
</script>
</head>
<body>
<h1>Page intermédire. <strong>Insérer un titre ici</strong></h1>
<button type="button" class="buttonStyle" onclick="index();">Boutton accueil</button>

<form method ="post" action="ServletProjet" class="form">
<div class="information">
<label>nom du projet :</label>
<input type="text" name="nom">
<br></br>
<label>id du chef de projet :</label>
<input type="text" name="idchef">
<br></br>
<label>echeance : </label>
<input type="date" name="echeance">
<br></br>
<label>nom du département :</label>
<input type="text" name="departement">
<br></br>
<label>etat :</label>
<input type ="text" name="etat">
<br></br>
</div>
<hr>
<div class="equipeList">
<input type="text" name="liste">
</div>
<label>retard (en mois) :</label>
<input type="text" name="retard">
<br></br>
<input type="submit" value="Exécuter la requête">
</form>
<div class="form-get">
<form action ="ServletProjet" method ="get" class="form">
<label>Date limite d'échéance</label>
<input type="date" name="limitDate">
<label>Etat requis(en cours, terminé ou phase de lancement)</label>
<input type="text" name="state">
<input type="submit" value ="Voir les projets">
</form>
</div>
</body>
</html>