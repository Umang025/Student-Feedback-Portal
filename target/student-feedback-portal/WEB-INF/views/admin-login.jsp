<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Login - Student Feedback Portal" />
<c:set var="activePage" value="dashboard" />

<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card card-portal shadow-sm">
                <div class="card-header card-header-portal text-center py-3">
                    <i class="bi bi-shield-lock-fill text-primary fs-2 d-block mb-1"></i>
                    <h4 class="fw-bold mb-0 text-dark">Administrator Login</h4>
                    <small class="text-muted">Enter credentials to access the feedback management dashboard</small>
                </div>

                <div class="card-body p-4">
                    <!-- Auth Required Alert -->
                    <c:if test="${authRequired}">
                        <div class="alert alert-warning alert-dismissible fade show small" role="alert">
                            <i class="bi bi-lock-fill me-1"></i> Access restricted. Please log in with admin privileges.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Logged Out Alert -->
                    <c:if test="${loggedOut}">
                        <div class="alert alert-info alert-dismissible fade show small" role="alert">
                            <i class="bi bi-info-circle-fill me-1"></i> You have been successfully logged out. Session invalidated.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Error Alert -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                            <i class="bi bi-exclamation-octagon-fill me-1"></i> <c:out value="${errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Academic / Viva Demo Credentials Notice -->
                    <div class="alert alert-light border small text-muted mb-4">
                        <div class="fw-bold text-dark mb-1"><i class="bi bi-key-fill text-warning me-1"></i> Academic Test Credentials:</div>
                        <div>Username: <code>admin</code></div>
                        <div>Password: <code>admin123</code></div>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin-login" method="POST">
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">Username</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                                <input type="text"
                                       class="form-control"
                                       id="username"
                                       name="username"
                                       placeholder="admin"
                                       value="<c:out value='${enteredUsername != null ? enteredUsername : "admin"}' />"
                                       required autofocus>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-key"></i></span>
                                <input type="password"
                                       class="form-control"
                                       id="password"
                                       name="password"
                                       placeholder="••••••••"
                                       required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-navy w-100 py-2 fw-semibold">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Log In to Dashboard
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
