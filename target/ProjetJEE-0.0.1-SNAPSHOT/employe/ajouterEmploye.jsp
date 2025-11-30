<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ajouter un Employé</title>
</head>
<body>
<h2>Ajouter un Employé</h2>
<form action="employes" method="post">
    <input type="hidden" name="action" value="insert">
    
    Nom : <input type="text" name="nom" maxlength="50" required><br>
    Prénom : <input type="text" name="prenom" maxlength="50" required><br>
    Âge : <input type="number" name="age" max="999" required><br>
    Adresse : <input type="text" name="adresse" maxlength="50"><br>
    Type de contrat : <input type="text" name="typeContrat" maxlength="50"><br>
    Ancienneté : <input type="number" name="anciennete" max="999"><br>
    Grade : <input type="text" name="grade" maxlength="50"><br>
    Poste : <input type="text" name="poste" maxlength="50"><br>
    Matricule : <input type="number" name="matricule" max="99999999999999999999999"><br>
    Statut cadre : <input type="checkbox" name="statutCadre" value="true"><br>
    
    <button type="submit">Enregistrer</button>
</form>
<br>
<a href="employes">Retour à la liste</a>
</body>
</html>
