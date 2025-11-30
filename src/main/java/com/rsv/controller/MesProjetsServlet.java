package com.rsv.controller;

import com.rsv.bdd.ProjetDAO;
import com.rsv.bdd.EmployeDAO;
import com.rsv.bdd.UserDAO;
import com.rsv.bdd.FicheDePaieDAO;
import com.rsv.model.Projet;
import com.rsv.model.Employe;
import com.rsv.model.User;
import com.rsv.model.FicheDePaie;
import com.rsv.util.RoleHelper;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.HashSet;

/**
 * Servlet pour gérer "Mes Projets".
 * Permet à chaque employé de voir ses projets (comme membre ou chef).
 * Les chefs de projet peuvent modifier et gérer les membres.
 * 
 * @author RowTech Team
 * @version 1.1 - Corrigé pour pointer vers /projet/
 */
@WebServlet("/mesProjets")
@SuppressWarnings("serial")
public class MesProjetsServlet extends HttpServlet {
    
    private ProjetDAO projetDAO;
    private EmployeDAO employeDAO;
    private UserDAO userDAO;
    private FicheDePaieDAO ficheDePaieDAO;
    
    @Override
    public void init() {
        projetDAO = new ProjetDAO();
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
        if (action == null) action = "lister";
        
        try {
            switch (action) {
                case "lister":
                    listerMesProjets(request, response);
                    break;
                case "detail":
                    afficherDetailProjet(request, response);
                    break;
                case "modifier":
                    afficherFormulaireModification(request, response);
                    break;
                case "gererEquipe":
                    afficherGestionEquipe(request, response);
                    break;
                case "fichesPaieEquipe":
                    afficherFichesPaieEquipe(request, response);
                    break;
                default:
                    listerMesProjets(request, response);
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
                    modifierProjet(request, response);
                    break;
                case "ajouterMembre":
                    ajouterMembre(request, response);
                    break;
                case "retirerMembre":
                    retirerMembre(request, response);
                    break;
                default:
                    response.sendRedirect("mesProjets?action=lister");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("mesProjets?action=lister&erreur=exception");
        }
    }
    
    /**
     * Liste tous les projets de l'employé connecté (comme membre ou chef)
     */
    private void listerMesProjets(HttpServletRequest request, HttpServletResponse response) 
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
        
        // Récupérer tous les projets où l'employé est membre ou chef
        List<Projet> mesProjets = projetDAO.listerTousMesProjets(employe.getId());
        
        // Récupérer les projets où l'employé est chef
        List<Projet> projetsChef = projetDAO.listerProjetsParChef(employe.getId());
        Set<Integer> projetsChefIds = new HashSet<>();
        for (Projet p : projetsChef) {
            projetsChefIds.add(p.getId());
        }
        
        request.setAttribute("mesProjets", mesProjets);
        request.setAttribute("projetsChefIds", projetsChefIds);
        request.setAttribute("employeConnecte", employe);
        
        
        request.getRequestDispatcher("/chefProjet/mesProjets.jsp").forward(request, response);
    }
    
