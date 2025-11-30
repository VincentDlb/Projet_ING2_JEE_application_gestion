package com.rsv.controller;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.rsv.bdd.StatistiquesDAO;
import com.rsv.model.Statistiques;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

/**
 * Servlet pour exporter les statistiques en PDF.
 * 
 * @author RowTech Team
 * @version 1.0
 */
@WebServlet("/exportStatistiquesPdf")
public class ExportStatistiquesPdfServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private StatistiquesDAO statistiquesDAO;
    private DecimalFormat dfMoney = new DecimalFormat("#,##0.00 €");
    private DecimalFormat dfNumber = new DecimalFormat("#,##0");
    
    @Override
    public void init() {
        statistiquesDAO = new StatistiquesDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupérer les statistiques
            Statistiques stats = statistiquesDAO.getStatistiquesGlobales();
            
            // Générer le PDF
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            genererPdfStatistiques(stats, baos);
            
            // Préparer la réponse HTTP
            String fileName = "Rapport_Statistiques_" + 
                            LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) + 
                            ".pdf";
            
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength(baos.size());
            
            // Envoyer le PDF
            baos.writeTo(response.getOutputStream());
            response.getOutputStream().flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Erreur lors de la génération du PDF");
        }
    }
    
    /**
     * Génère le PDF complet des statistiques.
     */
    private void genererPdfStatistiques(Statistiques stats, ByteArrayOutputStream baos) throws Exception {
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc);
        
        // Couleurs personnalisées
        DeviceRgb primaryColor = new DeviceRgb(99, 102, 241);
        DeviceRgb successColor = new DeviceRgb(16, 185, 129);
        
        // En-tête
        ajouterEnTete(document);
        
        // Vue d'ensemble
        ajouterVueEnsemble(document, stats, primaryColor);
        
        // Statistiques salaires
        ajouterStatistiquesSalaires(document, stats, successColor);
        
        // Employés par département
        ajouterTableauEmployesParDepartement(document, stats, primaryColor);
        
        // Employés par projet
        ajouterTableauEmployesParProjet(document, stats, primaryColor);
        
        // Projets par état
        ajouterTableauProjetsParEtat(document, stats, primaryColor);
        
        // Employés par grade
        ajouterTableauEmployesParGrade(document, stats, successColor);
        
        // Employés par poste
        ajouterTableauEmployesParPoste(document, stats, successColor);
        
        // Pied de page
        ajouterPiedDePage(document);
        
        document.close();
    }
    
    /**
     * Ajoute l'en-tête du document.
     */
    private void ajouterEnTete(Document document) {
        Paragraph titre = new Paragraph("📊 RAPPORT STATISTIQUES ROWTECH")
                .setFontSize(20)
                .setBold()
                .setTextAlignment(TextAlignment.CENTER)
                .setMarginBottom(10);
        document.add(titre);
        
        String dateGeneration = LocalDateTime.now().format(
                DateTimeFormatter.ofPattern("dd/MM/yyyy à HH:mm"));
        Paragraph date = new Paragraph("Généré le " + dateGeneration)
                .setFontSize(10)
                .setTextAlignment(TextAlignment.CENTER)
                .setMarginBottom(20);
        document.add(date);
        
        document.add(new Paragraph("\n"));
    }
    
    /**
     * Ajoute la vue d'ensemble (totaux).
     */
    private void ajouterVueEnsemble(Document document, Statistiques stats, DeviceRgb color) {
        Paragraph sectionTitle = new Paragraph("📈 VUE D'ENSEMBLE")
                .setFontSize(16)
                .setBold()
                .setFontColor(color)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Table table = new Table(UnitValue.createPercentArray(new float[]{1, 1}))
                .setWidth(UnitValue.createPercentValue(100));
        
        ajouterCelluleStatGlobale(table, "👥 Total Employés", 
                                 dfNumber.format(stats.getTotalEmployes()));
        ajouterCelluleStatGlobale(table, "🏛️ Total Départements", 
                                 dfNumber.format(stats.getTotalDepartements()));
        ajouterCelluleStatGlobale(table, "📁 Total Projets", 
                                 dfNumber.format(stats.getTotalProjets()));
        ajouterCelluleStatGlobale(table, "💰 Total Fiches de Paie", 
                                 dfNumber.format(stats.getTotalFichesDePaie()));
        
        document.add(table);
        document.add(new Paragraph("\n"));
    }
    
    /**
     * Ajoute les statistiques salaires.
     */
    private void ajouterStatistiquesSalaires(Document document, Statistiques stats, DeviceRgb color) {
        Paragraph sectionTitle = new Paragraph("💵 STATISTIQUES SALAIRES")
                .setFontSize(16)
                .setBold()
                .setFontColor(color)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Table table = new Table(UnitValue.createPercentArray(new float[]{1, 1}))
                .setWidth(UnitValue.createPercentValue(100));
        
        ajouterCelluleStatGlobale(table, "💰 Masse Salariale Totale", 
                                 dfMoney.format(stats.getMasseSalarialeTotal()));
        ajouterCelluleStatGlobale(table, "📊 Salaire Moyen", 
                                 dfMoney.format(stats.getSalaireMoyen()));
        ajouterCelluleStatGlobale(table, "⬇️ Salaire Minimum", 
                                 dfMoney.format(stats.getSalaireMin()));
        ajouterCelluleStatGlobale(table, "⬆️ Salaire Maximum", 
                                 dfMoney.format(stats.getSalaireMax()));
        
        document.add(table);
        document.add(new Paragraph("\n"));
    }
    
    /**
     * Ajoute une cellule de statistique globale.
     */
    private void ajouterCelluleStatGlobale(Table table, String label, String value) {
        Cell cellLabel = new Cell()
                .add(new Paragraph(label).setBold())
                .setBackgroundColor(new DeviceRgb(240, 240, 250))
                .setPadding(10);
        
        Cell cellValue = new Cell()
                .add(new Paragraph(value))
                .setTextAlignment(TextAlignment.RIGHT)
                .setPadding(10);
        
        table.addCell(cellLabel);
        table.addCell(cellValue);
    }
    
    /**
     * Ajoute le tableau employés par département.
     */
    private void ajouterTableauEmployesParDepartement(Document document, Statistiques stats, DeviceRgb color) {
        Paragraph sectionTitle = new Paragraph("🏛️ EMPLOYÉS PAR DÉPARTEMENT")
                .setFontSize(16)
                .setBold()
                .setFontColor(color)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Map<String, Integer> data = stats.getEmployesParDepartement();
        
        if (data != null && !data.isEmpty()) {
            Table table = new Table(UnitValue.createPercentArray(new float[]{3, 1}))
                    .setWidth(UnitValue.createPercentValue(100));
            
            // En-têtes
            table.addHeaderCell(creerCelluleEntete("Département"));
            table.addHeaderCell(creerCelluleEntete("Nombre"));
            
            // Données
            for (Map.Entry<String, Integer> entry : data.entrySet()) {
                table.addCell(new Cell().add(new Paragraph(entry.getKey())).setPadding(8));
                table.addCell(new Cell().add(new Paragraph(String.valueOf(entry.getValue())))
                        .setTextAlignment(TextAlignment.CENTER).setPadding(8));
            }
            
            document.add(table);
        } else {
            document.add(new Paragraph("Aucune donnée disponible").setItalic());
        }
        
        document.add(new Paragraph("\n"));
    }
    
    /**
     * Ajoute le tableau employés par projet.
     */
    private void ajouterTableauEmployesParProjet(Document document, Statistiques stats, DeviceRgb color) {
        Paragraph sectionTitle = new Paragraph("📁 EMPLOYÉS PAR PROJET")
                .setFontSize(16)
                .setBold()
                .setFontColor(color)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Map<String, Integer> data = stats.getEmployesParProjet();
        
        if (data != null && !data.isEmpty()) {
            Table table = new Table(UnitValue.createPercentArray(new float[]{3, 1}))
                    .setWidth(UnitValue.createPercentValue(100));
            
            // En-têtes
            table.addHeaderCell(creerCelluleEntete("Projet"));
            table.addHeaderCell(creerCelluleEntete("Nombre"));
            
            // Données
            for (Map.Entry<String, Integer> entry : data.entrySet()) {
                table.addCell(new Cell().add(new Paragraph(entry.getKey())).setPadding(8));
                table.addCell(new Cell().add(new Paragraph(String.valueOf(entry.getValue())))
                        .setTextAlignment(TextAlignment.CENTER).setPadding(8));
            }
            
            document.add(table);
        } else {
            document.add(new Paragraph("Aucune donnée disponible").setItalic());
        }
        
        document.add(new Paragraph("\n"));
    }
    
    /**
     * Ajoute le tableau projets par état.
     */
    private void ajouterTableauProjetsParEtat(Document document, Statistiques stats, DeviceRgb color) {
        Paragraph sectionTitle = new Paragraph("📊 PROJETS PAR ÉTAT")
                .setFontSize(16)
                .setBold()
                .setFontColor(color)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Map<String, Integer> data = stats.getProjetsParEtat();
        
        if (data != null && !data.isEmpty()) {
            Table table = new Table(UnitValue.createPercentArray(new float[]{2, 1}))
                    .setWidth(UnitValue.createPercentValue(100));
            
            // En-têtes
            table.addHeaderCell(creerCelluleEntete("État"));
            table.addHeaderCell(creerCelluleEntete("Nombre"));
            
            // Données
            int enCours = data.getOrDefault("EN_COURS", 0);
            int termine = data.getOrDefault("TERMINE", 0);
            int annule = data.getOrDefault("ANNULE", 0);
            
            table.addCell(new Cell().add(new Paragraph("🔵 En Cours")).setPadding(8));
            table.addCell(new Cell().add(new Paragraph(String.valueOf(enCours)))
                    .setTextAlignment(TextAlignment.CENTER).setPadding(8));
            
            table.addCell(new Cell().add(new Paragraph("🟢 Terminé")).setPadding(8));
            table.addCell(new Cell().add(new Paragraph(String.valueOf(termine)))
                    .setTextAlignment(TextAlignment.CENTER).setPadding(8));
            
            table.addCell(new Cell().add(new Paragraph("🔴 Annulé")).setPadding(8));
            table.addCell(new Cell().add(new Paragraph(String.valueOf(annule)))
                    .setTextAlignment(TextAlignment.CENTER).setPadding(8));
            
            document.add(table);
        } else {
            document.add(new Paragraph("Aucune donnée disponible").setItalic());
        }
        
        document.add(new Paragraph("\n"));
    }
    
    /**
     * Ajoute le tableau employés par grade.
     */
    private void ajouterTableauEmployesParGrade(Document document, Statistiques stats, DeviceRgb color) {
        Paragraph sectionTitle = new Paragraph("🎓 EMPLOYÉS PAR GRADE")
                .setFontSize(16)
                .setBold()
                .setFontColor(color)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Map<String, Integer> data = stats.getEmployesParGrade();
        
        if (data != null && !data.isEmpty()) {
            Table table = new Table(UnitValue.createPercentArray(new float[]{3, 1}))
                    .setWidth(UnitValue.createPercentValue(100));
            
            // En-têtes
            table.addHeaderCell(creerCelluleEntete("Grade"));
            table.addHeaderCell(creerCelluleEntete("Nombre"));
            
            // Données
            for (Map.Entry<String, Integer> entry : data.entrySet()) {
                table.addCell(new Cell().add(new Paragraph(entry.getKey())).setPadding(8));
                table.addCell(new Cell().add(new Paragraph(String.valueOf(entry.getValue())))
                        .setTextAlignment(TextAlignment.CENTER).setPadding(8));
            }
            
            document.add(table);
        } else {
            document.add(new Paragraph("Aucune donnée disponible").setItalic());
        }
        
        document.add(new Paragraph("\n"));
    }
    
    /**
     * Ajoute le tableau employés par poste.
     */
    private void ajouterTableauEmployesParPoste(Document document, Statistiques stats, DeviceRgb color) {
        Paragraph sectionTitle = new Paragraph("💼 EMPLOYÉS PAR POSTE")
                .setFontSize(16)
                .setBold()
                .setFontColor(color)
                .setMarginBottom(10);
        document.add(sectionTitle);
        
        Map<String, Integer> data = stats.getEmployesParPoste();
        
        if (data != null && !data.isEmpty()) {
            Table table = new Table(UnitValue.createPercentArray(new float[]{3, 1}))
                    .setWidth(UnitValue.createPercentValue(100));
            
            // En-têtes
            table.addHeaderCell(creerCelluleEntete("Poste"));
            table.addHeaderCell(creerCelluleEntete("Nombre"));
            
            // Données
            for (Map.Entry<String, Integer> entry : data.entrySet()) {
                table.addCell(new Cell().add(new Paragraph(entry.getKey())).setPadding(8));
                table.addCell(new Cell().add(new Paragraph(String.valueOf(entry.getValue())))
                        .setTextAlignment(TextAlignment.CENTER).setPadding(8));
            }
            
            document.add(table);
        } else {
            document.add(new Paragraph("Aucune donnée disponible").setItalic());
        }
        
        document.add(new Paragraph("\n"));
    }
    
    /**
     * Crée une cellule d'en-tête de tableau.
     */
    private Cell creerCelluleEntete(String texte) {
        return new Cell()
                .add(new Paragraph(texte).setBold())
                .setBackgroundColor(new DeviceRgb(99, 102, 241))
                .setFontColor(ColorConstants.WHITE)
                .setTextAlignment(TextAlignment.CENTER)
                .setPadding(10);
    }
    
    /**
     * Ajoute le pied de page.
     */
    private void ajouterPiedDePage(Document document) {
        document.add(new Paragraph("\n\n"));
        
        Paragraph footer = new Paragraph("© 2025 RowTech - Rapport généré automatiquement")
                .setFontSize(9)
                .setTextAlignment(TextAlignment.CENTER)
                .setFontColor(new DeviceRgb(100, 100, 100));
        
        document.add(footer);
    }
}