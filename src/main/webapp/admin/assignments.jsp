<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="app-container">
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="active" value="assignments" />
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid p-0">
            <jsp:include page="/includes/alerts.jsp" />

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1"><i class="fa-solid fa-user-check text-primary me-2"></i>Campus Staff Dispatch & Assignments</h2>
                    <p class="text-muted mb-0">Monitor all dispatched tasks, response acceptance times, and resolution logs.</p>
                </div>
                <div class="input-group" style="max-width: 300px;">
                    <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                    <input type="text" id="tableSearchInput" class="form-control form-control-sm" placeholder="Search assignments...">
                </div>
            </div>

            <div class="card card-custom">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty requestScope.assignments}">
                            <div class="text-center py-5 text-muted">
                                <i class="fa-regular fa-clipboard-check fs-1 mb-2 d-block opacity-50"></i>
                                <p class="mb-0">No incident assignments recorded yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom table-hover filterable-table">
                                    <thead>
                                        <tr>
                                            <th>Assign ID</th>
                                            <th>Incident</th>
                                            <th>Category</th>
                                            <th>Priority</th>
                                            <th>Assigned Staff</th>
                                            <th>Assigned By</th>
                                            <th>Dispatch Time</th>
                                            <th>Accepted Time</th>
                                            <th>Completed Time</th>
                                            <th>Assignment Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="a" items="${requestScope.assignments}">
                                            <tr>
                                                <td><strong>#${a.id}</strong></td>
                                                <td>
                                                    <div class="fw-bold text-dark">#${a.incidentId} - ${a.incidentTitle}</div>
                                                    <small class="text-muted"><i class="fa-solid fa-location-dot me-1 text-danger"></i>${a.incidentLocation}</small>
                                                </td>
                                                <td><span class="badge bg-light text-dark border">${a.incidentCategory}</span></td>
                                                <td><span class="badge ${a.incidentPriority == 'CRITICAL' ? 'bg-danger' : (a.incidentPriority == 'HIGH' ? 'bg-warning text-dark' : 'bg-secondary')}">${a.incidentPriority}</span></td>
                                                <td>
                                                    <div class="fw-semibold text-dark">${a.assignedToName}</div>
                                                    <small class="text-muted">${a.assignedToDepartment}</small>
                                                </td>
                                                <td><small class="text-muted">${a.assignedByName}</small></td>
                                                <td class="small text-muted">${a.assignedAt}</td>
                                                <td class="small text-muted">${a.acceptedAt != null ? a.acceptedAt : '<span class=\"text-danger\">Pending</span>'}</td>
                                                <td class="small text-muted">${a.completedAt != null ? a.completedAt : '<span class=\"text-muted\">-</span>'}</td>
                                                <td>
                                                    <span class="badge ${a.assignmentStatus == 'COMPLETED' ? 'bg-success' : (a.assignmentStatus == 'ACCEPTED' ? 'bg-primary' : 'bg-warning text-dark')}">
                                                        ${a.assignmentStatus}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/incident/details?id=${a.incidentId}" class="btn btn-sm btn-light border">
                                                        <i class="fa-solid fa-eye me-1"></i> View
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
