package com.rsv.controller;

import com.rsv.bdd.UserDAO;
import com.rsv.util.PasswordUtil;
import com.rsv.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet qui gère l'authentification des utilisateurs
 * (login et logout)
 */
@WebServlet("/auth")
@SuppressWarnings("serial")
public class AuthServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            logout(request, response);
        } else {
            response.sendRedirect("auth.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        login(request, response);
    }
    
    /**
     * Gère la connexion d'un utilisateur
     */
    private void login(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération des données du formulaire
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Vérification que les champs sont remplis
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("auth.jsp?erreur=champs_vides");
            return;
        }
        
     // Tentative d'authentification
        User user = userDAO.getUserByUsername(username);

        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
            // connexion réussie : création de la session
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("nomComplet", user.getNomComplet());
            session.setAttribute("userRole", user.getRole());
            
            // Redirection vers l'accueil
            response.sendRedirect("accueil.jsp");
        } else {
            // échec de connexion
            response.sendRedirect("auth.jsp?erreur=identifiants_invalides");
        }
        }
    
    /**
     * Déconnecte l'utilisateur et détruit la session
     */
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        response.sendRedirect("auth.jsp?message=deconnexion_ok");
    }
}