package com.rsv.util;

import java.util.regex.Pattern;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe utilitaire pour la validation des données côté serveur
 */
public class ValidationUtil {
    
    // Patterns de validation
    private static final Pattern PATTERN_NOM_PRENOM = Pattern.compile("^[a-zA-ZÀ-ÿ\\s\\-']+$");
    private static final Pattern PATTERN_EMAIL = Pattern.compile("^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$");
    private static final Pattern PATTERN_MATRICULE = Pattern.compile("^[A-Z0-9\\-]+$");
    private static final Pattern PATTERN_TELEPHONE = Pattern.compile("^[0-9\\s\\+\\-\\(\\)]+$");
    
    /**
     * Valide un nom ou prénom
     */
    public static String validerNomPrenom(String valeur, String champNom) {
        if (valeur == null || valeur.trim().isEmpty()) {
            return "Le " + champNom + " est obligatoire.";
        }
        if (!PATTERN_NOM_PRENOM.matcher(valeur).matches()) {
            return "Le " + champNom + " ne peut contenir que des lettres, espaces, tirets et apostrophes.";
        }
        if (valeur.length() < 2) {
            return "Le " + champNom + " doit contenir au moins 2 caractères.";
        }
        if (valeur.length() > 50) {
            return "Le " + champNom + " ne peut pas dépasser 50 caractères.";
        }
        return null;
    }
    
    /**
     * Valide un email
     */
    public static String validerEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return "L'email est obligatoire.";
        }
        if (!PATTERN_EMAIL.matcher(email).matches()) {
            return "L'email doit être au format valide (exemple@domaine.com).";
        }
        return null;
    }
    
    /**
     * Valide un matricule
     */
    public static String validerMatricule(String matricule) {
        if (matricule == null || matricule.trim().isEmpty()) {
            return "Le matricule est obligatoire.";
        }
        if (!PATTERN_MATRICULE.matcher(matricule).matches()) {
            return "Le matricule ne peut contenir que des lettres majuscules, chiffres et tirets.";
        }
        if (matricule.length() < 3 || matricule.length() > 20) {
            return "Le matricule doit contenir entre 3 et 20 caractères.";
        }
        return null;
    }
    
    /**
     * Valide un téléphone
     */
    public static String validerTelephone(String telephone) {
        if (telephone == null || telephone.trim().isEmpty()) {
            return null; // Optionnel
        }
        if (!PATTERN_TELEPHONE.matcher(telephone).matches()) {
            return "Le téléphone ne peut contenir que des chiffres, espaces, +, -, ( et ).";
        }
        String chiffres = telephone.replaceAll("\\D", "");
        if (chiffres.length() < 10) {
            return "Le téléphone doit contenir au moins 10 chiffres.";
        }
        return null;
    }
    
    /**
     * Valide un nombre positif
     */
    public static String validerNombrePositif(String valeur, String champNom) {
        if (valeur == null || valeur.trim().isEmpty()) {
            return "Le " + champNom + " est obligatoire.";
        }
        try {
            double nombre = Double.parseDouble(valeur);
            if (nombre < 0) {
                return "Le " + champNom + " ne peut pas être négatif.";
            }
        } catch (NumberFormatException e) {
            return "Le " + champNom + " doit être un nombre valide.";
        }
        return null;
    }
    
    /**
     * Valide un salaire
     */
    public static String validerSalaire(String salaire) {
        String erreur = validerNombrePositif(salaire, "salaire");
        if (erreur != null) return erreur;
        
        try {
            double montant = Double.parseDouble(salaire);
            if (montant < 500) {
                return "Le salaire doit être supérieur à 500€.";
            }
            if (montant > 1000000) {
                return "Le salaire ne peut pas dépasser 1 000 000€.";
            }
        } catch (NumberFormatException e) {
            return "Le salaire doit être un nombre valide.";
        }
        return null;
    }
    
    /**
     * Valide un nombre entier positif
     */
    public static String validerEntierPositif(String valeur, String champNom) {
        if (valeur == null || valeur.trim().isEmpty()) {
            return null; // Optionnel
        }
        try {
            int nombre = Integer.parseInt(valeur);
            if (nombre < 0) {
                return "Le " + champNom + " ne peut pas être négatif.";
            }
        } catch (NumberFormatException e) {
            return "Le " + champNom + " doit être un nombre entier valide.";
        }
        return null;
    }
    
    /**
     * Valide toutes les données d'un employé
     */
    public static List<String> validerEmploye(String nom, String prenom, String email, 
                                               String matricule, String telephone, String salaire) {
        List<String> erreurs = new ArrayList<>();
        
        String erreurNom = validerNomPrenom(nom, "nom");
        if (erreurNom != null) erreurs.add(erreurNom);
        
        String erreurPrenom = validerNomPrenom(prenom, "prénom");
        if (erreurPrenom != null) erreurs.add(erreurPrenom);
        
        String erreurEmail = validerEmail(email);
        if (erreurEmail != null) erreurs.add(erreurEmail);
        
        String erreurMatricule = validerMatricule(matricule);
        if (erreurMatricule != null) erreurs.add(erreurMatricule);
        
        String erreurTelephone = validerTelephone(telephone);
        if (erreurTelephone != null) erreurs.add(erreurTelephone);
        
        String erreurSalaire = validerSalaire(salaire);
        if (erreurSalaire != null) erreurs.add(erreurSalaire);
        
        return erreurs;
    }
    
    /**
     * Valide toutes les données d'une fiche de paie
     */
    public static List<String> validerFichePaie(String salaireBase, String primes, 
                                                 String deductions, String heuresSupp, String joursAbsence) {
        List<String> erreurs = new ArrayList<>();
        
        String erreurSalaire = validerSalaire(salaireBase);
        if (erreurSalaire != null) erreurs.add(erreurSalaire);
        
        if (primes != null && !primes.trim().isEmpty()) {
            String erreurPrimes = validerNombrePositif(primes, "primes");
            if (erreurPrimes != null) erreurs.add(erreurPrimes);
        }
        
        if (deductions != null && !deductions.trim().isEmpty()) {
            String erreurDeductions = validerNombrePositif(deductions, "déductions");
            if (erreurDeductions != null) erreurs.add(erreurDeductions);
        }
        
        if (heuresSupp != null && !heuresSupp.trim().isEmpty()) {
            String erreurHeures = validerNombrePositif(heuresSupp, "heures supplémentaires");
            if (erreurHeures != null) erreurs.add(erreurHeures);
        }
        
        if (joursAbsence != null && !joursAbsence.trim().isEmpty()) {
            String erreurJours = validerEntierPositif(joursAbsence, "jours d'absence");
            if (erreurJours != null) {
                erreurs.add(erreurJours);
            } else {
                try {
                    int jours = Integer.parseInt(joursAbsence);
                    if (jours > 31) {
                        erreurs.add("Le nombre de jours d'absence ne peut pas dépasser 31.");
                    }
                } catch (NumberFormatException e) {
                    // Déjà géré par validerEntierPositif
                }
            }
        }
        
        return erreurs;
    }
}