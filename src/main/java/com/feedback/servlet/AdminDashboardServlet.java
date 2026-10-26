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

/**
 * Controller Servlet for the Administrator Dashboard.
 * Demonstrates:
 *   - JDBC SELECT querying with filtering and search
 *   - Statistical aggregations (total count, average rating)
 *   - Passing models to JSP view via Request attributes
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private static final List<String> ALL_CATEGORIES = Arrays.asList(
            "ALL", "Teaching", "Laboratory", "Library", "Hostel", "Internet", "Other"
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

        String searchQuery = request.getParameter("q");
        String categoryFilter = request.getParameter("category");

        if (categoryFilter == null || categoryFilter.isBlank()) {
            categoryFilter = "ALL";
        }

        try {
            List<Feedback> feedbackList = feedbackDAO.searchAndFilter(searchQuery, categoryFilter);
            int totalCount = feedbackDAO.getTotalCount();
            double averageRating = feedbackDAO.getAverageRating();

            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("searchQuery", (searchQuery != null) ? searchQuery : "");
            request.setAttribute("selectedCategory", categoryFilter);
            request.setAttribute("categories", ALL_CATEGORIES);

            // Pass flash message flags if redirected from edit or delete
            request.setAttribute("msgUpdated", request.getParameter("updated") != null);
            request.setAttribute("msgDeleted", request.getParameter("deleted") != null);

            request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Unable to load dashboard data: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
        }
    }
}
