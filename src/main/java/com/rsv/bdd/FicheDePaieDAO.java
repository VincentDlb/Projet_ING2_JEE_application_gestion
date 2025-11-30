package com.rsv.bdd;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.rsv.model.Employe;
import com.rsv.model.FicheDePaie;

public class FicheDePaieDAO {

	// CREATE : Ajouter une nouvelle fiche de paie
	public static int ajouter(FicheDePaie fiche) throws SQLException {
		String sql = "INSERT INTO fichedepaie (employeId, mois, annee, salaireBrut, bonus, deduction, numeroFiscal, "
				+ "statutCadre, heureSupp, tauxHoraire, heureSemaine, heureDansLeMois, heureAbsences) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try (Connection c = DBUtil.getConnection();
				PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, fiche.getEmployeId());
			ps.setInt(2, fiche.getMois());
			ps.setInt(3, fiche.getAnnee());
			ps.setFloat(4, fiche.getSalaireBrut());
			ps.setFloat(5, fiche.getBonus());
			ps.setFloat(6, fiche.getDeduction());
			ps.setLong(7, fiche.getNumeroFiscal());
			ps.setBoolean(8, fiche.isStatutCadre());
			ps.setFloat(9, fiche.getHeureSupp());
			ps.setFloat(10, fiche.getTauxHoraire());
			ps.setFloat(11, fiche.getHeureSemaine());
			ps.setFloat(12, fiche.getHeureDansLeMois());
			ps.setFloat(13, fiche.getHeureAbsences());

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

	// READ : Récupérer une fiche de paie par ID
	public static FicheDePaie ficheAvecId(int id) throws SQLException {
		String sql = "SELECT * FROM fichedepaie WHERE id = ?";
		FicheDePaie fiche = null;

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, id);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					fiche = construireFicheDePaie(rs);
				}
			}
		}

		return fiche;
	}

	// UPDATE : Modifier une fiche de paie existante
	public static void modifier(FicheDePaie fiche) throws SQLException {
		String sql = "UPDATE fichedepaie SET employeId = ?, mois = ?, annee = ?, salaireBrut = ?, bonus = ?, "
				+ "deduction = ?, numeroFiscal = ?, statutCadre = ?, heureSupp = ?, tauxHoraire = ?, "
				+ "heureSemaine = ?, heureDansLeMois = ?, heureAbsences = ? WHERE id = ?";

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, fiche.getEmployeId());
			ps.setInt(2, fiche.getMois());
			ps.setInt(3, fiche.getAnnee());
			ps.setFloat(4, fiche.getSalaireBrut());
			ps.setFloat(5, fiche.getBonus());
			ps.setFloat(6, fiche.getDeduction());
			ps.setLong(7, fiche.getNumeroFiscal());
			ps.setBoolean(8, fiche.isStatutCadre());
			ps.setFloat(9, fiche.getHeureSupp());
			ps.setFloat(10, fiche.getTauxHoraire());
			ps.setFloat(11, fiche.getHeureSemaine());
			ps.setFloat(12, fiche.getHeureDansLeMois());
			ps.setFloat(13, fiche.getHeureAbsences());
			ps.setInt(14, fiche.getId());

			ps.executeUpdate();
		}
	}

	// DELETE : Supprimer une fiche de paie
	public static void supprimer(int id) throws SQLException {
		String sql = "DELETE FROM fichedepaie WHERE id = ?";

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, id);
			ps.executeUpdate();
		}
	}

	// LIST ALL : Lister toutes les fiches de paie
	public static List<FicheDePaie> listerTous() throws SQLException {
		String sql = "SELECT * FROM fichedepaie ORDER BY annee DESC, mois DESC";
		List<FicheDePaie> fiches = new ArrayList<>();

		try (Connection c = DBUtil.getConnection();
				PreparedStatement ps = c.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				FicheDePaie fiche = construireFicheDePaie(rs);
				fiches.add(fiche);
			}
		}

		return fiches;
	}

	// Lister les fiches de paie d'un employé
	public static List<FicheDePaie> listerParEmploye(int employeId) throws SQLException {
		String sql = "SELECT * FROM fichedepaie WHERE employeId = ? ORDER BY annee DESC, mois DESC";
		List<FicheDePaie> fiches = new ArrayList<>();

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, employeId);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					FicheDePaie fiche = construireFicheDePaie(rs);
					fiches.add(fiche);
				}
			}
		}

		return fiches;
	}

	// Lister les fiches de paie par période
	public static List<FicheDePaie> listerParPeriode(int mois, int annee) throws SQLException {
		String sql = "SELECT * FROM fichedepaie WHERE mois = ? AND annee = ? ORDER BY employeId";
		List<FicheDePaie> fiches = new ArrayList<>();

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, mois);
			ps.setInt(2, annee);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					FicheDePaie fiche = construireFicheDePaie(rs);
					fiches.add(fiche);
				}
			}
		}

		return fiches;
	}

	// Rechercher une fiche de paie pour un employé à une période donnée
	public static FicheDePaie rechercherParEmployeEtPeriode(int employeId, int mois, int annee) throws SQLException {
		String sql = "SELECT * FROM fichedepaie WHERE employeId = ? AND mois = ? AND annee = ?";
		FicheDePaie fiche = null;

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, employeId);
			ps.setInt(2, mois);
			ps.setInt(3, annee);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					fiche = construireFicheDePaie(rs);
				}
			}
		}

		return fiche;
	}

	// Rechercher les fiches de paie par année
	public static List<FicheDePaie> listerParAnnee(int annee) throws SQLException {
		String sql = "SELECT * FROM fichedepaie WHERE annee = ? ORDER BY mois DESC, employeId";
		List<FicheDePaie> fiches = new ArrayList<>();

		try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, annee);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					FicheDePaie fiche = construireFicheDePaie(rs);
					fiches.add(fiche);
				}
			}
		}

		return fiches;
	}

	// Méthode utilitaire pour construire un objet FicheDePaie depuis un ResultSet
	private static FicheDePaie construireFicheDePaie(ResultSet rs) throws SQLException {
		FicheDePaie fiche = new FicheDePaie(
			rs.getInt("id"),
			rs.getInt("employeId"),
			rs.getInt("mois"),
			rs.getInt("annee"),
			rs.getFloat("salaireBrut"),
			rs.getFloat("bonus"),
			rs.getFloat("deduction"),
			rs.getLong("numeroFiscal"),
			rs.getBoolean("statutCadre"),
			rs.getFloat("heureSupp"),
			rs.getFloat("tauxHoraire"),
			rs.getFloat("heureSemaine"),
			rs.getFloat("heureDansLeMois"),
			rs.getFloat("heureAbsences")
		);

		// Charger les informations de l'employé
		try {
			Employe employe = EmployeDAO.employeAvecId(fiche.getEmployeId());
			fiche.setEmploye(employe);
		} catch (SQLException e) {
			// Si l'employé n'est pas trouvé, on laisse null
			e.printStackTrace();
		}

		return fiche;
	}
}
