package com.rsv.controller;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.rsv.bdd.FicheDePaieDAO;
import com.rsv.model.FicheDePaie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/generatePdf")
public class GeneratePdfServlet extends HttpServlet {

    private String getMonthName(int month) {
        String[] months = {"Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
        return months[month - 1];
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de fiche manquant");
            return;
        }

        try {
            int ficheId = Integer.parseInt(idStr);
            FicheDePaieDAO ficheDAO = new FicheDePaieDAO();
            FicheDePaie fiche = ficheDAO.getFicheById(ficheId);

            if (fiche == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Fiche de paie introuvable");
                return;
            }

            // Configuration de la réponse HTTP pour le PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"Fiche_Paie_" + fiche.getEmploye().getMatricule()
                            + "_" + getMonthName(fiche.getMois()) + "_" + fiche.getAnnee() + ".pdf\"");

            OutputStream out = response.getOutputStream();
            PdfWriter writer = new PdfWriter(out);
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

            // Couleurs
            DeviceRgb headerColor = new DeviceRgb(200, 200, 200);
            DeviceRgb totalColor = new DeviceRgb(220, 220, 220);

            // En-tête
            Paragraph title = new Paragraph("SALARIÉ")
                    .setFontSize(16)
                    .setBold()
                    .setTextAlignment(TextAlignment.LEFT);
            document.add(title);

            // Informations salarié
            document.add(new Paragraph("Nom : " + fiche.getEmploye().getNom() + " " + fiche.getEmploye().getPrenom()));
            document.add(new Paragraph("Matricule : " + fiche.getEmploye().getMatricule()));
            document.add(new Paragraph("Poste : " + fiche.getEmploye().getPoste()));
            document.add(new Paragraph("Grade : " + fiche.getEmploye().getGrade()));
            document.add(new Paragraph("\n"));

            // Période
            Paragraph periode = new Paragraph("Période : " + getMonthName(fiche.getMois()) + " " + fiche.getAnnee())
                    .setFontSize(14)
                    .setBold();
            document.add(periode);
            document.add(new Paragraph("\n"));

            // === TABLEAU RÉMUNÉRATION BRUTE ===
            Table table1 = new Table(UnitValue.createPercentArray(new float[]{2, 2, 3}))
                    .useAllAvailableWidth();

            // Header
            table1.addHeaderCell(new Cell().add(new Paragraph("Libellé").setBold())
                    .setBackgroundColor(headerColor).setTextAlignment(TextAlignment.LEFT));
            table1.addHeaderCell(new Cell().add(new Paragraph("Base").setBold())
                    .setBackgroundColor(headerColor).setTextAlignment(TextAlignment.CENTER));
            table1.addHeaderCell(new Cell().add(new Paragraph("Montant").setBold())
                    .setBackgroundColor(headerColor).setTextAlignment(TextAlignment.RIGHT));

            // Section RÉMUNÉRATION BRUTE
            table1.addCell(new Cell(1, 3).add(new Paragraph("RÉMUNÉRATION BRUTE").setBold())
                    .setBackgroundColor(totalColor));

            // Salaire de base
            table1.addCell(new Cell().add(new Paragraph("")));
            table1.addCell(new Cell().add(new Paragraph("")));
            table1.addCell(new Cell().add(new Paragraph("Salaire de base"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Primes
            table1.addCell(new Cell().add(new Paragraph("-")));
            table1.addCell(new Cell().add(new Paragraph(String.format("%.2f €", fiche.getSalaireDeBase())))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("Primes et indemnités"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Total Brut
            table1.addCell(new Cell().add(new Paragraph("-")));
            table1.addCell(new Cell().add(new Paragraph(String.format("+ %.2f €", fiche.getPrimes())))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("TOTAL BRUT").setBold())
                    .setTextAlignment(TextAlignment.RIGHT));

            // Total brut montant
            table1.addCell(new Cell().add(new Paragraph("")));
            table1.addCell(new Cell().add(new Paragraph(String.format("%.2f €", fiche.getSalaireBrut())).setBold())
                    .setTextAlignment(TextAlignment.CENTER).setBackgroundColor(totalColor));
            table1.addCell(new Cell().add(new Paragraph("COTISATIONS SOCIALES SALARIALES").setBold())
                    .setBackgroundColor(totalColor));

            // === COTISATIONS SOCIALES ===
            double salaireBrut = fiche.getSalaireBrut();

            // Sécurité sociale
            table1.addCell(new Cell().add(new Paragraph("")));
            table1.addCell(new Cell().add(new Paragraph("")));
            table1.addCell(new Cell().add(new Paragraph("Sécurité sociale - Maladie"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Assurance vieillesse
            table1.addCell(new Cell().add(new Paragraph(String.format("%.2f €", salaireBrut))));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", fiche.getCotisationSecu())))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("Assurance vieillesse"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Assurance chômage
            table1.addCell(new Cell().add(new Paragraph(String.format("%.2f €", salaireBrut))));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", fiche.getCotisationVieillesse())))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("Assurance chômage"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Retraite complémentaire
            table1.addCell(new Cell().add(new Paragraph(String.format("%.2f €", salaireBrut))));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", fiche.getCotisationChomage())))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("Retraite complémentaire"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // CSG déductible
            table1.addCell(new Cell().add(new Paragraph(String.format("%.2f €", salaireBrut))));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", fiche.getCotisationRetraite())))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("CSG déductible"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // CRDS
            table1.addCell(new Cell().add(new Paragraph(String.format("%.2f €", salaireBrut))));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", fiche.getCotisationCSG())))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("CRDS"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Total cotisations salariales
            table1.addCell(new Cell().add(new Paragraph(String.format("%.2f €", salaireBrut))));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", fiche.getCotisationCRDS())))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("Total cotisations salariales").setBold())
                    .setTextAlignment(TextAlignment.RIGHT));

            // Total cotisations montant
            table1.addCell(new Cell().add(new Paragraph("")));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", fiche.getTotalCotisations())).setBold())
                    .setTextAlignment(TextAlignment.CENTER).setBackgroundColor(totalColor));
            table1.addCell(new Cell().add(new Paragraph("DÉDUCTIONS").setBold())
                    .setBackgroundColor(totalColor));

            // === DÉDUCTIONS ===
            // Avance sur salaire
            table1.addCell(new Cell().add(new Paragraph("")));
            table1.addCell(new Cell().add(new Paragraph("")));
            table1.addCell(new Cell().add(new Paragraph("Avance sur salaire"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Mutuelle entreprise
            double mutuelle = fiche.getDeductions() * 0.4;
            table1.addCell(new Cell().add(new Paragraph("-")));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", mutuelle)))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("Mutuelle entreprise (part salariale)"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Tickets restaurant
            double tickets = fiche.getDeductions() * 0.3;
            table1.addCell(new Cell().add(new Paragraph("-")));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", tickets)))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("Tickets restaurant (part salariale)"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Autres retenues
            double autres = fiche.getDeductions() * 0.2;
            table1.addCell(new Cell().add(new Paragraph("-")));
            table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", autres)))
                    .setTextAlignment(TextAlignment.CENTER));
            table1.addCell(new Cell().add(new Paragraph("Autres retenues"))
                    .setTextAlignment(TextAlignment.RIGHT));

            // Absences
            if (fiche.getJoursAbsence() > 0) {
                table1.addCell(new Cell().add(new Paragraph("-")));
                table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", fiche.getDeductionAbsence())))
                        .setTextAlignment(TextAlignment.CENTER));
                table1.addCell(new Cell().add(new Paragraph("Absences (" + fiche.getJoursAbsence() + " jours)"))
                        .setTextAlignment(TextAlignment.RIGHT));
            } else {
                table1.addCell(new Cell().add(new Paragraph("-")));
                table1.addCell(new Cell().add(new Paragraph(String.format("- %.2f €", fiche.getDeductions() * 0.1)))
                        .setTextAlignment(TextAlignment.CENTER));
                table1.addCell(new Cell().add(new Paragraph("")));
            }

            document.add(table1);

            // === NET À PAYER ===
            document.add(new Paragraph("\n"));
            Table netTable = new Table(UnitValue.createPercentArray(new float[]{1, 1}))
                    .useAllAvailableWidth();

            netTable.addCell(new Cell().add(new Paragraph("NET À PAYER").setBold().setFontSize(14))
                    .setBackgroundColor(new DeviceRgb(173, 216, 230))
                    .setTextAlignment(TextAlignment.LEFT)
                    .setPadding(10));

            netTable.addCell(new Cell().add(new Paragraph(String.format("%.2f €", fiche.getNetAPayer())).setBold().setFontSize(16))
                    .setBackgroundColor(new DeviceRgb(173, 216, 230))
                    .setTextAlignment(TextAlignment.RIGHT)
                    .setPadding(10));

            document.add(netTable);

            // Informations supplémentaires
            document.add(new Paragraph("\n"));
            document.add(new Paragraph("Modalités de paiement : Virement bancaire"));
            document.add(new Paragraph("Date de paiement : Fin du mois"));
            document.add(new Paragraph("Congés payés acquis : 2.5 jours"));

            document.close();

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID invalide");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur lors de la génération du PDF: " + e.getMessage());
        }
    }
}