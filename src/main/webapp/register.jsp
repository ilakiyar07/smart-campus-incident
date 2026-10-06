<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <jsp:include page="/includes/alerts.jsp" />

            <div id="clientValidationMsg" class="alert alert-danger d-none shadow-sm" role="alert"></div>

            <div class="card card-custom p-4 shadow">
                <div class="text-center mb-4">
                    <div class="bg-success-subtle text-success rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 56px; height: 56px; font-size: 1.5rem;">
                        <i class="fa-solid fa-user-plus"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Student Registration</h3>
                    <p class="text-muted small">Register to report and track campus safety incidents</p>
                </div>

                <form id="registerForm" action="${pageContext.request.contextPath}/register" method="POST">
                    <div class="mb-3">
                        <label for="fullName" class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="fa-regular fa-user text-muted"></i></span>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="${requestScope.fullName}" placeholder="e.g. Alice Johnson" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label fw-semibold">Student Email <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-regular fa-envelope text-muted"></i></span>
                                <input type="email" class="form-control" id="email" name="email" value="${requestScope.email}" placeholder="student@campus.com" required>
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label fw-semibold">Phone Number</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-phone text-muted"></i></span>
                                <input type="text" class="form-control" id="phone" name="phone" value="${requestScope.phone}" placeholder="+1-555-0199">
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="department" class="form-label fw-semibold">Academic Department</label>
                        <select class="form-select" id="department" name="department">
                            <option value="Computer Science">Computer Science</option>
                            <option value="Electrical Engineering">Electrical Engineering</option>
                            <option value="Mechanical Engineering">Mechanical Engineering</option>
                            <option value="Civil Engineering">Civil Engineering</option>
                            <option value="Business Administration">Business Administration</option>
                            <option value="Health Sciences">Health Sciences</option>
                            <option value="General">General / Undeclared</option>
                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="password" class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Min. 6 chars" required minlength="6">
                            </div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label for="confirmPassword" class="form-label fw-semibold">Confirm Password <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-shield-check text-muted"></i></span>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" required>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-light border small text-muted mb-4">
                        <i class="fa-solid fa-circle-info text-primary me-1"></i> New registrations are registered as <strong>STUDENT</strong> accounts. Staff and Admin accounts are provisioned by Campus Administration.
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
                        <i class="fa-solid fa-user-check me-2"></i> Register Account
                    </button>
                </form>

                <div class="text-center mt-4 pt-3 border-top">
                    <span class="text-muted small">Already have an account?</span>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="fw-semibold text-primary ms-1 small">Sign In</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
