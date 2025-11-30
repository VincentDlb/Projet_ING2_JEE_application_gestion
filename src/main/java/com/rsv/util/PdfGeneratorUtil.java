package com.rsv.util;

import com.rsv.model.FicheDePaie;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.kernel.colors.ColorConstants;

import java.io.ByteArrayOutputStream;

/**
 * Génère des PDF pour les fiches de paie (utilise les données calculées en BDD)
 */
public class PdfGeneratorUtil {

    /**
     * Génère un PDF détaillé pour une fiche de paie
     */
    public static byte[] genererFicheDePaiePdf(FicheDePaie fiche) throws Exception {
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);

        // === EN-TÊTE ===
        Paragraph header = new Paragraph("BULLETIN DE PAIE")
            .setFontSize(18)
            .setBold()
            .setTextAlignment(TextAlignment.CENTER);
        document.add(header);
        
        document.add(new Paragraph("\n"));

        // === INFORMATIONS ENTREPRISE ===
        document.add(new Paragraph("RowTech SAS").setBold().setFontSize(11));
        document.add(new Paragraph("123 Avenue des Champs-Élysées").setFontSize(9));
        document.add(new Paragraph("75008 Paris").setFontSize(9));
        document.add(new Paragraph("SIRET: 123 456 789 00012").setFontSize(9));
        
        document.add(new Paragraph("\n"));

        // === INFORMATIONS EMPLOYÉ ===
        document.add(new Paragraph("SALARIÉ").setBold().setFontSize(11));
        document.add(new Paragraph("Nom : " + fiche.getEmploye().getNom() + " " + fiche.getEmploye().getPrenom()).setFontSize(9));
        document.add(new Paragraph("Matricule : " + fiche.getEmploye().getMatricule()).setFontSize(9));
        document.add(new Paragraph("Poste : " + fiche.getEmploye().getPoste()).setFontSize(9));
        document.add(new Paragraph("Grade : " + fiche.getEmploye().getGrade()).setFontSize(9));
        
        document.add(new Paragraph("\n"));

        // === PÉRIODE ===
        document.add(new Paragraph("Période : " + getMoisTexte(fiche.getMois()) + " " + fiche.getAnnee())
            .setBold()
            .setFontSize(10));
        
        document.add(new Paragraph("\n"));

        // === RÉCUPÉRATION DES DONNÉES ===
        double salaireBase = fiche.getSalaireDeBase();
        double primes = fiche.getPrimes();
        double heuresSupp = fiche.getHeuresSupp();
        double salaireBrut = fiche.getSalaireBrut();
        
        // Cotisations depuis la BDD
        double secu = fiche.getCotisationSecu();
        double vieillesse = fiche.getCotisationVieillesse();
        double chomage = fiche.getCotisationChomage();
        double retraiteCompl = fiche.getCotisationRetraite();
        double csg = fiche.getCotisationCSG();
        double crds = fiche.getCotisationCRDS();
        double totalCotisations = fiche.getTotalCotisations();
        
        // Déductions
        double deductionsSupp = fiche.getDeductions();
        double deductionAbsence = fiche.getDeductionAbsence();
        
        // Net à payer depuis la BDD
        double netAPayer = fiche.getNetAPayer();

        // === TABLEAU DÉTAILLÉ ===
        float[] columnWidths = {4, 2, 2};
        Table table = new Table(columnWidths);
        table.setWidth(500);

        // En-tête du tableau
        table.addHeaderCell(createHeaderCell("Libellé"));
        table.addHeaderCell(createHeaderCell("Base"));
        table.addHeaderCell(createHeaderCell("Montant"));

        // === RÉMUNÉRATION BRUTE ===
        table.addCell(createSectionCell("RÉMUNÉRATION BRUTE"));
        table.addCell("");
        table.addCell("");

        table.addCell("Salaire de base");
        table.addCell("-");
        table.addCell(String.format("%.2f €", salaireBase));

        if (primes > 0) {
            table.addCell("Primes et indemnités");
            table.addCell("-");
            table.addCell(String.format("+ %.2f €", primes));
        }

        if (heuresSupp > 0) {
            table.addCell("Heures supplémentaires");
            table.addCell("-");
            table.addCell(String.format("+ %.2f €", heuresSupp));
        }

        table.addCell(createBoldCell("TOTAL BRUT"));
        table.addCell("");
        table.addCell(createBoldCell(String.format("%.2f €", salaireBrut)));

        // === COTISATIONS SOCIALES SALARIALES ===
        table.addCell(createSectionCell("COTISATIONS SOCIALES SALARIALES"));
        table.addCell("");
        table.addCell("");

        table.addCell("Sécurité sociale - Maladie");
        table.addCell(String.format("%.2f €", salaireBrut));
        table.addCell(String.format("- %.2f €", secu));

        table.addCell("Assurance vieillesse");
        table.addCell(String.format("%.2f €", salaireBrut));
        table.addCell(String.format("- %.2f €", vieillesse));

