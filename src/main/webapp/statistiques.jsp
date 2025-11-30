<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.Statistiques" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.rsv.util.RoleHelper" %>
<%boolean isAdmin = RoleHelper.isAdmin(session);
boolean isChefDept = RoleHelper.isChefDepartement(session);
boolean isChefProjet = RoleHelper.isChefProjet(session);
boolean isEmploye = RoleHelper.isEmploye(session);
%>
	


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

        <!-- Navigation -->
        <nav class="nav-menu">
            <a href="accueil.jsp">🏠 Accueil</a>
            <a href="employes?action=lister">👥 Employés</a>
            <a href="departements?action=lister">🏛️ Départements</a>
            <a href="projets?action=lister">📁 Projets</a>
            <a href="fichesDePaie?action=lister">💰 Fiches de Paie</a>
            <a href="statistiques?action=afficher" class="active">📊 Statistiques</a>
            
            <%
                String nomComplet = (String) session.getAttribute("nomComplet");
                String userRole = (String) session.getAttribute("userRole");
                
                if (nomComplet != null) {
            %>
                <span style="color: var(--text-light); margin-left: auto; padding: 10px;">
                     <%= nomComplet %> (<%= userRole %>)
                </span>
                <a href="auth?action=logout" style="background: var(--danger);"> Déconnexion</a>
            <%
                } else {
            %>
                <a href="auth.jsp"> Connexion</a>
            <%
                }
            %>
        </nav>

        <!-- Contenu -->
        <div class="content">
            <div class="actions-header">
                <h2 class="page-title"> Tableau de Bord Statistiques</h2>
                <a href="exportStatistiquesPdf" class="export-button">
                     Exporter en PDF
                </a>
            </div>

            <%
                Statistiques stats = (Statistiques) request.getAttribute("statistiques");
                DecimalFormat dfMoney = new DecimalFormat("#,##0.00 €");
                DecimalFormat dfNumber = new DecimalFormat("#,##0");
                
                if (stats != null) {
            %>
            
            <!-- Vue d'ensemble -->
            <h3 style="font-size: 1.3rem; margin-top: var(--spacing-xl); margin-bottom: var(--spacing-md); color: var(--primary-light);">
                 Vue d'Ensemble
            </h3>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-value"><%= stats.getTotalEmployes() %></div>
                    <div class="stat-label">Employés</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">🏛️</div>
                    <div class="stat-value"><%= stats.getTotalDepartements() %></div>
                    <div class="stat-label">Départements</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">📁</div>
                    <div class="stat-value"><%= stats.getTotalProjets() %></div>
                    <div class="stat-label">Projets</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">💰</div>
                    <div class="stat-value"><%= stats.getTotalFichesDePaie() %></div>
                    <div class="stat-label">Fiches de Paie</div>
                </div>
            </div>

            <!-- Statistiques Salaires -->
            <h3 style="font-size: 1.3rem; margin-top: var(--spacing-xl); margin-bottom: var(--spacing-md); color: var(--success);">
                 Statistiques Salaires
            </h3>
            
            <div class="stats-grid">
                <div class="stat-card" style="border-color: var(--success);">
                    <div class="stat-icon"></div>
                    <div class="stat-value" style="font-size: 1.8rem; color: var(--success);">
                        <%= dfMoney.format(stats.getMasseSalarialeTotal()) %>
                    </div>
                    <div class="stat-label">Masse Salariale</div>
                </div>
                
                <div class="stat-card" style="border-color: var(--success);">
                    <div class="stat-icon"></div>
                    <div class="stat-value" style="font-size: 1.8rem; color: var(--success);">
                        <%= dfMoney.format(stats.getSalaireMoyen()) %>
                    </div>
                    <div class="stat-label">Salaire Moyen</div>
                </div>
                
                <div class="stat-card" style="border-color: var(--warning);">
                    <div class="stat-icon"></div>
                    <div class="stat-value" style="font-size: 1.5rem; color: var(--warning);">
                        <%= dfMoney.format(stats.getSalaireMin()) %>
                    </div>
                    <div class="stat-label">Salaire Minimum</div>
                </div>
                
                <div class="stat-card" style="border-color: var(--accent);">
                    <div class="stat-icon"></div>
                    <div class="stat-value" style="font-size: 1.5rem; color: var(--accent);">
                        <%= dfMoney.format(stats.getSalaireMax()) %>
                    </div>
                    <div class="stat-label">Salaire Maximum</div>
                </div>
            </div>

            <!-- Graphiques en Ligne  -->
            <div class="chart-grid">
                <!-- Graphique : Employés par Département -->
                <div class="chart-section">
                    <h3 class="chart-title">Employés par Département</h3>
                    <%
                        Map<String, Integer> empParDept = stats.getEmployesParDepartement();
                        if (empParDept != null && !empParDept.isEmpty()) {
                    %>
                        <div class="chart-container">
                            <canvas id="chartDepartements"></canvas>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="empty-state">
                            <p>Aucune donnée disponible</p>
                        </div>
                    <%
                        }
                    %>
                </div>

                <!-- Graphique : Projets par État -->
                <div class="chart-section">
                    <h3 class="chart-title"> Projets par État</h3>
                    <%
                        Map<String, Integer> projetsParEtat = stats.getProjetsParEtat();
                        if (projetsParEtat != null && !projetsParEtat.isEmpty()) {
                    %>
                        <div class="chart-container">
                            <canvas id="chartProjetsEtat"></canvas>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="empty-state">
                            <p>Aucune donnée disponible</p>
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Graphiques 2ème ligne -->
            <div class="chart-grid">
                <!-- Graphique : Employés par Grade (NOUVEAU) -->
                <div class="chart-section">
                    <h3 class="chart-title">Employés par Grade</h3>
                    <%
                        Map<String, Integer> empParGrade = stats.getEmployesParGrade();
                        if (empParGrade != null && !empParGrade.isEmpty()) {
                    %>
                        <div class="chart-container">
                            <canvas id="chartGrades"></canvas>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="empty-state">
                            <p>Aucune donnée disponible</p>
                        </div>
                    <%
                        }
                    %>
                </div>

                <!-- Graphique : Employés par Poste (NOUVEAU) -->
                <div class="chart-section">
                    <h3 class="chart-title"> Employés par Poste</h3>
                    <%
                        Map<String, Integer> empParPoste = stats.getEmployesParPoste();
                        if (empParPoste != null && !empParPoste.isEmpty()) {
                    %>
                        <div class="chart-container">
                            <canvas id="chartPostes"></canvas>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="empty-state">
                            <p>Aucune donnée disponible</p>
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Graphique : Employés par Projet (Barres horizontales) -->
            <div class="chart-section">
                <h3 class="chart-title">Employés par Projet</h3>
                <%
                    Map<String, Integer> empParProjet = stats.getEmployesParProjet();
                    if (empParProjet != null && !empParProjet.isEmpty()) {
                %>
                    <div class="chart-container" style="height: 500px;">
                        <canvas id="chartProjets"></canvas>
                    </div>
                <%
                    } else {
                %>
                    <div class="empty-state">
                        <p>Aucun projet avec des employés assignés</p>
                    </div>
                <%
                    }
                %>
            </div>

            <!-- Tableau détaillé : Employés par Projet et Grade -->
            <div class="chart-section">
                <h3 class="chart-title"> Employés par Projet et Grade</h3>
                
                <%
                    Map<String, Map<String, Integer>> empParProjetGrade = stats.getEmployesParProjetEtGrade();
                    
                    if (empParProjetGrade != null && !empParProjetGrade.isEmpty()) {
                %>
                
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: var(--spacing-lg);">
                    <%
                        for (Map.Entry<String, Map<String, Integer>> projetEntry : empParProjetGrade.entrySet()) {
                            String nomProjet = projetEntry.getKey();
                            Map<String, Integer> grades = projetEntry.getValue();
                    %>
                    
                    <div style="background: var(--dark); padding: var(--spacing-md); border-radius: 12px; border: 1px solid var(--border);">
                        <h4 style="color: var(--primary-light); margin-bottom: var(--spacing-md); font-weight: 700;">
                            <%= nomProjet %>
                        </h4>
                        
                        <%
                            for (Map.Entry<String, Integer> gradeEntry : grades.entrySet()) {
                                String grade = gradeEntry.getKey();
                                int nombre = gradeEntry.getValue();
                        %>
                        
                        <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid var(--border);">
                            <span style="color: var(--text-secondary); font-weight: 600;"><%= grade %></span>
                            <span class="badge badge-primary"><%= nombre %></span>
                        </div>
                        
                        <%
                            }
                        %>
                    </div>
                    
                    <%
                        }
                    %>
                </div>
                
                <%
                    } else {
                %>
                    <div class="empty-state">
                        <p>Aucune donnée disponible pour les projets et grades</p>
                    </div>
                <%
                    }
                %>
            </div>

            <%
                } else {
            %>
            
            <div class="alert alert-danger">
                ⚠ Impossible de charger les statistiques
            </div>
            
            <%
                }
            %>
            
            <!-- Boutons d'action -->
            <div class="actions" style="margin-top: var(--spacing-xl);">
                <a href="accueil.jsp" class="btn btn-secondary">← Retour à l'accueil</a>
                <a href="exportStatistiquesPdf" class="btn btn-danger" style="background: var(--danger);">
                    Télécharger PDF
                </a>
            </div>
        </div>

        <!-- Footer -->
        <footer>
            <p>© 2025 RowTech - Tous droits réservés</p>
        </footer>
    </div>
    <!-- Chart.js Scripts -->
    <script>
        <%
            // Préparer les données pour Chart.js
            if (stats != null) {
                Map<String, Integer> empParDept = stats.getEmployesParDepartement();
                Map<String, Integer> projetsParEtat = stats.getProjetsParEtat();
                Map<String, Integer> empParGrade = stats.getEmployesParGrade();
                Map<String, Integer> empParPoste = stats.getEmployesParPoste();
                Map<String, Integer> empParProjet = stats.getEmployesParProjet();
        %>

        // Configuration globale Chart.js
        Chart.defaults.color = '#e0e0e0';
        Chart.defaults.borderColor = '#2d2d3d';
        Chart.defaults.font.family = "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif";

        // Palette de couleurs
        const colors = {
            primary: ['rgba(99, 102, 241, 0.8)', 'rgba(139, 92, 246, 0.8)', 'rgba(59, 130, 246, 0.8)', 
                     'rgba(14, 165, 233, 0.8)', 'rgba(6, 182, 212, 0.8)', 'rgba(20, 184, 166, 0.8)',
                     'rgba(16, 185, 129, 0.8)', 'rgba(34, 197, 94, 0.8)', 'rgba(132, 204, 22, 0.8)',
                     'rgba(234, 179, 8, 0.8)', 'rgba(251, 146, 60, 0.8)', 'rgba(251, 113, 133, 0.8)'],
            borders: ['rgba(99, 102, 241, 1)', 'rgba(139, 92, 246, 1)', 'rgba(59, 130, 246, 1)',
                     'rgba(14, 165, 233, 1)', 'rgba(6, 182, 212, 1)', 'rgba(20, 184, 166, 1)',
                     'rgba(16, 185, 129, 1)', 'rgba(34, 197, 94, 1)', 'rgba(132, 204, 22, 1)',
                     'rgba(234, 179, 8, 1)', 'rgba(251, 146, 60, 1)', 'rgba(251, 113, 133, 1)']
        };

        // 1. Graphique : Employés par Département (Camembert)
        <% if (empParDept != null && !empParDept.isEmpty()) { %>
        const ctxDept = document.getElementById('chartDepartements');
        if (ctxDept) {
            new Chart(ctxDept, {
                type: 'doughnut',
                data: {
                    labels: [
                        <% 
                        for (Map.Entry<String, Integer> entry : empParDept.entrySet()) { 
                        %>'<%= entry.getKey() %>',<% 
                        } 
                        %>
                    ],
                    datasets: [{
                        data: [
                            <% 
                            for (Map.Entry<String, Integer> entry : empParDept.entrySet()) { 
                            %><%= entry.getValue() %>,<% 
                            } 
                            %>
                        ],
                        backgroundColor: colors.primary,
                        borderColor: colors.borders,
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 15,
                                font: {
                                    size: 12
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = context.parsed || 0;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((value / total) * 100).toFixed(1);
                                    return label + ': ' + value + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });
        }
        <% } %>

        // 2. Graphique : Projets par État (Camembert)
        <% if (projetsParEtat != null && !projetsParEtat.isEmpty()) { %>
        const ctxEtat = document.getElementById('chartProjetsEtat');
        if (ctxEtat) {
            new Chart(ctxEtat, {
                type: 'pie',
                data: {
                    labels: ['🔵 En Cours', '🟢 Terminé', '🔴 Annulé'],
                    datasets: [{
                        data: [
                            <%= projetsParEtat.getOrDefault("EN_COURS", 0) %>,
                            <%= projetsParEtat.getOrDefault("TERMINE", 0) %>,
                            <%= projetsParEtat.getOrDefault("ANNULE", 0) %>
                        ],
                        backgroundColor: [
                            'rgba(59, 130, 246, 0.8)',
                            'rgba(16, 185, 129, 0.8)',
                            'rgba(239, 68, 68, 0.8)'
                        ],
                        borderColor: [
                            'rgba(59, 130, 246, 1)',
                            'rgba(16, 185, 129, 1)',
                            'rgba(239, 68, 68, 1)'
                        ],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 15,
                                font: {
                                    size: 12
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = context.parsed || 0;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((value / total) * 100).toFixed(1);
                                    return label + ': ' + value + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });
        }
        <% } %>

        // 3. Graphique : Employés par Grade (Barres verticales)
        <% if (empParGrade != null && !empParGrade.isEmpty()) { %>
        const ctxGrade = document.getElementById('chartGrades');
        if (ctxGrade) {
            new Chart(ctxGrade, {
                type: 'bar',
                data: {
                    labels: [
                        <% 
                        for (Map.Entry<String, Integer> entry : empParGrade.entrySet()) { 
                        %>'<%= entry.getKey() %>',<% 
                        } 
                        %>
                    ],
                    datasets: [{
                        label: 'Nombre d\'employés',
                        data: [
                            <% 
                            for (Map.Entry<String, Integer> entry : empParGrade.entrySet()) { 
                            %><%= entry.getValue() %>,<% 
                            } 
                            %>
                        ],
                        backgroundColor: 'rgba(16, 185, 129, 0.8)',
                        borderColor: 'rgba(16, 185, 129, 1)',
                        borderWidth: 2,
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Employés: ' + context.parsed.y;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            },
                            grid: {
                                color: 'rgba(255, 255, 255, 0.05)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        }
        <% } %>

        // 4. Graphique : Employés par Poste (Barres verticales)
        <% if (empParPoste != null && !empParPoste.isEmpty()) { %>
        const ctxPoste = document.getElementById('chartPostes');
        if (ctxPoste) {
            new Chart(ctxPoste, {
                type: 'bar',
                data: {
                    labels: [
                        <% 
                        for (Map.Entry<String, Integer> entry : empParPoste.entrySet()) { 
                        %>'<%= entry.getKey() %>',<% 
                        } 
                        %>
                    ],
                    datasets: [{
                        label: 'Nombre d\'employés',
                        data: [
                            <% 
                            for (Map.Entry<String, Integer> entry : empParPoste.entrySet()) { 
                            %><%= entry.getValue() %>,<% 
                            } 
                            %>
                        ],
                        backgroundColor: colors.primary,
                        borderColor: colors.borders,
                        borderWidth: 2,
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Employés: ' + context.parsed.y;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            },
                            grid: {
                                color: 'rgba(255, 255, 255, 0.05)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        }
        <% } %>

        // 5. Graphique : Employés par Projet (Barres horizontales)
        <% if (empParProjet != null && !empParProjet.isEmpty()) { %>
        const ctxProjet = document.getElementById('chartProjets');
        if (ctxProjet) {
            new Chart(ctxProjet, {
                type: 'bar',
                data: {
                    labels: [
                        <% 
                        for (Map.Entry<String, Integer> entry : empParProjet.entrySet()) { 
                        %>'<%= entry.getKey() %>',<% 
                        } 
                        %>
                    ],
                    datasets: [{
                        label: 'Nombre d\'employés',
                        data: [
                            <% 
                            for (Map.Entry<String, Integer> entry : empParProjet.entrySet()) { 
                            %><%= entry.getValue() %>,<% 
                            } 
                            %>
                        ],
                        backgroundColor: 'rgba(139, 92, 246, 0.8)',
                        borderColor: 'rgba(139, 92, 246, 1)',
                        borderWidth: 2,
                        borderRadius: 8
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Employés: ' + context.parsed.x;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            },
                            grid: {
                                color: 'rgba(255, 255, 255, 0.05)'
                            }
                        },
                        y: {
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        }
        <% } %>

        <%
            }
        %>
    </script>
</body>
</html>
