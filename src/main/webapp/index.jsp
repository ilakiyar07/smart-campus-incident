<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="container my-4">
    <jsp:include page="/includes/alerts.jsp" />
    
    <!-- Hero Banner -->
    <div class="hero-section mb-5">
        <div class="container">
            <span class="badge bg-white text-primary fw-bold px-3 py-2 rounded-pill text-uppercase mb-3 shadow-sm">
                <i class="fa-solid fa-bolt me-1 text-warning"></i> 24/7 Smart Campus Safety Network
            </span>
            <h1 class="hero-title">SMART CAMPUS<br>EMERGENCY & INCIDENT MANAGEMENT</h1>
            <p class="hero-subtitle">"Report. Respond. Resolve." — A centralized platform for real-time campus safety, infrastructure reporting, and rapid emergency dispatch.</p>
            
            <div class="d-flex justify-content-center gap-3 flex-wrap">
                <c:choose>
                    <c:when test="${empty sessionScope.currentUser}">
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-light btn-lg px-4 py-2 fw-bold text-primary shadow">
                            <i class="fa-solid fa-right-to-bracket me-2"></i> Access Portal
                        </a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline-light btn-lg px-4 py-2 fw-bold">
                            <i class="fa-solid fa-user-plus me-2"></i> Student Registration
                        </a>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${sessionScope.userRole == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-light btn-lg px-4 py-2 fw-bold text-primary shadow">
                                <i class="fa-solid fa-gauge me-2"></i> Go to Admin Dashboard
                            </a>
                        </c:if>
                        <c:if test="${sessionScope.userRole == 'STAFF'}">
                            <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-light btn-lg px-4 py-2 fw-bold text-primary shadow">
                                <i class="fa-solid fa-gauge me-2"></i> Go to Staff Dashboard
                            </a>
                        </c:if>
                        <c:if test="${sessionScope.userRole == 'STUDENT'}">
                            <a href="${pageContext.request.contextPath}/student/report-incident" class="btn btn-warning btn-lg px-4 py-2 fw-bold text-dark shadow">
                                <i class="fa-solid fa-circle-exclamation me-2"></i> Report An Incident
                            </a>
                            <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-light btn-lg px-4 py-2 fw-bold text-primary shadow ms-2">
                                <i class="fa-solid fa-gauge me-2"></i> My Dashboard
                            </a>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- 3 Core Feature Cards -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="feature-card h-100">
                <div class="feature-icon-box bg-danger-subtle text-danger">
                    <i class="fa-solid fa-bullhorn"></i>
                </div>
                <h3 class="h4 fw-bold mb-2">1. REPORT</h3>
                <p class="text-muted">Quickly report emergencies, hazards, maintenance failures, or safety issues with location details and evidence.</p>
                <span class="badge bg-light text-danger border">Instant Logging</span>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card h-100">
                <div class="feature-icon-box bg-primary-subtle text-primary">
                    <i class="fa-solid fa-truck-fast"></i>
                </div>
                <h3 class="h4 fw-bold mb-2">2. RESPOND</h3>
                <p class="text-muted">Authorities immediately receive categorized alerts, prioritize critical emergencies, and dispatch specialized staff.</p>
                <span class="badge bg-light text-primary border">Rapid Assignment</span>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card h-100">
                <div class="feature-icon-box bg-success-subtle text-success">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <h3 class="h4 fw-bold mb-2">3. RESOLVE</h3>
                <p class="text-muted">Track complete step-by-step audit timelines from first response to verified resolution with full transparency.</p>
                <span class="badge bg-light text-success border">End-to-End Tracking</span>
            </div>
        </div>
    </div>

    <!-- Incident Categories Showcase -->
    <div class="card card-custom p-4 mb-5">
        <div class="text-center mb-4">
            <h3 class="fw-bold mb-1">Supported Emergency & Incident Categories</h3>
            <p class="text-muted">Direct routing to relevant campus departments</p>
        </div>

        <div class="row g-3 text-center">
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 bg-light rounded-3 border h-100">
                    <i class="fa-solid fa-heart-pulse text-danger fs-3 mb-2"></i>
                    <div class="fw-bold small">Medical</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 bg-light rounded-3 border h-100">
                    <i class="fa-solid fa-fire text-danger fs-3 mb-2"></i>
                    <div class="fw-bold small">Fire & Smoke</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 bg-light rounded-3 border h-100">
                    <i class="fa-solid fa-shield-halved text-primary fs-3 mb-2"></i>
                    <div class="fw-bold small">Security</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 bg-light rounded-3 border h-100">
                    <i class="fa-solid fa-bolt text-warning fs-3 mb-2"></i>
                    <div class="fw-bold small">Electrical</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 bg-light rounded-3 border h-100">
                    <i class="fa-solid fa-faucet-drip text-info fs-3 mb-2"></i>
                    <div class="fw-bold small">Plumbing</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="p-3 bg-light rounded-3 border h-100">
                    <i class="fa-solid fa-person-falling-burst text-secondary fs-3 mb-2"></i>
                    <div class="fw-bold small">Accident / Other</div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
