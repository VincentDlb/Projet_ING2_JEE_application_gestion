package com.rsv.controller;

import com.rsv.bdd.EmployeDAO;
import com.rsv.bdd.DepartementDAO;
import com.rsv.bdd.ProjetDAO;
import com.rsv.model.Employe;
import com.rsv.model.Departement;
import com.rsv.model.Projet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/rapports")
public class RapportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			// 1. Statistiques générales
			EmployeDAO empDao = new EmployeDAO();
			List<Employe> tousEmployes = empDao.listerTous();
			List<Departement> tousDepartements = DepartementDAO.listerTous();
			List<Projet> tousProjets = ProjetDAO.getAll();

			req.setAttribute("totalEmployes", tousEmployes.size());
			req.setAttribute("totalDepartements", tousDepartements.size());
			req.setAttribute("totalProjets", tousProjets.size());

			// 2. Répartition des employés par grade
			Map<String, Integer> employesParGrade = new HashMap<>();
			for (Employe emp : tousEmployes) {
				String grade = emp.getGrade() != null && !emp.getGrade().isEmpty() ? emp.getGrade() : "Non défini";
				employesParGrade.put(grade, employesParGrade.getOrDefault(grade, 0) + 1);
			}
			req.setAttribute("employesParGrade", employesParGrade);

			// 3. Répartition des employés par type de contrat
			Map<String, Integer> employesParContrat = new HashMap<>();
			for (Employe emp : tousEmployes) {
				String contrat = emp.getTypeContrat() != null && !emp.getTypeContrat().isEmpty()
						? emp.getTypeContrat()
						: "Non défini";
				employesParContrat.put(contrat, employesParContrat.getOrDefault(contrat, 0) + 1);
			}
			req.setAttribute("employesParContrat", employesParContrat);

			// 4. Répartition Cadres vs Non-Cadres
			int cadres = 0;
			int nonCadres = 0;
			for (Employe emp : tousEmployes) {
				if (emp.isStatutCadre()) {
					cadres++;
				} else {
					nonCadres++;
				}
			}
			req.setAttribute("nombreCadres", cadres);
			req.setAttribute("nombreNonCadres", nonCadres);

			// 5. Répartition des employés par département
			Map<String, Integer> employesParDepartement = new HashMap<>();
			for (Employe emp : tousEmployes) {
				if (emp.getDepartementId() > 0) {
					try {
						Departement dept = DepartementDAO.departementAvecId(emp.getDepartementId());
						if (dept != null) {
							String nomDept = dept.getNom();
							employesParDepartement.put(nomDept, employesParDepartement.getOrDefault(nomDept, 0) + 1);
						}
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			req.setAttribute("employesParDepartement", employesParDepartement);

			// 6. Répartition des projets par état
			Map<String, Integer> projetsParEtat = new HashMap<>();
			for (Projet proj : tousProjets) {
				String etat = proj.getÉtat() != null && !proj.getÉtat().isEmpty() ? proj.getÉtat() : "Non défini";
				projetsParEtat.put(etat, projetsParEtat.getOrDefault(etat, 0) + 1);
			}
			req.setAttribute("projetsParEtat", projetsParEtat);

			// 7. Distribution de l'ancienneté
			Map<String, Integer> employesParAnciennete = new HashMap<>();
			for (Employe emp : tousEmployes) {
				int anc = emp.getAnciennete();
				String categorie;
				if (anc < 2) {
					categorie = "< 2 ans";
				} else if (anc < 5) {
					categorie = "2-5 ans";
				} else if (anc < 10) {
					categorie = "5-10 ans";
				} else {
					categorie = "10+ ans";
				}
				employesParAnciennete.put(categorie, employesParAnciennete.getOrDefault(categorie, 0) + 1);
			}
			req.setAttribute("employesParAnciennete", employesParAnciennete);

			// 8. Distribution par âge
			Map<String, Integer> employesParAge = new HashMap<>();
			for (Employe emp : tousEmployes) {
				int age = emp.getAge();
				String categorie;
				if (age < 25) {
					categorie = "< 25 ans";
				} else if (age < 35) {
					categorie = "25-34 ans";
				} else if (age < 45) {
					categorie = "35-44 ans";
				} else if (age < 55) {
					categorie = "45-54 ans";
				} else {
					categorie = "55+ ans";
				}
				employesParAge.put(categorie, employesParAge.getOrDefault(categorie, 0) + 1);
			}
			req.setAttribute("employesParAge", employesParAge);

			// Rediriger vers la page JSP
			req.getRequestDispatcher("rapports.jsp").forward(req, resp);

		} catch (SQLException e) {
			e.printStackTrace();
			req.setAttribute("erreur", "Erreur lors de la génération des rapports : " + e.getMessage());
			req.getRequestDispatcher("rapports.jsp").forward(req, resp);
		}
	}
}
