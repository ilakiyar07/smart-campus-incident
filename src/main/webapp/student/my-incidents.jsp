<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="app-container">
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="active" value="my-incidents" />
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid p-0">
            <jsp:include page="/includes/alerts.jsp" />

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1"><i class="fa-solid fa-clipboard-list text-primary me-2"></i>My Reported Incidents</h2>
                    <p class="text-muted mb-0">Track live resolution progress and history of all incidents submitted by you.</p>
                </div>
                <a href="${pageContext.request.contextPath}/student/report-incident" class="btn btn-danger btn-sm px-3 fw-bold">
                    <i class="fa-solid fa-circle-plus me-1"></i> New Report
                </a>
            </div>

            <!-- Status Filter Navigation Pills -->
            <div class="card card-custom p-3 mb-4">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div class="btn-group flex-wrap" role="group">
                        <a href="${pageContext.request.contextPath}/student/my-incidents?status=ALL" class="btn btn-sm ${requestScope.currentFilter == 'ALL' ? 'btn-primary' : 'btn-outline-secondary'}">All</a>
                        <a href="${pageContext.request.contextPath}/student/my-incidents?status=REPORTED" class="btn btn-sm ${requestScope.currentFilter == 'REPORTED' ? 'btn-warning text-dark' : 'btn-outline-secondary'}">Reported</a>
                        <a href="${pageContext.request.contextPath}/student/my-incidents?status=ASSIGNED" class="btn btn-sm ${requestScope.currentFilter == 'ASSIGNED' ? 'btn-info text-white' : 'btn-outline-secondary'}">Assigned</a>
                        <a href="${pageContext.request.contextPath}/student/my-incidents?status=IN_PROGRESS" class="btn btn-sm ${requestScope.currentFilter == 'IN_PROGRESS' ? 'btn-primary' : 'btn-outline-secondary'}">In Progress</a>
                        <a href="${pageContext.request.contextPath}/student/my-incidents?status=RESOLVED" class="btn btn-sm ${requestScope.currentFilter == 'RESOLVED' ? 'btn-success' : 'btn-outline-secondary'}">Resolved</a>
                        <a href="${pageContext.request.contextPath}/student/my-incidents?status=CLOSED" class="btn btn-sm ${requestScope.currentFilter == 'CLOSED' ? 'btn-secondary' : 'btn-outline-secondary'}">Closed</a>
                    </div>

                    <div class="input-group" style="max-width: 300px;">
                        <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                        <input type="text" id="tableSearchInput" class="form-control form-control-sm" placeholder="Search my reports...">
                    </div>
                </div>
            </div>

            <!-- Incidents Table -->
            <div class="card card-custom">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty requestScope.incidents}">
                            <div class="text-center py-5 text-muted">
                                <i class="fa-regular fa-folder-open fs-1 mb-2 d-block opacity-50"></i>
                                <p class="mb-2">No incidents found under the selected filter.</p>
                                <a href="${pageContext.request.contextPath}/student/report-incident" class="btn btn-sm btn-danger">Create New Incident Report</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom table-hover filterable-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Incident Title</th>
                                            <th>Category</th>
                                            <th>Priority</th>
                                            <th>Location</th>
                                            <th>Status</th>
                                            <th>Assigned Staff</th>
                                            <th>Reported Date</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="inc" items="${requestScope.incidents}">
                                            <tr>
                                                <td><strong class="text-primary">#${inc.id}</strong></td>
                                                <td>
                                                    <div class="fw-bold text-dark">${inc.title}</div>
                                                </td>
                                                <td><span class="badge bg-light text-dark border">${inc.categoryDisplayName}</span></td>
                                                <td><span class="badge-priority ${inc.priorityBadgeClass}">${inc.priority}</span></td>
                                                <td><small class="text-muted"><i class="fa-solid fa-location-dot me-1 text-danger"></i>${inc.location}</small></td>
                                                <td><span class="badge-status ${inc.statusBadgeClass}">${inc.status}</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty inc.assignedStaffName}">
                                                            <div class="small fw-semibold text-dark">${inc.assignedStaffName}</div>
                                                            <small class="text-muted">${inc.assignedStaffDepartment}</small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted small fst-italic">Pending dispatch</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="small text-muted">${inc.createdAt}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/incident/details?id=${inc.id}" class="btn btn-sm btn-primary">
                                                        <i class="fa-solid fa-timeline me-1"></i> Track
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
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
