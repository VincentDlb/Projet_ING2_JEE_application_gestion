package com.rsv.controller;

import com.rsv.bdd.EmployeDAO;
import com.rsv.util.PasswordUtil;
import com.rsv.bdd.UserDAO;
import com.rsv.model.Employe;
import com.rsv.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet pour gérer l'inscription des employés
 */
@WebServlet("/inscription")
public class InscriptionServlet extends HttpServlet {

    private EmployeDAO employeDAO = new EmployeDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Afficher le formulaire d'inscription
        request.getRequestDispatcher("/inscription.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String matricule = request.getParameter("matricule");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation
        if (matricule == null || matricule.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("erreur", "Tous les champs sont obligatoires");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            return;
        }
        
        // Vérifier que les mots de passe correspondent
        if (!password.equals(confirmPassword)) {
            request.setAttribute("erreur", "Les mots de passe ne correspondent pas");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            return;
        }
        
        // Validation du mot de passe : au moins 8 caractères, 1 chiffre, 1 caractère spécial
        if (!isPasswordValid(password)) {
            request.setAttribute("erreur", "Le mot de passe doit contenir au moins 8 caractères, dont 1 chiffre et 1 caractère spécial (!@#$%^&*)");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            return;
        }
        
        // Vérifier que le matricule existe
        Employe employe = employeDAO.getEmployeByMatricule(matricule.trim());
        if (employe == null) {
            request.setAttribute("erreur", "Matricule introuvable. Contactez votre administrateur.");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            return;
        }
        
        // Vérifier que l'employé n'a pas déjà un compte
        User existingUser = userDAO.getUserByEmployeId(employe.getId());
        if (existingUser != null) {
            request.setAttribute("erreur", "Un compte existe déjà pour ce matricule. Impossible de créer un second compte.");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            return;
        }
        
        // Vérifier que le username n'est pas déjà pris
        User existingUsername = userDAO.getUserByUsername(username.trim());
        if (existingUsername != null) {
            request.setAttribute("erreur", "Ce nom d'utilisateur est déjà utilisé");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            return;
        }
        
        // Créer le nouveau compte
        User newUser = new User();
        newUser.setUsername(username.trim());
        String hashedPassword = PasswordUtil.hashPassword(password);
        newUser.setPassword(hashedPassword);
        newUser.setNomComplet(employe.getNom() + " " + employe.getPrenom());
        newUser.setRole("EMPLOYE"); 
        newUser.setEmploye(employe);
        newUser.setDepartement(employe.getDepartement());
        
        boolean success = userDAO.ajouterUser(newUser);
        
        if (success) {
            request.setAttribute("succes", "Compte créé avec succès ! Vous pouvez maintenant vous connecter.");
            request.getRequestDispatcher("/auth.jsp").forward(request, response);
        } else {
            request.setAttribute("erreur", "Erreur lors de la création du compte");
            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
        }
    }
    
    /**
     * Vérifie que le mot de passe respecte les critères de sécurité
     */
    private boolean isPasswordValid(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasDigit = false;
        boolean hasSpecialChar = false;
        String specialChars = "!@#$%^&*";
        
        for (char c : password.toCharArray()) {
            if (Character.isDigit(c)) {
                hasDigit = true;
            }
            if (specialChars.indexOf(c) >= 0) {
                hasSpecialChar = true;
            }
        }
        
        return hasDigit && hasSpecialChar;
    }
}