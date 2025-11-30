package com.rsv.model;

import java.util.List;
import java.util.Objects;

public class Departement {
	private int id;
	private List<Employe> equipeListe;
	private String nom;
	private String adresse;
	private int taille;
	private String presentation;
	private String role;

	public Departement(int id, List<Employe> equipeListe, String nom, String adresse, int taille, String presentation,
			String role) {
		super();
		this.id = id;
		this.equipeListe = equipeListe;
		this.nom = nom;
		this.adresse = adresse;
		this.taille = taille;
		this.presentation = presentation;
		this.role = role;
	}
	
	public List<Employe> getEquipeListe() {
		return equipeListe;
	}
	
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id= id;
	}

	public void setEquipeListe(List<Employe> equipeListe) {
		this.equipeListe = equipeListe;
	}

	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}

	public String getAdresse() {
		return adresse;
	}

	public void setAdresse(String adresse) {
		this.adresse = adresse;
	}

	public int getTaille() {
		return taille;
	}

	public void setTaille(int taille) {
		this.taille = taille;
	}

	public String getPresentation() {
		return presentation;
	}

	public void setPresentation(String presentation) {
		this.presentation = presentation;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}
	
	@Override
	public int hashCode() {
		return Objects.hash(id,adresse, equipeListe, nom, presentation, role, taille);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Departement other = (Departement) obj;
		return Objects.equals(id, other.id) && Objects.equals(adresse, other.adresse) && Objects.equals(equipeListe, other.equipeListe)
				&& Objects.equals(nom, other.nom) && Objects.equals(presentation, other.presentation)
				&& Objects.equals(role, other.role) && taille == other.taille;
	}

	@Override
	public String toString() {
		return "Departement [id=" + id +"equipeListe=" + equipeListe + ", nom=" + nom + ", adresse=" + adresse + ", taille="
				+ taille + ", presentation=" + presentation + ", role=" + role + "]";
	}

}
