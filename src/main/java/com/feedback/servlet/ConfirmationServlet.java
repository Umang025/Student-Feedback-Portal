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

/**
 * Controller Servlet for Feedback Submission Confirmation.
 * Safe against F5 / browser reload duplicates because the actual submission occurred via POST
 * and redirected here via GET (Post-Redirect-Get pattern).
 */
@WebServlet(name = "ConfirmationServlet", urlPatterns = {"/confirmation"})
public class ConfirmationServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String refIdStr = request.getParameter("refId");
        int refId = 0;
        try {
            if (refIdStr != null && !refIdStr.isBlank()) {
                refId = Integer.parseInt(refIdStr.trim());
            }
        } catch (NumberFormatException ignored) {
        }

        Feedback feedback = null;
        HttpSession session = request.getSession(false);
        if (session != null) {
            feedback = (Feedback) session.getAttribute("lastSubmittedFeedback");
        }

        // If not in session or ID differs, query DB
        if ((feedback == null || feedback.getId() != refId) && refId > 0) {
            try {
                feedback = feedbackDAO.getFeedbackById(refId);
            } catch (SQLException e) {
                // Ignore, we will display what we have
            }
        }

        request.setAttribute("refId", refId);
        request.setAttribute("feedback", feedback);
        request.getRequestDispatcher("/WEB-INF/views/confirmation.jsp").forward(request, response);
    }
}
