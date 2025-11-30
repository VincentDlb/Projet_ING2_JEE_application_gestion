package com.rsv.model;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

/**
 * Entité représentant un département.
 * Version 2.0 avec chef de département.
 * 
 * @author RowTech Team
 * @version 2.0
 */
@Entity
@Table(name = "departement")
public class Departement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(columnDefinition = "TEXT")
    private String description;

    // NOUVEAU : Chef de département
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "chef_departement_id")
    private Employe chefDepartement;

    @OneToMany(mappedBy = "departement", fetch = FetchType.LAZY)
    private Set<Employe> employes = new HashSet<>();

    // Constructeurs
    public Departement() {
        this.employes = new HashSet<>();
    }

    public Departement(String nom, String description) {
        this.nom = nom;
        this.description = description;
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

    /**
     * Récupère le chef de département (NOUVEAU).
     * @return Le chef de département ou null si aucun chef n'est désigné
     */
    public Employe getChefDepartement() {
        return chefDepartement;
    }

    /**
     * Définit le chef de département (NOUVEAU).
     * @param chefDepartement L'employé à désigner comme chef
     */
    public void setChefDepartement(Employe chefDepartement) {
        this.chefDepartement = chefDepartement;
    }

    public Set<Employe> getEmployes() {
        return employes != null ? employes : new HashSet<>();
    }

    public void setEmployes(Set<Employe> employes) {
        this.employes = employes;
    }

    @Override
    public String toString() {
        return "Departement{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", description='" + description + '\'' +
                ", chef=" + (chefDepartement != null ? chefDepartement.getNom() + " " + chefDepartement.getPrenom() : "Aucun") +
                '}';
    }
}