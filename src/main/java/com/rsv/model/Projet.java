package com.rsv.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

/**
 * Entité représentant un projet
 */
@Entity
@Table(name = "projet")
public class Projet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "date_debut")
    private LocalDate dateDebut;

    @Column(name = "date_fin")
    private LocalDate dateFin;

    @Column(length = 20)
    private String etat;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "chef_projet_id")
    private Employe chefDeProjet;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "employe_projet",
        joinColumns = @JoinColumn(name = "projet_id"),
        inverseJoinColumns = @JoinColumn(name = "employe_id")
    )
    private Set<Employe> employes = new HashSet<>();

    // Constructeurs
    public Projet() {
        this.etat = "EN_COURS"; // Valeur par défaut
        this.employes = new HashSet<>();
    }

    public Projet(String nom, String description, LocalDate dateDebut, LocalDate dateFin) {
        this.nom = nom;
        this.description = description;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.etat = "EN_COURS";
        this.employes = new HashSet<>();
    }

    // Getters et Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    public String getEtat() {
        return etat != null ? etat : "EN_COURS";
    }

    public void setEtat(String etat) {
        this.etat = etat;
    }

    public Employe getChefDeProjet() {
        return chefDeProjet;
    }

    public void setChefDeProjet(Employe chefDeProjet) {
        this.chefDeProjet = chefDeProjet;
    }

    public Set<Employe> getEmployes() {
        return employes != null ? employes : new HashSet<>();
    }

    public void setEmployes(Set<Employe> employes) {
        this.employes = employes;
    }

    // Méthode utilitaire pour getDateEcheance (alias de dateFin)
    public LocalDate getDateEcheance() {
        return this.dateFin;
    }

    public void setDateEcheance(LocalDate dateEcheance) {
        this.dateFin = dateEcheance;
    }

    @Override
    public String toString() {
        return "Projet{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", description='" + description + '\'' +
                ", dateDebut=" + dateDebut +
                ", dateFin=" + dateFin +
                ", etat='" + etat + '\'' +
                ", chefDeProjet=" + (chefDeProjet != null ? chefDeProjet.getNom() : "Non assigné") +
                '}';
    }
}