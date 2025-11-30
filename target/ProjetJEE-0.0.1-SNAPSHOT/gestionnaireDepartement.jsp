<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
</head>
<body>
<h1>Page intermédire. <strong>Insérer un titre ici</strong></h1>
<form method="post" action="Servlet">
        <label for="requete">Sélectionnez une requête :</label>
        <select name="requete" id="requete">
            <option value="1">Arènes contenant "eisti"</option>
            <option value="2">Pokémons commençant par 'P'</option>
            <option value="3">Joueurs sans la lettre 'a'</option>
        </select>
        <br>
        <input type="submit" value="Exécuter la requête">
    </form>
<button type="button" class="buttonStyle" onclick="index();">Boutton accueil</button>
</body>
</html>