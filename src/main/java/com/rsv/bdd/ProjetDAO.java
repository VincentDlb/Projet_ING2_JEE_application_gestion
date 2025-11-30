package com.rsv.bdd;


import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.rsv.model.Departement;
import com.rsv.model.Employe;
import com.rsv.model.Projet;

public class ProjetDAO {
	
	public static boolean createProject(Projet projet) {
		
		String nom = projet.getNom();
		Employe chef = projet.getChefDeProjet();
		LocalDate echeance= projet.getEcheance();
		Departement domaine = projet.getDomaine();
		String état = projet.getÉtat();
		List<Employe> equipe = projet.getEquipe();
		int retard = projet.getRetard();
		
		Date echeanceDate = Date.valueOf(echeance);
		String equipeListe = equipe.stream()
				.map(e -> String.valueOf(e.getId()))
				.collect(Collectors.joining(","));
		
		String sql = "INSERT INTO projet (id_projet,nom,chefDeProjetId,echeance,id_domaine,etat,equipeList,retard) VALUES (?,?,?,?,?,?,?,?)";
		try(Connection conn = DBUtil.getConnection()) {
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setString(1, null);
			stmt.setString(2,nom);
			stmt.setString(3,""+chef.getId());
			stmt.setString(4,""+echeanceDate);
			stmt.setString(5,""+ domaine.getId());
			stmt.setString(6,état);
			stmt.setString(7,equipeListe);
			stmt.setString(8,""+retard);
			System.out.println(sql);
			
			int rowInserted = stmt.executeUpdate();
			
			stmt.close();
			return rowInserted>0;
		} catch (SQLException e) {
			System.out.println("Error registrating project :" +e.getMessage());
			return false;
		}
		
	}
	
	public static boolean modifyProject(int id, Projet projetModifie) {


		String sqlModify = "UPDATE Projet SET nom = ?, chefDeProjetId = ?, echeance = ?, id_domaine = ?, etat = ?, equipeList = ?, retard = ? WHERE id_projet = ?";
		try(Connection conn = DBUtil.getConnection()){
			PreparedStatement stmt = conn.prepareStatement(sqlModify);

			String equipeListe = projetModifie.getEquipe().stream()
					.map(e -> String.valueOf(e.getId()))
					.collect(Collectors.joining(","));

			stmt.setString(1, projetModifie.getNom());
			stmt.setString(2, ""+projetModifie.getChefDeProjet().getId());
			stmt.setString(3,""+ projetModifie.getEcheance());
			stmt.setString(4,""+ projetModifie.getDomaine().getId());
			stmt.setString(5, projetModifie.getÉtat());
			stmt.setString(6, equipeListe);
			stmt.setString(7,""+projetModifie.getRetard());
			stmt.setInt(8,id);
			
			stmt.executeUpdate();
			
			stmt.close();
			
			return true;
			
		}catch(SQLException e) {
			e.printStackTrace();
			return false;
		}
		
	}
	
	public static String getProjectStatus(Projet projet) {
		int idProjet = projet.getId();
		try(Connection conn = DBUtil.getConnection()){
			String sql = "SELECT etat FROM Projet WHERE id_projet = ?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setString(1,Integer.toString(idProjet));
			
			ResultSet rs = stmt.executeQuery();
			rs.next();
			String statut =rs.getString(1);
			return statut;
		}catch(SQLException e) {
			System.out.println("Error on getting project status");
			return null;
		}
	}
	
