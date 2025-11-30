package com.rsv.bdd;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utilitaire pour gérer les connexions JDBC
 */
public class DBUtil {

    private static final String URL = "jdbc:mysql://localhost:3306/projetjeeapp";
    private static final String USER = "root";
    private static final String PASS = "root"; 

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}