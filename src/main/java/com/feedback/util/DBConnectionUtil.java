package com.feedback.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database Connection Utility demonstrating Experiment 4 (JDBC Connection).
 * Loads connection configuration from db.properties or falls back to standard XAMPP defaults.
 */
public class DBConnectionUtil {

    private static final Logger LOGGER = Logger.getLogger(DBConnectionUtil.class.getName());

    private static String jdbcUrl;
    private static String jdbcUser;
    private static String jdbcPassword;
    private static String jdbcDriver;

    static {
        loadConfiguration();
    }

    private DBConnectionUtil() {
        // Prevent instantiation
    }

    private static synchronized void loadConfiguration() {
        Properties props = new Properties();
        try (InputStream in = DBConnectionUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                props.load(in);
                LOGGER.info("Successfully loaded db.properties configuration.");
            } else {
                LOGGER.warning("db.properties not found on classpath. Falling back to default XAMPP settings.");
            }
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Failed to read db.properties. Using default XAMPP credentials.", e);
        }

        // Allow environment variables or system properties to override properties file
        jdbcDriver = getEnvOrProp("DB_DRIVER", props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver"));
        jdbcUrl = getEnvOrProp("DB_URL", props.getProperty("db.url",
                "jdbc:mysql://localhost:3306/student_feedback_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata&characterEncoding=UTF-8"));
        jdbcUser = getEnvOrProp("DB_USER", props.getProperty("db.user", "root"));
        jdbcPassword = getEnvOrProp("DB_PASSWORD", props.getProperty("db.password", ""));

        // Register JDBC Driver
        try {
            Class.forName(jdbcDriver);
            LOGGER.info("Registered JDBC Driver: " + jdbcDriver);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found in classpath! Check pom.xml dependency.", e);
        }
    }

    private static String getEnvOrProp(String name, String defaultValue) {
        String env = System.getenv(name);
        if (env != null && !env.isBlank()) {
            return env.trim();
        }
        String sysProp = System.getProperty(name);
        if (sysProp != null && !sysProp.isBlank()) {
            return sysProp.trim();
        }
        return defaultValue;
    }

    /**
     * Obtains a new JDBC connection to the MySQL database.
     *
     * @return active java.sql.Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to connect to MySQL database at " + jdbcUrl + " with user " + jdbcUser
                    + ". Ensure XAMPP MySQL is running on port 3306.", e);
            throw e;
        }
    }

    /**
     * Quick health check method to verify database connectivity.
     *
     * @return true if connection succeeds and is valid
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }

    public static String getJdbcUrl() {
        return jdbcUrl;
    }

    public static String getJdbcUser() {
        return jdbcUser;
    }
}
