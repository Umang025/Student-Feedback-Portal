package com.feedback.servlet;

import com.feedback.dao.AdminDAO;
import com.feedback.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller Servlet for Administrator Login.
 * Demonstrates Experiment 2: HttpSession creation and user authentication state storage.
 */
@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin-login"})
public class AdminLoginServlet extends HttpServlet {

    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        request.setAttribute("authRequired", request.getParameter("authRequired") != null);
        request.setAttribute("loggedOut", request.getParameter("loggedOut") != null);
        request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Please enter both username and password.");
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
            return;
        }

        Admin admin = adminDAO.validateCredentials(username.trim(), password);
        if (admin != null) {
            // Invalidate any existing session to prevent session fixation, then create new
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("adminUser", admin);
            newSession.setAttribute("loginTime", System.currentTimeMillis());

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid administrator username or password.");
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("/WEB-INF/views/admin-login.jsp").forward(request, response);
        }
    }
}