    public static Projet projetAvecId(int id) throws SQLException {
	    String sql = "SELECT * FROM Projet WHERE id_projet = ?";
	    Projet e = null;

	    try (Connection c = DBUtil.getConnection()) {
	    		PreparedStatement ps = c.prepareStatement(sql);
	    		ps.setInt(1, id);
	    		ResultSet rs = ps.executeQuery();
	            if (rs.next()) {
	            	int idChef =rs.getInt("chefDeProjetId");
	            	Employe chef = EmployeDAO.employeAvecId(idChef);
	            	int idDep = rs.getInt("id_domaine");
	            	Departement departement = DepartementDAO.departementAvecId(idDep);

	            	// Charger l'équipe réelle depuis equipeList
	            	List<Employe> equipe = new ArrayList<Employe>();
	            	String equipeListStr = rs.getString("equipeList");
	            	if (equipeListStr != null && !equipeListStr.trim().isEmpty()) {
	            		String[] ids = equipeListStr.split(",");
	            		for (String idStr : ids) {
	            			try {
	            				int empId = Integer.parseInt(idStr.trim());
	            				Employe emp = EmployeDAO.employeAvecId(empId);
	            				if (emp != null) {
	            					equipe.add(emp);
	            				}
	            			} catch (NumberFormatException ex) {
	            				// Ignorer les IDs invalides
	            			}
	            		}
	            	}

	            	Date dateSql =  rs.getDate("echeance");
	            	System.out.println(dateSql);
	            	LocalDate date = dateSql.toLocalDate();
	                e = new Projet(
	                		rs.getInt("id_projet"),
	                	    rs.getString("nom"),
	                	    chef,
	                	    date,
	                	    departement,
	                	    rs.getString("etat"),
	                	    equipe,
	                	    rs.getInt("retard")
	                );

	            }
	        }
	    return e;
	    }

	
    public static List<Projet> getAll() throws SQLException{
    	String sql = "SELECT * FROM projet";
    	List<Projet> result = new ArrayList<Projet>();
    	try (Connection c = DBUtil.getConnection()) {
    		PreparedStatement stmt = c.prepareStatement(sql);
    		ResultSet rs = stmt.executeQuery();
    		
   	           while(rs.next()) {
   	            	int id = rs.getInt("id_projet");
   	            	System.out.println(id);
   	            	Projet projet=projetAvecId(id);
   	            	
   	            	result.add(projet);
   	            	System.out.println(result);
   	            }
   	            	
   	           
   	      
			}

  
    	return result;
    }
    public static boolean deleteProject(int id) throws SQLException {
    	String sql ="DELETE FROM projet WHERE id_projet=?";
    	try(Connection c = DBUtil.getConnection()){
    		PreparedStatement stmt = c.prepareStatement(sql);
    		stmt.setInt(1, id);
    		int rowDeleted = stmt.executeUpdate();

			stmt.close();
			return rowDeleted>0;
    	}
    }

    // Méthode alias pour getProjectById
    public static Projet getProjectById(int id) throws SQLException {
    	return projetAvecId(id);
    }

    // Méthode pour mettre à jour un projet
    public static boolean updateProject(Projet projet) throws SQLException {
    	return modifyProject(projet.getId(), projet);
    }

    // Rechercher des projets par état
    public static List<Projet> rechercherParEtat(String etat) throws SQLException {
    	if (etat == null || etat.trim().isEmpty()) {
    		return getAll();
    	}

    	String sql = "SELECT * FROM projet WHERE etat LIKE ?";
    	List<Projet> result = new ArrayList<>();

    	try (Connection c = DBUtil.getConnection()) {
    		PreparedStatement stmt = c.prepareStatement(sql);
    		stmt.setString(1, "%" + etat + "%");
    		ResultSet rs = stmt.executeQuery();

    		while(rs.next()) {
    			int id = rs.getInt("id_projet");
    			Projet projet = projetAvecId(id);
    			result.add(projet);
    		}
    	}

    	return result;
    }

    // Ajouter un employé à un projet
    public static boolean ajouterEmployeAProjet(int projetId, int employeId) throws SQLException {
    	Projet projet = projetAvecId(projetId);
    	if (projet == null) {
    		return false;
    	}

    	List<Employe> equipe = projet.getEquipe();
    	// Vérifier si l'employé n'est pas déjà dans l'équipe
    	boolean exists = equipe.stream().anyMatch(e -> e.getId() == employeId);
    	if (exists) {
    		return false; // Déjà dans l'équipe
    	}

    	Employe employe = EmployeDAO.employeAvecId(employeId);
    	if (employe == null) {
    		return false;
    	}

    	equipe.add(employe);
    	String equipeList = equipe.stream()
    			.map(e -> String.valueOf(e.getId()))
    			.collect(Collectors.joining(","));

    	String sql = "UPDATE projet SET equipeList = ? WHERE id_projet = ?";
    	try (Connection c = DBUtil.getConnection()) {
    		PreparedStatement ps = c.prepareStatement(sql);
    		ps.setString(1, equipeList);
    		ps.setInt(2, projetId);
    		int rows = ps.executeUpdate();
    		return rows > 0;
    	}
    }

    // Retirer un employé d'un projet
    public static boolean retirerEmployeDeProjet(int projetId, int employeId) throws SQLException {
    	Projet projet = projetAvecId(projetId);
    	if (projet == null) {
    		return false;
    	}

    	List<Employe> equipe = projet.getEquipe();
    	boolean removed = equipe.removeIf(e -> e.getId() == employeId);

    	if (!removed) {
    		return false; // Employé n'était pas dans l'équipe
    	}

    	String equipeList = equipe.stream()
    			.map(e -> String.valueOf(e.getId()))
    			.collect(Collectors.joining(","));

    	String sql = "UPDATE projet SET equipeList = ? WHERE id_projet = ?";
    	try (Connection c = DBUtil.getConnection()) {
    		PreparedStatement ps = c.prepareStatement(sql);
    		ps.setString(1, equipeList);
    		ps.setInt(2, projetId);
    		int rows = ps.executeUpdate();
    		return rows > 0;
    	}
    }
}
