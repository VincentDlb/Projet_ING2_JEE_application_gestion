package com.rsv.controller;

import com.rsv.bdd.DepartementDAO;
import com.rsv.bdd.EmployeDAO;
import com.rsv.model.Departement;
import com.rsv.model.Employe;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/employes")
public class EmployeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");
		if (action == null) {
			action = "list";
		}
		EmployeDAO dao = new EmployeDAO();

		try {
			switch (action) {
			case "insert":
				// Charger les départements pour le formulaire
				List<Departement> departements = DepartementDAO.listerTous();
				req.setAttribute("departements", departements);
				req.getRequestDispatcher("employe/ajouterEmploye.jsp").forward(req, resp);
				break;

			case "delete":
				String idStr = req.getParameter("id");
				int id = Integer.parseInt(idStr);
				dao.supprimer(id);
				resp.sendRedirect(req.getContextPath() + "/employes");
				break;

			case "edit":
				int idEdit = Integer.parseInt(req.getParameter("id"));
				Employe employe = dao.employeAvecId(idEdit);
				List<Departement> departementsEdit = DepartementDAO.listerTous();
				req.setAttribute("employe", employe);
				req.setAttribute("departements", departementsEdit);
				req.getRequestDispatcher("employe/modifierEmploye.jsp").forward(req, resp);
				break;

			case "search":
				String nomSearch = req.getParameter("nom");
				String prenomSearch = req.getParameter("prenom");
				String matriculeSearch = req.getParameter("matricule");
				String gradeFilter = req.getParameter("grade");
				String posteFilter = req.getParameter("poste");

				List<Employe> resultats = dao.rechercherEmployes(nomSearch, prenomSearch, matriculeSearch,
						gradeFilter, posteFilter);
				req.setAttribute("listeEmployes", resultats);
				req.getRequestDispatcher("employe/gestionnaireEmploye.jsp").forward(req, resp);
				break;

			default:
				// Lister tous les employés
				List<Employe> liste = dao.listerTous();
				req.setAttribute("listeEmployes", liste);
				req.getRequestDispatcher("employe/gestionnaireEmploye.jsp").forward(req, resp);
				break;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			req.setAttribute("erreur", "Erreur lors de l'opération : " + e.getMessage());
			try {
				List<Employe> liste = dao.listerTous();
				req.setAttribute("listeEmployes", liste);
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
			req.getRequestDispatcher("employe/gestionnaireEmploye.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			String action = req.getParameter("action");
			EmployeDAO dao = new EmployeDAO();

			switch (action) {
			case "insert":
				String nom = req.getParameter("nom");
				String prenom = req.getParameter("prenom");
				String ageStr = req.getParameter("age");
				String adresse = req.getParameter("adresse");
				String typeContrat = req.getParameter("typeContrat");
				String ancienneteStr = req.getParameter("anciennete");
				String grade = req.getParameter("grade");
				String poste = req.getParameter("poste");
				String matriculeStr = req.getParameter("matricule");
				String statutCadreStr = req.getParameter("statutCadre");
				String departementIdStr = req.getParameter("departementId");

				int age = Integer.parseInt(ageStr);
				int anciennete = Integer.parseInt(ancienneteStr);
				int matricule = Integer.parseInt(matriculeStr);
				boolean statutCadre = "true".equals(statutCadreStr);

				Employe employeAjoute = new Employe(nom, prenom, age, adresse, typeContrat, anciennete,
						grade, poste, matricule, statutCadre);

				// Affecter le département si fourni
				if (departementIdStr != null && !departementIdStr.isEmpty() && !departementIdStr.equals("0")) {
					employeAjoute.setDepartementId(Integer.parseInt(departementIdStr));
				}

				dao.ajouter(employeAjoute);
				break;

			case "edit":
				String idStrEdit = req.getParameter("id");
				String nomEdit = req.getParameter("nom");
				String prenomEdit = req.getParameter("prenom");
				String ageStrEdit = req.getParameter("age");
				String adresseEdit = req.getParameter("adresse");
				String typeContratEdit = req.getParameter("typeContrat");
				String ancienneteStrEdit = req.getParameter("anciennete");
				String gradeEdit = req.getParameter("grade");
				String posteEdit = req.getParameter("poste");
				String matriculeStrEdit = req.getParameter("matricule");
				String statutCadreStrEdit = req.getParameter("statutCadre");
				String departementIdStrEdit = req.getParameter("departementId");

				int idEditInt = Integer.parseInt(idStrEdit);
				int ageEdit = Integer.parseInt(ageStrEdit);
				int ancienneteEdit = Integer.parseInt(ancienneteStrEdit);
				int matriculeEdit = Integer.parseInt(matriculeStrEdit);
				boolean statutCadreEdit = "true".equals(statutCadreStrEdit);

				Employe employeModifie = new Employe(idEditInt, nomEdit, prenomEdit, ageEdit, adresseEdit,
						typeContratEdit, ancienneteEdit, gradeEdit, posteEdit, matriculeEdit, statutCadreEdit);

				// Affecter le département si fourni
				if (departementIdStrEdit != null && !departementIdStrEdit.isEmpty() && !departementIdStrEdit.equals("0")) {
					employeModifie.setDepartementId(Integer.parseInt(departementIdStrEdit));
				}

				dao.modifier(employeModifie);
				break;

			default:
				break;
			}
		} catch (NumberFormatException | SQLException ex) {
			ex.printStackTrace();
			req.setAttribute("erreur", "Erreur lors de l'opération : " + ex.getMessage());
		}

		resp.sendRedirect(req.getContextPath() + "/employes");
	}
}
