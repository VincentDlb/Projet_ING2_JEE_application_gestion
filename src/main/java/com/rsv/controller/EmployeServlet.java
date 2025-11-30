package com.rsv.controller;

import com.rsv.bdd.EmployeDAO;
import com.rsv.bdd.DepartementDAO;
import com.rsv.model.Employe;
import com.rsv.model.Departement;
import com.rsv.util.ValidationUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet qui gère toutes les opérations sur les employés
 */
@WebServlet("/employes")
@SuppressWarnings("serial")
public class EmployeServlet extends HttpServlet {
    
    private EmployeDAO employeDAO;
    
    @Override
    public void init() {
        employeDAO = new EmployeDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "lister";
        
        try {
            switch (action) {
                case "lister":
                    listerEmployes(request, response);
                    break;
                case "nouveau":
                    afficherFormulaireAjout(request, response);
                    break;
                case "modifier":
                    afficherFormulaireModification(request, response);
                    break;
                case "supprimer":
                    supprimerEmploye(request, response);
                    break;
                case "rechercher":
                    afficherPageRecherche(request, response);
                    break;
                case "filtrer":
                    filtrerEmployes(request, response);
                    break;
                default:
                    listerEmployes(request, response);
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
        
        if ("ajouter".equals(action)) {
            ajouterEmploye(request, response);
        } else if ("modifier".equals(action)) {
            modifierEmploye(request, response);
        } else {
            response.sendRedirect("employes?action=lister");
        }
    }
    
    /**
     * Liste tous les employés
     */
    private void listerEmployes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Employe> liste = employeDAO.listerTous();
        
        // Charger les départements pour le filtre
        DepartementDAO departementDAO = new DepartementDAO();
        List<Departement> departements = departementDAO.listerTous();
        
        request.setAttribute("listeEmployes", liste);
        request.setAttribute("departements", departements);
        request.getRequestDispatcher("/employe/gestionnaireEmploye.jsp").forward(request, response);
    }
    
    /**
     * Filtre les employés selon plusieurs critères combinés
     */
    private void filtrerEmployes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String departementIdStr = request.getParameter("departement");
        String grade = request.getParameter("grade");
        String poste = request.getParameter("poste");
        
        // Commencer avec tous les employés
        List<Employe> liste = employeDAO.listerTous();
        
        // Appliquer les filtres successivement
        if (departementIdStr != null && !departementIdStr.isEmpty()) {
            Integer deptId = Integer.parseInt(departementIdStr);
            liste = liste.stream()
                         .filter(emp -> emp.getDepartement() != null && emp.getDepartement().getId().equals(deptId))
                         .collect(java.util.stream.Collectors.toList());
        }
        
        if (grade != null && !grade.isEmpty()) {
            liste = liste.stream()
                         .filter(emp -> grade.equals(emp.getGrade()))
                         .collect(java.util.stream.Collectors.toList());
        }
        
        if (poste != null && !poste.isEmpty()) {
            liste = liste.stream()
                         .filter(emp -> poste.equals(emp.getPoste()))
                         .collect(java.util.stream.Collectors.toList());
        }
        
        // Charger les départements pour les filtres
        DepartementDAO departementDAO = new DepartementDAO();
        List<Departement> departements = departementDAO.listerTous();
        
        // Conserver les valeurs des filtres
        request.setAttribute("listeEmployes", liste);
        request.setAttribute("departements", departements);
        request.setAttribute("filtreDepartement", departementIdStr);
        request.setAttribute("filtreGrade", grade);
        request.setAttribute("filtrePoste", poste);
        
        // Indicateur pour savoir si des filtres sont actifs
        boolean filtresActifs = (departementIdStr != null && !departementIdStr.isEmpty()) || 
                                (grade != null && !grade.isEmpty()) || 
                                (poste != null && !poste.isEmpty());
        request.setAttribute("filtresActifs", filtresActifs);
        
        request.getRequestDispatcher("/employe/gestionnaireEmploye.jsp").forward(request, response);
    }
    
    /**
     * Affiche la page de recherche avancée
     */
    private void afficherPageRecherche(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Charger la liste des départements pour le filtre
        DepartementDAO departementDAO = new DepartementDAO();
        List<Departement> departements = departementDAO.listerTous();
        
        // Récupérer les critères de recherche
        String critere = request.getParameter("critere");
        String valeur = request.getParameter("valeur");
        
        List<Employe> resultats = null;
        
        // Si des critères sont fournis, effectuer la recherche
        if (critere != null && valeur != null && !valeur.trim().isEmpty()) {
            resultats = rechercherEmployesParCritere(critere, valeur);
        }
        
        request.setAttribute("departements", departements);
        request.setAttribute("resultats", resultats);
        request.getRequestDispatcher("/employe/rechercherEmploye.jsp").forward(request, response);
    }
    
