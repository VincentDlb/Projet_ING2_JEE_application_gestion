package com.rsv.bdd;
import com.rsv.model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeDAO {
	
	public static List<Employe> listerTous() throws SQLException {
	    List<Employe> liste = new ArrayList<>();

	    String sql = "SELECT * FROM employe";
	    try (Connection c = DBUtil.getConnection();
	         Statement st = c.createStatement();
	         ResultSet rs = st.executeQuery(sql)) {

	        while (rs.next()) {
	            Employe e = new Employe(
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
	            liste.add(e);
	        }
	    }

	    return liste;
	}
	
	
	public void ajouter(Employe e) throws SQLException {
        String sql = "INSERT INTO employe (nom, prenom, age, adresse, typeContrat, anciennete, grade, poste, matricule, statutCadre) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        	ps.setString(1, e.getNom());
            ps.setString(2, e.getPrenom());
            ps.setInt(3, e.getAge());
            ps.setString(4, e.getAdresse());
            ps.setString(5, e.getTypeContrat());
            ps.setInt(6, e.getAnciennete());
            ps.setString(7, e.getGrade());
            ps.setString(8, e.getPoste());
            ps.setInt(9, e.getMatricule());
            ps.setBoolean(10, e.isStatutCadre());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) e.setId(rs.getInt(1));
            }
        }
    }
	
	public void supprimer(int id) throws SQLException {
	    String sql = "DELETE FROM employe WHERE id = ?";
	    try (Connection c = DBUtil.getConnection();
	         PreparedStatement ps = c.prepareStatement(sql)) {
	        ps.setInt(1, id);
	        ps.executeUpdate();
	    }
	}
	
	public static Employe employeAvecId(int id) throws SQLException {
	    String sql = "SELECT * FROM employe WHERE id = ?";
	    Employe e = null;

	    try (Connection c = DBUtil.getConnection();
	         PreparedStatement ps = c.prepareStatement(sql)) {

	        ps.setInt(1, id);
	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                e = new Employe(
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
	            }
	        }
	    }

	    return e;
	}
	
	public void modifier(Employe e) throws SQLException {
	    String sql = "UPDATE employe SET nom = ?, prenom = ?, age = ?, adresse = ?, typeContrat = ?, anciennete = ?, grade = ?, poste = ?, matricule = ?, statutCadre = ? WHERE id = ?";
	    
	    try (Connection c = DBUtil.getConnection();
	         PreparedStatement ps = c.prepareStatement(sql)) {
	        
	        ps.setString(1, e.getNom());
	        ps.setString(2, e.getPrenom());
	        ps.setInt(3, e.getAge());
	        ps.setString(4, e.getAdresse());
	        ps.setString(5, e.getTypeContrat());
	        ps.setInt(6, e.getAnciennete());
	        ps.setString(7, e.getGrade());
	        ps.setString(8, e.getPoste());
	        ps.setInt(9, e.getMatricule());
	        ps.setBoolean(10, e.isStatutCadre());
	        ps.setInt(11, e.getId());

	        ps.executeUpdate();
	    }
	}
	
	public List<Employe> rechercherEmployes(String nom, String prenom, String matricule, String grade, String poste) throws SQLException {
	    List<Employe> employes = new ArrayList<>();
	    Connection c = DBUtil.getConnection();
	    StringBuilder sql = new StringBuilder("SELECT * FROM employe WHERE 1=1");

	    if (nom != null && !nom.isEmpty()) {
	        sql.append(" AND nom LIKE ?");
	    }
	    if (prenom != null && !prenom.isEmpty()) {
	        sql.append(" AND prenom LIKE ?");
	    }
	    if (matricule != null && !matricule.isEmpty()) {
	        sql.append(" AND matricule LIKE ?");
	    }
	    if (grade != null && !grade.isEmpty()) {
	        sql.append(" AND grade LIKE ?");
	    }
	    if (poste != null && !poste.isEmpty()) {
	        sql.append(" AND poste LIKE ?");
	    }

	    try (PreparedStatement stmt = c.prepareStatement(sql.toString())) {
	        int index = 1;
	        if (nom != null && !nom.isEmpty()) {
	            stmt.setString(index++, "%" + nom + "%");
	        }
	        if (prenom != null && !prenom.isEmpty()) {
	            stmt.setString(index++, "%" + prenom + "%");
	        }
	        if (matricule != null && !matricule.isEmpty()) {
	            stmt.setString(index++, "%" + matricule + "%");
	        }
	        if (grade != null && !grade.isEmpty()) {
	            stmt.setString(index++, "%" + grade + "%");
	        }
	        if (poste != null && !poste.isEmpty()) {
	            stmt.setString(index++, "%" + poste + "%");
	        }

	        ResultSet rs = stmt.executeQuery();
	        while (rs.next()) {
	        	Employe e = new Employe(
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
	        	employes.add(e);
	        }
	    }

	    return employes;
	}
	
	
}
