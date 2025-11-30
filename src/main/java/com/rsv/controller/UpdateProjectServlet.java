package com.rsv.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.rsv.bdd.DepartementDAO;
import com.rsv.bdd.EmployeDAO;
import com.rsv.bdd.ProjetDAO;
import com.rsv.model.Departement;
import com.rsv.model.Employe;
import com.rsv.model.Projet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdateProjectServlet")
public class UpdateProjectServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String VUE = "/accueil.jsp";
   
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		switch(action) {
		case "delete":
			String idStr = request.getParameter("id");
			int id = Integer.parseInt(idStr);
			try {
				ProjetDAO.deleteProject(id);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			List<Projet> projets = null;
			try {
				projets = ProjetDAO.getAll();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			request.setAttribute("projets", projets);
			request.getRequestDispatcher("updateAndDelete.jsp").forward(request, response);
			break; // Fix: ajout du break manquant pour éviter le fall-through
		case "modify":
			String idStr1 = request.getParameter("id");
			Projet projet = null;
			try {
				projet = ProjetDAO.projetAvecId(Integer.parseInt(idStr1));
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			request.setAttribute("projet", projet);
			request.getRequestDispatcher("modifyProject.jsp").forward(request,response);
		}
		
		
		
	}
	
}
