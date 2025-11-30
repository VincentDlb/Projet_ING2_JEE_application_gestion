package com.rsv.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filtre d'authentification
 * Vérifie que l'utilisateur est connecté avant d'accéder aux pages protégées
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    private String contextPath;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Récupérer le contexte de l'application
        contextPath = filterConfig.getServletContext().getContextPath();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String uri = httpRequest.getRequestURI();
        
        // Vérifier si la page est publique (accessible sans connexion)
        if (isPublicPage(uri)) {
            chain.doFilter(request, response);
            return;
        }

        // Vérifier si l'utilisateur est connecté
        HttpSession session = httpRequest.getSession(false);
        
        // DEBUG
        System.out.println("DEBUG AuthFilter - URI: " + uri + " | isPublicPage: " + isPublicPage(uri));
        System.out.println("DEBUG - Session: " + (session != null ? "EXISTS" : "NULL") + 
                           " | UserId: " + (session != null ? session.getAttribute("userId") : "N/A"));
        
        if (session == null || session.getAttribute("userId") == null) {
            httpResponse.sendRedirect(contextPath + "/auth.jsp?erreur=non_connecte");
            return;
        }

        // L'utilisateur est connecté, continuer
        chain.doFilter(request, response);
    }

    /**
     * Vérifie si une URI correspond à une page publique
     */
    private boolean isPublicPage(String uri) {
        return uri.endsWith("/auth.jsp") || 
               uri.endsWith("/auth") ||
               uri.endsWith("/inscription.jsp") ||
               uri.endsWith("/inscription") ||
               uri.contains("/css/") ||
               uri.contains("/js/") ||
               uri.contains("/images/") ||
               uri.contains("/fonts/") ||
               uri.contains("/favicon.ico") ||
               uri.equals(contextPath + "/") ||
               uri.equals(contextPath);
    }

    @Override
    public void destroy() {
        // Nettoyage si nécessaire
    }
}