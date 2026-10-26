<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Experiment 1: GET vs POST - Student Feedback Portal" />
<c:set var="activePage" value="experiments" />

<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container my-5">
    <!-- Header -->
    <div class="mb-4">
        <span class="badge bg-primary text-uppercase px-3 py-2 fw-bold">Syllabus Experiment 1</span>
        <h2 class="fw-bold mt-2">HTML Forms, Servlets, GET and POST Requests</h2>
        <p class="text-muted">
            Demonstrates how client form inputs are transmitted and how Java Servlets handle them via <code>doGet()</code> and <code>doPost()</code>.
        </p>
    </div>

    <div class="row g-4">
        <!-- Form Column -->
        <div class="col-lg-5">
            <div class="card card-portal h-100">
                <div class="card-header card-header-portal">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-ui-checks text-primary me-2"></i>Interactive Test Form</h5>
                </div>
                <div class="card-body p-4">
                    <form id="testForm" action="${pageContext.request.contextPath}/demo-request" method="GET">
                        <div class="mb-3">
                            <label for="testName" class="form-label fw-semibold">Student Name</label>
                            <input type="text" class="form-control" id="testName" name="testName"
                                   placeholder="e.g. Ankit Verma"
                                   value="<c:out value='${testName != null ? testName : "Ankit Verma"}' />" required>
                        </div>

                        <div class="mb-3">
                            <label for="testTopic" class="form-label fw-semibold">Feedback Subject</label>
                            <select class="form-select" id="testTopic" name="testTopic">
                                <option value="Servlet Lifecycle" ${testTopic == 'Servlet Lifecycle' ? 'selected' : ''}>Servlet Lifecycle</option>
                                <option value="HTTP Protocol" ${testTopic == 'HTTP Protocol' ? 'selected' : ''}>HTTP Protocol</option>
                                <option value="Session Tracking" ${testTopic == 'Session Tracking' ? 'selected' : ''}>Session Tracking</option>
                                <option value="JDBC Connection" ${testTopic == 'JDBC Connection' ? 'selected' : ''}>JDBC Connection</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label for="testComments" class="form-label fw-semibold">Comments</label>
                            <textarea class="form-control" id="testComments" name="testComments" rows="3"
                                      placeholder="Write test notes..."><c:out value='${testComments != null ? testComments : "Testing HTTP request methods in Servlet"}' /></textarea>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-outline-primary py-2" onclick="submitForm('GET')">
                                <i class="bi bi-box-arrow-up-right me-1"></i> Submit using HTTP GET
                            </button>
                            <button type="button" class="btn btn-navy py-2" onclick="submitForm('POST')">
                                <i class="bi bi-send-check-fill me-1"></i> Submit using HTTP POST
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Request Analysis Column -->
        <div class="col-lg-7">
            <div class="card card-portal h-100">
                <div class="card-header card-header-portal d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-cpu text-success me-2"></i>Servlet Request Inspector</h5>
                    <span class="badge ${httpMethod == 'POST' ? 'bg-danger' : 'bg-primary'} px-3 py-2">
                        Method: <c:out value="${httpMethod}" />
                    </span>
                </div>
                <div class="card-body p-4">
                    <c:choose>
                        <c:when test="${isSubmitted}">
                            <div class="alert alert-success border-0 py-2 mb-3">
                                <i class="bi bi-check-circle-fill me-1"></i> Handled by Servlet: <code>do<c:out value="${httpMethod.substring(0, 1)}${httpMethod.substring(1).toLowerCase()}" />(HttpServletRequest, HttpServletResponse)</code>
                            </div>

                            <table class="table table-bordered table-sm small align-middle mb-4">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 30%;">Request Property</th>
                                        <th>Captured Value from Servlet API</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="fw-semibold"><code>request.getMethod()</code></td>
                                        <td><span class="badge bg-secondary"><c:out value="${httpMethod}" /></span></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold"><code>request.getParameter("testName")</code></td>
                                        <td><strong><c:out value="${testName}" /></strong></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold"><code>request.getParameter("testTopic")</code></td>
                                        <td><c:out value="${testTopic}" /></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold"><code>request.getParameter("testComments")</code></td>
                                        <td><c:out value="${testComments}" /></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold"><code>request.getQueryString()</code></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty queryString}">
                                                    <code class="text-break"><c:out value="${queryString}" /></code>
                                                </c:when>
                                                <c:otherwise>
                                                    <em class="text-muted">null (Parameters passed invisibly inside the HTTP request body)</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold"><code>request.getContentType()</code></td>
                                        <td><c:out value="${contentType != null ? contentType : 'application/x-www-form-urlencoded'}" /></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold"><code>request.getContentLength()</code></td>
                                        <td><c:out value="${contentLength}" /> bytes</td>
                                    </tr>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-arrow-left-circle display-4 d-block mb-2 text-primary opacity-50"></i>
                                <h6>Submit the form using GET or POST to view live Servlet inspection details.</h6>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Academic Theory Summary Table for Viva -->
                    <div class="border rounded p-3 bg-light">
                        <h6 class="fw-bold mb-2 text-dark"><i class="bi bi-lightbulb-fill text-warning me-1"></i> Viva Voce Reference: GET vs POST</h6>
                        <div class="table-responsive">
                            <table class="table table-sm table-striped small mb-0">
                                <thead>
                                    <tr>
                                        <th>Aspect</th>
                                        <th>HTTP GET</th>
                                        <th>HTTP POST</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="fw-semibold">Servlet Handler</td>
                                        <td><code>doGet()</code></td>
                                        <td><code>doPost()</code></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold">Data Placement</td>
                                        <td>Appended to URL query string</td>
                                        <td>Sent in HTTP message body</td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold">Data Visibility</td>
                                        <td>Visible in browser address bar</td>
                                        <td>Hidden from URL bar</td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold">Idempotency</td>
                                        <td>Idempotent (safe for retrieval)</td>
                                        <td>Non-idempotent (creates/updates state)</td>
                                    </tr>
                                    <tr>
                                        <td class="fw-semibold">Payload Size</td>
                                        <td>Limited by URL length (~2048 chars)</td>
                                        <td>Virtually unlimited body size</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function submitForm(method) {
    const form = document.getElementById('testForm');
    form.method = method;
    form.submit();
}
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
