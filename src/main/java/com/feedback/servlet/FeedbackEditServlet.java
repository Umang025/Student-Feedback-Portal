package com.feedback.servlet;

import com.feedback.dao.FeedbackDAO;
import com.feedback.model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Controller Servlet for Editing a Feedback record (JDBC UPDATE).
 */
@WebServlet(name = "FeedbackEditServlet", urlPatterns = {"/feedback/edit"})
public class FeedbackEditServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final List<String> VALID_CATEGORIES = Arrays.asList(
            "Teaching", "Laboratory", "Library", "Hostel", "Internet", "Other"
    );

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            Feedback feedback = feedbackDAO.getFeedbackById(id);
            if (feedback == null) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=NotFound");
                return;
            }

            request.setAttribute("feedback", feedback);
            request.setAttribute("categories", VALID_CATEGORIES);
            request.getRequestDispatcher("/WEB-INF/views/feedback-edit.jsp").forward(request, response);
        } catch (NumberFormatException | SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=InvalidId");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String studentName = request.getParameter("student_name");
        String email = request.getParameter("email");
        String category = request.getParameter("category");
        String message = request.getParameter("message");
        String ratingStr = request.getParameter("rating");

        studentName = (studentName != null) ? studentName.trim() : "";
        email = (email != null) ? email.trim() : "";
        category = (category != null) ? category.trim() : "";
        message = (message != null) ? message.trim() : "";

        int id = 0;
        int rating = 0;
        StringBuilder errorMsg = new StringBuilder();

        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            errorMsg.append("Invalid Feedback ID. ");
        }

        if (studentName.isEmpty() || studentName.length() > 100) {
            errorMsg.append("Student Name is required (max 100 characters). ");
        }

        if (email.isEmpty() || !EMAIL_PATTERN.matcher(email).matches()) {
            errorMsg.append("Valid email address is required. ");
        }

        if (category.isEmpty() || !VALID_CATEGORIES.contains(category)) {
            errorMsg.append("Valid category selection is required. ");
        }

        if (message.isEmpty() || message.length() < 5 || message.length() > 2000) {
            errorMsg.append("Message must be between 5 and 2000 characters. ");
        }

        try {
            rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                errorMsg.append("Rating must be between 1 and 5. ");
            }
        } catch (NumberFormatException e) {
            errorMsg.append("Rating is required (1-5). ");
        }

        if (errorMsg.length() > 0) {
            Feedback f = new Feedback(id, studentName, email, category, message, rating, null);
            request.setAttribute("feedback", f);
            request.setAttribute("errorMessage", errorMsg.toString());
            request.setAttribute("categories", VALID_CATEGORIES);
            request.getRequestDispatcher("/WEB-INF/views/feedback-edit.jsp").forward(request, response);
            return;
        }

        Feedback updatedFeedback = new Feedback(id, studentName, email, category, message, rating, null);

        try {
            boolean success = feedbackDAO.updateFeedback(updatedFeedback);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?updated=true");
            } else {
                request.setAttribute("feedback", updatedFeedback);
                request.setAttribute("errorMessage", "Failed to update record. ID might not exist.");
                request.setAttribute("categories", VALID_CATEGORIES);
                request.getRequestDispatcher("/WEB-INF/views/feedback-edit.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("feedback", updatedFeedback);
            request.setAttribute("errorMessage", "Database error during update: " + e.getMessage());
            request.setAttribute("categories", VALID_CATEGORIES);
            request.getRequestDispatcher("/WEB-INF/views/feedback-edit.jsp").forward(request, response);
        }
    }
}
