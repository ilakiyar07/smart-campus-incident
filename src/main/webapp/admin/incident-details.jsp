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

            <!-- Breadcrumb and Header -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <a href="${pageContext.request.contextPath}/admin/incidents" class="text-decoration-none text-muted small">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back to All Incidents
                    </a>
                    <h2 class="fw-bold mb-0 mt-1">Incident #${incident.id}: ${incident.title}</h2>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge-priority ${incident.priorityBadgeClass} fs-6">${incident.priority}</span>
                    <span class="badge-status ${incident.statusBadgeClass} fs-6">${incident.status}</span>
                </div>
            </div>

            <!-- Admin Control Bar -->
            <div class="card card-custom bg-white border p-3 mb-4 shadow-sm">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <i class="fa-solid fa-sliders text-primary fs-5"></i>
                        <span class="fw-bold">Administrative Actions:</span>
                    </div>

                    <div class="d-flex gap-2 flex-wrap">
                        <button type="button" class="btn btn-outline-primary btn-sm fw-semibold" data-bs-toggle="modal" data-bs-target="#assignModal">
                            <i class="fa-solid fa-user-plus me-1"></i> ${empty incident.assignedStaffName ? 'Assign Staff' : 'Reassign Staff'}
                        </button>

                        <button type="button" class="btn btn-outline-secondary btn-sm fw-semibold" data-bs-toggle="modal" data-bs-target="#reclassifyModal">
                            <i class="fa-solid fa-tag me-1"></i> Edit Priority / Category
                        </button>

                        <c:if test="${incident.status == 'RESOLVED'}">
                            <form action="${pageContext.request.contextPath}/incident/update-status" method="POST" onsubmit="return confirmAction('Verify and officially close this incident?');">
                                <input type="hidden" name="incidentId" value="${incident.id}">
                                <input type="hidden" name="action" value="close">
                                <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/incident/details?id=${incident.id}">
                                <button type="submit" class="btn btn-success btn-sm fw-bold">
                                    <i class="fa-solid fa-check-double me-1"></i> Verify & Close Incident
                                </button>
                            </form>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/incident/delete" method="POST" onsubmit="return confirmAction('Are you sure you want to permanently delete this incident report?');">
                            <input type="hidden" name="incidentId" value="${incident.id}">
                            <button type="submit" class="btn btn-outline-danger btn-sm">
                                <i class="fa-solid fa-trash me-1"></i> Delete
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <!-- Left: Incident Details -->
                <div class="col-lg-7">
                    <div class="card card-custom mb-4">
                        <div class="card-header">
                            <span><i class="fa-solid fa-file-invoice me-2 text-primary"></i>Incident Record Overview</span>
                            <small class="text-muted">ID: #${incident.id}</small>
                        </div>
                        <div class="card-body">
                            <div class="row g-3 mb-4">
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Category</small>
                                    <span class="badge bg-light text-dark border mt-1">${incident.categoryDisplayName}</span>
                                </div>
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Priority Level</small>
                                    <span class="badge-priority ${incident.priorityBadgeClass} mt-1">${incident.priority}</span>
                                </div>
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Campus Location</small>
                                    <div class="fw-bold text-dark mt-1"><i class="fa-solid fa-location-dot me-1 text-danger"></i>${incident.location}</div>
                                </div>
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Incident Date</small>
                                    <div class="text-dark mt-1">${incident.incidentDate}</div>
                                </div>
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Reported By</small>
                                    <div class="fw-bold text-dark mt-1">${incident.reportedByName}</div>
                                    <small class="text-muted">${incident.reportedByDepartment} &bull; ${incident.reportedByEmail}</small>
                                </div>
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Assigned Responder</small>
                                    <div class="mt-1">
                                        <c:choose>
                                            <c:when test="${not empty incident.assignedStaffName}">
                                                <strong class="text-dark">${incident.assignedStaffName}</strong>
                                                <div class="text-muted small">${incident.assignedStaffDepartment}</div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark">Unassigned</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <h6 class="fw-bold text-muted text-uppercase" style="font-size: 0.75rem;">Description</h6>
                                <div class="p-3 bg-light rounded-3 border text-dark" style="white-space: pre-line;">${incident.description}</div>
                            </div>

                            <c:if test="${not empty incident.evidencePath}">
                                <div class="mt-3">
                                    <h6 class="fw-bold text-muted text-uppercase" style="font-size: 0.75rem;">Evidence Attachment</h6>
                                    <a href="${pageContext.request.contextPath}/${incident.evidencePath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                        <i class="fa-solid fa-paperclip me-1"></i> View Uploaded Evidence File
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Add Admin Note -->
                    <div class="card card-custom">
                        <div class="card-header">
                            <span><i class="fa-solid fa-pen-nib me-2 text-primary"></i>Append Administrative Note</span>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/incident/add-note" method="POST">
                                <input type="hidden" name="incidentId" value="${incident.id}">
                                <div class="mb-3">
                                    <textarea class="form-control" name="note" rows="3" placeholder="Enter administrative remark, inspection notes, or resolution verification..." required></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary btn-sm px-4">
                                    <i class="fa-solid fa-plus me-1"></i> Add Audit Note
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Right: Timeline -->
                <div class="col-lg-5">
                    <div class="card card-custom">
                        <div class="card-header bg-white">
                            <span><i class="fa-solid fa-timeline me-2 text-primary"></i>Complete Audit History</span>
                        </div>
                        <div class="card-body">
                            <ul class="timeline">
                                <c:forEach var="update" items="${timeline}">
                                    <li class="timeline-item">
                                        <div class="timeline-marker ${update.newStatus == 'RESOLVED' || update.newStatus == 'CLOSED' ? 'resolved' : ''}"></div>
                                        <div class="timeline-content">
                                            <div class="timeline-title">
                                                <span class="badge ${update.newStatus == 'RESOLVED' ? 'bg-success' : (update.newStatus == 'IN_PROGRESS' ? 'bg-primary' : (update.newStatus == 'CLOSED' ? 'bg-secondary' : 'bg-info text-white'))}">
                                                    ${update.newStatus}
                                                </span>
                                                <span class="timeline-time">${update.formattedTime}</span>
                                            </div>
                                            <div class="small text-muted mt-1">
                                                <i class="fa-regular fa-user me-1"></i>
                                                <strong>${update.updatedByName}</strong> (${update.updatedByRole})
                                            </div>
                                            <c:if test="${not empty update.note}">
                                                <p class="timeline-note mt-2">${update.note}</p>
                                            </c:if>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Modal: Assign Staff -->
