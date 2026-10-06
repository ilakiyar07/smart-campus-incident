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

            <!-- Title and Status Controls -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <a href="${pageContext.request.contextPath}/staff/assigned-incidents" class="text-decoration-none text-muted small">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back to Taskboard
                    </a>
                    <h2 class="fw-bold mb-0 mt-1">Incident #${incident.id}: ${incident.title}</h2>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge-priority ${incident.priorityBadgeClass} fs-6">${incident.priority}</span>
                    <span class="badge-status ${incident.statusBadgeClass} fs-6">${incident.status}</span>
                </div>
            </div>

            <!-- Action Ribbon for Staff -->
            <div class="card card-custom bg-primary-subtle border-primary mb-4 p-3">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                    <div>
                        <h6 class="fw-bold text-primary mb-0"><i class="fa-solid fa-bolt me-2"></i>Staff Workflow Action</h6>
                        <small class="text-muted">Current Workflow Stage: <strong>${incident.status}</strong></small>
                    </div>

                    <div class="d-flex gap-2">
                        <c:if test="${incident.status == 'ASSIGNED'}">
                            <form action="${pageContext.request.contextPath}/incident/update-status" method="POST">
                                <input type="hidden" name="incidentId" value="${incident.id}">
                                <input type="hidden" name="action" value="accept">
                                <input type="hidden" name="note" value="Staff accepted assignment and dispatched response.">
                                <button type="submit" class="btn btn-success fw-bold">
                                    <i class="fa-solid fa-check me-1"></i> Accept Assignment & Start Work
                                </button>
                            </form>
                        </c:if>

                        <c:if test="${incident.status == 'IN_PROGRESS'}">
                            <button type="button" class="btn btn-primary fw-bold" data-bs-toggle="modal" data-bs-target="#progressNoteModal">
                                <i class="fa-solid fa-comment-medical me-1"></i> Add Progress Note
                            </button>
                            <button type="button" class="btn btn-success fw-bold" data-bs-toggle="modal" data-bs-target="#resolveModal">
                                <i class="fa-solid fa-circle-check me-1"></i> Mark as Resolved
                            </button>
                        </c:if>

                        <c:if test="${incident.status == 'RESOLVED'}">
                            <span class="badge bg-success p-2 fs-6"><i class="fa-solid fa-check-double me-1"></i> Resolved &mdash; Pending Admin Verification</span>
                        </c:if>

                        <c:if test="${incident.status == 'CLOSED'}">
                            <span class="badge bg-secondary p-2 fs-6"><i class="fa-solid fa-lock me-1"></i> Case Closed</span>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <!-- Left: Details -->
                <div class="col-lg-7">
                    <div class="card card-custom mb-4">
                        <div class="card-header">
                            <span><i class="fa-solid fa-circle-info me-2 text-primary"></i>Incident Specifications</span>
                            <small class="text-muted">Reported: ${incident.createdAt}</small>
                        </div>
                        <div class="card-body">
                            <div class="row g-3 mb-4">
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Category</small>
                                    <span class="badge bg-light text-dark border mt-1">${incident.categoryDisplayName}</span>
                                </div>
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Location</small>
                                    <div class="fw-bold text-dark mt-1"><i class="fa-solid fa-location-dot me-1 text-danger"></i>${incident.location}</div>
                                </div>
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Reported By</small>
                                    <div class="fw-bold text-dark mt-1">${incident.reportedByName}</div>
                                    <small class="text-muted">${incident.reportedByDepartment} &bull; ${incident.reportedByPhone}</small>
                                </div>
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Reporter Email</small>
                                    <div class="mt-1"><a href="mailto:${incident.reportedByEmail}" class="text-decoration-none">${incident.reportedByEmail}</a></div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <h6 class="fw-bold text-muted text-uppercase" style="font-size: 0.75rem;">Description of Issue</h6>
                                <div class="p-3 bg-light rounded-3 border text-dark" style="white-space: pre-line;">${incident.description}</div>
                            </div>

                            <c:if test="${not empty incident.evidencePath}">
                                <div class="mt-3">
                                    <h6 class="fw-bold text-muted text-uppercase" style="font-size: 0.75rem;">Reporter Evidence Attachment</h6>
                                    <a href="${pageContext.request.contextPath}/${incident.evidencePath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                        <i class="fa-solid fa-paperclip me-1"></i> View Uploaded Evidence
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Right: Timeline -->
                <div class="col-lg-5">
                    <div class="card card-custom">
                        <div class="card-header bg-white">
                            <span><i class="fa-solid fa-timeline me-2 text-primary"></i>Audit Trail & Response History</span>
                        </div>
                        <div class="card-body">
                            <ul class="timeline">
                                <c:forEach var="update" items="${timeline}">
                                    <li class="timeline-item">
                                        <div class="timeline-marker ${update.newStatus == 'RESOLVED' || update.newStatus == 'CLOSED' ? 'resolved' : ''}"></div>
                                        <div class="timeline-content">
                                            <div class="timeline-title">
                                                <span class="badge ${update.newStatus == 'RESOLVED' ? 'bg-success' : (update.newStatus == 'IN_PROGRESS' ? 'bg-primary' : 'bg-secondary')}">
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

<!-- Modal: Progress Note -->
<div class="modal fade" id="progressNoteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/incident/add-note" method="POST">
                <input type="hidden" name="incidentId" value="${incident.id}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-comment-dots text-primary me-2"></i>Add Progress Note</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="progressNoteText" class="form-label fw-semibold">Note / Action Performed</label>
                        <textarea class="form-control" id="progressNoteText" name="note" rows="4" placeholder="e.g. Inspecting main valve, parts ordered from supplier..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary fw-bold">Post Note to Timeline</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Mark as Resolved -->
<div class="modal fade" id="resolveModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/incident/update-status" method="POST">
                <input type="hidden" name="incidentId" value="${incident.id}">
                <input type="hidden" name="action" value="resolve">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-circle-check me-2"></i>Mark Incident as Resolved</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted small">Please describe the resolution details and any preventative maintenance completed.</p>
                    <div class="mb-3">
                        <label for="resolveNoteText" class="form-label fw-semibold">Resolution Summary <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="resolveNoteText" name="note" rows="4" placeholder="e.g. Hazard cleared, faulty wiring replaced and tested for safety." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success fw-bold">Confirm Resolution</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
