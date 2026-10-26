package com.feedback.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter that protects administrator-only URLs.
 * Checks whether an active HttpSession exists and contains the "adminUser" attribute.
 * If not authenticated, redirects the user to the admin login page with an alert.
 */
@WebFilter(urlPatterns = {
        "/admin/*",
        "/feedback/edit",
        "/feedback/delete"
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Obtain current session without creating a new one (pass false)
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("adminUser") != null);

        if (isLoggedIn) {
            // User is authenticated as admin, continue down the chain
            chain.doFilter(request, response);
        } else {
            // Not authenticated: capture requested URI to redirect after login if desired
            String contextPath = httpRequest.getContextPath();
            httpResponse.sendRedirect(contextPath + "/admin-login?authRequired=true");
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
