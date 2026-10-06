<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="app-container">
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="active" value="incidents" />
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid p-0">
            <jsp:include page="/includes/alerts.jsp" />

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1"><i class="fa-solid fa-list-check text-primary me-2"></i>Campus Incidents Master Registry</h2>
                    <p class="text-muted mb-0">Search, filter, assign, reclassify, and manage the complete campus incident database.</p>
                </div>
            </div>

            <!-- Multi-Criteria Filter Bar -->
            <div class="card card-custom p-3 mb-4">
                <form action="${pageContext.request.contextPath}/admin/incidents" method="GET" class="row g-2 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-muted mb-1">Search Keywords</label>
                        <div class="input-group input-group-sm">
                            <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                            <input type="text" name="search" class="form-control" placeholder="Title, location, reporter..." value="${requestScope.searchQuery}">
                        </div>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small fw-bold text-muted mb-1">Category</label>
                        <select name="category" class="form-select form-select-sm">
                            <option value="ALL" ${requestScope.selectedCategory == 'ALL' ? 'selected' : ''}>All Categories</option>
                            <option value="MEDICAL" ${requestScope.selectedCategory == 'MEDICAL' ? 'selected' : ''}>Medical</option>
                            <option value="FIRE" ${requestScope.selectedCategory == 'FIRE' ? 'selected' : ''}>Fire / Smoke</option>
                            <option value="SECURITY" ${requestScope.selectedCategory == 'SECURITY' ? 'selected' : ''}>Security</option>
                            <option value="HARASSMENT" ${requestScope.selectedCategory == 'HARASSMENT' ? 'selected' : ''}>Harassment</option>
                            <option value="SUSPICIOUS_ACTIVITY" ${requestScope.selectedCategory == 'SUSPICIOUS_ACTIVITY' ? 'selected' : ''}>Suspicious Activity</option>
                            <option value="ELECTRICAL" ${requestScope.selectedCategory == 'ELECTRICAL' ? 'selected' : ''}>Electrical</option>
                            <option value="PLUMBING" ${requestScope.selectedCategory == 'PLUMBING' ? 'selected' : ''}>Plumbing</option>
                            <option value="INFRASTRUCTURE" ${requestScope.selectedCategory == 'INFRASTRUCTURE' ? 'selected' : ''}>Infrastructure</option>
                            <option value="ACCIDENT" ${requestScope.selectedCategory == 'ACCIDENT' ? 'selected' : ''}>Accident</option>
                            <option value="OTHER" ${requestScope.selectedCategory == 'OTHER' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small fw-bold text-muted mb-1">Priority</label>
                        <select name="priority" class="form-select form-select-sm">
                            <option value="ALL" ${requestScope.selectedPriority == 'ALL' ? 'selected' : ''}>All Priorities</option>
                            <option value="CRITICAL" ${requestScope.selectedPriority == 'CRITICAL' ? 'selected' : ''}>Critical</option>
                            <option value="HIGH" ${requestScope.selectedPriority == 'HIGH' ? 'selected' : ''}>High</option>
                            <option value="MEDIUM" ${requestScope.selectedPriority == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                            <option value="LOW" ${requestScope.selectedPriority == 'LOW' ? 'selected' : ''}>Low</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small fw-bold text-muted mb-1">Status</label>
                        <select name="status" class="form-select form-select-sm">
                            <option value="ALL" ${requestScope.selectedStatus == 'ALL' ? 'selected' : ''}>All Statuses</option>
                            <option value="REPORTED" ${requestScope.selectedStatus == 'REPORTED' ? 'selected' : ''}>Reported</option>
                            <option value="ASSIGNED" ${requestScope.selectedStatus == 'ASSIGNED' ? 'selected' : ''}>Assigned</option>
                            <option value="IN_PROGRESS" ${requestScope.selectedStatus == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                            <option value="RESOLVED" ${requestScope.selectedStatus == 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                            <option value="CLOSED" ${requestScope.selectedStatus == 'CLOSED' ? 'selected' : ''}>Closed</option>
                        </select>
                    </div>

                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary btn-sm flex-fill fw-bold">
                            <i class="fa-solid fa-filter me-1"></i> Apply Filter
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/incidents" class="btn btn-light btn-sm border" title="Reset Filters">
                            <i class="fa-solid fa-rotate-left"></i>
                        </a>
                    </div>
                </form>
            </div>

            <!-- Master Table -->
            <div class="card card-custom">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty requestScope.incidents}">
                            <div class="text-center py-5 text-muted">
                                <i class="fa-solid fa-magnifying-glass fs-1 mb-2 d-block opacity-50"></i>
                                <p class="mb-0">No incidents match the selected filter criteria.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Title</th>
                                            <th>Reporter</th>
                                            <th>Category</th>
                                            <th>Priority</th>
                                            <th>Location</th>
                                            <th>Status</th>
                                            <th>Assigned Staff</th>
                                            <th>Date</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="inc" items="${requestScope.incidents}">
                                            <tr class="${inc.priority == 'CRITICAL' && inc.status != 'CLOSED' ? 'table-danger' : ''}">
                                                <td><strong>#${inc.id}</strong></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/incident/details?id=${inc.id}" class="fw-bold text-dark text-decoration-none">
                                                        ${inc.title}
                                                    </a>
                                                </td>
                                                <td>
                                                    <div class="small fw-semibold">${inc.reportedByName}</div>
                                                    <small class="text-muted">${inc.reportedByDepartment}</small>
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
                                                            <button type="button" class="btn btn-sm btn-outline-primary py-0 px-2" data-bs-toggle="modal" data-bs-target="#assignModal" onclick="prepareAssignModal('${inc.id}', '${inc.title}')">
                                                                <i class="fa-solid fa-user-plus me-1"></i> Assign
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="small text-muted">${inc.createdAt}</td>
                                                <td class="text-end">
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-light border dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                                            Manage
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                                            <li>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/incident/details?id=${inc.id}">
                                                                    <i class="fa-solid fa-eye me-2 text-primary"></i> View Details & Audit
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#assignModal" onclick="prepareAssignModal('${inc.id}', '${inc.title}')">
                                                                    <i class="fa-solid fa-user-check me-2 text-info"></i> ${empty inc.assignedStaffName ? 'Assign Staff' : 'Reassign Staff'}
                                                                </a>
                                                            </li>
                                                            <c:if test="${inc.status == 'RESOLVED'}">
                                                                <li>
                                                                    <form action="${pageContext.request.contextPath}/incident/update-status" method="POST" onsubmit="return confirmAction('Officially verify and close this resolved incident?');">
                                                                        <input type="hidden" name="incidentId" value="${inc.id}">
                                                                        <input type="hidden" name="action" value="close">
                                                                        <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/admin/incidents">
                                                                        <button type="submit" class="dropdown-item text-success">
                                                                            <i class="fa-solid fa-check-double me-2"></i> Close Incident
                                                                        </button>
                                                                    </form>
                                                                </li>
                                                            </c:if>
                                                            <li><hr class="dropdown-menu-divider"></li>
                                                            <li>
                                                                <form action="${pageContext.request.contextPath}/incident/delete" method="POST" onsubmit="return confirmAction('Permanently delete this incident and its history? This action cannot be undone.');">
                                                                    <input type="hidden" name="incidentId" value="${inc.id}">
                                                                    <button type="submit" class="dropdown-item text-danger">
                                                                        <i class="fa-solid fa-trash me-2"></i> Delete Report
                                                                    </button>
                                                                </form>
                                                            </li>
                                                        </ul>
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

<!-- Modal: Assign Incident -->
<div class="modal fade" id="assignModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/assign-incident" method="POST">
                <input type="hidden" id="modalIncidentId" name="incidentId">
                <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/admin/incidents">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-check text-primary me-2"></i>Assign Staff Responder</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-3">Incident: <strong id="modalIncidentTitle" class="text-primary"></strong></p>
                    <div class="mb-3">
                        <label for="modalStaffSelect" class="form-label fw-semibold">Select Responder <span class="text-danger">*</span></label>
                        <select class="form-select" id="modalStaffSelect" name="staffId" required>
                            <option value="" disabled selected>-- Choose from Active Staff --</option>
                            <c:forEach var="s" items="${requestScope.staffList}">
                                <option value="${s.id}">${s.fullName} &bull; ${s.department} (${s.email})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="modalAssignNote" class="form-label fw-semibold">Dispatch Note / Instructions</label>
                        <textarea class="form-control" id="modalAssignNote" name="note" rows="3" placeholder="Add specific task instructions or priority notices..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary fw-bold">Dispatch Staff</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
