package com.rsv.model;

import jakarta.persistence.*;

@Entity
@Table(name = "fiche_de_paie")
public class FicheDePaie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "employe_id", nullable = false)
    private Employe employe;

    @Column(name = "mois", nullable = false)
    private Integer mois;

    @Column(name = "annee", nullable = false)
    private Integer annee;

    @Column(name = "salaire_de_base", nullable = false)
    private Double salaireDeBase;

    @Column(name = "primes")
    private Double primes = 0.0;

    @Column(name = "deductions")
    private Double deductions = 0.0;
    
    @Column(name = "heures_supp")
    private Double heuresSupp = 0.0;

    @Column(name = "jours_absence")
    private Integer joursAbsence = 0;
    
    // Nouvelles colonnes pour les cotisations sociales
    @Column(name = "cotisation_secu")
    private Double cotisationSecu = 0.0;
    
    @Column(name = "cotisation_vieillesse")
    private Double cotisationVieillesse = 0.0;
    
    @Column(name = "cotisation_chomage")
    private Double cotisationChomage = 0.0;
    
    @Column(name = "cotisation_retraite")
    private Double cotisationRetraite = 0.0;
    
    @Column(name = "cotisation_csg")
    private Double cotisationCSG = 0.0;
    
    @Column(name = "cotisation_crds")
    private Double cotisationCRDS = 0.0;

    @Column(name = "net_a_payer", nullable = false)
    private Double netAPayer;

    public FicheDePaie() {
    }

    public FicheDePaie(Employe employe, Integer mois, Integer annee, Double salaireDeBase) {
        this.employe = employe;
        this.mois = mois;
        this.annee = annee;
        this.salaireDeBase = salaireDeBase;
        calculerTout();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Employe getEmploye() {
        return employe;
    }

    public void setEmploye(Employe employe) {
        this.employe = employe;
    }

    public Integer getMois() {
        return mois;
    }

    public void setMois(Integer mois) {
        this.mois = mois;
    }

    public Integer getAnnee() {
        return annee;
    }

    public void setAnnee(Integer annee) {
        this.annee = annee;
    }

    public Double getSalaireDeBase() {
        return salaireDeBase;
    }

    public void setSalaireDeBase(Double salaireDeBase) {
        this.salaireDeBase = salaireDeBase;
    }

    public Double getPrimes() {
        return primes != null ? primes : 0.0;
    }

    public void setPrimes(Double primes) {
        this.primes = primes != null ? primes : 0.0;
    }

    public Double getDeductions() {
        return deductions != null ? deductions : 0.0;
    }

    public void setDeductions(Double deductions) {
        this.deductions = deductions != null ? deductions : 0.0;
    }

    public Double getHeuresSupp() {
        return heuresSupp;
    }

    public void setHeuresSupp(Double heuresSupp) {
        this.heuresSupp = heuresSupp;
    }

    public Integer getJoursAbsence() {
        return joursAbsence;
    }

    public void setJoursAbsence(Integer joursAbsence) {
        this.joursAbsence = joursAbsence;
    }

    public Double getCotisationSecu() {
        return cotisationSecu != null ? cotisationSecu : 0.0;
    }

    public void setCotisationSecu(Double cotisationSecu) {
        this.cotisationSecu = cotisationSecu;
    }

    public Double getCotisationVieillesse() {
        return cotisationVieillesse != null ? cotisationVieillesse : 0.0;
    }

    public void setCotisationVieillesse(Double cotisationVieillesse) {
        this.cotisationVieillesse = cotisationVieillesse;
    }

    public Double getCotisationChomage() {
        return cotisationChomage != null ? cotisationChomage : 0.0;
    }

    public void setCotisationChomage(Double cotisationChomage) {
        this.cotisationChomage = cotisationChomage;
    }

    public Double getCotisationRetraite() {
        return cotisationRetraite != null ? cotisationRetraite : 0.0;
    }

    public void setCotisationRetraite(Double cotisationRetraite) {
        this.cotisationRetraite = cotisationRetraite;
    }

    public Double getCotisationCSG() {
        return cotisationCSG != null ? cotisationCSG : 0.0;
    }

    public void setCotisationCSG(Double cotisationCSG) {
        this.cotisationCSG = cotisationCSG;
    }

    public Double getCotisationCRDS() {
        return cotisationCRDS != null ? cotisationCRDS : 0.0;
    }

    public void setCotisationCRDS(Double cotisationCRDS) {
        this.cotisationCRDS = cotisationCRDS;
    }

    public Double getNetAPayer() {
        return netAPayer;
    }

    public void setNetAPayer(Double netAPayer) {
        this.netAPayer = netAPayer;
    }

    /**
     * Calcule le salaire brut
     */
    public Double getSalaireBrut() {
        double base = salaireDeBase != null ? salaireDeBase : 0.0;
        double prime = primes != null ? primes : 0.0;
        double heures = heuresSupp != null ? heuresSupp : 0.0;
        return base + prime + heures;
    }

    /**
     * Calcule le total des cotisations sociales
     */
    public Double getTotalCotisations() {
        return getCotisationSecu() + getCotisationVieillesse() + 
               getCotisationChomage() + getCotisationRetraite() + 
               getCotisationCSG() + getCotisationCRDS();
    }

    /**
     * Calcule la déduction pour absences
     */
    public Double getDeductionAbsence() {
        if (joursAbsence != null && joursAbsence > 0 && salaireDeBase != null) {
            return (salaireDeBase / 30.0) * joursAbsence;
        }
        return 0.0;
    }

    /**
     * Calcule automatiquement toutes les cotisations et le net à payer
     */
    public void calculerTout() {
        // Calcul du brut
        double salaireBrut = getSalaireBrut();
        
        // Calcul des cotisations sociales (pourcentages réalistes)
        this.cotisationSecu = salaireBrut * 0.0075;        // 0.75%
        this.cotisationVieillesse = salaireBrut * 0.1145;  // 11.45%
        this.cotisationChomage = salaireBrut * 0.024;      // 2.4%
        this.cotisationRetraite = salaireBrut * 0.0787;    // 7.87%
        this.cotisationCSG = salaireBrut * 0.092;          // 9.2%
        this.cotisationCRDS = salaireBrut * 0.005;         // 0.5%
        
        // Calcul des déductions
        double totalCotisations = getTotalCotisations();
        double deductionsSupp = deductions != null ? deductions : 0.0;
        double deductionAbsence = getDeductionAbsence();
        
        // Calcul du net à payer
        this.netAPayer = salaireBrut - totalCotisations - deductionsSupp - deductionAbsence;
        
        // S'assurer que le net ne soit jamais négatif
        if (this.netAPayer < 0) {
            this.netAPayer = 0.0;
        }
    }

    /**
     * Alias de calculerTout() pour compatibilité avec l'ancien code
     */
    public void calculerNetAPayer() {
        calculerTout();
    }

    @Override
    public String toString() {
        return "FicheDePaie{" +
                "id=" + id +
                ", mois=" + mois +
                ", annee=" + annee +
                ", netAPayer=" + netAPayer +
                '}';
    }
}