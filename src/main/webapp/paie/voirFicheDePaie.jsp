<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rsv.model.FicheDePaie" %>
<%@ page import="com.rsv.model.Employe" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fiche de Paie - Impression</title>
<link rel="stylesheet" href="../style.css">
<style>
@media print {
    .no-print {
        display: none !important;
    }
    body {
        background: white;
    }
    .container {
        max-width: 100%;
        box-shadow: none;
    }
}
</style>
<script>
function imprimer() {
    window.print();
}
function retour(){
    window.close();
}
</script>
</head>
<body>

<%
    FicheDePaie fiche = (FicheDePaie) request.getAttribute("fiche");
    if (fiche != null && fiche.getEmploye() != null) {
        Employe employe = fiche.getEmploye();
        float salaireNet = fiche.calculerSalaireNet();
%>

<div class="container" style="max-width: 900px;">

    <!-- Boutons d'action (masqués à l'impression) -->
    <div class="no-print" style="margin-bottom: 1.5rem; text-align: center;">
        <button type="button" onclick="imprimer();" style="padding: 1rem 2rem; font-size: 1rem; background: linear-gradient(135deg, #3b82f6, #2563eb);">
            🖨️ Imprimer
        </button>
        <button type="button" onclick="retour();" style="padding: 1rem 2rem; font-size: 1rem; background: linear-gradient(135deg, #6b7280, #4b5563);">
            ◀️ Fermer
        </button>
    </div>

    <!-- En-tête de la fiche -->
    <div style="text-align: center; padding: 2rem; background: linear-gradient(135deg, #f59e0b, #d97706); color: white; border-radius: 0.75rem; margin-bottom: 2rem;">
        <h1 style="margin: 0 0 0.5rem 0; font-size: 2rem;">💰 FICHE DE PAIE</h1>
        <h2 style="margin: 0; font-size: 1.25rem; opacity: 0.9;"><%= fiche.getNomMois() %> <%= fiche.getAnnee() %></h2>
    </div>

    <!-- Informations entreprise et employé -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem;">

        <!-- Entreprise -->
        <div style="padding: 1.5rem; background: #f3f4f6; border-radius: 0.5rem;">
            <h3 style="margin: 0 0 1rem 0; color: #1f2937; border-bottom: 2px solid #d1d5db; padding-bottom: 0.5rem;">🏢 EMPLOYEUR</h3>
            <p style="margin: 0.5rem 0;"><strong>Entreprise :</strong> RowTech</p>
            <p style="margin: 0.5rem 0;"><strong>Adresse :</strong> 123 Avenue de l'Innovation</p>
            <p style="margin: 0.5rem 0;"><strong>Code Postal :</strong> 75001 Paris</p>
            <p style="margin: 0.5rem 0;"><strong>SIRET :</strong> 123 456 789 00012</p>
        </div>

        <!-- Employé -->
        <div style="padding: 1.5rem; background: #f3f4f6; border-radius: 0.5rem;">
            <h3 style="margin: 0 0 1rem 0; color: #1f2937; border-bottom: 2px solid #d1d5db; padding-bottom: 0.5rem;">👤 EMPLOYÉ</h3>
            <p style="margin: 0.5rem 0;"><strong>Nom :</strong> <%= employe.getNom() %> <%= employe.getPrenom() %></p>
            <p style="margin: 0.5rem 0;"><strong>Matricule :</strong> <%= employe.getMatricule() %></p>
            <p style="margin: 0.5rem 0;"><strong>Poste :</strong> <%= employe.getPoste() %></p>
            <p style="margin: 0.5rem 0;"><strong>Grade :</strong> <%= employe.getGrade() != null ? employe.getGrade() : "N/A" %></p>
            <p style="margin: 0.5rem 0;"><strong>Statut :</strong> <%= fiche.isStatutCadre() ? "Cadre" : "Non-cadre" %></p>
            <p style="margin: 0.5rem 0;"><strong>N° Fiscal :</strong> <%= fiche.getNumeroFiscal() %></p>
        </div>

    </div>

    <!-- Détail des heures -->
    <div style="margin-bottom: 2rem;">
        <h3 style="margin: 0 0 1rem 0; color: #1f2937; border-bottom: 2px solid #d1d5db; padding-bottom: 0.5rem;">⏰ DÉTAIL DES HEURES</h3>
        <table style="width: 100%; border-collapse: collapse; background: white;">
            <thead>
                <tr style="background: #f3f4f6;">
                    <th style="padding: 0.75rem; text-align: left; border: 1px solid #d1d5db;">Description</th>
                    <th style="padding: 0.75rem; text-align: right; border: 1px solid #d1d5db;">Heures</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="padding: 0.75rem; border: 1px solid #e5e7eb;">Heures hebdomadaires</td>
                    <td style="padding: 0.75rem; text-align: right; border: 1px solid #e5e7eb;"><%= String.format("%.2f", fiche.getHeureSemaine()) %> h</td>
                </tr>
                <tr>
                    <td style="padding: 0.75rem; border: 1px solid #e5e7eb;">Heures dans le mois</td>
                    <td style="padding: 0.75rem; text-align: right; border: 1px solid #e5e7eb;"><%= String.format("%.2f", fiche.getHeureDansLeMois()) %> h</td>
                </tr>
                <tr>
                    <td style="padding: 0.75rem; border: 1px solid #e5e7eb;">Heures supplémentaires</td>
                    <td style="padding: 0.75rem; text-align: right; border: 1px solid #e5e7eb; color: #059669;"><%= String.format("%.2f", fiche.getHeureSupp()) %> h</td>
                </tr>
                <tr>
                    <td style="padding: 0.75rem; border: 1px solid #e5e7eb;">Heures d'absence</td>
                    <td style="padding: 0.75rem; text-align: right; border: 1px solid #e5e7eb; color: #dc2626;"><%= String.format("%.2f", fiche.getHeureAbsences()) %> h</td>
                </tr>
                <tr>
                    <td style="padding: 0.75rem; border: 1px solid #e5e7eb;"><strong>Taux horaire</strong></td>
                    <td style="padding: 0.75rem; text-align: right; border: 1px solid #e5e7eb;"><strong><%= String.format("%.2f", fiche.getTauxHoraire()) %> €/h</strong></td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Détail de la rémunération -->
    <div style="margin-bottom: 2rem;">
        <h3 style="margin: 0 0 1rem 0; color: #1f2937; border-bottom: 2px solid #d1d5db; padding-bottom: 0.5rem;">💰 DÉTAIL DE LA RÉMUNÉRATION</h3>
        <table style="width: 100%; border-collapse: collapse; background: white;">
            <thead>
                <tr style="background: #f3f4f6;">
                    <th style="padding: 0.75rem; text-align: left; border: 1px solid #d1d5db;">Libellé</th>
                    <th style="padding: 0.75rem; text-align: right; border: 1px solid #d1d5db;">Montant</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="padding: 0.75rem; border: 1px solid #e5e7eb;"><strong>Salaire de base (brut)</strong></td>
                    <td style="padding: 0.75rem; text-align: right; border: 1px solid #e5e7eb;"><strong><%= String.format("%.2f", fiche.getSalaireBrut()) %> €</strong></td>
                </tr>
                <tr>
                    <td style="padding: 0.75rem; border: 1px solid #e5e7eb; color: #059669;">+ Primes et bonus</td>
                    <td style="padding: 0.75rem; text-align: right; border: 1px solid #e5e7eb; color: #059669;"><%= String.format("%.2f", fiche.getBonus()) %> €</td>
                </tr>
                <tr>
                    <td style="padding: 0.75rem; border: 1px solid #e5e7eb; color: #dc2626;">- Cotisations et déductions</td>
                    <td style="padding: 0.75rem; text-align: right; border: 1px solid #e5e7eb; color: #dc2626;"><%= String.format("%.2f", fiche.getDeduction()) %> €</td>
                </tr>
                <tr style="background: linear-gradient(135deg, #dbeafe, #bfdbfe);">
                    <td style="padding: 1rem; border: 2px solid #3b82f6; font-size: 1.25rem;"><strong>💵 SALAIRE NET À PAYER</strong></td>
                    <td style="padding: 1rem; text-align: right; border: 2px solid #3b82f6; font-size: 1.5rem; font-weight: bold; color: #1e40af;"><%= String.format("%.2f", salaireNet) %> €</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Pied de page -->
    <div style="margin-top: 3rem; padding: 1.5rem; background: #f9fafb; border-radius: 0.5rem; text-align: center; font-size: 0.875rem; color: #6b7280;">
        <p style="margin: 0.25rem 0;">Document généré le <%= new java.text.SimpleDateFormat("dd/MM/yyyy à HH:mm").format(new java.util.Date()) %></p>
        <p style="margin: 0.25rem 0;">Fiche de paie ID: <%= fiche.getId() %></p>
        <p style="margin: 0.25rem 0;">⚠️ Ce document est confidentiel et ne peut être communiqué à des tiers.</p>
        <p style="margin: 0.25rem 0;">Pour toute question, contactez le service RH : rh@rowtech.com</p>
    </div>

</div>

<%
    } else {
%>
    <div class="container">
        <div style="padding: 3rem; text-align: center; background: #fee2e2; border-radius: 0.75rem; border-left: 4px solid #ef4444;">
            <h2 style="color: #991b1b; margin-bottom: 1rem;">⚠️ Erreur</h2>
            <p style="color: #7f1d1d;">La fiche de paie demandée n'a pas été trouvée.</p>
            <button type="button" onclick="retour();" style="margin-top: 1rem;">
                ◀️ Fermer
            </button>
        </div>
    </div>
<%
    }
%>

</body>
</html>
