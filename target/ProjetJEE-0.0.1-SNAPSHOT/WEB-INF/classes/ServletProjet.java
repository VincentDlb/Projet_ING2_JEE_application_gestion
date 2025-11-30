package com.rsv.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.rsv.model.Departement;
import com.rsv.model.Employe;
import com.rsv.model.Projet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.rsv.bdd.DepartementDAO;
import com.rsv.bdd.EmployeDAO;
import com.rsv.bdd.ProjetDAO;

@WebServlet("/ServletProjet")
public class ServletProjet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String VUE = "/accueil.jsp";
   
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Projet> projets = null;
		try {
			projets = ProjetDAO.getAll();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		request.setAttribute("projets", projets);
		request.getRequestDispatcher("updateAndDelete.jsp").forward(request, response);
	}
		 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		
		try {
			String nom =request.getParameter("nom");
			String idChef = request.getParameter("idchef");
		
			String echeance = request.getParameter("echeance");
			String departement = request.getParameter("departement");
			String etat = request.getParameter("etat");
			String liste = request.getParameter("liste");
			String retard = request.getParameter("retard");
			
			int idchef = Integer.parseInt(idChef);
			Employe chef = EmployeDAO.employeAvecId(idchef);
			
			LocalDate dateEcheance = LocalDate.parse(echeance);
			
			Departement departement1 = DepartementDAO.departementAvecId(Integer.parseInt(departement));
		
			List<Employe> list = new ArrayList<Employe>();
			
			Projet projet = new Projet(0,nom,chef,dateEcheance,departement1,etat,list,Integer.parseInt(retard));
		
			ProjetDAO.createProject(projet);
			this.getServletContext().getRequestDispatcher(VUE).forward(request, response);
		}catch(SQLException e) {
			System.out.println(e.getMessage());
		}
	}
}

