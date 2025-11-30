package com.rsv.controller;

import com.rsv.bdd.UserDAO;
import com.rsv.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Si déjà connecté, rediriger vers l'accueil
		HttpSession session = req.getSession(false);
		if (session != null && session.getAttribute("user") != null) {
			resp.sendRedirect(req.getContextPath() + "/accueil.jsp");
			return;
		}

		// Afficher la page de login
		req.getRequestDispatcher("auth.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String username = req.getParameter("username");
		String password = req.getParameter("password");

		// Validation des champs
		if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
			req.setAttribute("erreur", "Veuillez remplir tous les champs.");
			req.getRequestDispatcher("auth.jsp").forward(req, resp);
			return;
		}

		try {
			// Authentifier l'utilisateur
			User user = UserDAO.authentifier(username, password);

			if (user != null) {
				// Créer une session
				HttpSession session = req.getSession(true);
				session.setAttribute("user", user);
				session.setAttribute("username", user.getUsername());
				session.setAttribute("role", user.getRole());
				session.setAttribute("userId", user.getId());

				// Timeout de session : 30 minutes
				session.setMaxInactiveInterval(30 * 60);

				// Rediriger vers la page d'accueil
				resp.sendRedirect(req.getContextPath() + "/accueil.jsp");
			} else {
				// Authentification échouée
				req.setAttribute("erreur", "Identifiant ou mot de passe incorrect.");
				req.getRequestDispatcher("auth.jsp").forward(req, resp);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			req.setAttribute("erreur", "Erreur lors de l'authentification : " + e.getMessage());
			req.getRequestDispatcher("auth.jsp").forward(req, resp);
		}
	}
}