    /**
     * Affiche les détails d'un projet
     */
    private void afficherDetailProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("mesProjets?action=lister&erreur=id_manquant");
            return;
        }
        
        Integer projetId = Integer.parseInt(idStr);
        Projet projet = projetDAO.getProjetAvecEmployes(projetId);
        
        if (projet == null) {
            response.sendRedirect("mesProjets?action=lister&erreur=projet_introuvable");
            return;
        }
        
        // Vérifier que l'employé appartient au projet
        if (!projetDAO.appartientAuProjet(projetId, employe.getId())) {
            request.setAttribute("erreur", "Vous n'avez pas accès à ce projet.");
            request.getRequestDispatcher("/accessDenied.jsp").forward(request, response);
            return;
        }
        
        // Vérifier si l'utilisateur est chef de ce projet
        boolean isChefDuProjet = projet.getChefDeProjet() != null 
            && projet.getChefDeProjet().getId().equals(employe.getId());
        
        request.setAttribute("projet", projet);
        request.setAttribute("isChef", isChefDuProjet);
        
        
        request.getRequestDispatcher("/projet/detailProjet.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de modification (chefs uniquement)
     */
    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("mesProjets?action=lister&erreur=id_manquant");
            return;
        }
        
        Integer projetId = Integer.parseInt(idStr);
        Projet projet = projetDAO.getProjetAvecEmployes(projetId);
        
        if (projet == null) {
            response.sendRedirect("mesProjets?action=lister&erreur=projet_introuvable");
            return;
        }
        
        // Vérifier les permissions (chef du projet ou admin)
        boolean isChefDuProjet = projet.getChefDeProjet() != null 
            && projet.getChefDeProjet().getId().equals(employe.getId());
        
        if (!isChefDuProjet && !RoleHelper.isAdmin(session)) {
            request.setAttribute("erreur", "Vous n'avez pas les droits pour modifier ce projet.");
            request.getRequestDispatcher("/accessDenied.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("projet", projet);
        
        
        request.getRequestDispatcher("/projet/modifierProjet.jsp").forward(request, response);
    }
    
    /**
     * Modifie un projet (POST)
     */
    private void modifierProjet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        String idStr = request.getParameter("id");
        Integer projetId = Integer.parseInt(idStr);
        Projet projet = projetDAO.getProjetById(projetId);
        
        // Vérifier les permissions
        boolean isChefDuProjet = projet.getChefDeProjet() != null 
            && projet.getChefDeProjet().getId().equals(employe.getId());
        
        if (!isChefDuProjet && !RoleHelper.isAdmin(session)) {
            response.sendRedirect("mesProjets?action=lister&erreur=non_autorise");
            return;
        }
        
        // Récupérer les données du formulaire
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        String etat = request.getParameter("etat");
        String dateDebutStr = request.getParameter("dateDebut");
        String dateFinStr = request.getParameter("dateFin");
        
        // Mettre à jour le projet
        projet.setNom(nom);
        projet.setDescription(description);
        projet.setEtat(etat);
        
        if (dateDebutStr != null && !dateDebutStr.isEmpty()) {
            projet.setDateDebut(LocalDate.parse(dateDebutStr));
        }
        if (dateFinStr != null && !dateFinStr.isEmpty()) {
            projet.setDateFin(LocalDate.parse(dateFinStr));
        }
        
        projetDAO.modifierProjet(projet);
        
        response.sendRedirect("mesProjets?action=lister&message=modification_ok");
    }
    
    /**
     * Affiche la page de gestion d'équipe (chefs uniquement)
     */
    private void afficherGestionEquipe(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("mesProjets?action=lister&erreur=id_manquant");
            return;
        }
        
        Integer projetId = Integer.parseInt(idStr);
        Projet projet = projetDAO.getProjetAvecEmployes(projetId);
        
        if (projet == null) {
            response.sendRedirect("mesProjets?action=lister&erreur=projet_introuvable");
            return;
        }
        
        // Vérifier les permissions
        boolean isChefDuProjet = projet.getChefDeProjet() != null 
            && projet.getChefDeProjet().getId().equals(employe.getId());
        
        if (!isChefDuProjet && !RoleHelper.isAdmin(session)) {
            request.setAttribute("erreur", "Vous n'avez pas les droits pour gérer cette équipe.");
            request.getRequestDispatcher("/accessDenied.jsp").forward(request, response);
            return;
        }
        
        // Récupérer tous les employés pour ajout
        List<Employe> tousLesEmployes = employeDAO.listerTous();
        
        // Retirer les membres déjà présents
        Set<Employe> membresActuels = projet.getEmployes();
        List<Employe> employesDisponibles = new ArrayList<>();
        
        for (Employe emp : tousLesEmployes) {
            boolean dejaMembre = false;
            for (Employe membre : membresActuels) {
                if (membre.getId().equals(emp.getId())) {
                    dejaMembre = true;
                    break;
                }
            }
            // Ne pas inclure le chef de projet dans les disponibles
            if (projet.getChefDeProjet() != null && emp.getId().equals(projet.getChefDeProjet().getId())) {
                dejaMembre = true;
            }
            if (!dejaMembre) {
                employesDisponibles.add(emp);
            }
        }
        
        request.setAttribute("projet", projet);
        request.setAttribute("employesDisponibles", employesDisponibles);
        
        
        request.getRequestDispatcher("/projet/gererEquipe.jsp").forward(request, response);
    }
    
    /**
     * Ajoute un membre au projet (chefs uniquement)
     */
    private void ajouterMembre(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        String projetIdStr = request.getParameter("projetId");
        String employeIdStr = request.getParameter("employeId");
        
        Integer projetId = Integer.parseInt(projetIdStr);
        Projet projet = projetDAO.getProjetById(projetId);
        
        // Vérifier les permissions
        boolean isChefDuProjet = projet.getChefDeProjet() != null 
            && projet.getChefDeProjet().getId().equals(employe.getId());
        
        if (!isChefDuProjet && !RoleHelper.isAdmin(session)) {
            response.sendRedirect("mesProjets?action=lister&erreur=non_autorise");
            return;
        }
        
        Integer employeId = Integer.parseInt(employeIdStr);
        projetDAO.ajouterEmployeAuProjet(projetId, employeId);
        
        response.sendRedirect("mesProjets?action=gererEquipe&id=" + projetId + "&message=membre_ajoute");
    }
    
    /**
     * Retire un membre du projet (chefs uniquement)
     */
    private void retirerMembre(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        String projetIdStr = request.getParameter("projetId");
        String employeIdStr = request.getParameter("employeId");
        
        Integer projetId = Integer.parseInt(projetIdStr);
        Projet projet = projetDAO.getProjetById(projetId);
        
        // Vérifier les permissions
        boolean isChefDuProjet = projet.getChefDeProjet() != null 
            && projet.getChefDeProjet().getId().equals(employe.getId());
        
        if (!isChefDuProjet && !RoleHelper.isAdmin(session)) {
            response.sendRedirect("mesProjets?action=lister&erreur=non_autorise");
            return;
        }
        
        Integer employeId = Integer.parseInt(employeIdStr);
        projetDAO.retirerEmployeDuProjet(projetId, employeId);
        
        response.sendRedirect("mesProjets?action=gererEquipe&id=" + projetId + "&message=membre_retire");
    }
    
    /**
     * Affiche les fiches de paie des membres du projet (chefs uniquement)
     */
    private void afficherFichesPaieEquipe(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employe = user.getEmploye();
        
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("mesProjets?action=lister&erreur=id_manquant");
            return;
        }
        
        Integer projetId = Integer.parseInt(idStr);
        Projet projet = projetDAO.getProjetAvecEmployes(projetId);
        
        if (projet == null) {
            response.sendRedirect("mesProjets?action=lister&erreur=projet_introuvable");
            return;
        }
        
        // Vérifier les permissions
        boolean isChefDuProjet = projet.getChefDeProjet() != null 
            && projet.getChefDeProjet().getId().equals(employe.getId());
        
        if (!isChefDuProjet && !RoleHelper.isAdmin(session)) {
            request.setAttribute("erreur", "Vous n'avez pas les droits pour voir ces fiches.");
            request.getRequestDispatcher("/accessDenied.jsp").forward(request, response);
            return;
        }
        
        // Récupérer les fiches de paie de tous les membres
        List<FicheDePaie> fichesDePaie = new ArrayList<>();
        Set<Employe> membresProjet = projet.getEmployes();
        
        if (membresProjet != null && !membresProjet.isEmpty()) {
            for (Employe membre : membresProjet) {
                List<FicheDePaie> fichesEmploye = ficheDePaieDAO.getFichesParEmploye(membre.getId());
                fichesDePaie.addAll(fichesEmploye);
            }
        }
        
        // Ajouter aussi les fiches du chef s'il n'est pas dans les membres
        if (projet.getChefDeProjet() != null) {
            boolean chefDansMembres = false;
            if (membresProjet != null) {
                for (Employe membre : membresProjet) {
                    if (membre.getId().equals(projet.getChefDeProjet().getId())) {
                        chefDansMembres = true;
                        break;
                    }
                }
            }
            if (!chefDansMembres) {
                List<FicheDePaie> fichesChef = ficheDePaieDAO.getFichesParEmploye(projet.getChefDeProjet().getId());
                fichesDePaie.addAll(fichesChef);
            }
        }
        
        // Trier par date (année desc, mois desc)
        fichesDePaie.sort((f1, f2) -> {
            int cmp = Integer.compare(f2.getAnnee(), f1.getAnnee());
            if (cmp == 0) {
                cmp = Integer.compare(f2.getMois(), f1.getMois());
            }
            return cmp;
        });
        
        request.setAttribute("projet", projet);
        request.setAttribute("fichesDePaie", fichesDePaie);
        
   
        request.getRequestDispatcher("/chefProjet/fichesPaieEquipe.jsp").forward(request, response);
    }
}