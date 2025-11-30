<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rsv.model.User" %>
<%@ page import="com.rsv.model.Role" %>
<%
    // Set page title and breadcrumb for header
    request.setAttribute("pageTitle", "Rapports et Statistiques");
    request.setAttribute("pageBreadcrumb", "Rapports");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rapports et Statistiques - JEE RH</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
    .chart-container {
        position: relative;
        height: 400px;
        background: white;
        padding: 2rem;
        border-radius: 1rem;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        margin-bottom: 2rem;
    }

    .chart-title {
        text-align: center;
        font-size: 1.25rem;
        font-weight: 600;
        color: #1f2937;
        margin-bottom: 1.5rem;
    }

    .no-data-message {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 300px;
        color: #9ca3af;
        font-size: 1rem;
        text-align: center;
    }
    </style>
</head>
<body>

<!-- Layout principal -->
<div class="app-wrapper">

    <!-- Menu latéral -->
    <%@ include file="includes/menu.jsp" %>

    <!-- Contenu principal -->
    <div class="main-content">

        <!-- Header -->
        <jsp:include page="/includes/header.jsp" />


        <!-- Zone de contenu -->
        <div class="content-wrapper fade-in">

            <% String erreur = (String) request.getAttribute("erreur");
               if (erreur != null) { %>
                <div class="alert alert-error">
                    <strong>⚠️ Erreur :</strong> <%= erreur %>
                </div>
            <% } %>

            <!-- Statistiques générales -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Total Employés</h3>
                        <p><%= request.getAttribute("totalEmployes") != null ? request.getAttribute("totalEmployes") : 0 %></p>
                    </div>
                    <div class="stat-icon blue">
                        <span>👥</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Total Départements</h3>
                        <p><%= request.getAttribute("totalDepartements") != null ? request.getAttribute("totalDepartements") : 0 %></p>
                    </div>
                    <div class="stat-icon green">
                        <span>🏢</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Total Projets</h3>
                        <p><%= request.getAttribute("totalProjets") != null ? request.getAttribute("totalProjets") : 0 %></p>
                    </div>
                    <div class="stat-icon orange">
                        <span>📊</span>
                    </div>
                </div>
            </div>

            <!-- Graphiques -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(500px, 1fr)); gap: 2rem;">

                <!-- Cadres vs Non-Cadres -->
                <div class="chart-container">
                    <div class="chart-title">👔 Répartition Cadres / Non-Cadres</div>
                    <%
                        Integer nombreCadres = (Integer) request.getAttribute("nombreCadres");
                        Integer nombreNonCadres = (Integer) request.getAttribute("nombreNonCadres");
                        boolean hasCadresData = nombreCadres != null && nombreNonCadres != null && (nombreCadres + nombreNonCadres) > 0;
                    %>
                    <% if (hasCadresData) { %>
                        <canvas id="chartCadres"></canvas>
                    <% } else { %>
                        <div class="no-data-message">📭 Aucune donnée disponible</div>
                    <% } %>
                </div>

                <!-- Employés par grade -->
                <div class="chart-container">
                    <div class="chart-title">⭐ Employés par Grade</div>
                    <%
                        Map<String, Integer> employesParGrade = (Map<String, Integer>) request.getAttribute("employesParGrade");
                        boolean hasGradeData = employesParGrade != null && !employesParGrade.isEmpty();
                    %>
                    <% if (hasGradeData) { %>
                        <canvas id="chartGrade"></canvas>
                    <% } else { %>
                        <div class="no-data-message">📭 Aucune donnée disponible</div>
                    <% } %>
                </div>

                <!-- Employés par type de contrat -->
                <div class="chart-container">
                    <div class="chart-title">📄 Employés par Type de Contrat</div>
                    <%
                        Map<String, Integer> employesParContrat = (Map<String, Integer>) request.getAttribute("employesParContrat");
                        boolean hasContratData = employesParContrat != null && !employesParContrat.isEmpty();
                    %>
                    <% if (hasContratData) { %>
                        <canvas id="chartContrat"></canvas>
                    <% } else { %>
                        <div class="no-data-message">📭 Aucune donnée disponible</div>
                    <% } %>
                </div>

                <!-- Employés par département -->
                <div class="chart-container">
                    <div class="chart-title">🏢 Employés par Département</div>
                    <%
                        Map<String, Integer> employesParDepartement = (Map<String, Integer>) request.getAttribute("employesParDepartement");
                        boolean hasDepartementData = employesParDepartement != null && !employesParDepartement.isEmpty();
                    %>
                    <% if (hasDepartementData) { %>
                        <canvas id="chartDepartement"></canvas>
                    <% } else { %>
                        <div class="no-data-message">📭 Aucune donnée disponible</div>
                    <% } %>
                </div>

                <!-- Projets par état -->
                <div class="chart-container">
                    <div class="chart-title">📊 Projets par État</div>
                    <%
                        Map<String, Integer> projetsParEtat = (Map<String, Integer>) request.getAttribute("projetsParEtat");
                        boolean hasProjetData = projetsParEtat != null && !projetsParEtat.isEmpty();
                    %>
                    <% if (hasProjetData) { %>
                        <canvas id="chartProjet"></canvas>
                    <% } else { %>
                        <div class="no-data-message">📭 Aucune donnée disponible</div>
                    <% } %>
                </div>

                <!-- Employés par ancienneté -->
                <div class="chart-container">
                    <div class="chart-title">📅 Employés par Ancienneté</div>
                    <%
                        Map<String, Integer> employesParAnciennete = (Map<String, Integer>) request.getAttribute("employesParAnciennete");
                        boolean hasAncienneteData = employesParAnciennete != null && !employesParAnciennete.isEmpty();
                    %>
                    <% if (hasAncienneteData) { %>
                        <canvas id="chartAnciennete"></canvas>
                    <% } else { %>
                        <div class="no-data-message">📭 Aucune donnée disponible</div>
                    <% } %>
                </div>

                <!-- Employés par âge -->
                <div class="chart-container">
                    <div class="chart-title">🎂 Employés par Tranche d'Âge</div>
                    <%
                        Map<String, Integer> employesParAge = (Map<String, Integer>) request.getAttribute("employesParAge");
                        boolean hasAgeData = employesParAge != null && !employesParAge.isEmpty();
                    %>
                    <% if (hasAgeData) { %>
                        <canvas id="chartAge"></canvas>
                    <% } else { %>
                        <div class="no-data-message">📭 Aucune donnée disponible</div>
                    <% } %>
                </div>

            </div>

        </div>

    </div>

