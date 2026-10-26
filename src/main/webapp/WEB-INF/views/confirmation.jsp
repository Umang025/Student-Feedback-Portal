<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Feedback Submitted - Student Feedback Portal" />
<c:set var="activePage" value="submit" />

<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-7 col-md-9">
            <div class="card card-portal text-center p-4 p-md-5 shadow-sm">
                <div class="mb-3">
                    <span class="badge bg-success-subtle text-success p-3 rounded-circle">
                        <i class="bi bi-check-circle-fill display-4"></i>
                    </span>
                </div>

                <h2 class="fw-bold text-dark mb-2">Thank You for Your Feedback!</h2>
                <p class="text-muted mb-4">
                    Your feedback has been successfully recorded in the college database.
                </p>

                <!-- Reference ID Card -->
                <div class="alert alert-light border p-3 rounded-3 mb-4 text-start">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="text-muted small text-uppercase fw-bold">Feedback Reference ID:</span>
                        <span class="badge bg-primary fs-6 px-3 py-2">
                            #<c:out value="${refId > 0 ? refId : 'REC-OK'}" />
                        </span>
                    </div>

                    <c:if test="${not empty feedback}">
                        <hr class="my-2">
                        <div class="small text-muted mb-1">
                            <strong>Student Name:</strong> <c:out value="${feedback.studentName}" />
                        </div>
                        <div class="small text-muted mb-1">
                            <strong>Email:</strong> <c:out value="${feedback.email}" />
                        </div>
                        <div class="small text-muted mb-1">
                            <strong>Category:</strong> <span class="badge bg-secondary"><c:out value="${feedback.category}" /></span>
                        </div>
                        <div class="small text-muted mb-1">
                            <strong>Rating:</strong> <span class="text-warning"><c:out value="${feedback.starsDisplay}" /></span> (<c:out value="${feedback.rating}" /> / 5)
                        </div>
                    </c:if>
                </div>

                <div class="d-flex flex-wrap justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/feedback" class="btn btn-outline-primary">
                        <i class="bi bi-plus-circle me-1"></i> Submit Another Feedback
                    </a>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-navy">
                        <i class="bi bi-house-door me-1"></i> Return to Home
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
