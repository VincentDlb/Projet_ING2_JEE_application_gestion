package com.rsv.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

/**
 * Entité représentant un employé
 */
@Entity
@Table(name = "employe")
public class Employe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 50)
    private String nom;

    @Column(nullable = false, length = 50)
    private String prenom;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Column(length = 20)
    private String telephone;

    @Column(length = 200)
    private String adresse;

    @Column(nullable = false, unique = true, length = 20)
    private String matricule;

    @Column(nullable = false, length = 50)
    private String poste;

    @Column(nullable = false, length = 20)
    private String grade;

    @Column(nullable = false)
    private Double salaire;

    @Column(name = "date_embauche", nullable = false)
    private LocalDate dateEmbauche;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "departement_id")
    private Departement departement;

    @ManyToMany(mappedBy = "employes", fetch = FetchType.LAZY)
    private List<Projet> projets;

    // Constructeurs
    public Employe() {
    }

    public Employe(String nom, String prenom, String email, String matricule, String poste, String grade, Double salaire, LocalDate dateEmbauche) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.matricule = matricule;
        this.poste = poste;
        this.grade = grade;
        this.salaire = salaire;
        this.dateEmbauche = dateEmbauche;
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

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getPoste() {
        return poste;
    }

    public void setPoste(String poste) {
        this.poste = poste;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public Double getSalaire() {
        return salaire;
    }

    public void setSalaire(Double salaire) {
        this.salaire = salaire;
    }

    public LocalDate getDateEmbauche() {
        return dateEmbauche;
    }

    public void setDateEmbauche(LocalDate dateEmbauche) {
        this.dateEmbauche = dateEmbauche;
    }

    public Departement getDepartement() {
        return departement;
    }

    public void setDepartement(Departement departement) {
        this.departement = departement;
    }

    public List<Projet> getProjets() {
        return projets;
    }

    public void setProjets(List<Projet> projets) {
        this.projets = projets;
    }

    @Override
    public String toString() {
        return "Employe{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", email='" + email + '\'' +
                ", matricule='" + matricule + '\'' +
                ", poste='" + poste + '\'' +
                ", grade='" + grade + '\'' +
                ", salaire=" + salaire +
                ", dateEmbauche=" + dateEmbauche +
                '}';
    }
}