    /**
     * Recherche des employés selon le critère
     */
    private List<Employe> rechercherEmployesParCritere(String critere, String valeur) {
        try {
            switch (critere) {
                case "nom":
                    return employeDAO.rechercherParNom(valeur);
                    
                case "prenom":
                    return employeDAO.rechercherParPrenom(valeur);
                    
                case "matricule":
                    Employe emp = employeDAO.rechercherParMatricule(valeur);
                    return emp != null ? List.of(emp) : new ArrayList<>();
                    
                case "departement":
                    Integer departementId = Integer.parseInt(valeur);
                    return employeDAO.listerParDepartement(departementId);
                    
                case "grade":
                    return employeDAO.listerParGrade(valeur);
                    
                case "poste":
                    return employeDAO.listerParPoste(valeur);
                    
                default:
                    return new ArrayList<>();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * Affiche le formulaire d'ajout
     * ⭐ CORRECTION : Utilisation de "listeDepartements" au lieu de "departements"
     */
    private void afficherFormulaireAjout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        DepartementDAO departementDAO = new DepartementDAO();
        List<Departement> departements = departementDAO.listerTous();
        
        // ⭐ CORRECTION ICI : Nom d'attribut cohérent avec le JSP
        request.setAttribute("listeDepartements", departements);
        request.getRequestDispatcher("/employe/ajouterEmploye.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de modification
     */
    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            // Charger l'employé avec ses projets
            Employe employe = employeDAO.getEmployeAvecProjets(id);
            
            if (employe == null) {
                response.sendRedirect("employes?action=lister&erreur=employe_introuvable");
                return;
            }
            
            // Charger les départements
            DepartementDAO departementDAO = new DepartementDAO();
            List<Departement> departements = departementDAO.listerTous();
            
            // Charger TOUS les projets pour affichage dans le formulaire
            com.rsv.bdd.ProjetDAO projetDAO = new com.rsv.bdd.ProjetDAO();
            List<com.rsv.model.Projet> projets = projetDAO.listerTous();
            
            request.setAttribute("employe", employe);
            request.setAttribute("listeDepartements", departements);
            request.setAttribute("listeProjets", projets);
            request.getRequestDispatcher("/employe/modifierEmploye.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("employes?action=lister&erreur=exception");
        }
    }
    
    /**
     * Ajoute un nouvel employé
     * ⭐ CORRECTION : Recharger listeDepartements en cas d'erreur
     */
    private void ajouterEmploye(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Récupération des données du formulaire
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String telephone = request.getParameter("telephone");
            String adresse = request.getParameter("adresse");
            String matricule = request.getParameter("matricule");
            String poste = request.getParameter("poste");
            String grade = request.getParameter("grade");
            String salaireStr = request.getParameter("salaire");
            String dateEmbaucheStr = request.getParameter("dateEmbauche");
            String departementIdStr = request.getParameter("departementId");
            
            // Validation côté serveur
            List<String> erreurs = ValidationUtil.validerEmploye(nom, prenom, email, matricule, telephone, salaireStr);
            
            if (!erreurs.isEmpty()) {
                request.setAttribute("erreurs", erreurs);
                
                // ⭐ CORRECTION : Recharger la liste des départements
                DepartementDAO departementDAO = new DepartementDAO();
                List<Departement> departements = departementDAO.listerTous();
                request.setAttribute("listeDepartements", departements);
                
                request.getRequestDispatcher("/employe/ajouterEmploye.jsp").forward(request, response);
                return;
            }
            
            // Conversion des types
            Double salaire = Double.parseDouble(salaireStr);
            LocalDate dateEmbauche = LocalDate.parse(dateEmbaucheStr);
            
            // Création de l'objet Employe
            Employe employe = new Employe();
            employe.setNom(nom.trim());
            employe.setPrenom(prenom.trim());
            employe.setEmail(email.trim().toLowerCase());
            employe.setTelephone(telephone != null ? telephone.trim() : null);
            employe.setAdresse(adresse != null ? adresse.trim() : null);
            employe.setMatricule(matricule.trim().toUpperCase());
            employe.setPoste(poste.trim());
            employe.setGrade(grade);
            employe.setSalaire(salaire);
            employe.setDateEmbauche(dateEmbauche);
            
            // Département (optionnel)
            if (departementIdStr != null && !departementIdStr.isEmpty()) {
                Integer departementId = Integer.parseInt(departementIdStr);
                DepartementDAO departementDAO = new DepartementDAO();
                Departement departement = departementDAO.getDepartementById(departementId);
                employe.setDepartement(departement);
            }
            
            // Sauvegarde
            boolean success = employeDAO.ajouterEmploye(employe);
            
            if (success) {
                response.sendRedirect("employes?action=lister&message=ajout_ok");
            } else {
                response.sendRedirect("employes?action=nouveau&erreur=echec_ajout");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            
            // ⭐ CORRECTION : Recharger la liste en cas d'exception
            request.setAttribute("erreur", "Erreur lors de l'ajout : " + e.getMessage());
            DepartementDAO departementDAO = new DepartementDAO();
            List<Departement> departements = departementDAO.listerTous();
            request.setAttribute("listeDepartements", departements);
            
            request.getRequestDispatcher("/employe/ajouterEmploye.jsp").forward(request, response);
        }
    }
    
    /**
     * Modifie un employé existant
     */
    private void modifierEmploye(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            // Récupération de l'employé
            Employe employe = employeDAO.getEmployeById(id);
            
            if (employe == null) {
                response.sendRedirect("employes?action=lister&erreur=employe_introuvable");
                return;
            }
            
            // Récupération des données
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String telephone = request.getParameter("telephone");
            String adresse = request.getParameter("adresse");
            String poste = request.getParameter("poste");
            String grade = request.getParameter("grade");
            String salaireStr = request.getParameter("salaire");
            String dateEmbaucheStr = request.getParameter("dateEmbauche");
            String departementIdStr = request.getParameter("departementId");
            
            // Récupération des projets sélectionnés
            String[] projetIdsStr = request.getParameterValues("projetIds");
            List<Integer> projetIds = new ArrayList<>();
            if (projetIdsStr != null) {
                for (String projetIdStr : projetIdsStr) {
                    try {
                        projetIds.add(Integer.parseInt(projetIdStr));
                    } catch (NumberFormatException e) {
                        // Ignorer les valeurs invalides
                    }
                }
            }
            
            // Validation (sans matricule car non modifiable)
            List<String> erreurs = new ArrayList<>();
            String erreurNom = ValidationUtil.validerNomPrenom(nom, "Nom");
            if (erreurNom != null) erreurs.add(erreurNom);
            
            String erreurPrenom = ValidationUtil.validerNomPrenom(prenom, "Prénom");
            if (erreurPrenom != null) erreurs.add(erreurPrenom);
            
            String erreurEmail = ValidationUtil.validerEmail(email);
            if (erreurEmail != null) erreurs.add(erreurEmail);
            
            String erreurSalaire = ValidationUtil.validerSalaire(salaireStr);
            if (erreurSalaire != null) erreurs.add(erreurSalaire);
            
            if (!erreurs.isEmpty()) {
                request.setAttribute("erreurs", erreurs);
                request.setAttribute("employe", employe);
                afficherFormulaireModification(request, response);
                return;
            }
            
            // Mise à jour des champs
            employe.setNom(nom.trim());
            employe.setPrenom(prenom.trim());
            employe.setEmail(email.trim().toLowerCase());
            employe.setTelephone(telephone != null ? telephone.trim() : null);
            employe.setAdresse(adresse != null ? adresse.trim() : null);
            employe.setPoste(poste.trim());
            employe.setGrade(grade);
            employe.setSalaire(Double.parseDouble(salaireStr));
            employe.setDateEmbauche(LocalDate.parse(dateEmbaucheStr));
            
            // Département
            if (departementIdStr != null && !departementIdStr.isEmpty()) {
                Integer departementId = Integer.parseInt(departementIdStr);
                DepartementDAO departementDAO = new DepartementDAO();
                Departement departement = departementDAO.getDepartementById(departementId);
                employe.setDepartement(departement);
            } else {
                employe.setDepartement(null);
            }
            
            // Appeler la méthode qui gère aussi les projets
            boolean success = employeDAO.modifierEmployeAvecProjets(employe, projetIds);
            
            if (success) {
                response.sendRedirect("employes?action=lister&message=modification_ok");
            } else {
                response.sendRedirect("employes?action=modifier&id=" + id + "&erreur=echec_modification");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("employes?action=lister&erreur=exception");
        }
    }
    
    /**
     * Supprime un employé
     */
    private void supprimerEmploye(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            Integer id = Integer.parseInt(idStr);
            
            boolean success = employeDAO.supprimerEmploye(id);
            
            if (success) {
                response.sendRedirect("employes?action=lister&message=suppression_ok");
            } else {
                response.sendRedirect("employes?action=lister&erreur=echec_suppression");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("employes?action=lister&erreur=exception");
        }
    }
}