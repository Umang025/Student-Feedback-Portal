<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Experiment 2: HttpSession Tracking - Student Feedback Portal" />
<c:set var="activePage" value="experiments" />

<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container my-5">
    <!-- Header -->
    <div class="mb-4">
        <span class="badge bg-success text-uppercase px-3 py-2 fw-bold">Syllabus Experiment 2</span>
        <h2 class="fw-bold mt-2">HttpSession and Session Lifecycle Tracking</h2>
        <p class="text-muted">
            Demonstrates stateful tracking across stateless HTTP connections using <code>jakarta.servlet.http.HttpSession</code>.
        </p>
    </div>

    <!-- Alert for session invalidation -->
    <c:if test="${justInvalidated}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <i class="bi bi-info-circle-fill me-2"></i>
            Previous session was successfully invalidated with <code>session.invalidate()</code>. A brand-new session has now been generated!
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <!-- Session Overview Cards -->
        <div class="col-lg-8">
            <div class="card card-portal shadow-sm">
                <div class="card-header card-header-portal d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-shield-check text-success me-2"></i>Live Session Metadata</h5>
                    <span class="badge ${isNew ? 'bg-warning text-dark' : 'bg-success'} px-3 py-2">
                        Status: <c:out value="${isNew ? 'Brand New Session' : 'Active Existing Session'}" />
                    </span>
                </div>
                <div class="card-body p-4">
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle mb-4">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 35%;">HttpSession Method</th>
                                    <th>Evaluated Value &amp; Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="fw-semibold"><code>session.getId()</code></td>
                                    <td>
                                        <code class="text-primary text-break fw-bold"><c:out value="${sessionId}" /></code>
                                        <div class="small text-muted">Unique 32/64 char session token stored in client's <code>JSESSIONID</code> cookie.</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold"><code>session.isNew()</code></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${isNew}">
                                                <span class="badge bg-warning text-dark">true</span>
                                                <span class="small text-muted ms-2">(Server created this session on this current request)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success">false</span>
                                                <span class="small text-muted ms-2">(Client already sent back the valid session cookie)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold"><code>session.getCreationTime()</code></td>
                                    <td>
                                        <strong><c:out value="${creationTime}" /></strong>
                                        <div class="small text-muted">Exact epoch timestamp when the container initialized this session.</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold"><code>session.getLastAccessedTime()</code></td>
                                    <td>
                                        <strong><c:out value="${lastAccessedTime}" /></strong>
                                        <div class="small text-muted">Timestamp of the last client request associated with this session.</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold"><code>session.getMaxInactiveInterval()</code></td>
                                    <td>
                                        <span class="badge bg-secondary"><c:out value="${maxInactiveInterval}" /> seconds</span> (<c:out value="${maxInactiveInterval / 60}" /> minutes)
                                        <div class="small text-muted">Defined in <code>web.xml</code> as <code>&lt;session-timeout&gt;30&lt;/session-timeout&gt;</code>.</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold">Session Counter Attribute</td>
                                    <td>
                                        <span class="badge bg-primary fs-6 px-3 py-1"><c:out value="${visitCounter}" /> page loads</span>
                                        <div class="small text-muted">Value persisted across requests using <code>session.setAttribute()</code>.</div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Actions -->
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/demo-session" class="btn btn-outline-primary">
                            <i class="bi bi-arrow-clockwise me-1"></i> Refresh Page (Update Last-Accessed Time)
                        </a>
                        <a href="${pageContext.request.contextPath}/demo-session?action=invalidate" class="btn btn-outline-danger">
                            <i class="bi bi-trash-fill me-1"></i> Invalidate Session (Destroy Session)
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Viva Voce & Theory Card -->
        <div class="col-lg-4">
            <div class="card card-portal h-100">
                <div class="card-header card-header-portal">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-mortarboard-fill text-warning me-2"></i>Viva Key Points</h5>
                </div>
                <div class="card-body p-4 small">
                    <h6 class="fw-bold text-dark">Why is Session Tracking needed?</h6>
                    <p class="text-muted">
                        HTTP is a <strong>stateless protocol</strong>; every request is treated as independent. Session tracking allows web applications to remember user logins, shopping carts, and interaction history.
                    </p>

                    <h6 class="fw-bold text-dark mt-3">Mechanisms for Session Tracking:</h6>
                    <ol class="text-muted ps-3 mb-3">
                        <li><strong>Cookies (Default):</strong> <code>JSESSIONID</code> stored in browser.</li>
                        <li><strong>URL Rewriting:</strong> <code>;jsessionid=...</code> appended to URLs when cookies are disabled.</li>
                        <li><strong>Hidden Form Fields:</strong> <code>&lt;input type="hidden"&gt;</code> passed with forms.</li>
                    </ol>

                    <h6 class="fw-bold text-dark mt-3">Core HttpSession Methods:</h6>
                    <ul class="text-muted ps-3 mb-0">
                        <li><code>request.getSession(true)</code></li>
                        <li><code>session.setAttribute(name, value)</code></li>
                        <li><code>session.getAttribute(name)</code></li>
                        <li><code>session.removeAttribute(name)</code></li>
                        <li><code>session.invalidate()</code></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
