package com.rsv.controller;

import com.rsv.bdd.DepartementDAO;
import com.rsv.bdd.EmployeDAO;
import com.rsv.bdd.UserDAO;
import com.rsv.bdd.FicheDePaieDAO;
import com.rsv.model.Departement;
import com.rsv.model.Employe;
import com.rsv.model.User;
import com.rsv.model.FicheDePaie;
import com.rsv.util.RoleHelper;
import java.util.Set;
import java.util.HashSet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

/**
 * Servlet pour gérer "Mon Département".
 * Permet à chaque employé de voir son département.
 * Les chefs de département peuvent modifier et gérer les membres.
 * 
 * @author RowTech Team
 * @version 1.1 - Corrigé : vérification basée sur le chef réel du département
 */
@WebServlet("/monDepartement")
@SuppressWarnings("serial")
public class MonDepartementServlet extends HttpServlet {
    
    private DepartementDAO departementDAO;
    private EmployeDAO employeDAO;
    private UserDAO userDAO;
    private FicheDePaieDAO ficheDePaieDAO;
    
    @Override
    public void init() {
        departementDAO = new DepartementDAO();
        employeDAO = new EmployeDAO();
        userDAO = new UserDAO();
        ficheDePaieDAO = new FicheDePaieDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Vérifier que l'utilisateur est connecté
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth.jsp?erreur=non_connecte");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "afficher";
        
        try {
            switch (action) {
                case "afficher":
                    afficherMonDepartement(request, response);
                    break;
                case "modifier":
                    afficherFormulaireModification(request, response);
                    break;
                case "fichesPaieEquipe":
                    afficherFichesPaieEquipe(request, response);
                    break;
                case "gererMembres":
                    afficherGestionMembres(request, response);
                    break;
                default:
                    afficherMonDepartement(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Une erreur s'est produite : " + e.getMessage());
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Vérifier que l'utilisateur est connecté
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth.jsp?erreur=non_connecte");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "modifier":
                    modifierDepartement(request, response);
                    break;
                case "ajouterMembre":
                    ajouterMembre(request, response);
                    break;
                case "retirerMembre":
                    retirerMembre(request, response);
                    break;
                default:
                    response.sendRedirect("monDepartement?action=afficher");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("monDepartement?action=afficher&erreur=exception");
        }
    }
    
    /**
     * Vérifie si l'employé connecté est chef du département donné
     * @param employe L'employé connecté
     * @param departement Le département à vérifier
     * @return true si l'employé est chef de ce département
     */
    private boolean isChefDuDepartement(Employe employe, Departement departement) {
        if (employe == null || departement == null) {
            return false;
        }
        Employe chef = departement.getChefDepartement();
        return chef != null && chef.getId().equals(employe.getId());
    }
    
    /**
     * Récupère le département dont l'employé est chef ou membre
     * @param employe L'employé connecté
     * @return Le département trouvé ou null
     */
    private Departement getDepartementPourEmploye(Employe employe) {
        if (employe == null) return null;
        
        // D'abord vérifier s'il est chef d'un département
        Departement departement = departementDAO.getDepartementParChef(employe.getId());
        
        // Sinon, récupérer son département membre
        if (departement == null) {
            departement = employe.getDepartement();
        }
        
        return departement;
    }
    
    /**
     * Affiche le département de l'employé connecté
     */
    private void afficherMonDepartement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Récupérer l'utilisateur et son employé
        User user = userDAO.getUserById(userId);
        
        if (user == null || user.getEmploye() == null) {
            request.setAttribute("erreur", "Votre compte n'est pas lié à un employé.");
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
            return;
        }
        
        Employe employe = user.getEmploye();
        
        // Récupérer le département (chef ou membre)
        Departement departement = getDepartementPourEmploye(employe);
        
        if (departement == null) {
            request.setAttribute("aucunDepartement", true);
            request.getRequestDispatcher("/chefDepartement/aucunDepartement.jsp").forward(request, response);
            return;
        }
        
        // Récupérer les membres du département
        List<Employe> membres = departementDAO.getEmployesDuDepartement(departement.getId());
        
        // Vérifier si l'utilisateur est chef de ce département
        boolean isChef = isChefDuDepartement(employe, departement);
        
        request.setAttribute("departement", departement);
        request.setAttribute("membres", membres);
        request.setAttribute("isChef", isChef);
        request.setAttribute("employeConnecte", employe);
        
        request.getRequestDispatcher("/chefDepartement/monDepartement.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de modification du département (chefs uniquement)
     */
    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        // Récupérer le département dont l'employé est chef
        Departement departement = departementDAO.getDepartementParChef(employe.getId());
        
        // Vérifier les permissions : doit être chef de CE département ou admin
        if (departement == null && !RoleHelper.isAdmin(session)) {
            request.setAttribute("erreur", "Vous n'êtes pas chef d'un département.");
            request.getRequestDispatcher("/accessDenied.jsp").forward(request, response);
            return;
        }
        
        // Si admin sans être chef, récupérer le département via paramètre ou employé
        if (departement == null && RoleHelper.isAdmin(session)) {
            departement = employe.getDepartement();
        }
        
        if (departement == null) {
            response.sendRedirect("monDepartement?action=afficher&erreur=departement_introuvable");
            return;
        }
        
        request.setAttribute("departement", departement);
        request.getRequestDispatcher("/chefDepartement/modifierMonDepartement.jsp").forward(request, response);
    }
    
    /**
     * Modifie le département (chefs uniquement) - traitement POST
     */
    private void modifierDepartement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        // Récupérer le département dont l'employé est chef (pour vérifier les permissions)
        Departement departementChef = departementDAO.getDepartementParChef(employe.getId());
        
        // Vérifier les permissions : doit être chef de CE département ou admin
        if (departementChef == null && !RoleHelper.isAdmin(session)) {
            response.sendRedirect("monDepartement?action=afficher&erreur=non_autorise");
            return;
        }
        
        if (departementChef == null) {
            response.sendRedirect("monDepartement?action=afficher&erreur=departement_introuvable");
            return;
        }
        
        // Récupérer l'ID du département à modifier (depuis le formulaire ou depuis le département chef)
        String idParam = request.getParameter("id");
        Integer departementId = null;
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                departementId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                departementId = departementChef.getId();
            }
        } else {
            departementId = departementChef.getId();
        }
        
