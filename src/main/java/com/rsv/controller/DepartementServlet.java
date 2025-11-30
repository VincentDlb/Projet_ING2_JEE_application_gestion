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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/departements")
public class DepartementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");
		if (action == null) {
			action = "";
		}

		try {
			switch (action) {
			case "insert":
				// Afficher le formulaire d'ajout
				req.getRequestDispatcher("departement/ajouterDepartement.jsp").forward(req, resp);
				break;

			case "delete":
				// Supprimer un département
				String idStr = req.getParameter("id");
				int id = Integer.parseInt(idStr);
				DepartementDAO.supprimer(id);
				resp.sendRedirect(req.getContextPath() + "/departements");
				break;

			case "edit":
				// Afficher le formulaire de modification
				int idEdit = Integer.parseInt(req.getParameter("id"));
				Departement departement = DepartementDAO.departementAvecId(idEdit);
				req.setAttribute("departement", departement);
				req.getRequestDispatcher("departement/modifierDepartement.jsp").forward(req, resp);
				break;

			case "view":
				// Voir les détails d'un département avec ses employés
				int idView = Integer.parseInt(req.getParameter("id"));
				Departement dept = DepartementDAO.departementAvecId(idView);
				List<Employe> employes = DepartementDAO.listerEmployesDuDepartement(idView);
				req.setAttribute("departement", dept);
				req.setAttribute("employes", employes);
				req.getRequestDispatcher("departement/voirDepartement.jsp").forward(req, resp);
				break;

			case "search":
				// Rechercher des départements par nom
				String nomSearch = req.getParameter("nom");
				List<Departement> resultats = DepartementDAO.rechercherParNom(nomSearch != null ? nomSearch : "");
				req.setAttribute("listeDepartements", resultats);
				req.getRequestDispatcher("departement/gestionnaireDepartement.jsp").forward(req, resp);
				break;

			default:
				// Lister tous les départements
				List<Departement> liste = DepartementDAO.listerTous();
				req.setAttribute("listeDepartements", liste);
				req.getRequestDispatcher("departement/gestionnaireDepartement.jsp").forward(req, resp);
				break;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			req.setAttribute("erreur", "Erreur lors de l'opération : " + e.getMessage());
			req.getRequestDispatcher("departement/gestionnaireDepartement.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");

		try {
			switch (action) {
			case "insert":
				// Créer un nouveau département
				String nom = req.getParameter("nom");
				String adresse = req.getParameter("adresse");
				String tailleStr = req.getParameter("taille");
				String presentation = req.getParameter("presentation");
				String role = req.getParameter("role");

				int taille = Integer.parseInt(tailleStr);

				Departement nouveauDept = new Departement(
					0, // L'ID sera auto-généré
					new ArrayList<>(), // Liste vide d'employés
					nom,
					adresse,
					taille,
					presentation,
					role
				);

				DepartementDAO.ajouter(nouveauDept);
				break;

			case "edit":
				// Modifier un département existant
				String idStr = req.getParameter("id");
				String nomEdit = req.getParameter("nom");
				String adresseEdit = req.getParameter("adresse");
				String tailleStrEdit = req.getParameter("taille");
				String presentationEdit = req.getParameter("presentation");
				String roleEdit = req.getParameter("role");

				int idDept = Integer.parseInt(idStr);
				int tailleEdit = Integer.parseInt(tailleStrEdit);

				Departement deptModifie = new Departement(
					idDept,
					new ArrayList<>(),
					nomEdit,
					adresseEdit,
					tailleEdit,
					presentationEdit,
					roleEdit
				);

				DepartementDAO.modifier(deptModifie);
				break;

			default:
				break;
			}
		} catch (NumberFormatException | SQLException ex) {
			ex.printStackTrace();
			req.setAttribute("erreur", "Erreur lors de l'opération : " + ex.getMessage());
		}

		resp.sendRedirect(req.getContextPath() + "/departements");
	}
}
