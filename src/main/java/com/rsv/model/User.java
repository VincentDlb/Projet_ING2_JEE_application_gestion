package com.rsv.model;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Objects;

/**
 * Entité User pour l'authentification et l'autorisation
 */
public class User {
	private int id;
	private String username;
	private String passwordHash; // Mot de passe hashé (SHA-256)
	private Role role;
	private Integer employeId; // Référence optionnelle vers un employé
	private boolean actif;

	// Constructeur complet
	public User(int id, String username, String passwordHash, Role role, Integer employeId, boolean actif) {
		this.id = id;
		this.username = username;
		this.passwordHash = passwordHash;
		this.role = role;
		this.employeId = employeId;
		this.actif = actif;
	}

	// Constructeur sans ID (pour création)
	public User(String username, String passwordHash, Role role, Integer employeId, boolean actif) {
		this(0, username, passwordHash, role, employeId, actif);
	}

	// Constructeur minimal
	public User(String username, String passwordHash, Role role) {
		this(0, username, passwordHash, role, null, true);
	}

	// Méthode statique pour hasher un mot de passe
	public static String hashPassword(String password) {
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(password.getBytes());
			StringBuilder hexString = new StringBuilder();
			for (byte b : hash) {
				String hex = Integer.toHexString(0xff & b);
				if (hex.length() == 1)
					hexString.append('0');
				hexString.append(hex);
			}
			return hexString.toString();
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("Erreur lors du hashage du mot de passe", e);
		}
	}

	// Méthode pour vérifier un mot de passe
	public boolean verifyPassword(String password) {
		return this.passwordHash.equals(hashPassword(password));
	}

	// Getters et Setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPasswordHash() {
		return passwordHash;
	}

	public void setPasswordHash(String passwordHash) {
		this.passwordHash = passwordHash;
	}

	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	public Integer getEmployeId() {
		return employeId;
	}

	public void setEmployeId(Integer employeId) {
		this.employeId = employeId;
	}

	public boolean isActif() {
		return actif;
	}

	public void setActif(boolean actif) {
		this.actif = actif;
	}

	// Méthodes de vérification de rôle
	public boolean isAdmin() {
		return role == Role.ADMIN;
	}

	public boolean isChefDepartement() {
		return role == Role.CHEF_DEPARTEMENT || role == Role.ADMIN;
	}

	public boolean isChefProjet() {
		return role == Role.CHEF_PROJET || role == Role.ADMIN;
	}

	public boolean hasRole(Role... roles) {
		for (Role r : roles) {
			if (this.role == r || this.role == Role.ADMIN) {
				return true;
			}
		}
		return false;
	}

	@Override
	public int hashCode() {
		return Objects.hash(actif, employeId, id, role, username);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		User other = (User) obj;
		return actif == other.actif && Objects.equals(employeId, other.employeId) && id == other.id
				&& role == other.role && Objects.equals(username, other.username);
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", username=" + username + ", role=" + role + ", employeId=" + employeId + ", actif="
				+ actif + "]";
	}
}
