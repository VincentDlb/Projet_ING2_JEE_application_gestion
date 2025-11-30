package com.rsv.model;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

public class Projet {
	private Integer id;
	private String nom;
	private Employe chefDeProjet;
	private LocalDate echeance;
	private Departement domaine;
	private String état;
	private List<Employe> equipe;
	private int retard;
	
	public Projet(Integer id, String nom, Employe chefDeProjet, LocalDate echeance, Departement domaine, String état,
			List<Employe> equipe, int retard) {
		super();
		this.id = id;
		this.nom = nom;
		this.chefDeProjet = chefDeProjet;
		this.echeance = echeance;
		this.domaine = domaine;
		this.état = état;
		this.equipe = equipe;
		this.retard = retard;
	}
	
	public String getNom() {
		return nom;
	}
	public Integer getId() {
		return id;
	}
	public int getRetard() {
		return retard;
	}
	
	public void setRetard(int retard) {
		this.retard = retard;
	}
	
	public void setId(int id) {
		this.id= id;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}

	public Employe getChefDeProjet() {
		return chefDeProjet;
	}

	public void setChefDeProjet(Employe chefDeProjet) {
		this.chefDeProjet = chefDeProjet;
	}

	public LocalDate getEcheance() {
		return echeance;
	}

	public void setEcheance(LocalDate echeance) {
		this.echeance = echeance;
	}

	public Departement getDomaine() {
		return domaine;
	}

	public void setDomaine(Departement domaine) {
		this.domaine = domaine;
	}

	public String getÉtat() {
		return état;
	}

	public void setÉtat(String état) {
		this.état = état;
	}

	public List<Employe> getEquipe() {
		return equipe;
	}

	public void setEquipe(List<Employe> equipe) {
		this.equipe = equipe;
	}
	@Override
	public int hashCode() {
		return Objects.hash(chefDeProjet, domaine, echeance, equipe, nom, état);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Projet other = (Projet) obj;
		return Objects.equals(chefDeProjet, other.chefDeProjet) && Objects.equals(domaine, other.domaine)
				&& Objects.equals(echeance, other.echeance) && Objects.equals(equipe, other.equipe)
				&& Objects.equals(nom, other.nom) && Objects.equals(état, other.état) && Objects.equals(id,other.id) &&Objects.equals(retard, other.retard);
	}
	@Override
	public String toString() {
		return "Projet [id="+ id + "nom=" + nom + ", chefDeProjet=" + chefDeProjet + ", echeance=" + echeance + ", domaine="
				+ domaine + ", état=" + état + ", equipe=" + equipe + ", retard=" + retard +"]";
	}
}

