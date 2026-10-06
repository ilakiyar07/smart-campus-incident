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

            <!-- Header and Navigation -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <a href="${pageContext.request.contextPath}/student/my-incidents" class="text-decoration-none text-muted small">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back to My Reports
                    </a>
                    <h2 class="fw-bold mb-0 mt-1">Incident #${incident.id}: ${incident.title}</h2>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge-priority ${incident.priorityBadgeClass} fs-6">${incident.priority}</span>
                    <span class="badge-status ${incident.statusBadgeClass} fs-6">${incident.status}</span>
                </div>
            </div>

            <div class="row g-4">
                <!-- Left Column: Details & Add Note Form -->
                <div class="col-lg-7">
                    <div class="card card-custom mb-4">
                        <div class="card-header">
                            <span><i class="fa-solid fa-file-lines me-2 text-primary"></i>Incident Overview</span>
                            <small class="text-muted">Reported on: ${incident.createdAt}</small>
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
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Incident Time</small>
                                    <div class="text-dark mt-1">${incident.incidentDate}</div>
                                </div>
                                <div class="col-sm-6">
                                    <small class="text-muted d-block text-uppercase fw-semibold" style="font-size: 0.72rem;">Assigned Responder</small>
                                    <div class="mt-1">
                                        <c:choose>
                                            <c:when test="${not empty incident.assignedStaffName}">
                                                <strong>${incident.assignedStaffName}</strong>
                                                <div class="text-muted small">${incident.assignedStaffDepartment}</div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary">Awaiting Staff Dispatch</span>
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
                                    <h6 class="fw-bold text-muted text-uppercase" style="font-size: 0.75rem;">Attached Evidence</h6>
                                    <a href="${pageContext.request.contextPath}/${incident.evidencePath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                        <i class="fa-solid fa-paperclip me-1"></i> View Attached File
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Add Additional Note Form -->
                    <c:if test="${incident.status != 'CLOSED'}">
                        <div class="card card-custom">
                            <div class="card-header">
                                <span><i class="fa-solid fa-comment-dots me-2 text-primary"></i>Add Additional Information</span>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/incident/add-note" method="POST">
                                    <input type="hidden" name="incidentId" value="${incident.id}">
                                    <div class="mb-3">
                                        <label for="studentNote" class="form-label small text-muted">Provide any updates, clarifications, or supplementary notes for responders:</label>
                                        <textarea class="form-control" id="studentNote" name="note" rows="3" placeholder="Type new details or updates here..." required></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-sm px-4">
                                        <i class="fa-solid fa-plus me-1"></i> Submit Note
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Right Column: Timeline / History Audit Trail -->
                <div class="col-lg-5">
                    <div class="card card-custom">
                        <div class="card-header bg-white">
                            <span><i class="fa-solid fa-timeline me-2 text-primary"></i>Incident Timeline & Audit Trail</span>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty timeline}">
                                    <div class="text-center py-4 text-muted small">No audit logs recorded.</div>
                                </c:when>
                                <c:otherwise>
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
