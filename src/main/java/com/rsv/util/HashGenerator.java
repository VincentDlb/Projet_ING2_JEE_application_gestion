package com.rsv.util;

import org.mindrot.jbcrypt.BCrypt;

public class HashGenerator {
    public static void main(String[] args) {
        String plainPassword = "Admin@2025!";
        String hashed = BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
        System.out.println(hashed);
    }
}