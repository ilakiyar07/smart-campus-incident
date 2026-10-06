<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="app-container">
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="active" value="assigned" />
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid p-0">
            <jsp:include page="/includes/alerts.jsp" />

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1"><i class="fa-solid fa-clipboard-user text-primary me-2"></i>My Assigned Campus Incidents</h2>
                    <p class="text-muted mb-0">Manage and progress all emergency, security, and maintenance assignments dispatched to you.</p>
                </div>
            </div>

            <!-- Filter navigation -->
            <div class="card card-custom p-3 mb-4">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div class="btn-group flex-wrap" role="group">
                        <a href="${pageContext.request.contextPath}/staff/assigned-incidents?status=ALL" class="btn btn-sm ${requestScope.currentFilter == 'ALL' ? 'btn-primary' : 'btn-outline-secondary'}">All</a>
                        <a href="${pageContext.request.contextPath}/staff/assigned-incidents?status=ASSIGNED" class="btn btn-sm ${requestScope.currentFilter == 'ASSIGNED' ? 'btn-danger text-white' : 'btn-outline-secondary'}">Pending Acceptance</a>
                        <a href="${pageContext.request.contextPath}/staff/assigned-incidents?status=IN_PROGRESS" class="btn btn-sm ${requestScope.currentFilter == 'IN_PROGRESS' ? 'btn-warning text-dark' : 'btn-outline-secondary'}">In Progress</a>
                        <a href="${pageContext.request.contextPath}/staff/assigned-incidents?status=RESOLVED" class="btn btn-sm ${requestScope.currentFilter == 'RESOLVED' ? 'btn-success' : 'btn-outline-secondary'}">Resolved</a>
                        <a href="${pageContext.request.contextPath}/staff/assigned-incidents?status=CLOSED" class="btn btn-sm ${requestScope.currentFilter == 'CLOSED' ? 'btn-secondary' : 'btn-outline-secondary'}">Closed</a>
                    </div>

                    <div class="input-group" style="max-width: 300px;">
                        <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                        <input type="text" id="tableSearchInput" class="form-control form-control-sm" placeholder="Search my tasks...">
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="card card-custom">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty requestScope.incidents}">
                            <div class="text-center py-5 text-muted">
                                <i class="fa-regular fa-calendar-check fs-1 mb-2 d-block opacity-50"></i>
                                <p class="mb-0">No incidents found in this category.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom table-hover filterable-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Incident Title</th>
                                            <th>Reporter Info</th>
                                            <th>Category</th>
                                            <th>Priority</th>
                                            <th>Location</th>
                                            <th>Status</th>
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
                                                <td>
                                                    <div>${inc.reportedByName}</div>
                                                    <small class="text-muted">${inc.reportedByPhone != null ? inc.reportedByPhone : inc.reportedByDepartment}</small>
                                                </td>
                                                <td><span class="badge bg-light text-dark border">${inc.categoryDisplayName}</span></td>
                                                <td><span class="badge-priority ${inc.priorityBadgeClass}">${inc.priority}</span></td>
                                                <td><small class="text-muted"><i class="fa-solid fa-location-dot me-1 text-danger"></i>${inc.location}</small></td>
                                                <td><span class="badge-status ${inc.statusBadgeClass}">${inc.status}</span></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/incident/details?id=${inc.id}" class="btn btn-sm btn-primary">
                                                        <i class="fa-solid fa-wrench me-1"></i> Manage
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
