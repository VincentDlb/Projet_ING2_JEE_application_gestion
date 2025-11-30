<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	function auth(){
		document.location.href="auth.jsp";
	}
	function paie(){
		document.location.href="gestionnairePaie.jsp";
	}
	function employe(){
		document.location.href="/ProjetJEE/employes";
	}
	function projets(){
		document.location.href="gestionnaireProjets.jsp";
	}
	function departement(){
		document.location.href="gestionnaireDepartement.jsp";
	}
</script>
</head>
<style>
.buttonStyle{
background-color : #00bb77;
color : black;
border : 3px solid black;
text-align : center;
font-size : 16px;
cursor : pointer;
border-radius : 10px;
padding : 20px;
}
.gestionnaire{
	border : 3px outset blue;
	background-color : #ADD8E6;
	text-align : center;
	width : 100%;
	height : 400px;
}
.informations{
	border : 3px outset red;
	background-color : #FFA500;
	width : 100%;
	heigth : 60%
}
.title{
	border : 3px outset black;
	background-color : grey;
	width : 100%;
	heigth : 50%;
	text-align: center;
	color: #E0E1DB;
}
</style>
<div class="title">
<h1>Application JEE pour le responsable RH.</h1>
<h2>Liste des différents gestionnaires</h2>
</div>
<body onload="setTimeOut('RedirectionJavascript()',2000)">
<div><p>Sélectionner l'option souhaitée :</p></div>
<div class="gestionnaire">
<ul>
	<button type="button" class="buttonStyle" onclick="employe();">Gestion des <strong>employés</strong></button>
	<button type="button" class="buttonStyle" onclick="departement();">Gestion des <strong>départements</strong></button>
	<button type="button" class="buttonStyle" onclick="projets();">Gestion des <strong>projets</strong></button>
	<button type="button" class="buttonStyle" onclick="paie();">Gestion des <strong>fiches de paie</strong></button>
	<button type="button" class="buttonStyle" onclick="auth();"><strong>Authentification et Autorisation</strong></button>
</ul>
</div>
<hr>
<div class="informations">	
	<p>Entreprise</p><span>RowTech </span><em>à noter que l'entreprise a ouvert en 2025.</em>
	<a href="gestionnaireEmploye.jsp">Lien vers notre site internet</a>
	
	<slot>slot exemple0</slot>
	<q>quote exemple</q>
</div>
<hr>
</body>
</html>