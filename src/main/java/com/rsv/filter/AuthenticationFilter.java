package com.rsv.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Filtre d'authentification pour protéger les pages de l'application
 * Vérifie si l'utilisateur est connecté avant d'accéder aux ressources protégées
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

	// Pages publiques (accessibles sans authentification)
	private static final String[] PUBLIC_PATHS = { "/login", "/auth.jsp", "/style.css", "/img/" };

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// Initialisation si nécessaire
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

		// Vérifier si la ressource est publique
		if (isPublicResource(path)) {
			chain.doFilter(request, response);
			return;
		}

		// Vérifier si l'utilisateur est authentifié
		HttpSession session = httpRequest.getSession(false);
		boolean isAuthenticated = (session != null && session.getAttribute("user") != null);

		if (isAuthenticated) {
			// L'utilisateur est authentifié, continuer
			chain.doFilter(request, response);
		} else {
			// L'utilisateur n'est pas authentifié, rediriger vers la page de login
			httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
		}
	}

	@Override
	public void destroy() {
		// Nettoyage si nécessaire
	}

	/**
	 * Vérifie si une ressource est publique (accessible sans authentification)
	 */
	private boolean isPublicResource(String path) {
		for (String publicPath : PUBLIC_PATHS) {
			if (path.startsWith(publicPath)) {
				return true;
			}
		}
		return false;
	}
}
