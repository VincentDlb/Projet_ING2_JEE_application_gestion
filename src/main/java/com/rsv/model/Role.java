package com.rsv.model;

/**
 * Énumération des rôles disponibles dans l'application
 * - ADMIN : Accès complet à toutes les fonctionnalités
 * - CHEF_DEPARTEMENT : Gestion de son département
 * - CHEF_PROJET : Gestion de ses projets
 * - EMPLOYE : Accès limité en lecture
 */
public enum Role {
	ADMIN("Administrateur", "Accès complet à toutes les fonctionnalités"),
	CHEF_DEPARTEMENT("Chef de Département", "Gestion de son département et de ses employés"),
	CHEF_PROJET("Chef de Projet", "Gestion de ses projets et de son équipe"),
	EMPLOYE("Employé", "Consultation de ses propres informations");

	private final String libelle;
	private final String description;

	Role(String libelle, String description) {
		this.libelle = libelle;
		this.description = description;
	}

	public String getLibelle() {
		return libelle;
	}

	public String getDescription() {
		return description;
	}

	// Méthode pour obtenir un Role depuis une string
	public static Role fromString(String roleStr) {
		if (roleStr == null) {
			return EMPLOYE; // Par défaut
		}
		try {
			return Role.valueOf(roleStr.toUpperCase());
		} catch (IllegalArgumentException e) {
			return EMPLOYE; // Par défaut si invalide
		}
	}
}
