package com.rsv.bdd;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Utilitaire pour gérer les connexions à la base de données
 * Les credentials sont chargés depuis db.properties pour plus de sécurité
 */
public class DBUtil {

	private static String URL;
	private static String USER;
	private static String PASS;
	private static String DRIVER;

	static {
		// Charger les propriétés depuis db.properties
		try (InputStream input = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
			if (input == null) {
				System.err.println("❌ Impossible de trouver db.properties dans le classpath !");
				// Fallback sur les valeurs par défaut (pour compatibilité)
				URL = "jdbc:mysql://localhost:3306/projetjeeapp";
				USER = "root";
				PASS = "cytech0001";
				DRIVER = "com.mysql.cj.jdbc.Driver";
			} else {
				Properties prop = new Properties();
				prop.load(input);

				URL = prop.getProperty("db.url");
				USER = prop.getProperty("db.user");
				PASS = prop.getProperty("db.password");
				DRIVER = prop.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");

				System.out.println("✓ Configuration DB chargée depuis db.properties");
			}
		} catch (IOException e) {
			System.err.println("❌ Erreur lors du chargement de db.properties : " + e.getMessage());
			e.printStackTrace();
		}

		// Charger le driver JDBC
		try {
			Class.forName(DRIVER);
		} catch (ClassNotFoundException e) {
			System.err.println("❌ Driver JDBC non trouvé : " + DRIVER);
			e.printStackTrace();
		}
	}

	/**
	 * Obtenir une connexion à la base de données
	 *
	 * @return Connection
	 * @throws SQLException
	 */
	public static Connection getConnection() throws SQLException {
		return DriverManager.getConnection(URL, USER, PASS);
	}

	/**
	 * Méthode pour tester la connexion (utile pour debugging)
	 *
	 * @return true si la connexion réussit
	 */
	public static boolean testConnection() {
		try (Connection conn = getConnection()) {
			return conn != null && !conn.isClosed();
		} catch (SQLException e) {
			System.err.println("❌ Erreur de connexion à la base de données : " + e.getMessage());
			return false;
		}
	}
}
