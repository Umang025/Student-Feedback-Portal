package com.feedback.servlet;

import com.feedback.dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Controller Servlet for Deleting a Feedback record (JDBC DELETE).
 * Strictly requires HTTP POST to prevent accidental deletion via URL visiting.
 */
@WebServlet(name = "FeedbackDeleteServlet", urlPatterns = {"/feedback/delete"})
public class FeedbackDeleteServlet extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Reject GET requests for destructive operations
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isBlank()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                boolean deleted = feedbackDAO.deleteFeedback(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard?deleted=true");
                    return;
                }
            } catch (NumberFormatException | SQLException ignored) {
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=DeleteFailed");
    }
}
