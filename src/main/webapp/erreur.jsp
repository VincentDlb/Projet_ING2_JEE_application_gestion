<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="fr">
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
            <h1>📊 Statistiques & Rapports</h1>
            <p>Vue d'ensemble de l'entreprise RowTech</p>
        </header>

        <nav class="nav-menu">
            <a href="${pageContext.request.contextPath}/accueil.jsp">🏠 Retour à l'accueil</a>
        </nav>

        <div class="content">
            <div style="text-align: center; padding: var(--spacing-xl);">
                <div style="font-size: 100px; margin-bottom: 20px;">⚠️</div>
                
                <h2 style="color: var(--danger); margin-bottom: var(--spacing-lg);">Oups ! Quelque chose s'est mal passé</h2>
                
                <%
                    String erreur = request.getParameter("erreur");
                    if (erreur != null) {
                %>
                <div style="padding: var(--spacing-lg); background: rgba(239, 68, 68, 0.1); border: 2px solid var(--danger); border-radius: 12px; margin-bottom: var(--spacing-xl);">
                    <p style="color: var(--text-primary); font-weight: 600; margin: 0;">
                        Erreur : <%= erreur.replace("_", " ") %>
                    </p>
                </div>
                <%
                    }
                %>
                
                <div class="actions" style="justify-content: center;">
                    <a href="javascript:history.back()" class="btn btn-secondary">← Retour</a>
                    <a href="${pageContext.request.contextPath}/accueil.jsp" class="btn btn-primary">🏠 Accueil</a>
                </div>
            </div>
        </div>

        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
</body>
</html>