<div class="modal fade" id="assignModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/assign-incident" method="POST">
                <input type="hidden" name="incidentId" value="${incident.id}">
                <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/incident/details?id=${incident.id}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-check text-primary me-2"></i>Assign Staff Responder</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="staffSelectAdmin" class="form-label fw-semibold">Select Campus Responder <span class="text-danger">*</span></label>
                        <select class="form-select" id="staffSelectAdmin" name="staffId" required>
                            <option value="" disabled selected>-- Select Staff Member --</option>
                            <c:forEach var="s" items="${requestScope.staffList}">
                                <option value="${s.id}" ${incident.assignedStaffId == s.id ? 'selected' : ''}>${s.fullName} &bull; ${s.department} (${s.email})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="assignNoteAdmin" class="form-label fw-semibold">Instructions / Dispatch Remarks</label>
                        <textarea class="form-control" id="assignNoteAdmin" name="note" rows="3" placeholder="Add specific task instructions or priority notices..."></textarea>
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

<!-- Modal: Reclassify Priority / Category -->
<div class="modal fade" id="reclassifyModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/incident/update-details" method="POST">
                <input type="hidden" name="incidentId" value="${incident.id}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-tag text-primary me-2"></i>Update Priority & Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="editCategory" class="form-label fw-semibold">Category</label>
                        <select class="form-select" id="editCategory" name="category" required>
                            <option value="MEDICAL" ${incident.category == 'MEDICAL' ? 'selected' : ''}>Medical</option>
                            <option value="FIRE" ${incident.category == 'FIRE' ? 'selected' : ''}>Fire / Smoke</option>
                            <option value="SECURITY" ${incident.category == 'SECURITY' ? 'selected' : ''}>Security</option>
                            <option value="HARASSMENT" ${incident.category == 'HARASSMENT' ? 'selected' : ''}>Harassment</option>
                            <option value="SUSPICIOUS_ACTIVITY" ${incident.category == 'SUSPICIOUS_ACTIVITY' ? 'selected' : ''}>Suspicious Activity</option>
                            <option value="ELECTRICAL" ${incident.category == 'ELECTRICAL' ? 'selected' : ''}>Electrical</option>
                            <option value="PLUMBING" ${incident.category == 'PLUMBING' ? 'selected' : ''}>Plumbing</option>
                            <option value="INFRASTRUCTURE" ${incident.category == 'INFRASTRUCTURE' ? 'selected' : ''}>Infrastructure</option>
                            <option value="ACCIDENT" ${incident.category == 'ACCIDENT' ? 'selected' : ''}>Accident</option>
                            <option value="OTHER" ${incident.category == 'OTHER' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="editPriority" class="form-label fw-semibold">Priority Level</label>
                        <select class="form-select" id="editPriority" name="priority" required>
                            <option value="LOW" ${incident.priority == 'LOW' ? 'selected' : ''}>Low</option>
                            <option value="MEDIUM" ${incident.priority == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                            <option value="HIGH" ${incident.priority == 'HIGH' ? 'selected' : ''}>High</option>
                            <option value="CRITICAL" ${incident.priority == 'CRITICAL' ? 'selected' : ''}>Critical</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="reclassifyNote" class="form-label fw-semibold">Reason for Modification</label>
                        <textarea class="form-control" id="reclassifyNote" name="note" rows="2" placeholder="e.g. Upgraded to CRITICAL following safety assessment"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary fw-bold">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
