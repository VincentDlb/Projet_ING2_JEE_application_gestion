package com.rsv.model;

import java.util.HashMap;
import java.util.Map;

/**
 * Classe pour stocker et manipuler les statistiques globales.
 * Améliorée avec statistiques salaires, grades et postes.
 * 
 * @author RowTech Team
 * @version 2.0
 */
public class Statistiques {
    
    // Totaux de base
    private int totalEmployes;
    private int totalDepartements;
    private int totalProjets;
    private int totalFichesDePaie;
    
    // Statistiques salaires (NOUVEAU)
    private double masseSalarialeTotal;
    private double salaireMoyen;
    private double salaireMin;
    private double salaireMax;
    
    // Statistiques détaillées
    private Map<String, Integer> employesParDepartement;
    private Map<String, Integer> employesParProjet;
    private Map<String, Integer> projetsParEtat;
    private Map<String, Map<String, Integer>> employesParProjetEtGrade;
    
    // Nouvelles statistiques (NOUVEAU)
    private Map<String, Integer> employesParGrade;
    private Map<String, Integer> employesParPoste;
    
    /**
     * Constructeur par défaut.
     */
    public Statistiques() {
        this.employesParDepartement = new HashMap<>();
        this.employesParProjet = new HashMap<>();
        this.projetsParEtat = new HashMap<>();
        this.employesParProjetEtGrade = new HashMap<>();
        this.employesParGrade = new HashMap<>();
        this.employesParPoste = new HashMap<>();
    }

    // ==================== GETTERS ET SETTERS ====================
    
    public int getTotalEmployes() {
        return totalEmployes;
    }

    public void setTotalEmployes(int totalEmployes) {
        this.totalEmployes = totalEmployes;
    }

    public int getTotalDepartements() {
        return totalDepartements;
    }

    public void setTotalDepartements(int totalDepartements) {
        this.totalDepartements = totalDepartements;
    }

    public int getTotalProjets() {
        return totalProjets;
    }

    public void setTotalProjets(int totalProjets) {
        this.totalProjets = totalProjets;
    }

    public int getTotalFichesDePaie() {
        return totalFichesDePaie;
    }

    public void setTotalFichesDePaie(int totalFichesDePaie) {
        this.totalFichesDePaie = totalFichesDePaie;
    }

    // NOUVEAU : Getters/Setters salaires
    public double getMasseSalarialeTotal() {
        return masseSalarialeTotal;
    }

    public void setMasseSalarialeTotal(double masseSalarialeTotal) {
        this.masseSalarialeTotal = masseSalarialeTotal;
    }

    public double getSalaireMoyen() {
        return salaireMoyen;
    }

    public void setSalaireMoyen(double salaireMoyen) {
        this.salaireMoyen = salaireMoyen;
    }

    public double getSalaireMin() {
        return salaireMin;
    }

    public void setSalaireMin(double salaireMin) {
        this.salaireMin = salaireMin;
    }

    public double getSalaireMax() {
        return salaireMax;
    }

    public void setSalaireMax(double salaireMax) {
        this.salaireMax = salaireMax;
    }

    public Map<String, Integer> getEmployesParDepartement() {
        return employesParDepartement;
    }

    public void setEmployesParDepartement(Map<String, Integer> employesParDepartement) {
        this.employesParDepartement = employesParDepartement;
    }

    public Map<String, Integer> getEmployesParProjet() {
        return employesParProjet;
    }

    public void setEmployesParProjet(Map<String, Integer> employesParProjet) {
        this.employesParProjet = employesParProjet;
    }

    public Map<String, Integer> getProjetsParEtat() {
        return projetsParEtat;
    }

    public void setProjetsParEtat(Map<String, Integer> projetsParEtat) {
        this.projetsParEtat = projetsParEtat;
    }

    public Map<String, Map<String, Integer>> getEmployesParProjetEtGrade() {
        return employesParProjetEtGrade;
    }

    public void setEmployesParProjetEtGrade(Map<String, Map<String, Integer>> employesParProjetEtGrade) {
        this.employesParProjetEtGrade = employesParProjetEtGrade;
    }

    // NOUVEAU : Getters/Setters grades et postes
    public Map<String, Integer> getEmployesParGrade() {
        return employesParGrade;
    }

    public void setEmployesParGrade(Map<String, Integer> employesParGrade) {
        this.employesParGrade = employesParGrade;
    }

    public Map<String, Integer> getEmployesParPoste() {
        return employesParPoste;
    }

    public void setEmployesParPoste(Map<String, Integer> employesParPoste) {
        this.employesParPoste = employesParPoste;
    }

    /**
     * Ajoute une statistique pour un département.
     */
    public void ajouterEmployesParDepartement(String nomDepartement, int nombre) {
        this.employesParDepartement.put(nomDepartement, nombre);
    }

    /**
     * Ajoute une statistique pour un projet.
     */
    public void ajouterEmployesParProjet(String nomProjet, int nombre) {
        this.employesParProjet.put(nomProjet, nombre);
    }

    /**
     * Ajoute une statistique pour l'état des projets.
     */
    public void ajouterProjetsParEtat(String etat, int nombre) {
        this.projetsParEtat.put(etat, nombre);
    }

    /**
     * Ajoute une statistique détaillée (projet + grade).
     */
    public void ajouterEmployesParProjetEtGrade(String nomProjet, String grade, int nombre) {
        if (!employesParProjetEtGrade.containsKey(nomProjet)) {
            employesParProjetEtGrade.put(nomProjet, new HashMap<>());
        }
        employesParProjetEtGrade.get(nomProjet).put(grade, nombre);
    }

    /**
     * Ajoute une statistique pour un grade (NOUVEAU).
     */
    public void ajouterEmployesParGrade(String grade, int nombre) {
        this.employesParGrade.put(grade, nombre);
    }

    /**
     * Ajoute une statistique pour un poste (NOUVEAU).
     */
    public void ajouterEmployesParPoste(String poste, int nombre) {
        this.employesParPoste.put(poste, nombre);
    }

    @Override
    public String toString() {
        return "Statistiques{" +
                "totalEmployes=" + totalEmployes +
                ", totalDepartements=" + totalDepartements +
                ", totalProjets=" + totalProjets +
                ", totalFichesDePaie=" + totalFichesDePaie +
                ", masseSalariale=" + masseSalarialeTotal +
                ", salaireMoyen=" + salaireMoyen +
                '}';
    }
}