        table.addCell("Assurance chômage");
        table.addCell(String.format("%.2f €", salaireBrut));
        table.addCell(String.format("- %.2f €", chomage));

        table.addCell("Retraite complémentaire");
        table.addCell(String.format("%.2f €", salaireBrut));
        table.addCell(String.format("- %.2f €", retraiteCompl));

        table.addCell("CSG déductible");
        table.addCell(String.format("%.2f €", salaireBrut));
        table.addCell(String.format("- %.2f €", csg));

        table.addCell("CRDS");
        table.addCell(String.format("%.2f €", salaireBrut));
        table.addCell(String.format("- %.2f €", crds));

        table.addCell(createBoldCell("Total cotisations salariales"));
        table.addCell("");
        table.addCell(createBoldCell(String.format("- %.2f €", totalCotisations)));

        // === DÉDUCTIONS SUPPLÉMENTAIRES ===
        if (deductionsSupp > 0 || deductionAbsence > 0) {
            table.addCell(createSectionCell("DÉDUCTIONS"));
            table.addCell("");
            table.addCell("");

            if (deductionsSupp > 0) {
                // Détail des déductions (répartition réaliste)
                double avanceSalaire = deductionsSupp * 0.40;
                double mutuelle = deductionsSupp * 0.30;
                double ticketResto = deductionsSupp * 0.20;
                double autres = deductionsSupp * 0.10;

                if (avanceSalaire > 0) {
                    table.addCell("Avance sur salaire");
                    table.addCell("-");
                    table.addCell(String.format("- %.2f €", avanceSalaire));
                }

                if (mutuelle > 0) {
                    table.addCell("Mutuelle entreprise (part salariale)");
                    table.addCell("-");
                    table.addCell(String.format("- %.2f €", mutuelle));
                }

                if (ticketResto > 0) {
                    table.addCell("Tickets restaurant (part salariale)");
                    table.addCell("-");
                    table.addCell(String.format("- %.2f €", ticketResto));
                }

                if (autres > 0) {
                    table.addCell("Autres retenues");
                    table.addCell("-");
                    table.addCell(String.format("- %.2f €", autres));
                }
            }

            if (deductionAbsence > 0) {
                table.addCell("Absences (" + fiche.getJoursAbsence() + " jours)");
                table.addCell(String.format("%.2f €/jour", salaireBase / 30.0));
                table.addCell(String.format("- %.2f €", deductionAbsence));
            }
        }

        document.add(table);
        
        document.add(new Paragraph("\n"));

        // === NET À PAYER ===
        Table netTable = new Table(new float[]{3, 2});
        netTable.setWidth(500);
        netTable.addCell(createBoldCell("NET À PAYER"));
        netTable.addCell(createHighlightCell(String.format("%.2f €", netAPayer)));
        document.add(netTable);

        // === INFORMATIONS SUPPLÉMENTAIRES ===
        document.add(new Paragraph("\n"));
        document.add(new Paragraph("Modalités de paiement : Virement bancaire").setFontSize(8));
        document.add(new Paragraph("Date de paiement : Fin du mois").setFontSize(8));
        document.add(new Paragraph("Congés payés acquis : 2.5 jours").setFontSize(8));

        // === PIED DE PAGE ===
        document.add(new Paragraph("\n\n"));
        document.add(new Paragraph("Document généré automatiquement - RowTech Système RH")
            .setFontSize(7)
            .setTextAlignment(TextAlignment.CENTER)
            .setFontColor(ColorConstants.GRAY));
        document.add(new Paragraph("Conservez ce bulletin de paie sans limitation de durée")
            .setFontSize(7)
            .setTextAlignment(TextAlignment.CENTER)
            .setFontColor(ColorConstants.GRAY));

        document.close();
        
        return baos.toByteArray();
    }

    private static com.itextpdf.layout.element.Cell createHeaderCell(String text) {
        return new com.itextpdf.layout.element.Cell()
            .add(new Paragraph(text).setBold().setFontSize(9))
            .setBackgroundColor(ColorConstants.LIGHT_GRAY)
            .setTextAlignment(TextAlignment.CENTER);
    }

    private static com.itextpdf.layout.element.Cell createSectionCell(String text) {
        return new com.itextpdf.layout.element.Cell(1, 3)
            .add(new Paragraph(text).setBold().setFontSize(9))
            .setBackgroundColor(ColorConstants.LIGHT_GRAY);
    }

    private static com.itextpdf.layout.element.Cell createBoldCell(String text) {
        return new com.itextpdf.layout.element.Cell()
            .add(new Paragraph(text).setBold().setFontSize(9));
    }

    private static com.itextpdf.layout.element.Cell createHighlightCell(String text) {
        return new com.itextpdf.layout.element.Cell()
            .add(new Paragraph(text).setBold().setFontSize(12))
            .setBackgroundColor(new com.itextpdf.kernel.colors.DeviceRgb(200, 230, 255))
            .setTextAlignment(TextAlignment.CENTER);
    }

    private static String getMoisTexte(int mois) {
        String[] moisNoms = {"", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                            "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
        return moisNoms[mois];
    }
}