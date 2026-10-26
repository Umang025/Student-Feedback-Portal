<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Experiment 3: JSP Elements & Implicit Objects - Student Feedback Portal" />
<c:set var="activePage" value="experiments" />

<%!
    // =========================================================================
    // 1. JSP DECLARATION TAG: <%! ... %>
    // Declares methods or class-level instance variables in the generated servlet
    // =========================================================================
    private String getStudentGreeting(String name) {
        return "Welcome to the JSP Demonstration, " + (name != null ? name : "Student") + "!";
    }
%>

<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container my-5">
    <!-- Header -->
    <div class="mb-4">
        <span class="badge bg-warning text-dark text-uppercase px-3 py-2 fw-bold">Syllabus Experiment 3</span>
        <h2 class="fw-bold mt-2">JSP Elements and Implicit Objects</h2>
        <p class="text-muted">
            Live demonstration of JSP directives, scriptlets, expressions, declarations, and all nine implicit objects.
        </p>
    </div>

    <!-- Section 1: JSP Elements Showcase -->
    <div class="card card-portal mb-4">
        <div class="card-header card-header-portal">
            <h5 class="mb-0 fw-bold"><i class="bi bi-code-square text-primary me-2"></i>JSP Scripting Elements Showcase</h5>
        </div>
        <div class="card-body p-4">
            <div class="row g-4">
                <!-- Directives -->
                <div class="col-md-6">
                    <div class="border rounded p-3 bg-light h-100">
                        <h6 class="fw-bold text-primary mb-2">1. JSP Directives (<code>&lt;%@ ... %&gt;</code>)</h6>
                        <p class="small text-muted mb-2">Provide global directions to the JSP engine during translation to servlet class:</p>
                        <ul class="small mb-0">
                            <li><code>&lt;%@ page contentType="text/html" language="java" %&gt;</code></li>
                            <li><code>&lt;%@ taglib prefix="c" uri="jakarta.tags.core" %&gt;</code></li>
                            <li><code>&lt;%@ include file="/WEB-INF/includes/header.jsp" %&gt;</code></li>
                        </ul>
                    </div>
                </div>

                <!-- Declarations -->
                <div class="col-md-6">
                    <div class="border rounded p-3 bg-light h-100">
                        <h6 class="fw-bold text-success mb-2">2. JSP Declaration (<code>&lt;%! ... %&gt;</code>)</h6>
                        <p class="small text-muted mb-2">Defines class-level variables and helper methods:</p>
                        <div class="alert alert-secondary py-2 small mb-0 font-monospace">
                            Result of <code>getStudentGreeting("MCA Scholar")</code>:<br>
                            <strong><%= getStudentGreeting("MCA Scholar") %></strong>
                        </div>
                    </div>
                </div>

                <!-- Expressions -->
                <div class="col-md-6">
                    <div class="border rounded p-3 bg-light h-100">
                        <h6 class="fw-bold text-danger mb-2">3. JSP Expression (<code>&lt;%= ... %&gt;</code>)</h6>
                        <p class="small text-muted mb-2">Evaluates an expression and writes directly to the response output stream without semicolon:</p>
                        <div class="alert alert-secondary py-2 small mb-0 font-monospace">
                            Current Date: <strong><%= new SimpleDateFormat("dd MMM yyyy, HH:mm:ss").format(new Date()) %></strong><br>
                            Math calculation: <code>21 * 4 = </code> <strong><%= (21 * 4) %></strong>
                        </div>
                    </div>
                </div>

                <!-- Scriptlets -->
                <div class="col-md-6">
                    <div class="border rounded p-3 bg-light h-100">
                        <h6 class="fw-bold text-warning text-dark mb-2">4. JSP Scriptlet (<code>&lt;% ... %&gt;</code>)</h6>
                        <p class="small text-muted mb-2">Contains valid Java code executed inside the servlet's <code>_jspService()</code> method:</p>
                        <%
                            int sum = 0;
                            for (int i = 1; i <= 5; i++) {
                                sum += i;
                            }
                        %>
                        <div class="alert alert-secondary py-2 small mb-0 font-monospace">
                            Sum of 1 to 5 calculated inside scriptlet: <strong><%= sum %></strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Section 2: JSP Implicit Objects Table -->
    <div class="card card-portal shadow-sm">
        <div class="card-header card-header-portal d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold"><i class="bi bi-box text-info me-2"></i>The 9 JSP Implicit Objects in Action</h5>
            <span class="badge bg-primary">Automatically Available in _jspService()</span>
        </div>
        <div class="card-body p-4">
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle small mb-0">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 15%;">Implicit Object</th>
                            <th style="width: 30%;">Underlying Java Type</th>
                            <th style="width: 25%;">Scope / Purpose</th>
                            <th>Inspected Live Value</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="fw-bold"><code>request</code></td>
                            <td><code>jakarta.servlet.http.HttpServletRequest</code></td>
                            <td>Request Scope: Client data &amp; headers</td>
                            <td>URI: <code><%= request.getRequestURI() %></code></td>
                        </tr>
                        <tr>
                            <td class="fw-bold"><code>response</code></td>
                            <td><code>jakarta.servlet.http.HttpServletResponse</code></td>
                            <td>Page response stream &amp; headers</td>
                            <td>Encoding: <code><%= response.getCharacterEncoding() %></code></td>
                        </tr>
                        <tr>
                            <td class="fw-bold"><code>session</code></td>
                            <td><code>jakarta.servlet.http.HttpSession</code></td>
                            <td>Session Scope: User state across requests</td>
                            <td>ID: <code class="text-truncate d-inline-block" style="max-width: 180px;"><%= session.getId() %></code></td>
                        </tr>
                        <tr>
                            <td class="fw-bold"><code>application</code></td>
                            <td><code>jakarta.servlet.ServletContext</code></td>
                            <td>Application Scope: Shared across all users</td>
                            <td>Server Info: <code><%= application.getServerInfo() %></code></td>
                        </tr>
                        <tr>
                            <td class="fw-bold"><code>out</code></td>
                            <td><code>jakarta.servlet.jsp.JspWriter</code></td>
                            <td>Buffered character output stream</td>
                            <td>Buffer Size: <code><%= out.getBufferSize() %> bytes</code></td>
                        </tr>
                        <tr>
                            <td class="fw-bold"><code>config</code></td>
                            <td><code>jakarta.servlet.ServletConfig</code></td>
                            <td>JSP configuration &amp; init params</td>
                            <td>Servlet Name: <code><%= config.getServletName() %></code></td>
                        </tr>
                        <tr>
                            <td class="fw-bold"><code>pageContext</code></td>
                            <td><code>jakarta.servlet.jsp.PageContext</code></td>
                            <td>Central access to all scopes &amp; attributes</td>
                            <td>Session attr via pageContext: <code>${sessionScope.sessionUserName}</code></td>
                        </tr>
                        <tr>
                            <td class="fw-bold"><code>page</code></td>
                            <td><code>java.lang.Object</code> (Servlet instance)</td>
                            <td>Synonym for <code>this</code> in the JSP page</td>
                            <td>Class: <code><%= page.getClass().getSimpleName() %></code></td>
                        </tr>
                        <tr>
                            <td class="fw-bold"><code>exception</code></td>
                            <td><code>java.lang.Throwable</code></td>
                            <td>Available only in error pages (<code>isErrorPage="true"</code>)</td>
                            <td><span class="badge bg-secondary">Active only on designated error pages</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
