<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Connexion - Gestion RH</title>
<link rel="stylesheet" href="style.css">
<style>
.login-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    padding: 1rem;
}

.login-box {
    background: white;
    padding: 3rem;
    border-radius: 1rem;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    width: 100%;
    max-width: 450px;
}

.login-header {
    text-align: center;
    margin-bottom: 2rem;
}

.login-header h1 {
    font-size: 2rem;
    color: #1f2937;
    margin-bottom: 0.5rem;
}

.login-header p {
    color: #6b7280;
    font-size: 1rem;
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    color: #374151;
    font-weight: 600;
}

.form-group input {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 2px solid #e5e7eb;
    border-radius: 0.5rem;
    font-size: 1rem;
    transition: border-color 0.3s;
}

.form-group input:focus {
    outline: none;
    border-color: #667eea;
}

.login-button {
    width: 100%;
    padding: 1rem;
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: white;
    border: none;
    border-radius: 0.5rem;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
}

.login-button:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
}

.error-message {
    background: #fee2e2;
    color: #991b1b;
    padding: 1rem;
    border-radius: 0.5rem;
    margin-bottom: 1.5rem;
    border-left: 4px solid #ef4444;
}

.success-message {
    background: #dcfce7;
    color: #166534;
    padding: 1rem;
    border-radius: 0.5rem;
    margin-bottom: 1.5rem;
    border-left: 4px solid #10b981;
}

.login-footer {
    text-align: center;
    margin-top: 2rem;
    color: #6b7280;
    font-size: 0.875rem;
}

.demo-credentials {
    background: #fef3c7;
    padding: 1rem;
    border-radius: 0.5rem;
    margin-top: 1.5rem;
    border-left: 4px solid #f59e0b;
}

.demo-credentials h3 {
    margin: 0 0 0.5rem 0;
    color: #92400e;
    font-size: 0.9rem;
}

.demo-credentials p {
    margin: 0.25rem 0;
    color: #78350f;
    font-size: 0.85rem;
}
</style>
</head>
<body>

<div class="login-container">
    <div class="login-box">

        <div class="login-header">
            <h1>🔐 Connexion</h1>
            <p>Application de Gestion RH - RowTech</p>
        </div>

        <%
            String erreur = (String) request.getAttribute("erreur");
            String message = request.getParameter("message");

            if (erreur != null) {
        %>
            <div class="error-message">
                <strong>⚠️ Erreur :</strong> <%= erreur %>
            </div>
        <%
            }

            if ("deconnecte".equals(message)) {
        %>
            <div class="success-message">
                <strong>✓ Déconnexion réussie</strong><br>
                Vous avez été déconnecté avec succès.
            </div>
        <%
            }
        %>

        <form action="login" method="post">

            <div class="form-group">
                <label for="username">👤 Nom d'utilisateur</label>
                <input type="text" id="username" name="username" required autofocus placeholder="Entrez votre nom d'utilisateur">
            </div>

            <div class="form-group">
                <label for="password">🔑 Mot de passe</label>
                <input type="password" id="password" name="password" required placeholder="Entrez votre mot de passe">
            </div>

            <button type="submit" class="login-button">
                🚀 Se Connecter
            </button>

        </form>

        <!-- Informations de démonstration -->
        <div class="demo-credentials">
            <h3>💡 Comptes de démonstration :</h3>
            <p><strong>Admin :</strong> admin / admin123</p>
            <p><strong>Chef Département :</strong> chef_dept / chef123</p>
            <p><strong>Chef Projet :</strong> chef_proj / chef123</p>
            <p><strong>Employé :</strong> employe / emp123</p>
        </div>

        <div class="login-footer">
            <p>&copy; 2025 RowTech - Tous droits réservés</p>
            <p>Pour toute assistance, contactez le service IT</p>
        </div>

    </div>
</div>

</body>
</html>
