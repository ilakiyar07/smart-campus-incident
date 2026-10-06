<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="app-container">
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="active" value="report" />
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid p-0">
            <jsp:include page="/includes/alerts.jsp" />

            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h2 class="fw-bold mb-1"><i class="fa-solid fa-triangle-exclamation text-danger me-2"></i>Report Campus Incident</h2>
                    <p class="text-muted mb-0">Submit a detailed incident report to notify campus authorities immediately.</p>
                </div>
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-secondary btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i> Back to Dashboard
                </a>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <div class="card card-custom shadow-sm">
                        <div class="card-header bg-white">
                            <span class="text-dark"><i class="fa-solid fa-file-pen me-2 text-primary"></i>Incident Details Form</span>
                        </div>
                        <div class="card-body p-4">
                            <div id="criticalWarningBox" class="alert alert-danger d-none mb-4" role="alert">
                                <div class="d-flex align-items-center">
                                    <i class="fa-solid fa-triangle-exclamation fs-3 me-3"></i>
                                    <div>
                                        <strong>CRITICAL / HIGH PRIORITY SELECTED:</strong>
                                        <p class="mb-0 small">If this is an immediate life-threatening emergency, please also call Campus Emergency Hotline: <strong>Ext. 911 / +1-555-0100</strong>.</p>
                                    </div>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/student/report-incident" method="POST" enctype="multipart/form-data">
                                <div class="mb-3">
                                    <label for="title" class="form-label fw-semibold">Incident Title <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control form-control-lg" id="title" name="title" placeholder="e.g. Smoke detected near Chemistry Lab" required>
                                    <small class="text-muted">Provide a short, descriptive summary of the incident.</small>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="category" class="form-label fw-semibold">Incident Category <span class="text-danger">*</span></label>
                                        <select class="form-select" id="category" name="category" required>
                                            <option value="" disabled selected>-- Select Incident Category --</option>
                                            <option value="MEDICAL">Medical Emergency</option>
                                            <option value="FIRE">Fire / Smoke</option>
                                            <option value="SECURITY">Security Issue</option>
                                            <option value="HARASSMENT">Harassment / Misconduct</option>
                                            <option value="SUSPICIOUS_ACTIVITY">Suspicious Activity</option>
                                            <option value="ELECTRICAL">Electrical Problem</option>
                                            <option value="PLUMBING">Water / Plumbing Issue</option>
                                            <option value="INFRASTRUCTURE">Infrastructure / Structural Damage</option>
                                            <option value="ACCIDENT">Accident / Physical Hazard</option>
                                            <option value="OTHER">Other Incident</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="incidentPrioritySelect" class="form-label fw-semibold">Estimated Severity / Priority <span class="text-danger">*</span></label>
                                        <select class="form-select" id="incidentPrioritySelect" name="priority" required>
                                            <option value="LOW">Low (Minor inconvenience / Routine maintenance)</option>
                                            <option value="MEDIUM" selected>Medium (Standard hazard / Needs attention)</option>
                                            <option value="HIGH">High (Urgent situation / Safety risk)</option>
                                            <option value="CRITICAL">Critical (Immediate danger / Emergency)</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="location" class="form-label fw-semibold">Specific Location <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fa-solid fa-location-dot text-danger"></i></span>
                                            <input type="text" class="form-control" id="location" name="location" placeholder="e.g. Block A, Room 302 / Cafeteria Entrance" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="incidentDate" class="form-label fw-semibold">Date & Time of Incident</label>
                                        <input type="datetime-local" class="form-control" id="incidentDate" name="incidentDate">
                                        <small class="text-muted">Leave empty for current timestamp.</small>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label fw-semibold">Detailed Description <span class="text-danger">*</span></label>
                                    <textarea class="form-control" id="description" name="description" rows="4" placeholder="Describe exactly what happened, any persons involved, immediate hazards, or special instructions..." required></textarea>
                                </div>

                                <div class="mb-4">
                                    <label for="evidenceFile" class="form-label fw-semibold">Attach Photo / Evidence (Optional)</label>
                                    <input class="form-control" type="file" id="evidenceFile" name="evidenceFile" accept="image/*,.pdf,.doc,.docx">
                                    <small class="text-muted">Supported formats: JPG, PNG, PDF (Max 10MB)</small>
                                </div>

                                <div class="d-flex gap-2 justify-content-end">
                                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-light border px-4">Cancel</a>
                                    <button type="submit" class="btn btn-danger px-4 fw-bold shadow-sm">
                                        <i class="fa-solid fa-paper-plane me-2"></i> Submit Incident Report
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Guidelines Sidebar -->
                <div class="col-lg-4">
                    <div class="card card-custom mb-3">
                        <div class="card-header">
                            <span><i class="fa-solid fa-circle-info me-2 text-primary"></i>Reporting Guidelines</span>
                        </div>
                        <div class="card-body small">
                            <p><strong>1. Accuracy:</strong> Be as specific as possible regarding the building, floor, room number, or landmark.</p>
                            <p><strong>2. Safety First:</strong> Do not put yourself in danger to take photos or inspect active hazards.</p>
                            <p><strong>3. Status Tracking:</strong> You can follow progress in real-time under the <em>"My Reports"</em> tab.</p>
                        </div>
                    </div>

                    <div class="p-3 bg-danger-subtle text-danger rounded-3 border border-danger">
                        <h6 class="fw-bold mb-1"><i class="fa-solid fa-phone-flip me-2"></i>Campus Emergency Contacts</h6>
                        <ul class="list-unstyled mb-0 small mt-2">
                            <li><strong>Security Dispatch:</strong> Ext. 911</li>
                            <li><strong>Health Clinic:</strong> Ext. 402</li>
                            <li><strong>Maintenance:</strong> Ext. 505</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
