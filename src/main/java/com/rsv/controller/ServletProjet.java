package com.rsv.controller;

import com.rsv.bdd.DepartementDAO;
import com.rsv.bdd.EmployeDAO;
import com.rsv.bdd.ProjetDAO;
import com.rsv.model.Departement;
import com.rsv.model.Employe;
import com.rsv.model.Projet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ServletProjet")
public class ServletProjet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");
		if (action == null) {
			action = "list";
		}

		try {
			switch (action) {
			case "insert":
				// Afficher le formulaire d'ajout
				List<Employe> employesInsert = EmployeDAO.listerTous();
				List<Departement> departementsInsert = DepartementDAO.listerTous();
				req.setAttribute("employes", employesInsert);
				req.setAttribute("departements", departementsInsert);
				req.getRequestDispatcher("projet/ajouterProjet.jsp").forward(req, resp);
				break;

			case "delete":
				// Supprimer un projet
				int idDelete = Integer.parseInt(req.getParameter("id"));
				ProjetDAO.deleteProject(idDelete);
				resp.sendRedirect(req.getContextPath() + "/ServletProjet");
				break;

			case "edit":
				// Afficher le formulaire de modification
				int idEdit = Integer.parseInt(req.getParameter("id"));
				Projet projetEdit = ProjetDAO.getProjectById(idEdit);
				List<Employe> employesEdit = EmployeDAO.listerTous();
				List<Departement> departementsEdit = DepartementDAO.listerTous();
				req.setAttribute("projet", projetEdit);
				req.setAttribute("employes", employesEdit);
				req.setAttribute("departements", departementsEdit);
				req.getRequestDispatcher("projet/modifierProjet.jsp").forward(req, resp);
				break;

			case "view":
				// Voir les détails d'un projet
				int idView = Integer.parseInt(req.getParameter("id"));
				Projet projetView = ProjetDAO.getProjectById(idView);
				List<Employe> tousEmployes = EmployeDAO.listerTous();
				req.setAttribute("projet", projetView);
				req.setAttribute("tousEmployes", tousEmployes);
				req.getRequestDispatcher("projet/voirProjet.jsp").forward(req, resp);
				break;

			case "addEmployee":
				// Ajouter un employé à un projet
				int projetIdAdd = Integer.parseInt(req.getParameter("projetId"));
				int employeIdAdd = Integer.parseInt(req.getParameter("employeId"));
				ProjetDAO.ajouterEmployeAProjet(projetIdAdd, employeIdAdd);
				resp.sendRedirect(req.getContextPath() + "/ServletProjet?action=view&id=" + projetIdAdd);
				break;

			case "removeEmployee":
				// Retirer un employé d'un projet
				int projetIdRemove = Integer.parseInt(req.getParameter("projetId"));
				int employeIdRemove = Integer.parseInt(req.getParameter("employeId"));
				ProjetDAO.retirerEmployeDeProjet(projetIdRemove, employeIdRemove);
				resp.sendRedirect(req.getContextPath() + "/ServletProjet?action=view&id=" + projetIdRemove);
				break;

			case "search":
				// Rechercher des projets par état
				String etatSearch = req.getParameter("etat");
				List<Projet> resultats = ProjetDAO.rechercherParEtat(etatSearch != null ? etatSearch : "");
				req.setAttribute("listeProjets", resultats);
				req.getRequestDispatcher("projet/gestionnaireProjet.jsp").forward(req, resp);
				break;

			default:
				// Lister tous les projets
				List<Projet> liste = ProjetDAO.getAll();
				req.setAttribute("listeProjets", liste);
				req.getRequestDispatcher("projet/gestionnaireProjet.jsp").forward(req, resp);
				break;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			req.setAttribute("erreur", "Erreur lors de l'opération : " + e.getMessage());
			try {
				List<Projet> liste = ProjetDAO.getAll();
				req.setAttribute("listeProjets", liste);
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
			req.getRequestDispatcher("projet/gestionnaireProjet.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");

		try {
			switch (action) {
			case "insert":
				// Créer un nouveau projet
				String nom = req.getParameter("nom");
				String idChefStr = req.getParameter("chefDeProjetId");
				String echeance = req.getParameter("echeance");
				String idDepartementStr = req.getParameter("departementId");
				String etat = req.getParameter("etat");
				String retardStr = req.getParameter("retard");

				int chefDeProjetId = Integer.parseInt(idChefStr);
				Employe chef = EmployeDAO.employeAvecId(chefDeProjetId);

				LocalDate dateEcheance = LocalDate.parse(echeance);

				int departementId = Integer.parseInt(idDepartementStr);
				Departement departement = DepartementDAO.departementAvecId(departementId);

				int retard = retardStr != null && !retardStr.isEmpty() ? Integer.parseInt(retardStr) : 0;

				List<Employe> equipe = new ArrayList<>();

				Projet nouveauProjet = new Projet(
					0, // L'ID sera auto-généré
					nom,
					chef,
					dateEcheance,
					departement,
					etat,
					equipe,
					retard
				);

				ProjetDAO.createProject(nouveauProjet);
				break;

			case "edit":
				// Modifier un projet existant
				String idStr = req.getParameter("id");
				String nomEdit = req.getParameter("nom");
				String idChefStrEdit = req.getParameter("chefDeProjetId");
				String echeanceEdit = req.getParameter("echeance");
				String idDepartementStrEdit = req.getParameter("departementId");
				String etatEdit = req.getParameter("etat");
				String retardStrEdit = req.getParameter("retard");

				int idProjet = Integer.parseInt(idStr);
				int chefDeProjetIdEdit = Integer.parseInt(idChefStrEdit);
				Employe chefEdit = EmployeDAO.employeAvecId(chefDeProjetIdEdit);

				LocalDate dateEcheanceEdit = LocalDate.parse(echeanceEdit);

				int departementIdEdit = Integer.parseInt(idDepartementStrEdit);
				Departement departementEdit = DepartementDAO.departementAvecId(departementIdEdit);

				int retardEdit = retardStrEdit != null && !retardStrEdit.isEmpty() ? Integer.parseInt(retardStrEdit) : 0;

				List<Employe> equipeEdit = new ArrayList<>();

				Projet projetModifie = new Projet(
					idProjet,
					nomEdit,
					chefEdit,
					dateEcheanceEdit,
					departementEdit,
					etatEdit,
					equipeEdit,
					retardEdit
				);

				ProjetDAO.updateProject(projetModifie);
				break;

			default:
				break;
			}
		} catch (NumberFormatException | SQLException ex) {
			ex.printStackTrace();
			req.setAttribute("erreur", "Erreur lors de l'opération : " + ex.getMessage());
		}

		resp.sendRedirect(req.getContextPath() + "/ServletProjet");
	}
}
