package com.rsv.model;

import jakarta.persistence.*;

/**
 * Entité représentant un utilisateur du système
 * avec son rôle et ses droits d'accès
 */
@Entity
@Table(name = "user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(name = "nom_complet", length = 100)
    private String nomComplet;

    @Column(nullable = false, length = 50)
    private String role; // ADMINISTRATEUR, CHEF_DEPARTEMENT, CHEF_PROJET, EMPLOYE

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "employe_id")
    private Employe employe;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "departement_id")
    private Departement departement;

    // Constructeurs
    public User() {
    }

    public User(String username, String password, String nomComplet, String role) {
        this.username = username;
        this.password = password;
        this.nomComplet = nomComplet;
        this.role = role;
    }

    // Getters et Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNomComplet() {
        return nomComplet;
    }

    public void setNomComplet(String nomComplet) {
        this.nomComplet = nomComplet;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Employe getEmploye() {
        return employe;
    }

    public void setEmploye(Employe employe) {
        this.employe = employe;
    }

    public Departement getDepartement() {
        return departement;
    }

    public void setDepartement(Departement departement) {
        this.departement = departement;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", nomComplet='" + nomComplet + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}