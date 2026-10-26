<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Home - Student Feedback Portal" />
<c:set var="activePage" value="home" />

<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container my-4">
    <!-- Hero Banner -->
    <div class="hero-section text-center text-md-start">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-warning text-dark fw-bold px-3 py-2 mb-3 rounded-pill text-uppercase">
                    <i class="bi bi-award-fill me-1"></i> MCA Java Web Mini Project
                </span>
                <h1 class="hero-title mb-3">Student Feedback Portal</h1>
                <p class="hero-subtitle mb-4">
                    A centralized college portal empowering students to submit confidential feedback regarding
                    teaching, laboratories, library services, hostel amenities, and campus internet infrastructure.
                </p>
                <div class="d-flex flex-wrap gap-3">
                    <a href="${pageContext.request.contextPath}/feedback" class="btn btn-light btn-lg text-primary fw-semibold shadow-sm">
                        <i class="bi bi-pencil-fill me-2"></i> Submit Feedback
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-light btn-lg fw-semibold">
                        <i class="bi bi-speedometer2 me-2"></i> Admin Dashboard
                    </a>
                </div>
            </div>
            <div class="col-lg-4 text-center mt-4 mt-lg-0 d-none d-lg-block">
                <i class="bi bi-chat-heart-fill display-1 text-light opacity-75"></i>
            </div>
        </div>
    </div>

    <!-- Categories Info Cards -->
    <div class="card card-portal p-4">
        <h4 class="fw-bold mb-3"><i class="bi bi-grid-3x3-gap-fill text-primary me-2"></i>Feedback Categories Covered</h4>
        <div class="row g-3">
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 text-center border rounded bg-light">
                    <i class="bi bi-person-video3 fs-3 text-primary d-block mb-1"></i>
                    <span class="fw-semibold small">Teaching</span>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 text-center border rounded bg-light">
                    <i class="bi bi-pc-display fs-3 text-indigo d-block mb-1"></i>
                    <span class="fw-semibold small">Laboratory</span>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 text-center border rounded bg-light">
                    <i class="bi bi-book-half fs-3 text-warning d-block mb-1"></i>
                    <span class="fw-semibold small">Library</span>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 text-center border rounded bg-light">
                    <i class="bi bi-building fs-3 text-success d-block mb-1"></i>
                    <span class="fw-semibold small">Hostel</span>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 text-center border rounded bg-light">
                    <i class="bi bi-wifi fs-3 text-purple d-block mb-1"></i>
                    <span class="fw-semibold small">Internet</span>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 text-center border rounded bg-light">
                    <i class="bi bi-three-dots fs-3 text-secondary d-block mb-1"></i>
                    <span class="fw-semibold small">Other</span>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
