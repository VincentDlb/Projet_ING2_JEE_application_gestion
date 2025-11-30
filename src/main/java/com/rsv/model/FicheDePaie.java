package com.rsv.model;

import java.util.Objects;

public class FicheDePaie {
	private int id;
	private int employeId; // Référence à l'employé
	private Employe employe; // Objet employé (pour affichage)
	private int mois; // 1-12
	private int annee; // ex: 2025
	private float salaireBrut;
	private float bonus;
	private float deduction;
	private long numeroFiscal;
	private boolean statutCadre;
	private float heureSupp;
	private float tauxHoraire;
	private float heureSemaine;
	private float heureDansLeMois;
	private float heureAbsences;

	// Constructeur complet avec ID (pour récupération depuis BD)
	public FicheDePaie(int id, int employeId, int mois, int annee, float salaireBrut, float bonus, float deduction,
			long numeroFiscal, boolean statutCadre, float heureSupp, float tauxHoraire, float heureSemaine,
			float heureDansLeMois, float heureAbsences) {
		this.id = id;
		this.employeId = employeId;
		this.mois = mois;
		this.annee = annee;
		this.salaireBrut = salaireBrut;
		this.bonus = bonus;
		this.deduction = deduction;
		this.numeroFiscal = numeroFiscal;
		this.statutCadre = statutCadre;
		this.heureSupp = heureSupp;
		this.tauxHoraire = tauxHoraire;
		this.heureSemaine = heureSemaine;
		this.heureDansLeMois = heureDansLeMois;
		this.heureAbsences = heureAbsences;
	}

	// Constructeur sans ID (pour création)
	public FicheDePaie(int employeId, int mois, int annee, float salaireBrut, float bonus, float deduction,
			long numeroFiscal, boolean statutCadre, float heureSupp, float tauxHoraire, float heureSemaine,
			float heureDansLeMois, float heureAbsences) {
		this(0, employeId, mois, annee, salaireBrut, bonus, deduction, numeroFiscal, statutCadre, heureSupp,
				tauxHoraire, heureSemaine, heureDansLeMois, heureAbsences);
	}

	// Ancien constructeur pour compatibilité (conservé pour ne pas casser le code existant)
	public FicheDePaie(Employe employe, float salaireBrut, float bonus, float deduction, long numeroFiscal,
			boolean statutCadre, float heureSupp, float tauxHoraire, float heureSemaine, float heureDansLeMois,
			float heureAbsences) {
		this(0, employe != null ? employe.getId() : 0, 1, 2025, salaireBrut, bonus, deduction, numeroFiscal,
				statutCadre, heureSupp, tauxHoraire, heureSemaine, heureDansLeMois, heureAbsences);
		this.employe = employe;
	}

	// Méthode de calcul du salaire net : net = brut + bonus - deduction
	public float calculerSalaireNet() {
		return salaireBrut + bonus - deduction;
	}

	// Getters et Setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getEmployeId() {
		return employeId;
	}

	public void setEmployeId(int employeId) {
		this.employeId = employeId;
	}

	public Employe getEmploye() {
		return employe;
	}

	public void setEmploye(Employe employe) {
		this.employe = employe;
		if (employe != null) {
			this.employeId = employe.getId();
		}
	}

	public int getMois() {
		return mois;
	}

	public void setMois(int mois) {
		this.mois = mois;
	}

	public int getAnnee() {
		return annee;
	}

	public void setAnnee(int annee) {
		this.annee = annee;
	}

	public float getSalaireBrut() {
		return salaireBrut;
	}

	public void setSalaireBrut(float salaireBrut) {
		this.salaireBrut = salaireBrut;
	}

	public float getBonus() {
		return bonus;
	}

	public void setBonus(float bonus) {
		this.bonus = bonus;
	}

	public float getDeduction() {
		return deduction;
	}

	public void setDeduction(float deduction) {
		this.deduction = deduction;
	}

	public long getNumeroFiscal() {
		return numeroFiscal;
	}

	public void setNumeroFiscal(long numeroFiscal) {
		this.numeroFiscal = numeroFiscal;
	}

	public boolean isStatutCadre() {
		return statutCadre;
	}

	public void setStatutCadre(boolean statutCadre) {
		this.statutCadre = statutCadre;
	}

	public float getHeureSupp() {
		return heureSupp;
	}

	public void setHeureSupp(float heureSupp) {
		this.heureSupp = heureSupp;
	}

	public float getTauxHoraire() {
		return tauxHoraire;
	}

	public void setTauxHoraire(float tauxHoraire) {
		this.tauxHoraire = tauxHoraire;
	}

	public float getHeureSemaine() {
		return heureSemaine;
	}

	public void setHeureSemaine(float heureSemaine) {
		this.heureSemaine = heureSemaine;
	}

	public float getHeureDansLeMois() {
		return heureDansLeMois;
	}

	public void setHeureDansLeMois(float heureDansLeMois) {
		this.heureDansLeMois = heureDansLeMois;
	}

	public float getHeureAbsences() {
		return heureAbsences;
	}

	public void setHeureAbsences(float heureAbsences) {
		this.heureAbsences = heureAbsences;
	}

	@Override
	public int hashCode() {
		return Objects.hash(annee, bonus, deduction, employeId, heureAbsences, heureDansLeMois, heureSemaine,
				heureSupp, id, mois, numeroFiscal, salaireBrut, statutCadre, tauxHoraire);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		FicheDePaie other = (FicheDePaie) obj;
		return annee == other.annee && Float.floatToIntBits(bonus) == Float.floatToIntBits(other.bonus)
				&& Float.floatToIntBits(deduction) == Float.floatToIntBits(other.deduction)
				&& employeId == other.employeId
				&& Float.floatToIntBits(heureAbsences) == Float.floatToIntBits(other.heureAbsences)
				&& Float.floatToIntBits(heureDansLeMois) == Float.floatToIntBits(other.heureDansLeMois)
				&& Float.floatToIntBits(heureSemaine) == Float.floatToIntBits(other.heureSemaine)
				&& Float.floatToIntBits(heureSupp) == Float.floatToIntBits(other.heureSupp) && id == other.id
				&& mois == other.mois && numeroFiscal == other.numeroFiscal
				&& Float.floatToIntBits(salaireBrut) == Float.floatToIntBits(other.salaireBrut)
				&& statutCadre == other.statutCadre
				&& Float.floatToIntBits(tauxHoraire) == Float.floatToIntBits(other.tauxHoraire);
	}

	@Override
	public String toString() {
		return "FicheDePaie [id=" + id + ", employeId=" + employeId + ", mois=" + mois + ", annee=" + annee
				+ ", salaireBrut=" + salaireBrut + ", bonus=" + bonus + ", deduction=" + deduction + ", numeroFiscal="
				+ numeroFiscal + ", statutCadre=" + statutCadre + ", heureSupp=" + heureSupp + ", tauxHoraire="
				+ tauxHoraire + ", heureSemaine=" + heureSemaine + ", heureDansLeMois=" + heureDansLeMois
				+ ", heureAbsences=" + heureAbsences + ", salaireNet=" + calculerSalaireNet() + "]";
	}

	// Méthode utilitaire pour obtenir le nom du mois
	public String getNomMois() {
		String[] nomsMois = { "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre",
				"Octobre", "Novembre", "Décembre" };
		if (mois >= 1 && mois <= 12) {
			return nomsMois[mois - 1];
		}
		return "Mois inconnu";
	}
}
