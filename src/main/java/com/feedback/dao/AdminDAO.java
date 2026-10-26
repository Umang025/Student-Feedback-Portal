package com.feedback.dao;

import com.feedback.model.Admin;
import com.feedback.util.DBConnectionUtil;
import com.feedback.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Administrator Authentication.
 */
public class AdminDAO {

    private static final Logger LOGGER = Logger.getLogger(AdminDAO.class.getName());

    /**
     * Looks up an administrator by their unique username.
     *
     * @param username admin username
     * @return Admin object if found, null otherwise
     */
    public Admin findByUsername(String username) {
        String sql = "SELECT id, username, password_hash, full_name, created_at FROM admins WHERE username = ?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setPasswordHash(rs.getString("password_hash"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setCreatedAt(rs.getTimestamp("created_at"));
                    return admin;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding admin by username: " + username, e);
        }
        return null;
    }

    /**
     * Validates administrator login credentials against the database.
     *
     * @param username username entered in the login form
     * @param plainPassword plain text password entered
     * @return Admin instance if credentials are valid, null otherwise
     */
    public Admin validateCredentials(String username, String plainPassword) {
        if (username == null || plainPassword == null) {
            return null;
        }

        Admin admin = findByUsername(username.trim());
        if (admin == null) {
            return null;
        }

        boolean matches = PasswordUtil.verifyPassword(plainPassword, admin.getPasswordHash());
        if (matches) {
            return admin;
        }
        return null;
    }
}
