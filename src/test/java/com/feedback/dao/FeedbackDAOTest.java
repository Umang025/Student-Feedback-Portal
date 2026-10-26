package com.feedback.dao;

import com.feedback.model.Feedback;
import com.feedback.util.DBConnectionUtil;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class FeedbackDAOTest {

    private static FeedbackDAO feedbackDAO;

    @BeforeAll
    public static void setUp() {
        // Only run test if MySQL database is active and reachable
        boolean connected = DBConnectionUtil.testConnection();
        Assumptions.assumeTrue(connected, "Skipping database tests: MySQL database is not reachable.");
        feedbackDAO = new FeedbackDAO();
    }

    @Test
    public void testCrudLifecycle() throws SQLException {
        // 1. Create (Insert)
        String testEmail = "test_junit_" + System.currentTimeMillis() + "@example.edu";
        Feedback feedback = new Feedback("JUnit Test Student", testEmail, "Laboratory", "Automated test message for lab demo", 4);

        int generatedId = feedbackDAO.insertFeedback(feedback);
        assertTrue(generatedId > 0, "Generated ID should be positive");

        // 2. Read (Get by ID)
        Feedback retrieved = feedbackDAO.getFeedbackById(generatedId);
        assertNotNull(retrieved, "Retrieved feedback should not be null");
        assertEquals("JUnit Test Student", retrieved.getStudentName());
        assertEquals(4, retrieved.getRating());

        // 3. Update
        retrieved.setMessage("Updated feedback message via JUnit test");
        retrieved.setRating(5);
        boolean updated = feedbackDAO.updateFeedback(retrieved);
        assertTrue(updated, "Update operation should succeed");

        Feedback postUpdate = feedbackDAO.getFeedbackById(generatedId);
        assertEquals("Updated feedback message via JUnit test", postUpdate.getMessage());
        assertEquals(5, postUpdate.getRating());

        // 4. Search & Filter
        List<Feedback> searchResults = feedbackDAO.searchAndFilter("JUnit Test", "Laboratory");
        assertFalse(searchResults.isEmpty(), "Should find the inserted record via search and filter");

        // 5. Delete
        boolean deleted = feedbackDAO.deleteFeedback(generatedId);
        assertTrue(deleted, "Delete operation should succeed");

        Feedback postDelete = feedbackDAO.getFeedbackById(generatedId);
        assertNull(postDelete, "Record should no longer exist after deletion");
    }

    @Test
    public void testStatsMethods() throws SQLException {
        int count = feedbackDAO.getTotalCount();
        assertTrue(count >= 0, "Total count should be non-negative");

        double avgRating = feedbackDAO.getAverageRating();
        assertTrue(avgRating >= 0.0 && avgRating <= 5.0, "Average rating should be between 0 and 5");
    }
}
