<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Aucun Projet</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="app-container">
        <header class="app-header">
            <h1>Mes Projets</h1>
        </header>

        <nav class="nav-menu">
            <a href="<%=request.getContextPath()%>/accueil.jsp">Accueil</a>
        </nav>

        <div class="content">
            <div style="text-align:center;padding:50px;">
                <h2>Vous n'êtes chef d'aucun projet</h2>
                <p>Contactez un administrateur pour être désigné comme chef de projet.</p>
                <a href="<%=request.getContextPath()%>/accueil.jsp" class="btn btn-primary">← Retour</a>
            </div>
        </div>
    </div>
</body>
</html>
