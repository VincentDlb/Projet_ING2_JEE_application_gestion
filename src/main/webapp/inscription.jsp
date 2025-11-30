<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - RowTech</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
    <style>
        .inscription-container {
            max-width: 500px;
            margin: 80px auto;
            padding: 40px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .inscription-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .inscription-header h1 {
            color: #2d3748;
            margin-bottom: 10px;
        }
        
        .inscription-header p {
            color: #718096;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2d3748;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #3b82f6;
        }
        
        .btn-inscription {
            width: 100%;
            padding: 14px;
            background: #3b82f6;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .btn-inscription:hover {
            background: #2563eb;
        }
        
        .message-erreur {
            background: #fee;
            color: #c00;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c00;
        }
        
        .lien-connexion {
            text-align: center;
            margin-top: 20px;
            color: #718096;
        }
        
        .lien-connexion a {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
        }
        
        .lien-connexion a:hover {
            text-decoration: underline;
        }
        
        .info-box {
            background: #e0f2fe;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 4px solid #3b82f6;
        }
        
        .info-box p {
            margin: 5px 0;
            color: #0c4a6e;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <div class="inscription-container">
        <div class="inscription-header">
            <h1>📝 Créer un compte</h1>
            <p>Inscription pour les employés de RowTech</p>
        </div>
        
        <div class="info-box">
            <p><strong>ℹ️ Information :</strong></p>
            <p>Utilisez votre matricule d'employé pour créer votre compte.</p>
            <p>Si vous n'avez pas de matricule, contactez l'administrateur.</p>
        </div>
        
        <% if (request.getAttribute("erreur") != null) { %>
            <div class="message-erreur">
                ⚠️ <%= request.getAttribute("erreur") %>
            </div>
        <% } %>
        
        <form action="<%= request.getContextPath() %>/inscription" method="post">
            <div class="form-group">
                <label for="matricule">Matricule</label>
                <input type="text" 
                       id="matricule" 
                       name="matricule" 
                       placeholder="Ex: EMP-001"
                       required>
            </div>
            
            <div class="form-group">
                <label for="username">Nom d'utilisateur</label>
                <input type="text" 
                       id="username" 
                       name="username" 
                       placeholder="Choisissez un nom d'utilisateur"
                       required>
            </div>
            
            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password" 
                       id="password" 
                       name="password" 
                       placeholder="Minimum 8 caractères"
                       minlength="8"
                       required>
                <small style="color: #718096; font-size: 12px; display: block; margin-top: 5px;">
                    Au moins 8 caractères, dont 1 chiffre et 1 caractère spécial (!@#$%^*)
                </small>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirmer le mot de passe</label>
                <input type="password" 
                       id="confirmPassword" 
                       name="confirmPassword" 
                       placeholder="Confirmez votre mot de passe"
                       minlength="8"
                       required>
            </div>
            
            <button type="submit" class="btn-inscription">
                Créer mon compte
            </button>
        </form>
        
        <div class="lien-connexion">
            Vous avez déjà un compte ? 
            <a href="<%= request.getContextPath() %>/auth.jsp">Se connecter</a>
        </div>
    </div>
</body>
</html>
