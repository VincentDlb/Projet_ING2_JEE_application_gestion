package com.rsv.bdd;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.rsv.model.Role;
import com.rsv.model.User;

public class UserDAO {

	// CREATE : Ajouter un nouvel utilisateur
	public static int ajouter(User user) throws SQLException {
		String sql = "INSERT INTO user (username, passwordHash, role, employeId, actif) VALUES (?, ?, ?, ?, ?)";

		try (Connection c = DBUtil.getConnection();
				PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setString(1, user.getUsername());
			ps.setString(2, user.getPasswordHash());
			ps.setString(3, user.getRole().name());
			if (user.getEmployeId() != null) {
				ps.setInt(4, user.getEmployeId());
			} else {
				ps.setNull(4, java.sql.Types.INTEGER);
			}
			ps.setBoolean(5, user.isActif());

			int affectedRows = ps.executeUpdate();

			if (affectedRows > 0) {
				try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
					if (generatedKeys.next()) {
						return generatedKeys.getInt(1);
					}
				}
			}
		}
		return 0;
	}

	// READ : Récupérer un utilisateur par ID
	public static User userAvecId(int id) throws SQLException {
		String sql = "SELECT * FROM user WHERE id = ?";
		User user = null;

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, id);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					user = construireUser(rs);
				}
			}
		}

		return user;
	}

	// READ : Récupérer un utilisateur par username
	public static User userAvecUsername(String username) throws SQLException {
		String sql = "SELECT * FROM user WHERE username = ?";
		User user = null;

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, username);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					user = construireUser(rs);
				}
			}
		}

		return user;
	}

	// UPDATE : Modifier un utilisateur existant
	public static void modifier(User user) throws SQLException {
		String sql = "UPDATE user SET username = ?, passwordHash = ?, role = ?, employeId = ?, actif = ? WHERE id = ?";

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, user.getUsername());
			ps.setString(2, user.getPasswordHash());
			ps.setString(3, user.getRole().name());
			if (user.getEmployeId() != null) {
				ps.setInt(4, user.getEmployeId());
			} else {
				ps.setNull(4, java.sql.Types.INTEGER);
			}
			ps.setBoolean(5, user.isActif());
			ps.setInt(6, user.getId());

			ps.executeUpdate();
		}
	}

	// DELETE : Supprimer un utilisateur
	public static void supprimer(int id) throws SQLException {
		String sql = "DELETE FROM user WHERE id = ?";

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, id);
			ps.executeUpdate();
		}
	}

	// LIST ALL : Lister tous les utilisateurs
	public static List<User> listerTous() throws SQLException {
		String sql = "SELECT * FROM user ORDER BY username";
		List<User> users = new ArrayList<>();

		try (Connection c = DBUtil.getConnection();
				PreparedStatement ps = c.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				User user = construireUser(rs);
				users.add(user);
			}
		}

		return users;
	}

	// Authentifier un utilisateur (login)
	public static User authentifier(String username, String password) throws SQLException {
		User user = userAvecUsername(username);

		if (user != null && user.isActif() && user.verifyPassword(password)) {
			return user;
		}

		return null; // Authentification échouée
	}

	// Vérifier si un username existe déjà
	public static boolean usernameExiste(String username) throws SQLException {
		String sql = "SELECT COUNT(*) FROM user WHERE username = ?";

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, username);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1) > 0;
				}
			}
		}

		return false;
	}

	// Lister les utilisateurs par rôle
	public static List<User> listerParRole(Role role) throws SQLException {
		String sql = "SELECT * FROM user WHERE role = ? ORDER BY username";
		List<User> users = new ArrayList<>();

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, role.name());

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					User user = construireUser(rs);
					users.add(user);
				}
			}
		}

		return users;
	}

	// Changer le mot de passe d'un utilisateur
	public static void changerMotDePasse(int userId, String nouveauMotDePasse) throws SQLException {
		String sql = "UPDATE user SET passwordHash = ? WHERE id = ?";

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, User.hashPassword(nouveauMotDePasse));
			ps.setInt(2, userId);
			ps.executeUpdate();
		}
	}

	// Activer/Désactiver un utilisateur
	public static void toggleActif(int userId) throws SQLException {
		String sql = "UPDATE user SET actif = NOT actif WHERE id = ?";

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.executeUpdate();
		}
	}

	// Méthode utilitaire pour construire un objet User depuis un ResultSet
	private static User construireUser(ResultSet rs) throws SQLException {
		return new User(rs.getInt("id"), rs.getString("username"), rs.getString("passwordHash"),
				Role.fromString(rs.getString("role")),
				rs.getObject("employeId") != null ? rs.getInt("employeId") : null, rs.getBoolean("actif"));
	}
}
