<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Edit Feedback - Student Feedback Portal" />
<c:set var="activePage" value="dashboard" />

<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="card card-portal shadow-sm">
                <div class="card-header card-header-portal d-flex align-items-center justify-content-between">
                    <div>
                        <h4 class="mb-0 fw-bold text-dark"><i class="bi bi-pencil-square text-primary me-2"></i>Edit Feedback Record</h4>
                        <small class="text-muted">Demonstrating JDBC UPDATE (Experiment 4)</small>
                    </div>
                    <span class="badge bg-primary">Record #<c:out value="${feedback.id}" /></span>
                </div>

                <div class="card-body p-4">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <c:out value="${errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/feedback/edit" method="POST">
                        <input type="hidden" name="id" value="<c:out value='${feedback.id}' />">

                        <!-- Student Name -->
                        <div class="mb-3">
                            <label for="student_name" class="form-label fw-semibold">
                                Student Name <span class="text-danger">*</span>
                            </label>
                            <input type="text"
                                   class="form-control"
                                   id="student_name"
                                   name="student_name"
                                   value="<c:out value='${feedback.studentName}' />"
                                   maxlength="100"
                                   required>
                        </div>

                        <!-- Email Address -->
                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">
                                Email Address <span class="text-danger">*</span>
                            </label>
                            <input type="email"
                                   class="form-control"
                                   id="email"
                                   name="email"
                                   value="<c:out value='${feedback.email}' />"
                                   maxlength="150"
                                   required>
                        </div>

                        <!-- Category -->
                        <div class="mb-3">
                            <label for="category" class="form-label fw-semibold">
                                Category <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="category" name="category" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat}" ${feedback.category == cat ? 'selected' : ''}>
                                        <c:out value="${cat}" />
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Star Rating -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold d-block">Rating <span class="text-danger">*</span></label>
                            <div class="d-flex align-items-center gap-3">
                                <div class="star-rating-group">
                                    <input type="radio" id="edit_star5" name="rating" value="5" ${feedback.rating == 5 ? 'checked' : ''} required>
                                    <label for="edit_star5" title="5 Stars">★</label>

                                    <input type="radio" id="edit_star4" name="rating" value="4" ${feedback.rating == 4 ? 'checked' : ''}>
                                    <label for="edit_star4" title="4 Stars">★</label>

                                    <input type="radio" id="edit_star3" name="rating" value="3" ${feedback.rating == 3 ? 'checked' : ''}>
                                    <label for="edit_star3" title="3 Stars">★</label>

                                    <input type="radio" id="edit_star2" name="rating" value="2" ${feedback.rating == 2 ? 'checked' : ''}>
                                    <label for="edit_star2" title="2 Stars">★</label>

                                    <input type="radio" id="edit_star1" name="rating" value="1" ${feedback.rating == 1 ? 'checked' : ''}>
                                    <label for="edit_star1" title="1 Star">★</label>
                                </div>
                                <span id="rating-text" class="text-muted small">${feedback.rating} Stars selected</span>
                            </div>
                        </div>

                        <!-- Feedback Message -->
                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <label for="message" class="form-label fw-semibold">
                                    Feedback Message <span class="text-danger">*</span>
                                </label>
                                <span id="char-counter" class="text-muted small"></span>
                            </div>
                            <textarea class="form-control"
                                      id="message"
                                      name="message"
                                      rows="5"
                                      maxlength="2000"
                                      required><c:out value="${feedback.message}" /></textarea>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-between align-items-center pt-2">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle me-1"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-blue px-4 py-2 fw-semibold">
                                <i class="bi bi-check-lg me-1"></i> Save Changes (UPDATE)
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
