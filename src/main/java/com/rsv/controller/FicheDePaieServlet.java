package com.rsv.controller;

import com.rsv.bdd.FicheDePaieDAO;
import com.rsv.bdd.EmployeDAO;
import com.rsv.bdd.DepartementDAO;
import com.rsv.bdd.ProjetDAO;
import com.rsv.bdd.UserDAO;
import com.rsv.model.FicheDePaie;
import com.rsv.model.Employe;
import com.rsv.model.Departement;
import com.rsv.model.Projet;
import com.rsv.model.User;
import com.rsv.model.UserRole;
import com.rsv.util.RoleHelper;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.HashSet;

/**
 * Servlet pour gérer les fiches de paie.
 * Version 2.2 - Correction accès admin sans employé associé
 * 
 * @author RowTech Team
 * @version 2.2
 */
@WebServlet("/fichesDePaie")
@SuppressWarnings("serial")
public class FicheDePaieServlet extends HttpServlet {

    private FicheDePaieDAO ficheDAO;
    private EmployeDAO employeDAO;
    private DepartementDAO departementDAO;
    private ProjetDAO projetDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        ficheDAO = new FicheDePaieDAO();
        employeDAO = new EmployeDAO();
        departementDAO = new DepartementDAO();
        projetDAO = new ProjetDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "lister";

