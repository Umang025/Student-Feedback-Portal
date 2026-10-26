<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Submit Feedback - Student Feedback Portal" />
<c:set var="activePage" value="submit" />

<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="card card-portal shadow-sm">
                <div class="card-header card-header-portal d-flex align-items-center justify-content-between">
                    <div>
                        <h4 class="mb-0 fw-bold text-dark"><i class="bi bi-pencil-square text-primary me-2"></i>Student Feedback Form</h4>
                        <small class="text-muted">Please share your honest ratings and feedback to help improve college facilities.</small>
                    </div>
                    <span class="badge bg-primary text-uppercase px-2 py-1">Experiment 1 &amp; 4</span>
                </div>

                <div class="card-body p-4">
                    <!-- Error Message Alert -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <c:out value="${errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/submit-feedback" method="POST" novalidate>

                        <!-- Student Name -->
                        <div class="mb-3">
                            <label for="student_name" class="form-label fw-semibold">
                                Student Full Name <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                                <input type="text"
                                       class="form-control"
                                       id="student_name"
                                       name="student_name"
                                       placeholder="e.g. Rahul Sharma"
                                       maxlength="100"
                                       value="<c:out value='${paramStudentName}' />"
                                       required>
                            </div>
                            <div class="form-text">As registered in college student records.</div>
                        </div>

                        <!-- Email Address -->
                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">
                                Student Email Address <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                                <input type="email"
                                       class="form-control"
                                       id="email"
                                       name="email"
                                       placeholder="e.g. rahul.sharma@example.edu"
                                       maxlength="150"
                                       value="<c:out value='${paramEmail}' />"
                                       required>
                            </div>
                            <div class="form-text">Used for reference acknowledgement and verification.</div>
                        </div>

                        <!-- Feedback Category -->
                        <div class="mb-3">
                            <label for="category" class="form-label fw-semibold">
                                Feedback Category <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-tag"></i></span>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="" disabled ${empty paramCategory ? 'selected' : ''}>-- Choose Category --</option>
                                    <option value="Teaching" ${paramCategory == 'Teaching' ? 'selected' : ''}>Teaching (Lectures, Notes, Faculty)</option>
                                    <option value="Laboratory" ${paramCategory == 'Laboratory' ? 'selected' : ''}>Laboratory (Systems, Hardware, Software)</option>
                                    <option value="Library" ${paramCategory == 'Library' ? 'selected' : ''}>Library (Books, Journals, Reading Hall)</option>
                                    <option value="Hostel" ${paramCategory == 'Hostel' ? 'selected' : ''}>Hostel (Rooms, Mess, Cleanliness)</option>
                                    <option value="Internet" ${paramCategory == 'Internet' ? 'selected' : ''}>Internet (Wi-Fi Speed &amp; Coverage)</option>
                                    <option value="Other" ${paramCategory == 'Other' ? 'selected' : ''}>Other (Campus Sports, Canteen, Admin)</option>
                                </select>
                            </div>
                        </div>

                        <!-- Star Rating -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold d-block">
                                Rating <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex align-items-center gap-3">
                                <div class="star-rating-group">
                                    <input type="radio" id="star5" name="rating" value="5" ${paramRating == '5' ? 'checked' : ''} required>
                                    <label for="star5" title="5 Stars - Excellent">★</label>

                                    <input type="radio" id="star4" name="rating" value="4" ${paramRating == '4' ? 'checked' : ''}>
                                    <label for="star4" title="4 Stars - Very Good">★</label>

                                    <input type="radio" id="star3" name="rating" value="3" ${paramRating == '3' ? 'checked' : ''}>
                                    <label for="star3" title="3 Stars - Good">★</label>

                                    <input type="radio" id="star2" name="rating" value="2" ${paramRating == '2' ? 'checked' : ''}>
                                    <label for="star2" title="2 Stars - Fair">★</label>

                                    <input type="radio" id="star1" name="rating" value="1" ${paramRating == '1' ? 'checked' : ''}>
                                    <label for="star1" title="1 Star - Poor">★</label>
                                </div>
                                <span id="rating-text" class="text-muted small">Select star rating (1 to 5)</span>
                            </div>
                        </div>

                        <!-- Feedback Message -->
                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <label for="message" class="form-label fw-semibold">
                                    Feedback Comments &amp; Suggestions <span class="text-danger">*</span>
                                </label>
                                <span id="char-counter" class="text-muted small">0 / 2000 characters</span>
                            </div>
                            <textarea class="form-control"
                                      id="message"
                                      name="message"
                                      rows="5"
                                      placeholder="Provide detailed constructive feedback..."
                                      maxlength="2000"
                                      required><c:out value="${paramMessage}" /></textarea>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="d-flex justify-content-between align-items-center pt-2">
                            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-blue px-4 py-2 fw-semibold">
                                <i class="bi bi-send-fill me-2"></i> Submit Feedback
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
