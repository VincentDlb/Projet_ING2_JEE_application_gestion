package com.rsv.model;

import java.util.Objects;

public class Employe {
	private int id;
	private String nom;
	private String prenom;
	private int age;
	private String adresse;
	private String typeContrat;
	private int anciennete;
	private String grade;
	private String poste;
	private int matricule;
	private boolean statutCadre;
	private Integer departementId;

    public Employe(String nom, String prenom, int age, String adresse, String typeContrat,
                   int anciennete, String grade, String poste, int matricule, boolean statutCadre) {
        this.nom = nom;
        this.prenom = prenom;
        this.age = age;
        this.adresse = adresse;
        this.typeContrat = typeContrat;
        this.anciennete = anciennete;
        this.grade = grade;
        this.poste = poste;
        this.matricule = matricule;
        this.statutCadre = statutCadre;
    }

    public Employe(int id, String nom, String prenom, int age, String adresse, String typeContrat,
                   int anciennete, String grade, String poste, int matricule, boolean statutCadre) {
    	this.nom = nom;
        this.prenom = prenom;
        this.age = age;
        this.adresse = adresse;
        this.typeContrat = typeContrat;
        this.anciennete = anciennete;
        this.grade = grade;
        this.poste = poste;
        this.matricule = matricule;
        this.statutCadre = statutCadre;
        this.id = id;
    }
	
    
	public int getId() {
		return id;
	}

	public void setId(int id) {
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

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getAdresse() {
		return adresse;
	}

	public void setAdresse(String adresse) {
		this.adresse = adresse;
	}

	public String getTypeContrat() {
		return typeContrat;
	}

	public void setTypeContrat(String typeContrat) {
		this.typeContrat = typeContrat;
	}

	public int getAnciennete() {
		return anciennete;
	}

	public void setAnciennete(int anciennete) {
		this.anciennete = anciennete;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getPoste() {
		return poste;
	}

	public void setPoste(String poste) {
		this.poste = poste;
	}

	public int getMatricule() {
		return matricule;
	}

	public void setMatricule(int matricule) {
		this.matricule = matricule;
	}

	public boolean isStatutCadre() {
		return statutCadre;
	}

	public void setStatutCadre(boolean statutCadre) {
		this.statutCadre = statutCadre;
	}
	
	public Integer getDepartementId() {
    	return departementId;
    }

    public void setDepartementId(int departementId) {
		this.departementId = departementId;
	}
	
	@Override
	public int hashCode() {
		return Objects.hash(adresse, age, anciennete, grade, id, matricule, nom, poste, prenom, statutCadre,
				typeContrat);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Employe other = (Employe) obj;
		return Objects.equals(adresse, other.adresse) && age == other.age && anciennete == other.anciennete
				&& Objects.equals(grade, other.grade) && id == other.id && matricule == other.matricule
				&& Objects.equals(nom, other.nom) && Objects.equals(poste, other.poste)
				&& Objects.equals(prenom, other.prenom) && statutCadre == other.statutCadre
				&& Objects.equals(typeContrat, other.typeContrat);
	}
	
	@Override
	public String toString() {
		return "Employe [id=" + id + ", nom=" + nom + ", prenom=" + prenom + ", age=" + age + ", adresse=" + adresse
				+ ", typeContrat=" + typeContrat + ", anciennete=" + anciennete + ", grade=" + grade + ", poste="
				+ poste + ", matricule=" + matricule + ", statutCadre=" + statutCadre + "]";
	}
}