        try {
            switch (action) {
                case "lister":
                    listerFiches(request, response);
                    break;
                case "nouvelle":
                case "nouveau":
                    afficherFormulaireAjout(request, response);
                    break;
                case "voir":
                    voirFiche(request, response);
                    break;
                case "rechercher":
                    afficherPageRecherche(request, response);
                    break;
                case "mesFiches":
                    afficherMesFiches(request, response);
                    break;
                case "supprimer":
                    supprimerFiche(request, response);
                    break;
                default:
                    listerFiches(request, response);
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

        String action = request.getParameter("action");

        try {
            if ("ajouter".equals(action) || "creer".equals(action)) {
                ajouterFiche(request, response);
            } else {
                response.sendRedirect("fichesDePaie?action=lister");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("fichesDePaie?action=lister&erreur=exception");
        }
    }
    
    // ==================== MÉTHODES HELPER POUR VÉRIFIER LE STATUT RÉEL ====================
    
    /**
     * Vérifie si l'employé est chef de département dans la BDD (pas basé sur le rôle session)
     */
    private boolean isChefDepartementReel(Employe employe) {
        if (employe == null) return false;
        Departement dept = departementDAO.getDepartementParChef(employe.getId());
        return dept != null;
    }
    
    /**
     * Vérifie si l'employé est chef de projet dans la BDD (pas basé sur le rôle session)
     */
    private boolean isChefProjetReel(Employe employe) {
        if (employe == null) return false;
        List<Projet> projets = projetDAO.listerProjetsParChef(employe.getId());
        return projets != null && !projets.isEmpty();
    }
    
    /**
     * Vérifie si l'utilisateur peut rechercher des fiches (basé sur rôle session OU statut réel)
     */
    private boolean peutRechercherFiches(HttpSession session, Employe employe) {
        // Admin peut toujours
        if (RoleHelper.isAdmin(session)) return true;
        
        // Chef département (rôle session OU statut réel)
        if (RoleHelper.isChefDepartement(session)) return true;
        if (isChefDepartementReel(employe)) return true;
        
        // Chef projet (rôle session OU statut réel)
        if (RoleHelper.isChefProjet(session)) return true;
        if (isChefProjetReel(employe)) return true;
        
        return false;
    }
    
    /**
     * Vérifie si l'utilisateur peut créer des fiches (basé sur rôle session OU statut réel)
     */
    private boolean peutCreerFiches(HttpSession session, Employe employe) {
        // Admin peut toujours
        if (RoleHelper.isAdmin(session)) return true;
        
        // Chef département (rôle session OU statut réel)
        if (RoleHelper.isChefDepartement(session)) return true;
        if (isChefDepartementReel(employe)) return true;
        
        // Chef projet (rôle session OU statut réel)
        if (RoleHelper.isChefProjet(session)) return true;
        if (isChefProjetReel(employe)) return true;
        
        return false;
    }

    // ==================== MÉTHODES DE LISTING ====================

    /**
     * Liste les fiches selon le rôle de l'utilisateur.
     * Admin: toutes les fiches (même sans employé associé)
     * Chef Département: fiches de son département
     * Chef Projet: fiches de ses projets
     * Employé: uniquement ses propres fiches
     */
    private void listerFiches(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth.jsp?erreur=non_connecte");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        
        if (user == null) {
            response.sendRedirect("auth.jsp?erreur=utilisateur_introuvable");
            return;
        }
        
        // CORRECTION: L'admin peut accéder même sans employé associé
        if (RoleHelper.isAdmin(session)) {
            // Admin voit toutes les fiches
            List<FicheDePaie> liste = ficheDAO.listerToutes();
            request.setAttribute("currentPage", "fiches");
            request.setAttribute("listeFiches", liste);
            request.getRequestDispatcher("/ficheDePaie/listeFiches.jsp").forward(request, response);
            return;
        }
        
        // Pour les non-admins, il faut un employé associé
        if (user.getEmploye() == null) {
            response.sendRedirect("auth.jsp?erreur=pas_employe");
            return;
        }
        
        Employe employeConnecte = user.getEmploye();
        List<FicheDePaie> liste;
        
        // Selon le rôle OU le statut réel, filtrer les fiches
        if (RoleHelper.isChefDepartement(session) || isChefDepartementReel(employeConnecte)) {
            // Chef département (rôle OU statut réel) voit les fiches de son département
            liste = getFichesChefDepartement(employeConnecte);
        } else if (RoleHelper.isChefProjet(session) || isChefProjetReel(employeConnecte)) {
            // Chef projet (rôle OU statut réel) voit les fiches de ses projets
            liste = getFichesChefProjet(employeConnecte);
        } else {
            // Employé simple voit uniquement ses fiches
            liste = ficheDAO.getFichesParEmploye(employeConnecte.getId());
        }

        request.setAttribute("currentPage", "fiches");
        request.setAttribute("listeFiches", liste);
        request.getRequestDispatcher("/ficheDePaie/listeFiches.jsp").forward(request, response);
    }
    
    /**
     * Récupère les fiches pour un chef de département
     */
    private List<FicheDePaie> getFichesChefDepartement(Employe chef) {
        List<FicheDePaie> fiches = new ArrayList<>();
        Set<Integer> employeIdsTraites = new HashSet<>();
        
        // Département dont l'employé est chef
        Departement dept = departementDAO.getDepartementParChef(chef.getId());
        
        if (dept != null) {
            List<Employe> membres = departementDAO.getEmployesDuDepartement(dept.getId());
            for (Employe membre : membres) {
                if (!employeIdsTraites.contains(membre.getId())) {
                    fiches.addAll(ficheDAO.getFichesParEmploye(membre.getId()));
                    employeIdsTraites.add(membre.getId());
                }
            }
        }
        
        // Ajouter ses propres fiches si pas déjà incluses
        if (!employeIdsTraites.contains(chef.getId())) {
            fiches.addAll(ficheDAO.getFichesParEmploye(chef.getId()));
        }
        
        return fiches;
    }
    
    /**
     * Récupère les fiches pour un chef de projet
     */
    private List<FicheDePaie> getFichesChefProjet(Employe chef) {
        List<FicheDePaie> fiches = new ArrayList<>();
        Set<Integer> employeIdsTraites = new HashSet<>();
        
        // Projets dont l'employé est chef
        List<Projet> projets = projetDAO.listerProjetsParChef(chef.getId());
        
        for (Projet projet : projets) {
            Set<Employe> membres = projet.getEmployes();
            if (membres != null) {
                for (Employe membre : membres) {
                    if (!employeIdsTraites.contains(membre.getId())) {
                        fiches.addAll(ficheDAO.getFichesParEmploye(membre.getId()));
                        employeIdsTraites.add(membre.getId());
                    }
                }
            }
        }
        
        // Ajouter ses propres fiches si pas déjà incluses
        if (!employeIdsTraites.contains(chef.getId())) {
            fiches.addAll(ficheDAO.getFichesParEmploye(chef.getId()));
        }
        
        return fiches;
    }

    // ==================== FORMULAIRE D'AJOUT ====================

    /**
     * Affiche le formulaire d'ajout de fiche de paie.
     */
    private void afficherFormulaireAjout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employeConnecte = user != null ? user.getEmploye() : null;
        
        // Vérifier si l'utilisateur peut créer des fiches
        if (!peutCreerFiches(session, employeConnecte)) {
            response.sendRedirect("fichesDePaie?action=lister&erreur=non_autorise");
            return;
        }

        // Liste des employés accessibles
        List<Employe> listeEmployes;
        
        if (RoleHelper.isAdmin(session)) {
            listeEmployes = employeDAO.listerTous();
        } else if (RoleHelper.isChefDepartement(session) || isChefDepartementReel(employeConnecte)) {
            Departement dept = departementDAO.getDepartementParChef(employeConnecte.getId());
            listeEmployes = dept != null ? departementDAO.getEmployesDuDepartement(dept.getId()) : new ArrayList<>();
        } else if (RoleHelper.isChefProjet(session) || isChefProjetReel(employeConnecte)) {
            Set<Integer> employeIds = new HashSet<>();
            listeEmployes = new ArrayList<>();
            List<Projet> projets = projetDAO.listerProjetsParChef(employeConnecte.getId());
            for (Projet projet : projets) {
                for (Employe membre : projetDAO.getEmployesDuProjet(projet.getId())) {
                    if (!employeIds.contains(membre.getId())) {
                        listeEmployes.add(membre);
                        employeIds.add(membre.getId());
                    }
                }
            }
        } else {
            listeEmployes = new ArrayList<>();
        }

        request.setAttribute("currentPage", "fiches");
        request.setAttribute("listeEmployes", listeEmployes);
     
        request.getRequestDispatcher("/ficheDePaie/formFicheDePaie.jsp").forward(request, response);
    }

 // ==================== VOIR UNE FICHE ====================

    /**
     * Affiche le détail d'une fiche de paie.
     */
    private void voirFiche(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idStr = request.getParameter("id");
            
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect("fichesDePaie?action=lister&erreur=id_manquant");
                return;
            }
            
            Integer ficheId = Integer.parseInt(idStr);
            
            FicheDePaie fiche = ficheDAO.getFicheById(ficheId);
            
            if (fiche == null) {
                response.sendRedirect("fichesDePaie?action=lister&erreur=fiche_introuvable");
                return;
            }
            
            // Vérifier les permissions
            if (!peutVoirFichesEmploye(request, fiche.getEmploye().getId())) {
                response.sendRedirect("fichesDePaie?action=lister&erreur=non_autorise");
                return;
            }

            request.setAttribute("currentPage", "fiches");
            request.setAttribute("fiche", fiche);
            
           
            request.getRequestDispatcher("/ficheDePaie/viewFichePaie.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("fichesDePaie?action=lister&erreur=id_invalide");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors du chargement de la fiche : " + e.getMessage());
            request.getRequestDispatcher("/erreur.jsp").forward(request, response);
        }
    }
    
    /**
     * Vérifie si l'utilisateur peut voir les fiches d'un employé donné
     */
    private boolean peutVoirFichesEmploye(HttpServletRequest request, Integer employeId) {
        HttpSession session = request.getSession(false);
        
        // Admin peut tout voir
        if (RoleHelper.isAdmin(session)) return true;
        
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        
        if (user == null || user.getEmploye() == null) return false;
        
        Employe employeConnecte = user.getEmploye();
        
        // C'est sa propre fiche
        if (employeConnecte.getId().equals(employeId)) return true;
        
        // Chef de département
        if (RoleHelper.isChefDepartement(session) || isChefDepartementReel(employeConnecte)) {
            Departement dept = departementDAO.getDepartementParChef(employeConnecte.getId());
            if (dept != null) {
                List<Employe> membres = departementDAO.getEmployesDuDepartement(dept.getId());
                for (Employe membre : membres) {
                    if (membre.getId().equals(employeId)) return true;
                }
            }
        }
        
        // Chef de projet
        if (RoleHelper.isChefProjet(session) || isChefProjetReel(employeConnecte)) {
            List<Projet> projets = projetDAO.listerProjetsParChef(employeConnecte.getId());
            for (Projet projet : projets) {
                for (Employe membre : projetDAO.getEmployesDuProjet(projet.getId())) {
                    if (membre.getId().equals(employeId)) return true;
                }
            }
        }
        
        return false;
    }

    // ==================== AJOUT DE FICHE ====================

    /**
     * Ajoute une nouvelle fiche de paie.
     */
    private void ajouterFiche(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employeConnecte = user != null ? user.getEmploye() : null;
        
        // Vérifier les permissions
        if (!peutCreerFiches(session, employeConnecte)) {
            response.sendRedirect("fichesDePaie?action=lister&erreur=non_autorise");
            return;
        }

        try {
            // === RÉCUPÉRATION DES PARAMÈTRES OBLIGATOIRES ===
            String employeIdStr = request.getParameter("employeId");
            String moisStr = request.getParameter("mois");
            String anneeStr = request.getParameter("annee");
            String salaireBaseStr = request.getParameter("salaireBase");
            
            // Validation des champs obligatoires
            if (employeIdStr == null || employeIdStr.trim().isEmpty() ||
                moisStr == null || moisStr.trim().isEmpty() ||
                anneeStr == null || anneeStr.trim().isEmpty() ||
                salaireBaseStr == null || salaireBaseStr.trim().isEmpty()) {
                
                response.sendRedirect("fichesDePaie?action=nouvelle&erreur=champs_manquants");
                return;
            }
            
            Integer employeId = Integer.parseInt(employeIdStr);
            int mois = Integer.parseInt(moisStr);
            int annee = Integer.parseInt(anneeStr);
            double salaireBase = Double.parseDouble(salaireBaseStr);
           
            // === RÉCUPÉRATION DES PARAMÈTRES OPTIONNELS ===
            double primes = 0.0;
            String primesStr = request.getParameter("primes");
            if (primesStr != null && !primesStr.trim().isEmpty()) {
                try {
                    primes = Double.parseDouble(primesStr);
                } catch (NumberFormatException e) {
                    primes = 0.0;
                }
            }
            
            double heuresSupp = 0.0;
            String heuresSuppStr = request.getParameter("heuresSupp");
            if (heuresSuppStr != null && !heuresSuppStr.trim().isEmpty()) {
                try {
                    heuresSupp = Double.parseDouble(heuresSuppStr);
                } catch (NumberFormatException e) {
                    heuresSupp = 0.0;
                }
            }
            
            double deductions = 0.0;
            String deductionsStr = request.getParameter("deductions");
            if (deductionsStr != null && !deductionsStr.trim().isEmpty()) {
                try {
                    deductions = Double.parseDouble(deductionsStr);
                } catch (NumberFormatException e) {
                    deductions = 0.0;
                }
            }
            
            int joursAbsence = 0;
            String joursAbsenceStr = request.getParameter("joursAbsence");
            if (joursAbsenceStr != null && !joursAbsenceStr.trim().isEmpty()) {
                try {
                    joursAbsence = Integer.parseInt(joursAbsenceStr);
                } catch (NumberFormatException e) {
                    joursAbsence = 0;
                }
            }
            
            // === VÉRIFIER LES PERMISSIONS ===
            if (!peutVoirFichesEmploye(request, employeId)) {
                response.sendRedirect("fichesDePaie?action=nouvelle&erreur=employe_non_autorise");
                return;
            }
            
            // === VÉRIFIER QUE L'EMPLOYÉ EXISTE ===
            Employe employe = employeDAO.getEmployeById(employeId);
            
            if (employe == null) {
                response.sendRedirect("fichesDePaie?action=nouvelle&erreur=employe_introuvable");
                return;
            }
            
            // ===VÉRIFIER QU'UNE FICHE N'EXISTE PAS DÉJÀ POUR CETTE PÉRIODE ===
            List<FicheDePaie> fichesExistantes = ficheDAO.getFichesParPeriode(mois, annee);
            for (FicheDePaie f : fichesExistantes) {
                if (f.getEmploye().getId().equals(employeId)) {
                    response.sendRedirect("fichesDePaie?action=nouvelle&erreur=fiche_existe");
                    return;
                }
            }
            
            // === CRÉER LA FICHE DE PAIE ===
            FicheDePaie fiche = new FicheDePaie();
            fiche.setEmploye(employe);
            fiche.setMois(mois);
            fiche.setAnnee(annee);
            fiche.setSalaireDeBase(salaireBase);
            fiche.setPrimes(primes);
            fiche.setHeuresSupp(heuresSupp);
            fiche.setDeductions(deductions);
            fiche.setJoursAbsence(joursAbsence);
            
           
            fiche.calculerTout();
            
            // === 8. ENREGISTRER EN BASE DE DONNÉES ===
            boolean success = ficheDAO.ajouterFiche(fiche);
            
            if (success) {
                System.out.println("✅ Fiche de paie créée avec succès pour " + employe.getNom() + " " + employe.getPrenom());
                response.sendRedirect("fichesDePaie?action=lister&message=creation_ok");
            } else {
                System.err.println("❌ Échec de la création de la fiche de paie");
                response.sendRedirect("fichesDePaie?action=nouvelle&erreur=echec_ajout");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            System.err.println("❌ Erreur de format de nombre : " + e.getMessage());
            response.sendRedirect("fichesDePaie?action=nouvelle&erreur=format_invalide");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Erreur lors de l'ajout de la fiche : " + e.getMessage());
            response.sendRedirect("fichesDePaie?action=nouvelle&erreur=exception");
        }
    }

    // ==================== RECHERCHE ====================

    /**
     * Affiche la page de recherche avec filtres.
     */
    private void afficherPageRecherche(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);
        Employe employeConnecte = user != null ? user.getEmploye() : null;
        
        // Vérifier les permissions de recherche
        if (!peutRechercherFiches(session, employeConnecte)) {
            response.sendRedirect("fichesDePaie?action=mesFiches&erreur=non_autorise");
            return;
        }

        String employeIdStr = request.getParameter("employeId");
        String moisStr = request.getParameter("mois");
        String anneeStr = request.getParameter("annee");

        List<FicheDePaie> resultats = null;
        boolean hasSearchCriteria = false;

        if ((employeIdStr != null && !employeIdStr.trim().isEmpty()) ||
            (moisStr != null && !moisStr.trim().isEmpty()) ||
            (anneeStr != null && !anneeStr.trim().isEmpty())) {
            
            hasSearchCriteria = true;
            
            // Récupérer les fiches accessibles selon le rôle OU statut réel
            List<FicheDePaie> toutes;
            
            if (RoleHelper.isAdmin(session)) {
                toutes = ficheDAO.listerToutes();
            } else if (RoleHelper.isChefDepartement(session) || isChefDepartementReel(employeConnecte)) {
                toutes = getFichesChefDepartement(employeConnecte);
            } else if (RoleHelper.isChefProjet(session) || isChefProjetReel(employeConnecte)) {
                toutes = getFichesChefProjet(employeConnecte);
            } else {
                toutes = ficheDAO.getFichesParEmploye(employeConnecte.getId());
            }
            
            resultats = new ArrayList<>();
            
            Integer employeId = null;
            Integer mois = null;
            Integer annee = null;
            
            try {
                if (employeIdStr != null && !employeIdStr.trim().isEmpty()) {
                    employeId = Integer.parseInt(employeIdStr);
                }
            } catch (NumberFormatException e) {}
            
            try {
                if (moisStr != null && !moisStr.trim().isEmpty()) {
                    mois = Integer.parseInt(moisStr);
                }
            } catch (NumberFormatException e) {}
            
            try {
                if (anneeStr != null && !anneeStr.trim().isEmpty()) {
                    annee = Integer.parseInt(anneeStr);
                }
            } catch (NumberFormatException e) {}
            
            for (FicheDePaie fiche : toutes) {
                boolean match = true;
                
                if (employeId != null && !fiche.getEmploye().getId().equals(employeId)) {
                    match = false;
                }
                
                if (mois != null && fiche.getMois() != mois) {
                    match = false;
                }
                
                if (annee != null && fiche.getAnnee() != annee) {
                    match = false;
                }
                
                if (match) {
                    resultats.add(fiche);
                }
            }
        }

        // Liste des employés accessibles pour le filtre
        List<Employe> listeEmployes;
        
        if (RoleHelper.isAdmin(session)) {
            listeEmployes = employeDAO.listerTous();
        } else if (RoleHelper.isChefDepartement(session) || isChefDepartementReel(employeConnecte)) {
            Departement dept = departementDAO.getDepartementParChef(employeConnecte.getId());
            listeEmployes = dept != null ? departementDAO.getEmployesDuDepartement(dept.getId()) : new ArrayList<>();
        } else if (RoleHelper.isChefProjet(session) || isChefProjetReel(employeConnecte)) {
            Set<Integer> employeIds = new HashSet<>();
            listeEmployes = new ArrayList<>();
            List<Projet> projets = projetDAO.listerProjetsParChef(employeConnecte.getId());
            for (Projet projet : projets) {
                for (Employe membre : projetDAO.getEmployesDuProjet(projet.getId())) {
                    if (!employeIds.contains(membre.getId())) {
                        listeEmployes.add(membre);
                        employeIds.add(membre.getId());
                    }
                }
            }
        } else {
            listeEmployes = new ArrayList<>();
        }

        request.setAttribute("currentPage", "fiches");
        request.setAttribute("listeEmployes", listeEmployes);
        
        if (hasSearchCriteria) {
            request.setAttribute("resultats", resultats);
        }
        
        request.getRequestDispatcher("/ficheDePaie/rechercherFiches.jsp").forward(request, response);
    }

    // ==================== MES FICHES ====================

    /**
     * Affiche les fiches de paie de l'employé connecté + celles de son équipe si chef.
     */
    private void afficherMesFiches(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth.jsp?erreur=non_connecte");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);

        if (user == null || user.getEmploye() == null) {
            response.sendRedirect("auth.jsp?erreur=pas_employe");
            return;
        }

        Employe employe = user.getEmploye();
        List<FicheDePaie> fiches;
        
        // Selon le rôle OU statut réel, afficher différentes fiches
        if (RoleHelper.isChefDepartement(session) || isChefDepartementReel(employe)) {
            fiches = getFichesChefDepartement(employe);
        } else if (RoleHelper.isChefProjet(session) || isChefProjetReel(employe)) {
            fiches = getFichesChefProjet(employe);
        } else {
            fiches = ficheDAO.getFichesParEmploye(employe.getId());
        }

        request.setAttribute("currentPage", "fiches");
        request.setAttribute("listeFiches", fiches);
        request.setAttribute("employe", employe);
        request.getRequestDispatcher("/ficheDePaie/listeFiches.jsp").forward(request, response);
    }
    
    // ==================== SUPPRESSION ====================
    
    /**
     * Supprime une fiche de paie
     */
    private void supprimerFiche(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        try {
            String idStr = request.getParameter("id");
            Integer ficheId = Integer.parseInt(idStr);
            
            FicheDePaie fiche = ficheDAO.getFicheById(ficheId);
            
            if (fiche == null) {
                response.sendRedirect("fichesDePaie?action=lister&erreur=fiche_introuvable");
                return;
            }
            
            // Vérifier les permissions
            if (!peutVoirFichesEmploye(request, fiche.getEmploye().getId())) {
                response.sendRedirect("fichesDePaie?action=lister&erreur=non_autorise");
                return;
            }
            
            Integer userId = (Integer) session.getAttribute("userId");
            User user = userDAO.getUserById(userId);
            Employe employeConnecte = user != null ? user.getEmploye() : null;
            
            // Seuls admin et chefs (rôle OU statut réel) peuvent supprimer
            boolean peutSupprimer = RoleHelper.isAdmin(session) || 
                                    RoleHelper.isChefDepartement(session) || 
                                    RoleHelper.isChefProjet(session) ||
                                    isChefDepartementReel(employeConnecte) ||
                                    isChefProjetReel(employeConnecte);
            
            if (!peutSupprimer) {
                response.sendRedirect("fichesDePaie?action=lister&erreur=non_autorise");
                return;
            }
            
            boolean success = ficheDAO.supprimerFiche(ficheId);
            
            if (success) {
                response.sendRedirect("fichesDePaie?action=lister&message=suppression_ok");
            } else {
                response.sendRedirect("fichesDePaie?action=lister&erreur=echec_suppression");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("fichesDePaie?action=lister&erreur=exception");
        }
    }
}