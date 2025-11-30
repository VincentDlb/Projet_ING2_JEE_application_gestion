package com.rsv.bdd;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.rsv.model.Departement;
import com.rsv.model.Employe;

public class DepartementDAO {

		public static Departement departementAvecId(int id) throws SQLException {
		    String sql = "SELECT * FROM Departement WHERE id = ?";
		    Departement e = null;

		    try (Connection c = DBUtil.getConnection();
		         PreparedStatement ps = c.prepareStatement(sql)) {
		        ps.setInt(1, id);
		        
		        Employe employe = new Employe(0,"","",0,"","",0,"","",0,true);
		        List <Employe> list = new ArrayList<Employe>();
		        list.add(employe);
		        
		        try (ResultSet rs = ps.executeQuery()) {
		            if (rs.next()) {
		                e = new Departement(
		                    id,
		                    list,
		                    rs.getString("nom"),
		                    rs.getString("adresse"),
		                    rs.getInt("taille"),
		                    rs.getString("presentation"),
		                    rs.getString("role")


		                );
		            }
		        }
		    }

		    return e;
		}

		// CREATE : Ajouter un nouveau département
		public static void ajouter(Departement departement) throws SQLException {
		    String sql = "INSERT INTO Departement (nom, adresse, taille, presentation, role) VALUES (?, ?, ?, ?, ?)";

		    try (Connection c = DBUtil.getConnection();
		         PreparedStatement ps = c.prepareStatement(sql)) {
		        ps.setString(1, departement.getNom());
		        ps.setString(2, departement.getAdresse());
		        ps.setInt(3, departement.getTaille());
		        ps.setString(4, departement.getPresentation());
		        ps.setString(5, departement.getRole());

		        ps.executeUpdate();
		    }
		}

		// UPDATE : Modifier un département existant
		public static void modifier(Departement departement) throws SQLException {
		    String sql = "UPDATE Departement SET nom = ?, adresse = ?, taille = ?, presentation = ?, role = ? WHERE id = ?";

		    try (Connection c = DBUtil.getConnection();
		         PreparedStatement ps = c.prepareStatement(sql)) {
		        ps.setString(1, departement.getNom());
		        ps.setString(2, departement.getAdresse());
		        ps.setInt(3, departement.getTaille());
		        ps.setString(4, departement.getPresentation());
		        ps.setString(5, departement.getRole());
		        ps.setInt(6, departement.getId());

		        ps.executeUpdate();
		    }
		}

		// DELETE : Supprimer un département
		public static void supprimer(int id) throws SQLException {
		    String sql = "DELETE FROM Departement WHERE id = ?";

		    try (Connection c = DBUtil.getConnection();
		         PreparedStatement ps = c.prepareStatement(sql)) {
		        ps.setInt(1, id);
		        ps.executeUpdate();
		    }
		}

		// LIST ALL : Lister tous les départements
		public static List<Departement> listerTous() throws SQLException {
		    String sql = "SELECT * FROM Departement ORDER BY nom";
		    List<Departement> departements = new ArrayList<>();

		    try (Connection c = DBUtil.getConnection();
		         PreparedStatement ps = c.prepareStatement(sql);
		         ResultSet rs = ps.executeQuery()) {

		        while (rs.next()) {
		            Departement dept = new Departement(
		                rs.getInt("id"),
		                new ArrayList<>(), // Liste vide pour l'instant
		                rs.getString("nom"),
		                rs.getString("adresse"),
		                rs.getInt("taille"),
		                rs.getString("presentation"),
		                rs.getString("role")
		            );
		            departements.add(dept);
		        }
		    }

		    return departements;
		}

		// Lister les employés d'un département
		public static List<Employe> listerEmployesDuDepartement(int departementId) throws SQLException {
		    String sql = "SELECT * FROM employe WHERE departementId = ? ORDER BY nom, prenom";
		    List<Employe> employes = new ArrayList<>();

		    try (Connection c = DBUtil.getConnection();
		         PreparedStatement ps = c.prepareStatement(sql)) {
		        ps.setInt(1, departementId);

		        try (ResultSet rs = ps.executeQuery()) {
		            while (rs.next()) {
		                Employe emp = new Employe(
		                    rs.getInt("id"),
		                    rs.getString("nom"),
		                    rs.getString("prenom"),
		                    rs.getInt("age"),
		                    rs.getString("adresse"),
		                    rs.getString("typeContrat"),
		                    rs.getInt("anciennete"),
		                    rs.getString("grade"),
		                    rs.getString("poste"),
		                    rs.getInt("matricule"),
		                    rs.getBoolean("statutCadre")
		                );
		                employes.add(emp);
		            }
		        }
		    }

		    return employes;
		}

		// Rechercher des départements par nom
		public static List<Departement> rechercherParNom(String nom) throws SQLException {
		    String sql = "SELECT * FROM Departement WHERE nom LIKE ? ORDER BY nom";
		    List<Departement> departements = new ArrayList<>();

		    try (Connection c = DBUtil.getConnection();
		         PreparedStatement ps = c.prepareStatement(sql)) {
		        ps.setString(1, "%" + nom + "%");

		        try (ResultSet rs = ps.executeQuery()) {
		            while (rs.next()) {
		                Departement dept = new Departement(
		                    rs.getInt("id"),
		                    new ArrayList<>(),
		                    rs.getString("nom"),
		                    rs.getString("adresse"),
		                    rs.getInt("taille"),
		                    rs.getString("presentation"),
		                    rs.getString("role")
		                );
		                departements.add(dept);
		            }
		        }
		    }

		    return departements;
		}
}