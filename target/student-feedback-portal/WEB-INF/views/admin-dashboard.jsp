<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Dashboard - Student Feedback Portal" />
<c:set var="activePage" value="dashboard" />

<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container-fluid px-4 my-4">
    <!-- Top Header -->
    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-speedometer2 text-primary me-2"></i>Feedback Management Dashboard</h2>
            <p class="text-muted mb-0">Review, search, filter, edit, and manage all student feedback records (Demonstrating Experiment 4: JDBC CRUD).</p>
        </div>
        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/feedback" class="btn btn-primary btn-sm">
                <i class="bi bi-plus-circle me-1"></i> New Feedback
            </a>
            <a href="${pageContext.request.contextPath}/admin-logout" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i> Logout
            </a>
        </div>
    </div>

    <!-- Alerts -->
    <c:if test="${msgUpdated}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> Feedback record was successfully updated via JDBC PreparedStatement.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${msgDeleted}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-trash-fill me-2"></i> Feedback record was successfully deleted from the MySQL database.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> <c:out value="${errorMessage}" />
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Metrics Stat Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-label">Total Submissions</div>
                <div class="d-flex align-items-baseline justify-content-between mt-2">
                    <div class="stat-number text-primary"><c:out value="${totalCount}" /></div>
                    <i class="bi bi-inbox-fill fs-2 text-primary opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card stat-rating">
                <div class="stat-label">Average Rating</div>
                <div class="d-flex align-items-baseline justify-content-between mt-2">
                    <div class="stat-number text-warning">
                        <c:out value="${averageRating}" /> <span class="fs-6 text-muted">/ 5.0</span>
                    </div>
                    <i class="bi bi-star-fill fs-2 text-warning opacity-75"></i>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card" style="border-left-color: #10b981;">
                <div class="stat-label">Filtered Results</div>
                <div class="d-flex align-items-baseline justify-content-between mt-2">
                    <div class="stat-number text-success"><c:out value="${feedbackList.size()}" /></div>
                    <i class="bi bi-funnel-fill fs-2 text-success opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card" style="border-left-color: #8b5cf6;">
                <div class="stat-label">Active Session Admin</div>
                <div class="d-flex align-items-baseline justify-content-between mt-2">
                    <div class="h5 mb-0 fw-bold text-dark text-truncate" style="max-width: 170px;">
                        <c:out value="${sessionScope.adminUser.fullName}" />
                    </div>
                    <i class="bi bi-person-badge-fill fs-2 text-purple opacity-50"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Search & Filter Controls -->
    <div class="card card-portal mb-4">
        <div class="card-body p-3">
            <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="row g-2 align-items-center">
                <!-- Search text box -->
                <div class="col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                        <input type="text"
                               name="q"
                               class="form-control"
                               placeholder="Search student name or email..."
                               value="<c:out value='${searchQuery}' />">
                    </div>
                </div>

                <!-- Category dropdown filter -->
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-filter"></i></span>
                        <select name="category" class="form-select">
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${cat == 'ALL'}">All Categories</c:when>
                                        <c:otherwise>${cat}</c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-navy flex-grow-1">
                        <i class="bi bi-filter me-1"></i> Apply
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary" title="Reset Filters">
                        <i class="bi bi-arrow-counterclockwise"></i> Reset
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Feedback Records Table -->
    <div class="card card-portal shadow-sm">
        <div class="card-header card-header-portal d-flex justify-content-between align-items-center">
            <span class="fw-bold text-dark">
                <i class="bi bi-table me-2 text-primary"></i>Feedback Records List
            </span>
            <span class="badge bg-secondary">Showing <c:out value="${feedbackList.size()}" /> entries</span>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width: 60px;">#ID</th>
                        <th>Student Name</th>
                        <th>Email</th>
                        <th>Category</th>
                        <th style="width: 130px;">Rating</th>
                        <th>Message</th>
                        <th style="width: 170px;">Date &amp; Time</th>
                        <th style="width: 140px;" class="text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty feedbackList}">
                            <c:forEach var="item" items="${feedbackList}">
                                <tr>
                                    <td class="fw-bold text-muted">#<c:out value="${item.id}" /></td>
                                    <td class="fw-semibold text-dark"><c:out value="${item.studentName}" /></td>
                                    <td><a href="mailto:<c:out value='${item.email}' />" class="text-decoration-none text-muted small"><c:out value="${item.email}" /></a></td>
                                    <td>
                                        <span class="badge badge-cat-<c:out value='${item.category}' /> px-2 py-1">
                                            <c:out value="${item.category}" />
                                        </span>
                                    </td>
                                    <td>
                                        <span class="rating-stars-badge"><c:out value="${item.starsDisplay}" /></span>
                                        <span class="text-muted small ms-1">(<c:out value="${item.rating}" />)</span>
                                    </td>
                                    <td>
                                        <div class="text-truncate" style="max-width: 280px;" title="<c:out value='${item.message}' />">
                                            <c:out value="${item.message}" />
                                        </div>
                                    </td>
                                    <td class="small text-muted"><c:out value="${item.formattedDate}" /></td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <!-- Edit Action -->
                                            <a href="${pageContext.request.contextPath}/feedback/edit?id=<c:out value='${item.id}' />"
                                               class="btn btn-outline-primary"
                                               title="Edit Feedback">
                                                <i class="bi bi-pencil-fill"></i>
                                            </a>
                                            <!-- Delete Prompt Button -->
                                            <button type="button"
                                                    class="btn btn-outline-danger btn-delete-prompt"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#deleteConfirmationModal"
                                                    data-id="<c:out value='${item.id}' />"
                                                    data-name="<c:out value='${item.studentName}' />"
                                                    title="Delete Feedback">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox display-4 d-block mb-2 text-secondary opacity-50"></i>
                                    <h5>No feedback records found.</h5>
                                    <p class="small mb-0">Try clearing your search query or category filters.</p>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal: Delete Confirmation -->
<div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-labelledby="deleteModalTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/feedback/delete" method="POST">
                <input type="hidden" name="id" id="deleteModalId" value="">

                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteModalTitle">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>Confirm Deletion
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body py-4">
                    <p class="mb-2">Are you sure you want to permanently delete the feedback record submitted by:</p>
                    <div class="fw-bold fs-5 text-danger" id="deleteModalStudentName">Student Name</div>
                    <div class="text-muted small mt-2">
                        <i class="bi bi-info-circle me-1"></i>This action will execute a <code>DELETE FROM feedback WHERE id = ?</code> query and cannot be undone.
                    </div>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash-fill me-1"></i> Yes, Delete Record
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
