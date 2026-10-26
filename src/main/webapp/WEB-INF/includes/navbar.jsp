<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark navbar-portal sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-mortarboard-fill text-warning fs-4"></i>
            <span>Student Feedback Portal</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#portalNavbar" aria-controls="portalNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="portalNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'home' ? 'active' : ''}" href="${pageContext.request.contextPath}/index.jsp">
                        <i class="bi bi-house-door me-1"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'submit' ? 'active' : ''}" href="${pageContext.request.contextPath}/feedback">
                        <i class="bi bi-pencil-square me-1"></i> Submit Feedback
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i> Admin Dashboard
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.adminUser}">
                        <span class="text-light small me-2 d-none d-md-inline">
                            <i class="bi bi-person-circle me-1"></i>
                            <c:out value="${sessionScope.adminUser.fullName}" />
                        </span>
                        <a href="${pageContext.request.contextPath}/admin-logout" class="btn btn-outline-danger btn-sm">
                            <i class="bi bi-box-arrow-right me-1"></i> Logout
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/admin-login" class="btn btn-outline-light btn-sm">
                            <i class="bi bi-shield-lock me-1"></i> Admin Login
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
<main>
