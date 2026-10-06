package com.smartcampus.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility using MySQL JDBC Driver.
 * Provides synchronized connection handling with clear configuration settings.
 */
public class DBConnection {

    // Default connection parameters (Can be modified or overridden via System properties/Environment variables)
    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "3306";
    private static final String DEFAULT_DB = "smart_campus_incident";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "ilak_2007"; // Change to your local MySQL root password if different

    private static String dbUrl;
    private static String dbUser;
    private static String dbPassword;

    static {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            String host = System.getProperty("DB_HOST", System.getenv().getOrDefault("DB_HOST", DEFAULT_HOST));
            String port = System.getProperty("DB_PORT", System.getenv().getOrDefault("DB_PORT", DEFAULT_PORT));
            String db = System.getProperty("DB_NAME", System.getenv().getOrDefault("DB_NAME", DEFAULT_DB));
            
            dbUser = System.getProperty("DB_USER", System.getenv().getOrDefault("DB_USER", DEFAULT_USER));
            dbPassword = System.getProperty("DB_PASS", System.getenv().getOrDefault("DB_PASS", DEFAULT_PASS));
            
            dbUrl = "jdbc:mysql://" + host + ":" + port + "/" + db + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found in classpath: " + e.getMessage());
        }
    }

    /**
     * Obtains a new database Connection.
     * 
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        } catch (SQLException e) {
            // If default password failed and password was 'root', try blank password '' as a fallback for common XAMPP/WAMP setups
            if ("root".equals(dbPassword)) {
                try {
                    return DriverManager.getConnection(dbUrl, dbUser, "");
                } catch (SQLException ignored) {
                }
            }
            System.err.println("Database Connection Failed: " + e.getMessage());
            System.err.println("Attempted URL: " + dbUrl + " with User: " + dbUser);
            throw e;
        }
    }

    /**
     * Programmatic configuration helper if needed during startup or testing.
     */
    public static void configure(String url, String user, String password) {
        dbUrl = url;
        dbUser = user;
        dbPassword = password;
    }

    public static String getDbUrl() {
        return dbUrl;
    }

    public static String getDbUser() {
        return dbUser;
    }
}
