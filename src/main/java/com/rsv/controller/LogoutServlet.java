package com.rsv.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Invalider la session
		HttpSession session = req.getSession(false);
		if (session != null) {
			session.invalidate();
		}

		// Rediriger vers la page de login avec un message
		resp.sendRedirect(req.getContextPath() + "/login?message=deconnecte");
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
