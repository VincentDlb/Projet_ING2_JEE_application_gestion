<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String erreur = request.getParameter("erreur");
    String message = request.getParameter("message");
    String succes = (String) request.getAttribute("succes");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques - RowTech</title>
    <link rel="stylesheet" href="css/style.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: var(--spacing-lg);
            margin: var(--spacing-xl) 0;
        }
        
        .stat-card {
            background: linear-gradient(135deg, var(--dark-light) 0%, var(--dark-lighter) 100%);
            border-radius: 16px;
            padding: var(--spacing-lg);
            border: 2px solid var(--border);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
            border-color: var(--primary);
        }
        
        .stat-icon {
            font-size: 3rem;
            margin-bottom: var(--spacing-sm);
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--primary-light);
            margin-bottom: var(--spacing-xs);
            letter-spacing: -0.02em;
        }
        
        .stat-label {
            font-size: 1rem;
            color: var(--text-secondary);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .chart-section {
            margin: var(--spacing-xl) 0;
            background: var(--dark-light);
            border-radius: 16px;
            padding: var(--spacing-lg);
            border: 2px solid var(--border);
        }
        
        .chart-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: var(--spacing-lg);
            padding-bottom: var(--spacing-sm);
            border-bottom: 2px solid var(--border);
        }
        
        .chart-container {
            position: relative;
            height: 400px;
            margin: 20px 0;
        }
        
        .chart-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: var(--spacing-xl);
            margin: var(--spacing-xl) 0;
        }
        
        .empty-state {
            text-align: center;
            padding: var(--spacing-xl);
            color: var(--text-muted);
        }
        
        .export-button {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, var(--danger), #dc2626);
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(239, 68, 68, 0.2);
        }
        
        .export-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(239, 68, 68, 0.3);
        }
        
        .actions-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-lg);
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Header -->
        <header class="app-header">
            <h1>Connexion</h1>
            <p>Vue d'ensemble de l'entreprise RowTech</p>
        </header>

        <body>
            <div class="app-container">
        	
        

        <div class="content" style="max-width: 500px; margin: 60px auto;">
            
            <!-- Messages d'erreur -->
            <% if ("identifiants_invalides".equals(erreur)) { %>
                <div class="alert alert-danger">
                    ❌ Identifiants invalides. Veuillez réessayer.
                </div>
            <% } else if ("champs_vides".equals(erreur)) { %>
                <div class="alert alert-danger">
                    ⚠️ Veuillez remplir tous les champs.
                </div>
            <% } else if ("non_connecte".equals(erreur)) { %>
                <div class="alert alert-danger">
                    🔒 Vous devez être connecté pour accéder à cette page.
                </div>
            <% } %>
            
            <!-- Message de succès inscription -->
            <% if (succes != null) { %>
                <div class="alert alert-success">
                    ✅ <%= succes %>
                </div>
            <% } %>
            
            <!-- Message de succès -->
            <% if ("deconnexion_ok".equals(message)) { %>
                <div class="alert alert-success">
                    ✅ Vous avez été déconnecté avec succès.
                </div>
            <% } %>

            <!-- Formulaire de connexion -->
            <div style="background: var(--dark-light); padding: 40px; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.3);">
                <h2 style="text-align: center; color: var(--text-primary); margin-bottom: 30px;">
                    Identifiez-vous
                </h2>

                <form action="<%= request.getContextPath() %>/auth" method="post">
                    <div class="form-group">
                        <label>Nom d'utilisateur</label>
                        <input type="text" name="username" placeholder="Ex: admin" required autofocus>
                    </div>

                    <div class="form-group">
                        <label>Mot de passe</label>
                        <input type="password" name="password" placeholder="••••••••" required>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 20px;">
                        🔓 Se connecter
                    </button>
                </form>

                <!-- Lien d'inscription -->
                <div style="text-align: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.1);">
                    <p style="color: var(--text-muted); margin-bottom: 10px;">
                        Vous êtes un nouvel employé ?
                    </p>
                    <a href="<%= request.getContextPath() %>/inscription" 
                       style="color: var(--primary); text-decoration: none; font-weight: 600; font-size: 1.05rem;">
                        📝 Créer un compte
                    </a>
                </div>

                <!-- Comptes de test -->
                <div style="margin-top: 30px; padding: 20px; background: rgba(59, 130, 246, 0.1); border-radius: 8px; border: 1px solid rgba(59, 130, 246, 0.3);">
                    <p style="font-weight: 600; color: var(--text-primary); margin-bottom: 10px;">
                        📝 Comptes de test :
                    </p>
                    <ul style="color: var(--text-muted); font-size: 0.9rem; margin: 0; padding-left: 20px;">
                        <li><strong>Admin :</strong> admin / admin123</li>
                        <li><strong>Chef Dept :</strong> chef.dept / chef123</li>
                        <li><strong>Chef Projet :</strong> chef.projet / chef123</li>
                        <li><strong>Employé :</strong> employe1 / employe123</li>
                    </ul>
                </div>
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech</p>
        </footer>
    </div>
</body>
</html>
