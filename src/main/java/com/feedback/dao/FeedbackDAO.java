package com.feedback.dao;

import com.feedback.model.Feedback;
import com.feedback.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object (DAO) for Student Feedback.
 * Demonstrates Experiment 4: Full JDBC CRUD Operations using MySQL:
 *   - [C]reate: insertFeedback
 *   - [R]ead:   getAllFeedback, getFeedbackById, searchAndFilter
 *   - [U]pdate: updateFeedback
 *   - [D]elete: deleteFeedback
 *
 * All SQL interactions use PreparedStatement to ensure parameterized query
 * execution and complete SQL injection protection.
 */
public class FeedbackDAO {

    private static final Logger LOGGER = Logger.getLogger(FeedbackDAO.class.getName());

    // =========================================================================
    // 1. CREATE: Insert a new feedback record
    // =========================================================================
    public int insertFeedback(Feedback feedback) throws SQLException {
        String sql = "INSERT INTO feedback (student_name, email, category, message, rating) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, feedback.getStudentName());
            ps.setString(2, feedback.getEmail());
            ps.setString(3, feedback.getCategory());
            ps.setString(4, feedback.getMessage());
            ps.setInt(5, feedback.getRating());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Inserting feedback failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    feedback.setId(generatedId);
                    return generatedId;
                } else {
                    throw new SQLException("Inserting feedback succeeded, but no ID was obtained.");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting feedback into database", e);
            throw e;
        }
    }

    // =========================================================================
    // 2. READ: Get all feedback records ordered by latest first
    // =========================================================================
    public List<Feedback> getAllFeedback() throws SQLException {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT id, student_name, email, category, message, rating, created_at FROM feedback ORDER BY created_at DESC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all feedback", e);
            throw e;
        }
        return list;
    }

    // =========================================================================
    // 3. READ: Get a single feedback record by primary key ID
    // =========================================================================
    public Feedback getFeedbackById(int id) throws SQLException {
        String sql = "SELECT id, student_name, email, category, message, rating, created_at FROM feedback WHERE id = ?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFeedback(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding feedback by ID: " + id, e);
            throw e;
        }
        return null;
    }

    // =========================================================================
    // 4. READ: Search by name/email and filter by category
    // =========================================================================
    public List<Feedback> searchAndFilter(String query, String category) throws SQLException {
        List<Feedback> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT id, student_name, email, category, message, rating, created_at FROM feedback WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        boolean hasQuery = (query != null && !query.trim().isEmpty());
        boolean hasCategory = (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("ALL"));

        if (hasQuery) {
            sql.append("AND (LOWER(student_name) LIKE ? OR LOWER(email) LIKE ?) ");
            String wildcard = "%" + query.trim().toLowerCase() + "%";
            params.add(wildwildCard(wildcard));
            params.add(wildwildCard(wildcard));
        }

        if (hasCategory) {
            sql.append("AND category = ? ");
            params.add(category.trim());
        }

        sql.append("ORDER BY created_at DESC");

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFeedback(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching and filtering feedback", e);
            throw e;
        }
        return list;
    }

    private String wildwildCard(String str) {
        return str;
    }

    // =========================================================================
    // 5. UPDATE: Modify an existing feedback record
    // =========================================================================
    public boolean updateFeedback(Feedback feedback) throws SQLException {
        String sql = "UPDATE feedback SET student_name = ?, email = ?, category = ?, message = ?, rating = ? WHERE id = ?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, feedback.getStudentName());
            ps.setString(2, feedback.getEmail());
            ps.setString(3, feedback.getCategory());
            ps.setString(4, feedback.getMessage());
            ps.setInt(5, feedback.getRating());
            ps.setInt(6, feedback.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating feedback with ID: " + feedback.getId(), e);
            throw e;
        }
    }

    // =========================================================================
    // 6. DELETE: Remove a feedback record by primary key ID
    // =========================================================================
    public boolean deleteFeedback(int id) throws SQLException {
        String sql = "DELETE FROM feedback WHERE id = ?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting feedback with ID: " + id, e);
            throw e;
        }
    }

    // =========================================================================
    // 7. STATS: Total count of submissions
    // =========================================================================
    public int getTotalCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM feedback";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving total feedback count", e);
            throw e;
        }
        return 0;
    }

    // =========================================================================
    // 8. STATS: Average rating across all submissions
    // =========================================================================
    public double getAverageRating() throws SQLException {
        String sql = "SELECT AVG(rating) FROM feedback";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return Math.round(rs.getDouble(1) * 10.0) / 10.0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving average rating", e);
            throw e;
        }
        return 0.0;
    }

    // Helper method to convert a ResultSet row into a Feedback domain object
    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setId(rs.getInt("id"));
        f.setStudentName(rs.getString("student_name"));
        f.setEmail(rs.getString("email"));
        f.setCategory(rs.getString("category"));
        f.setMessage(rs.getString("message"));
        f.setRating(rs.getInt("rating"));
        f.setCreatedAt(rs.getTimestamp("created_at"));
        return f;
    }
}
