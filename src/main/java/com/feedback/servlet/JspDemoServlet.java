package com.feedback.servlet;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;

/**
 * Controller Servlet demonstrating Experiment 3:
 * "JSP elements (directives, scriptlets, expressions) and implicit objects
 * (request, session, application, config, pageContext, out)"
 */
@WebServlet(name = "JspDemoServlet", urlPatterns = {"/demo-jsp"})
public class JspDemoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Request scope attribute
        request.setAttribute("requestMessage", "Data scoped to this specific HTTP Request.");
        request.setAttribute("serverTime", new Date());

        // 2. Session scope attribute
        HttpSession session = request.getSession(true);
        if (session.getAttribute("sessionUserName") == null) {
            session.setAttribute("sessionUserName", "MCA Student (Session Scope)");
        }

        // 3. Application (ServletContext) scope attribute
        ServletContext context = getServletContext();
        if (context.getAttribute("appProjectName") == null) {
            context.setAttribute("appProjectName", "Student Feedback Portal (Application Scope)");
        }

        request.getRequestDispatcher("/WEB-INF/views/jsp-demo.jsp").forward(request, response);
    }
}
