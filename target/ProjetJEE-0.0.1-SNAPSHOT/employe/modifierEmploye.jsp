<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Modifier un Employé</title>
</head>
<body>
<h2>Modifer un Employé</h2>
<form action="employes" method="post">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="id" value="${employe.id}">

    Nom : <input type="text" name="nom" value="${employe.nom}" maxlength="50"><br>
    Prénom : <input type="text" name="prenom" value="${employe.prenom}" maxlength="50"><br>
    Âge : <input type="number" name="age" value="${employe.age}" min="0" max="999"><br>
    Adresse : <input type="text" name="adresse" value="${employe.adresse}" maxlength="50"><br>
    Type de contrat : <input type="text" name="typeContrat" value="${employe.typeContrat}" maxlength="50"><br>
    Ancienneté : <input type="number" name="anciennete" value="${employe.anciennete}" min="0" max="999"><br>
    Grade : <input type="text" name="grade" value="${employe.grade}" maxlength="50"><br>
    Poste : <input type="text" name="poste" value="${employe.poste}" maxlength="50"><br>
    Matricule : <input type="number" name="matricule" value="${employe.matricule}" min="0" max="999999"><br>
    Statut cadre : <input type="checkbox" name="statutCadre" ${employe.statutCadre ? "checked" : ""}><br>

    <button type="submit">Mettre à jour</button>
</form>
<br>
<a href="employes">Retour à la liste</a>
</body>
</html>