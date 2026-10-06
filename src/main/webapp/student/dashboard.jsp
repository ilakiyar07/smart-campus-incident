<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="app-container">
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="active" value="dashboard" />
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid p-0">
            <jsp:include page="/includes/alerts.jsp" />

            <!-- Welcome Header -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1">Welcome, ${sessionScope.userName}</h2>
                    <p class="text-muted mb-0"><i class="fa-solid fa-graduation-cap me-1"></i> Student Portal &bull; ${sessionScope.userDept != null ? sessionScope.userDept : 'Campus Student'}</p>
                </div>
                <a href="${pageContext.request.contextPath}/student/report-incident" class="btn btn-danger px-4 py-2 fw-bold shadow-sm">
                    <i class="fa-solid fa-circle-plus me-2"></i> Report Incident
                </a>
            </div>

            <!-- Statistics Cards -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Total Reports</div>
                            <div class="stat-number">${requestScope.stats.total != null ? requestScope.stats.total : 0}</div>
                        </div>
                        <div class="stat-icon icon-blue">
                            <i class="fa-solid fa-bullhorn"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Active Incidents</div>
                            <div class="stat-number text-warning">${requestScope.stats.active != null ? requestScope.stats.active : 0}</div>
                        </div>
                        <div class="stat-icon icon-amber">
                            <i class="fa-solid fa-clock-rotate-left"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Resolved Reports</div>
                            <div class="stat-number text-success">${requestScope.stats.resolved != null ? requestScope.stats.resolved : 0}</div>
                        </div>
                        <div class="stat-icon icon-green">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Incidents & Notifications Grid -->
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card card-custom h-100">
                        <div class="card-header">
                            <span><i class="fa-solid fa-list-check me-2 text-primary"></i>My Recent Reports</span>
                            <a href="${pageContext.request.contextPath}/student/my-incidents" class="btn btn-sm btn-outline-primary">View All</a>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty requestScope.recentIncidents}">
                                    <div class="text-center py-5 text-muted">
                                        <i class="fa-regular fa-clipboard fs-1 mb-2 d-block text-secondary opacity-50"></i>
                                        <p class="mb-2">You haven't reported any incidents yet.</p>
                                        <a href="${pageContext.request.contextPath}/student/report-incident" class="btn btn-sm btn-outline-danger">Report Your First Incident</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-custom table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Title</th>
                                                    <th>Category</th>
                                                    <th>Priority</th>
                                                    <th>Status</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="inc" items="${requestScope.recentIncidents}">
                                                    <tr>
                                                        <td><strong>#${inc.id}</strong></td>
                                                        <td>
                                                            <div class="fw-semibold text-dark">${inc.title}</div>
                                                            <small class="text-muted"><i class="fa-solid fa-location-dot me-1"></i>${inc.location}</small>
                                                        </td>
                                                        <td><span class="badge bg-light text-dark border">${inc.categoryDisplayName}</span></td>
                                                        <td><span class="badge-priority ${inc.priorityBadgeClass}">${inc.priority}</span></td>
                                                        <td><span class="badge-status ${inc.statusBadgeClass}">${inc.status}</span></td>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/incident/details?id=${inc.id}" class="btn btn-sm btn-light border" title="View Timeline">
                                                                <i class="fa-regular fa-eye me-1"></i> Details
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card card-custom h-100">
                        <div class="card-header">
                            <span><i class="fa-regular fa-bell me-2 text-primary"></i>Recent Alerts</span>
                            <a href="${pageContext.request.contextPath}/notifications" class="btn btn-sm btn-outline-primary">All</a>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty requestScope.recentNotifications}">
                                    <div class="text-center py-4 text-muted small">
                                        <i class="fa-regular fa-bell-slash fs-2 mb-2 d-block opacity-50"></i>
                                        No new notifications.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="list-group list-group-flush">
                                        <c:forEach var="notif" items="${requestScope.recentNotifications}">
                                            <div class="list-group-item px-0 py-2 border-bottom ${!notif.read ? 'bg-light-subtle fw-semibold' : ''}">
                                                <div class="d-flex w-100 justify-content-between">
                                                    <small class="text-primary fw-bold">
                                                        <c:if test="${!notif.read}"><span class="badge bg-primary me-1">&bull;</span></c:if>
                                                        Alert
                                                    </small>
                                                    <small class="text-muted" style="font-size: 0.72rem;">${notif.formattedTime}</small>
                                                </div>
                                                <p class="mb-1 small text-dark mt-1">${notif.message}</p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