        // Vérifier que le chef modifie bien son propre département
        if (!departementId.equals(departementChef.getId()) && !RoleHelper.isAdmin(session)) {
            response.sendRedirect("monDepartement?action=afficher&erreur=non_autorise");
            return;
        }
        
        // Récupérer les nouvelles valeurs du formulaire
        String description = request.getParameter("description");
        
        // Mettre à jour la description via DAO (méthode simplifiée)
        boolean success = departementDAO.modifierDescription(departementId, description != null ? description.trim() : "");
        
        if (success) {
            response.sendRedirect("monDepartement?action=afficher&message=modification_ok");
        } else {
            response.sendRedirect("monDepartement?action=modifier&erreur=echec_modification");
        }
    }
    
    /**
     * Affiche les fiches de paie des membres du département (chefs uniquement)
     */
    private void afficherFichesPaieEquipe(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        // Récupérer le département dont l'employé est chef
        Departement departement = departementDAO.getDepartementParChef(employe.getId());
        
        // Vérifier les permissions : doit être chef de CE département ou admin
        if (departement == null && !RoleHelper.isAdmin(session)) {
            request.setAttribute("erreur", "Vous devez être chef de département pour voir les fiches de paie de l'équipe.");
            request.getRequestDispatcher("/accessDenied.jsp").forward(request, response);
            return;
        }
        
        // Si admin, récupérer le département de l'employé
        if (departement == null && RoleHelper.isAdmin(session)) {
            departement = employe.getDepartement();
        }
        
        if (departement == null) {
            request.setAttribute("erreur", "Département introuvable.");
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
            return;
        }
        
        // Récupérer les membres du département
        List<Employe> membres = departementDAO.getEmployesDuDepartement(departement.getId());
        
        // Récupérer les fiches de paie de tous les membres
        List<FicheDePaie> fichesDePaie = new ArrayList<>();
        for (Employe membre : membres) {
            List<FicheDePaie> fichesEmploye = ficheDePaieDAO.getFichesParEmploye(membre.getId());
            fichesDePaie.addAll(fichesEmploye);
        }
        
        // Trier par date (année desc, mois desc)
        fichesDePaie.sort((f1, f2) -> {
            int cmp = Integer.compare(f2.getAnnee(), f1.getAnnee());
            if (cmp == 0) {
                cmp = Integer.compare(f2.getMois(), f1.getMois());
            }
            return cmp;
        });
        
        request.setAttribute("departement", departement);
        request.setAttribute("fichesDePaie", fichesDePaie);
        request.setAttribute("membresEquipe", membres);
        
        request.getRequestDispatcher("/chefDepartement/fichePaieEquipe.jsp").forward(request, response);
    }
    
    /**
     * Affiche la page de gestion des membres (chefs uniquement)
     */
    private void afficherGestionMembres(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        // Récupérer le département dont l'employé est chef
        Departement departement = departementDAO.getDepartementParChef(employe.getId());
        
        // Vérifier les permissions : doit être chef de CE département ou admin
        if (departement == null && !RoleHelper.isAdmin(session)) {
            request.setAttribute("erreur", "Vous devez être chef de département pour gérer les membres.");
            request.getRequestDispatcher("/accessDenied.jsp").forward(request, response);
            return;
        }
        
        // Si admin, récupérer le département de l'employé
        if (departement == null && RoleHelper.isAdmin(session)) {
            departement = employe.getDepartement();
        }
        
        if (departement == null) {
            request.setAttribute("erreur", "Département introuvable.");
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
            return;
        }
        
        // Récupérer les membres actuels
        List<Employe> membres = departementDAO.getEmployesDuDepartement(departement.getId());
        
        // Récupérer tous les employés pour ajout
        List<Employe> tousLesEmployes = employeDAO.listerTous();
        
        // Retirer les membres déjà présents
        List<Employe> employesDisponibles = new ArrayList<>();
        for (Employe emp : tousLesEmployes) {
            boolean dejaMembre = false;
            for (Employe membre : membres) {
                if (membre.getId().equals(emp.getId())) {
                    dejaMembre = true;
                    break;
                }
            }
            if (!dejaMembre) {
                employesDisponibles.add(emp);
            }
        }
        
        request.setAttribute("departement", departement);
        request.setAttribute("membresActuels", membres);
        request.setAttribute("employesDisponibles", employesDisponibles);
        
        request.getRequestDispatcher("/chefDepartement/gererMembres.jsp").forward(request, response);
    }
    
    /**
     * Ajoute un membre au département (chefs uniquement)
     */
    private void ajouterMembre(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        // Récupérer le département dont l'employé est chef
        Departement departement = departementDAO.getDepartementParChef(employe.getId());
        
        // Vérifier les permissions
        if (departement == null && !RoleHelper.isAdmin(session)) {
            response.sendRedirect("monDepartement?action=afficher&erreur=non_autorise");
            return;
        }
        
        if (departement == null) {
            response.sendRedirect("monDepartement?action=afficher&erreur=departement_introuvable");
            return;
        }
        
        String employeIdStr = request.getParameter("employeId");
        if (employeIdStr != null && !employeIdStr.isEmpty()) {
            Integer employeId = Integer.parseInt(employeIdStr);
            Employe nouveauMembre = employeDAO.getEmployeById(employeId);
            
            if (nouveauMembre != null) {
                nouveauMembre.setDepartement(departement);
                employeDAO.modifierEmploye(nouveauMembre);
            }
        }
        
        response.sendRedirect("monDepartement?action=gererMembres&message=membre_ajoute");
    }
    
    /**
     * Retire un membre du département (chefs uniquement)
     */
    private void retirerMembre(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        // Récupérer le département dont l'employé est chef
        Departement departement = departementDAO.getDepartementParChef(employe.getId());
        
        // Vérifier les permissions
        if (departement == null && !RoleHelper.isAdmin(session)) {
            response.sendRedirect("monDepartement?action=afficher&erreur=non_autorise");
            return;
        }
        
        String employeIdStr = request.getParameter("employeId");
        if (employeIdStr != null && !employeIdStr.isEmpty()) {
            Integer employeId = Integer.parseInt(employeIdStr);
            Employe membre = employeDAO.getEmployeById(employeId);
            
            if (membre != null) {
                membre.setDepartement(null);
                employeDAO.modifierEmploye(membre);
            }
        }
        
        response.sendRedirect("monDepartement?action=gererMembres&message=membre_retire");
    }
}