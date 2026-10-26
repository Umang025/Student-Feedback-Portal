package com.feedback.dao;

import com.feedback.model.Admin;
import com.feedback.util.DBConnectionUtil;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class AdminDAOTest {

    private static AdminDAO adminDAO;

    @BeforeAll
    public static void setUp() {
        boolean connected = DBConnectionUtil.testConnection();
        Assumptions.assumeTrue(connected, "Skipping admin test: MySQL database is not reachable.");
        adminDAO = new AdminDAO();
    }

    @Test
    public void testAdminAuthentication() {
        // Test successful validation with default credentials
        Admin validAdmin = adminDAO.validateCredentials("admin", "admin123");
        assertNotNull(validAdmin, "Admin credentials (admin / admin123) should validate successfully");
        assertEquals("admin", validAdmin.getUsername());

        // Test invalid password
        Admin invalidPass = adminDAO.validateCredentials("admin", "wrongPass!");
        assertNull(invalidPass, "Invalid password should return null");

        // Test invalid user
        Admin nonExistent = adminDAO.validateCredentials("unknown_user_999", "admin123");
        assertNull(nonExistent, "Non-existent username should return null");
    }
}
