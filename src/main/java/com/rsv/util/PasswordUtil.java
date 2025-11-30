package com.rsv.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utilitaire pour hasher et vérifier les mots de passe avec BCrypt
 */
public class PasswordUtil {
    
    /**
     * Hashe un mot de passe en clair
     * @param plainPassword Le mot de passe en clair
     * @return Le mot de passe hashé
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }
    
    /**
     * Vérifie si un mot de passe correspond au hash
     * @param plainPassword Le mot de passe en clair à vérifier
     * @param hashedPassword Le hash stocké en BDD
     * @return true si le mot de passe correspond, false sinon
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}