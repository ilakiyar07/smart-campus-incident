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
                    <h2 class="fw-bold mb-1">Campus Command Center</h2>
                    <p class="text-muted mb-0"><i class="fa-solid fa-user-shield me-1 text-primary"></i> Administrator: <strong>${sessionScope.userName}</strong> &bull; Incident Operations Hub</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-primary btn-sm px-3">
                        <i class="fa-solid fa-chart-pie me-1"></i> Analytics
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/incidents" class="btn btn-primary btn-sm px-3 fw-bold">
                        <i class="fa-solid fa-list-check me-1"></i> Master Incidents
                    </a>
                </div>
            </div>

            <!-- Emergency Warning Banner if Critical incidents exist -->
            <c:if test="${requestScope.stats.critical > 0}">
                <div class="emergency-banner shadow-sm">
                    <div class="d-flex align-items-center gap-3">
                        <i class="fa-solid fa-triangle-exclamation fs-3"></i>
                        <div>
                            <h6 class="fw-bold mb-0">ACTIVE CRITICAL INCIDENTS DETECTED (${requestScope.stats.critical})</h6>
                            <small>Immediate campus authority response and staff dispatch required.</small>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/incidents?priority=CRITICAL" class="btn btn-sm btn-danger fw-bold">
                        View Critical Now
                    </a>
                </div>
            </c:if>

            <!-- 7 Statistics Metrics Grid -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-md-4 col-xl">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Total Incidents</div>
                            <div class="stat-number">${requestScope.stats.total != null ? requestScope.stats.total : 0}</div>
                        </div>
                        <div class="stat-icon icon-blue"><i class="fa-solid fa-folder-open"></i></div>
                    </div>
                </div>

                <div class="col-6 col-md-4 col-xl">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Critical / Urgent</div>
                            <div class="stat-number text-danger">${requestScope.stats.critical != null ? requestScope.stats.critical : 0}</div>
                        </div>
                        <div class="stat-icon icon-red"><i class="fa-solid fa-circle-exclamation"></i></div>
                    </div>
                </div>

                <div class="col-6 col-md-4 col-xl">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Active Cases</div>
                            <div class="stat-number text-warning">${requestScope.stats.active != null ? requestScope.stats.active : 0}</div>
                        </div>
                        <div class="stat-icon icon-amber"><i class="fa-solid fa-person-running"></i></div>
                    </div>
                </div>

                <div class="col-6 col-md-4 col-xl">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Resolved Cases</div>
                            <div class="stat-number text-success">${requestScope.stats.resolved != null ? requestScope.stats.resolved : 0}</div>
                        </div>
                        <div class="stat-icon icon-green"><i class="fa-solid fa-circle-check"></i></div>
                    </div>
                </div>

                <div class="col-6 col-md-4 col-xl">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Needs Dispatch</div>
                            <div class="stat-number text-info">${requestScope.stats.pending_assignment != null ? requestScope.stats.pending_assignment : 0}</div>
                        </div>
                        <div class="stat-icon icon-purple"><i class="fa-solid fa-user-clock"></i></div>
                    </div>
                </div>
            </div>

            <!-- User Counts Summary Row -->
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="p-3 bg-white rounded-3 border d-flex justify-content-between align-items-center shadow-sm">
                        <div>
                            <span class="text-muted small fw-bold text-uppercase">Registered Students</span>
                            <h4 class="fw-bold mb-0 text-dark">${requestScope.totalStudents}</h4>
                        </div>
                        <i class="fa-solid fa-graduation-cap fs-2 text-primary opacity-50"></i>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="p-3 bg-white rounded-3 border d-flex justify-content-between align-items-center shadow-sm">
                        <div>
                            <span class="text-muted small fw-bold text-uppercase">Active Response Staff</span>
                            <h4 class="fw-bold mb-0 text-dark">${requestScope.totalStaff}</h4>
                        </div>
                        <i class="fa-solid fa-user-shield fs-2 text-success opacity-50"></i>
                    </div>
                </div>
            </div>

            <!-- Recent Incidents Table -->
            <div class="card card-custom">
                <div class="card-header">
                    <span><i class="fa-solid fa-tower-broadcast me-2 text-primary"></i>Recent Incidents Activity</span>
                    <a href="${pageContext.request.contextPath}/admin/incidents" class="btn btn-sm btn-outline-primary">View Full Registry</a>
                </div>
                <div class="card-body p-0">
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
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="inc" items="${requestScope.recentIncidents}">
                                    <tr class="${inc.priority == 'CRITICAL' && inc.status != 'CLOSED' ? 'table-danger' : ''}">
                                        <td><strong>#${inc.id}</strong></td>
                                        <td>
                                            <div class="fw-bold text-dark">${inc.title}</div>
                                            <small class="text-muted">${inc.createdAt}</small>
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
                                                    <span class="small fw-semibold text-dark">${inc.assignedStaffName}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#quickAssignModal" onclick="prepareAssignModal('${inc.id}', '${inc.title}')">
                                                        <i class="fa-solid fa-user-plus me-1"></i> Assign
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/incident/details?id=${inc.id}" class="btn btn-sm btn-light border" title="Control Panel">
                                                <i class="fa-solid fa-gear me-1"></i> Manage
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Modal: Quick Assign -->
<div class="modal fade" id="quickAssignModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/assign-incident" method="POST">
                <input type="hidden" id="modalIncidentId" name="incidentId">
                <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/admin/dashboard">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-check text-primary me-2"></i>Assign Incident to Staff</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-3">Assigning incident: <strong id="modalIncidentTitle" class="text-primary"></strong></p>
                    <div class="mb-3">
                        <label for="staffSelect" class="form-label fw-semibold">Select Campus Responder <span class="text-danger">*</span></label>
                        <select class="form-select" id="staffSelect" name="staffId" required>
                            <option value="" disabled selected>-- Select Staff Member --</option>
                            <c:forEach var="s" items="${requestScope.staffList}">
                                <option value="${s.id}">${s.fullName} &bull; ${s.department} (${s.email})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="assignNote" class="form-label fw-semibold">Instructions / Dispatch Remarks</label>
                        <textarea class="form-control" id="assignNote" name="note" rows="3" placeholder="e.g. Please check electrical mains in Block B room 204 immediately."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary fw-bold">Confirm Dispatch</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
