package com.rsv.controller;

import com.rsv.bdd.EmployeDAO;
import com.rsv.bdd.FicheDePaieDAO;
import com.rsv.model.Employe;
import com.rsv.model.FicheDePaie;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/fichesdepaie")
public class FicheDePaieServlet extends HttpServlet {
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
				// Récupérer la liste des employés pour le select
				EmployeDAO empDao = new EmployeDAO();
				List<Employe> employes = empDao.listerTous();
				req.setAttribute("employes", employes);
				req.getRequestDispatcher("paie/ajouterFicheDePaie.jsp").forward(req, resp);
				break;

			case "delete":
				// Supprimer une fiche de paie
				String idStr = req.getParameter("id");
				int id = Integer.parseInt(idStr);
				FicheDePaieDAO.supprimer(id);
				resp.sendRedirect(req.getContextPath() + "/fichesdepaie");
				break;

			case "view":
				// Voir les détails d'une fiche de paie (version imprimable)
				int idView = Integer.parseInt(req.getParameter("id"));
				FicheDePaie fiche = FicheDePaieDAO.ficheAvecId(idView);
				req.setAttribute("fiche", fiche);
				req.getRequestDispatcher("paie/voirFicheDePaie.jsp").forward(req, resp);
				break;

			case "searchByEmployee":
				// Rechercher les fiches d'un employé
				int employeId = Integer.parseInt(req.getParameter("employeId"));
				List<FicheDePaie> fichesEmploye = FicheDePaieDAO.listerParEmploye(employeId);
				req.setAttribute("listeFiches", fichesEmploye);
				req.setAttribute("filtre", "Employé ID " + employeId);
				req.getRequestDispatcher("paie/gestionnaireFichesDePaie.jsp").forward(req, resp);
				break;

			case "searchByPeriod":
				// Rechercher par période
				int mois = Integer.parseInt(req.getParameter("mois"));
				int annee = Integer.parseInt(req.getParameter("annee"));
				List<FicheDePaie> fichesPeriode = FicheDePaieDAO.listerParPeriode(mois, annee);
				req.setAttribute("listeFiches", fichesPeriode);
				req.setAttribute("filtre", getMoisNom(mois) + " " + annee);
				req.getRequestDispatcher("paie/gestionnaireFichesDePaie.jsp").forward(req, resp);
				break;

			case "searchByYear":
				// Rechercher par année
				int anneeSearch = Integer.parseInt(req.getParameter("annee"));
				List<FicheDePaie> fichesAnnee = FicheDePaieDAO.listerParAnnee(anneeSearch);
				req.setAttribute("listeFiches", fichesAnnee);
				req.setAttribute("filtre", "Année " + anneeSearch);
				req.getRequestDispatcher("paie/gestionnaireFichesDePaie.jsp").forward(req, resp);
				break;