</div>

<script>
// Configuration commune des graphiques
const commonOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {
            position: 'bottom',
            labels: {
                font: {
                    size: 12
                },
                padding: 15
            }
        }
    }
};

<%!
    // Fonction helper pour convertir Map en JSON
    String mapToLabels(Map<String, Integer> map) {
        if (map == null || map.isEmpty()) return "[]";
        List<String> labels = new ArrayList<>();
        for (String key : map.keySet()) {
            labels.add("'" + key.replace("'", "\\'") + "'");
        }
        return "[" + String.join(", ", labels) + "]";
    }

    String mapToValues(Map<String, Integer> map) {
        if (map == null || map.isEmpty()) return "[]";
        List<String> values = new ArrayList<>();
        for (Integer value : map.values()) {
            values.add(String.valueOf(value));
        }
        return "[" + String.join(", ", values) + "]";
    }
%>

// 1. Graphique Cadres vs Non-Cadres (Pie)
<% if (hasCadresData) { %>
new Chart(document.getElementById('chartCadres'), {
    type: 'pie',
    data: {
        labels: ['Cadres', 'Non-Cadres'],
        datasets: [{
            data: [<%= nombreCadres %>, <%= nombreNonCadres %>],
            backgroundColor: ['#667eea', '#f093fb'],
            borderWidth: 2,
            borderColor: '#fff'
        }]
    },
    options: commonOptions
});
<% } %>

