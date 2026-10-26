package com.feedback.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * Controller Servlet specifically demonstrating Experiment 1:
 * "HTML forms, Servlets, GET and POST requests"
 */
@WebServlet(name = "RequestDemoServlet", urlPatterns = {"/demo-request"})
public class RequestDemoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processDemoRequest("GET", request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processDemoRequest("POST", request, response);
    }

    private void processDemoRequest(String method, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String testName = request.getParameter("testName");
        String testTopic = request.getParameter("testTopic");
        String testComments = request.getParameter("testComments");

        Map<String, String> headersMap = new HashMap<>();
        Enumeration<String> headerNames = request.getHeaderNames();
        if (headerNames != null) {
            while (headerNames.hasMoreElements()) {
                String header = headerNames.nextElement();
                headersMap.put(header, request.getHeader(header));
            }
        }

        request.setAttribute("httpMethod", method);
        request.setAttribute("testName", (testName != null) ? testName : "");
        request.setAttribute("testTopic", (testTopic != null) ? testTopic : "");
        request.setAttribute("testComments", (testComments != null) ? testComments : "");
        request.setAttribute("queryString", request.getQueryString());
        request.setAttribute("contentType", request.getContentType());
        request.setAttribute("contentLength", request.getContentLength());
        request.setAttribute("headersMap", headersMap);
        request.setAttribute("isSubmitted", testName != null || testTopic != null);

        request.getRequestDispatcher("/WEB-INF/views/request-demo.jsp").forward(request, response);
    }
}
