package com.feedback.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * Controller Servlet specifically demonstrating Experiment 2:
 * "HttpSession and session creation/last-accessed time"
 */
@WebServlet(name = "SessionDemoServlet", urlPatterns = {"/demo-session"})
public class SessionDemoServlet extends HttpServlet {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd MMMM yyyy, hh:mm:ss a");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Allow explicit invalidation from the demo UI
        if ("invalidate".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/demo-session?invalidated=true");
            return;
        }

        // Create a new session if one does not exist
        HttpSession session = request.getSession(true);

        // Update a session-scoped visit counter
        Integer counter = (Integer) session.getAttribute("demoVisitCounter");
        if (counter == null) {
            counter = 1;
        } else {
            counter++;
        }
        session.setAttribute("demoVisitCounter", counter);

        // Extract and format session metadata
        String sessionId = session.getId();
        boolean isNew = session.isNew();

        long creationTimeMillis = session.getCreationTime();
        LocalDateTime creationLdt = LocalDateTime.ofInstant(Instant.ofEpochMilli(creationTimeMillis), ZoneId.systemDefault());
        String formattedCreationTime = creationLdt.format(FORMATTER);

        long lastAccessedTimeMillis = session.getLastAccessedTime();
        LocalDateTime lastAccessedLdt = LocalDateTime.ofInstant(Instant.ofEpochMilli(lastAccessedTimeMillis), ZoneId.systemDefault());
        String formattedLastAccessedTime = lastAccessedLdt.format(FORMATTER);

        int maxInactiveInterval = session.getMaxInactiveInterval();

        request.setAttribute("sessionId", sessionId);
        request.setAttribute("isNew", isNew);
        request.setAttribute("creationTime", formattedCreationTime);
        request.setAttribute("lastAccessedTime", formattedLastAccessedTime);
        request.setAttribute("maxInactiveInterval", maxInactiveInterval);
        request.setAttribute("visitCounter", counter);
        request.setAttribute("justInvalidated", request.getParameter("invalidated") != null);

        request.getRequestDispatcher("/WEB-INF/views/session-demo.jsp").forward(request, response);
    }
}
