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

            <!-- Welcome Banner -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1">Staff Operations: ${sessionScope.userName}</h2>
                    <p class="text-muted mb-0"><i class="fa-solid fa-id-badge me-1"></i> Department: <strong>${sessionScope.userDept != null ? sessionScope.userDept : 'Campus Security'}</strong></p>
                </div>
                <a href="${pageContext.request.contextPath}/staff/assigned-incidents" class="btn btn-primary px-3 fw-bold">
                    <i class="fa-solid fa-list-check me-1"></i> View All My Tasks
                </a>
            </div>

            <!-- Stats Row -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Total Assigned</div>
                            <div class="stat-number">${requestScope.stats.total_assigned != null ? requestScope.stats.total_assigned : 0}</div>
                        </div>
                        <div class="stat-icon icon-blue"><i class="fa-solid fa-clipboard-user"></i></div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Pending Acceptance</div>
                            <div class="stat-number text-danger">${requestScope.stats.pending_acceptance != null ? requestScope.stats.pending_acceptance : 0}</div>
                        </div>
                        <div class="stat-icon icon-red"><i class="fa-solid fa-clock"></i></div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">In Progress</div>
                            <div class="stat-number text-warning">${requestScope.stats.in_progress != null ? requestScope.stats.in_progress : 0}</div>
                        </div>
                        <div class="stat-icon icon-amber"><i class="fa-solid fa-person-digging"></i></div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Completed / Resolved</div>
                            <div class="stat-number text-success">${requestScope.stats.resolved != null ? requestScope.stats.resolved : 0}</div>
                        </div>
                        <div class="stat-icon icon-green"><i class="fa-solid fa-circle-check"></i></div>
                    </div>
                </div>
            </div>

            <!-- Assigned Incidents Taskboard -->
            <div class="card card-custom">
                <div class="card-header">
                    <span><i class="fa-solid fa-tasks me-2 text-primary"></i>Assigned Campus Emergency & Maintenance Tasks</span>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty requestScope.assignedIncidents}">
                            <div class="text-center py-5 text-muted">
                                <i class="fa-solid fa-clipboard-check fs-1 mb-2 d-block text-success opacity-50"></i>
                                <p class="mb-0">No active incidents currently assigned to you.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Incident Title</th>
                                            <th>Category</th>
                                            <th>Priority</th>
                                            <th>Location</th>
                                            <th>Current Status</th>
                                            <th>Assigned Date</th>
                                            <th>Quick Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="inc" items="${requestScope.assignedIncidents}">
                                            <tr>
                                                <td><strong>#${inc.id}</strong></td>
                                                <td>
                                                    <div class="fw-bold text-dark">${inc.title}</div>
                                                    <small class="text-muted">Reported by: ${inc.reportedByName} (${inc.reportedByDepartment})</small>
                                                </td>
                                                <td><span class="badge bg-light text-dark border">${inc.categoryDisplayName}</span></td>
                                                <td><span class="badge-priority ${inc.priorityBadgeClass}">${inc.priority}</span></td>
                                                <td><small class="text-muted"><i class="fa-solid fa-location-dot me-1 text-danger"></i>${inc.location}</small></td>
                                                <td><span class="badge-status ${inc.statusBadgeClass}">${inc.status}</span></td>
                                                <td class="small text-muted">${inc.createdAt}</td>
                                                <td>
                                                    <div class="d-flex gap-1">
                                                        <c:if test="${inc.status == 'ASSIGNED'}">
                                                            <form action="${pageContext.request.contextPath}/incident/update-status" method="POST" class="d-inline">
                                                                <input type="hidden" name="incidentId" value="${inc.id}">
                                                                <input type="hidden" name="action" value="accept">
                                                                <input type="hidden" name="note" value="Staff accepted assignment and initiated response.">
                                                                <button type="submit" class="btn btn-sm btn-success">
                                                                    <i class="fa-solid fa-check me-1"></i> Accept
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${inc.status == 'IN_PROGRESS'}">
                                                            <a href="${pageContext.request.contextPath}/incident/details?id=${inc.id}" class="btn btn-sm btn-warning text-dark">
                                                                <i class="fa-solid fa-wrench me-1"></i> Update / Resolve
                                                            </a>
                                                        </c:if>
                                                        <a href="${pageContext.request.contextPath}/incident/details?id=${inc.id}" class="btn btn-sm btn-light border">
                                                            Details
                                                        </a>
                                                    </div>
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
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
