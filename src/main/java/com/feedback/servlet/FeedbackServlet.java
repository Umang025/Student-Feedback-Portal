package com.feedback.servlet;

import com.feedback.dao.FeedbackDAO;
import com.feedback.model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Controller Servlet for Student Feedback Submission.
 * Demonstrates:
 *   - Experiment 1: Form handling, GET (form display) vs POST (submission)
 *   - Experiment 4: JDBC PreparedStatement insertion
 *   - Post-Redirect-Get (PRG) pattern to prevent duplicate submissions on refresh
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = {"/feedback", "/submit-feedback"})
public class FeedbackServlet extends HttpServlet {

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

    /**
     * Handles HTTP GET requests - Displays the feedback submission form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categories", VALID_CATEGORIES);
        request.getRequestDispatcher("/WEB-INF/views/feedback-form.jsp").forward(request, response);
    }

    /**
     * Handles HTTP POST requests - Validates and processes the feedback submission.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Read form parameter values
        String studentName = request.getParameter("student_name");
        String email = request.getParameter("email");
        String category = request.getParameter("category");
        String message = request.getParameter("message");
        String ratingStr = request.getParameter("rating");

        // Trim values safely
        studentName = (studentName != null) ? studentName.trim() : "";
        email = (email != null) ? email.trim() : "";
        category = (category != null) ? category.trim() : "";
        message = (message != null) ? message.trim() : "";

        // 2. Server-side validation
        StringBuilder errorMsg = new StringBuilder();

        if (studentName.isEmpty()) {
            errorMsg.append("Student Name is required. ");
        } else if (studentName.length() > 100) {
            errorMsg.append("Student Name must be under 100 characters. ");
        }

        if (email.isEmpty()) {
            errorMsg.append("Email address is required. ");
        } else if (!EMAIL_PATTERN.matcher(email).matches()) {
            errorMsg.append("Please provide a valid email address (e.g., student@example.edu). ");
        }

        if (category.isEmpty() || !VALID_CATEGORIES.contains(category)) {
            errorMsg.append("Please select a valid feedback category. ");
        }

        if (message.isEmpty()) {
            errorMsg.append("Feedback message is required. ");
        } else if (message.length() < 5) {
            errorMsg.append("Feedback message should be at least 5 characters long. ");
        } else if (message.length() > 2000) {
            errorMsg.append("Feedback message cannot exceed 2000 characters. ");
        }

        int rating = 0;
        try {
            rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                errorMsg.append("Rating must be between 1 and 5 stars. ");
            }
        } catch (NumberFormatException e) {
            errorMsg.append("Please select a rating between 1 and 5 stars. ");
        }

        // 3. If validation fails, return to form with preserved data and error alert
        if (errorMsg.length() > 0) {
            request.setAttribute("errorMessage", errorMsg.toString());
            request.setAttribute("paramStudentName", studentName);
            request.setAttribute("paramEmail", email);
            request.setAttribute("paramCategory", category);
            request.setAttribute("paramMessage", message);
            request.setAttribute("paramRating", ratingStr);
            request.setAttribute("categories", VALID_CATEGORIES);

            request.getRequestDispatcher("/WEB-INF/views/feedback-form.jsp").forward(request, response);
            return;
        }

        // 4. Construct Feedback object and insert via DAO
        Feedback feedback = new Feedback(studentName, email, category, message, rating);

        try {
            int generatedId = feedbackDAO.insertFeedback(feedback);

            // 5. Post/Redirect/Get (PRG) Pattern:
            // Store submission result details in session or pass via flash redirect
            // This prevents duplicate submissions when a user refreshes the confirmation page!
            HttpSession session = request.getSession();
            session.setAttribute("lastSubmittedFeedback", feedback);

            response.sendRedirect(request.getContextPath() + "/confirmation?refId=" + generatedId);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error occurred while saving your feedback. Please check if MySQL is running.");
            request.setAttribute("paramStudentName", studentName);
            request.setAttribute("paramEmail", email);
            request.setAttribute("paramCategory", category);
            request.setAttribute("paramMessage", message);
            request.setAttribute("paramRating", ratingStr);
            request.setAttribute("categories", VALID_CATEGORIES);

            request.getRequestDispatcher("/WEB-INF/views/feedback-form.jsp").forward(request, response);
        }
    }
}