// 2. Graphique Employés par Grade (Bar)
<% if (hasGradeData) { %>
new Chart(document.getElementById('chartGrade'), {
    type: 'bar',
    data: {
        labels: <%= mapToLabels(employesParGrade) %>,
        datasets: [{
            label: 'Nombre d\'employés',
            data: <%= mapToValues(employesParGrade) %>,
            backgroundColor: '#4facfe',
            borderRadius: 8
        }]
    },
    options: {
        ...commonOptions,
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    stepSize: 1
                }
            }
        }
    }
});
<% } %>

// 3. Graphique Employés par Contrat (Doughnut)
<% if (hasContratData) { %>
new Chart(document.getElementById('chartContrat'), {
    type: 'doughnut',
    data: {
        labels: <%= mapToLabels(employesParContrat) %>,
        datasets: [{
            data: <%= mapToValues(employesParContrat) %>,
            backgroundColor: ['#667eea', '#764ba2', '#f093fb', '#f5576c', '#4facfe'],
            borderWidth: 2,
            borderColor: '#fff'
        }]
    },
    options: commonOptions
});
<% } %>

// 4. Graphique Employés par Département (Bar horizontal)
<% if (hasDepartementData) { %>
new Chart(document.getElementById('chartDepartement'), {
    type: 'bar',
    data: {
        labels: <%= mapToLabels(employesParDepartement) %>,
        datasets: [{
            label: 'Nombre d\'employés',
            data: <%= mapToValues(employesParDepartement) %>,
            backgroundColor: '#10b981',
            borderRadius: 8
        }]
    },
    options: {
        ...commonOptions,
        indexAxis: 'y',
        scales: {
            x: {
                beginAtZero: true,
                ticks: {
                    stepSize: 1
                }
            }
        }
    }
});
<% } %>

// 5. Graphique Projets par État (Pie)
<% if (hasProjetData) { %>
new Chart(document.getElementById('chartProjet'), {
    type: 'pie',
    data: {
        labels: <%= mapToLabels(projetsParEtat) %>,
        datasets: [{
            data: <%= mapToValues(projetsParEtat) %>,
            backgroundColor: ['#4facfe', '#00f2fe', '#43e97b', '#f093fb'],
            borderWidth: 2,
            borderColor: '#fff'
        }]
    },
    options: commonOptions
});
<% } %>

// 6. Graphique Ancienneté (Bar)
<% if (hasAncienneteData) { %>
new Chart(document.getElementById('chartAnciennete'), {
    type: 'bar',
    data: {
        labels: <%= mapToLabels(employesParAnciennete) %>,
        datasets: [{
            label: 'Nombre d\'employés',
            data: <%= mapToValues(employesParAnciennete) %>,
            backgroundColor: '#f59e0b',
            borderRadius: 8
        }]
    },
    options: {
        ...commonOptions,
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    stepSize: 1
                }
            }
        }
    }
});
<% } %>

// 7. Graphique Âge (Line)
<% if (hasAgeData) { %>
new Chart(document.getElementById('chartAge'), {
    type: 'line',
    data: {
        labels: <%= mapToLabels(employesParAge) %>,
        datasets: [{
            label: 'Nombre d\'employés',
            data: <%= mapToValues(employesParAge) %>,
            borderColor: '#ef4444',
            backgroundColor: 'rgba(239, 68, 68, 0.1)',
            tension: 0.4,
            fill: true,
            borderWidth: 3,
            pointRadius: 5,
            pointHoverRadius: 7,
            pointBackgroundColor: '#ef4444'
        }]
    },
    options: {
        ...commonOptions,
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    stepSize: 1
                }
            }
        }
    }
});
<% } %>
</script>

</body>
</html>