			default:
				// Lister toutes les fiches de paie
				List<FicheDePaie> liste = FicheDePaieDAO.listerTous();
				req.setAttribute("listeFiches", liste);
				req.getRequestDispatcher("paie/gestionnaireFichesDePaie.jsp").forward(req, resp);
				break;
			}
		} catch (SQLException | NumberFormatException e) {
			e.printStackTrace();
			req.setAttribute("erreur", "Erreur lors de l'opération : " + e.getMessage());
			req.getRequestDispatcher("paie/gestionnaireFichesDePaie.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");

		try {
			if ("insert".equals(action)) {
				// Créer une nouvelle fiche de paie avec gestion des valeurs par défaut
				int employeId = Integer.parseInt(req.getParameter("employeId"));
				int mois = Integer.parseInt(req.getParameter("mois"));
				int annee = Integer.parseInt(req.getParameter("annee"));
				float salaireBrut = Float.parseFloat(req.getParameter("salaireBrut"));

				// Valeurs optionnelles avec défauts
				float bonus = parseFloatOrDefault(req.getParameter("bonus"), 0f);
				float deduction = parseFloatOrDefault(req.getParameter("deduction"), 0f);
				long numeroFiscal = Long.parseLong(req.getParameter("numeroFiscal"));
				boolean statutCadre = "true".equals(req.getParameter("statutCadre"));
				float heureSupp = parseFloatOrDefault(req.getParameter("heureSupp"), 0f);
				float tauxHoraire = parseFloatOrDefault(req.getParameter("tauxHoraire"), 0f);
				float heureSemaine = parseFloatOrDefault(req.getParameter("heureSemaine"), 35f);
				float heureDansLeMois = parseFloatOrDefault(req.getParameter("heureDansLeMois"), 151.67f);
				float heureAbsences = parseFloatOrDefault(req.getParameter("heureAbsences"), 0f);

				// Vérifier si une fiche existe déjà pour cet employé et cette période
				FicheDePaie ficheExistante = FicheDePaieDAO.rechercherParEmployeEtPeriode(employeId, mois, annee);
				if (ficheExistante != null) {
					req.setAttribute("erreur",
							"Une fiche de paie existe déjà pour cet employé pour cette période.");
					EmployeDAO empDao = new EmployeDAO();
					List<Employe> employes = empDao.listerTous();
					req.setAttribute("employes", employes);
					req.getRequestDispatcher("paie/ajouterFicheDePaie.jsp").forward(req, resp);
					return;
				}

				FicheDePaie nouvelleFiche = new FicheDePaie(employeId, mois, annee, salaireBrut, bonus, deduction,
						numeroFiscal, statutCadre, heureSupp, tauxHoraire, heureSemaine, heureDansLeMois,
						heureAbsences);

				int idGenere = FicheDePaieDAO.ajouter(nouvelleFiche);

				if (idGenere > 0) {
					resp.sendRedirect(req.getContextPath() + "/fichesdepaie");
					return;
				} else {
					req.setAttribute("erreur", "Erreur lors de la création de la fiche de paie.");
					EmployeDAO empDao = new EmployeDAO();
					List<Employe> employes = empDao.listerTous();
					req.setAttribute("employes", employes);
					req.getRequestDispatcher("paie/ajouterFicheDePaie.jsp").forward(req, resp);
				}
			}
		} catch (NumberFormatException ex) {
			ex.printStackTrace();
			try {
				req.setAttribute("erreur", "Erreur de format : Vérifiez que tous les champs numériques sont correctement remplis. " + ex.getMessage());
				EmployeDAO empDao = new EmployeDAO();
				List<Employe> employes = empDao.listerTous();
				req.setAttribute("employes", employes);
				req.getRequestDispatcher("paie/ajouterFicheDePaie.jsp").forward(req, resp);
			} catch (SQLException e) {
				e.printStackTrace();
				resp.sendRedirect(req.getContextPath() + "/fichesdepaie");
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
			try {
				req.setAttribute("erreur", "Erreur de base de données : " + ex.getMessage());
				EmployeDAO empDao = new EmployeDAO();
				List<Employe> employes = empDao.listerTous();
				req.setAttribute("employes", employes);
				req.getRequestDispatcher("paie/ajouterFicheDePaie.jsp").forward(req, resp);
			} catch (SQLException e) {
				e.printStackTrace();
				resp.sendRedirect(req.getContextPath() + "/fichesdepaie");
			}
		}
	}

	// Méthode utilitaire pour parser un float avec valeur par défaut
	private float parseFloatOrDefault(String value, float defaultValue) {
		if (value == null || value.trim().isEmpty()) {
			return defaultValue;
		}
		try {
			return Float.parseFloat(value);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	// Méthode utilitaire pour obtenir le nom du mois
	private String getMoisNom(int mois) {
		String[] nomsMois = { "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre",
				"Octobre", "Novembre", "Décembre" };
		if (mois >= 1 && mois <= 12) {
			return nomsMois[mois - 1];
		}
		return "Mois inconnu";
	}
}
