<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="app-container">
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="active" value="reports" />
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid p-0">
            <jsp:include page="/includes/alerts.jsp" />

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1"><i class="fa-solid fa-chart-pie text-primary me-2"></i>Campus Safety Analytics & Incident Reports</h2>
                    <p class="text-muted mb-0">Visual distribution analysis of campus incidents by category, priority, status, and department.</p>
                </div>
            </div>

            <!-- Top Summary Cards -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Total Logged</div>
                            <div class="stat-number">${requestScope.stats.total}</div>
                        </div>
                        <div class="stat-icon icon-blue"><i class="fa-solid fa-database"></i></div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Active Response</div>
                            <div class="stat-number text-warning">${requestScope.stats.active}</div>
                        </div>
                        <div class="stat-icon icon-amber"><i class="fa-solid fa-person-running"></i></div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Successfully Resolved</div>
                            <div class="stat-number text-success">${requestScope.stats.resolved}</div>
                        </div>
                        <div class="stat-icon icon-green"><i class="fa-solid fa-circle-check"></i></div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-title">Archived / Closed</div>
                            <div class="stat-number text-muted">${requestScope.stats.closed}</div>
                        </div>
                        <div class="stat-icon icon-gray"><i class="fa-solid fa-box-archive"></i></div>
                    </div>
                </div>
            </div>

            <!-- Visual Charts & Distributions Grid -->
            <div class="row g-4">
                <!-- Incidents by Category -->
                <div class="col-lg-6">
                    <div class="card card-custom h-100">
                        <div class="card-header bg-white">
                            <span><i class="fa-solid fa-shapes me-2 text-primary"></i>Incidents by Category</span>
                        </div>
                        <div class="card-body">
                            <c:set var="totalCount" value="${requestScope.stats.total > 0 ? requestScope.stats.total : 1}" />
                            <c:forEach var="entry" items="${requestScope.byCategory}">
                                <c:set var="pct" value="${(entry.value * 100) / totalCount}" />
                                <div class="progress-container">
                                    <div class="progress-label">
                                        <span><strong>${entry.key}</strong></span>
                                        <span class="text-muted">${entry.value} reports (${String.format("%.1f", pct)}%)</span>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill bg-primary" style="width: ${pct}%;"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Incidents by Priority -->
                <div class="col-lg-6">
                    <div class="card card-custom h-100">
                        <div class="card-header bg-white">
                            <span><i class="fa-solid fa-layer-group me-2 text-danger"></i>Incidents by Priority / Severity</span>
                        </div>
                        <div class="card-body">
                            <c:forEach var="entry" items="${requestScope.byPriority}">
                                <c:set var="pct" value="${(entry.value * 100) / totalCount}" />
                                <c:set var="barColor" value="${entry.key == 'CRITICAL' ? 'bg-danger' : (entry.key == 'HIGH' ? 'bg-warning' : (entry.key == 'MEDIUM' ? 'bg-info' : 'bg-secondary'))}" />
                                <div class="progress-container">
                                    <div class="progress-label">
                                        <span><strong class="${entry.key == 'CRITICAL' ? 'text-danger' : ''}">${entry.key}</strong></span>
                                        <span class="text-muted">${entry.value} (${String.format("%.1f", pct)}%)</span>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill ${barColor}" style="width: ${pct}%;"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Incidents by Status -->
                <div class="col-lg-6">
                    <div class="card card-custom h-100">
                        <div class="card-header bg-white">
                            <span><i class="fa-solid fa-list-check me-2 text-success"></i>Workflow Status Breakdown</span>
                        </div>
                        <div class="card-body">
                            <c:forEach var="entry" items="${requestScope.byStatus}">
                                <c:set var="pct" value="${(entry.value * 100) / totalCount}" />
                                <div class="progress-container">
                                    <div class="progress-label">
                                        <span><strong>${entry.key}</strong></span>
                                        <span class="text-muted">${entry.value} (${String.format("%.1f", pct)}%)</span>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill ${entry.key == 'RESOLVED' ? 'bg-success' : (entry.key == 'IN_PROGRESS' ? 'bg-primary' : (entry.key == 'REPORTED' ? 'bg-warning' : 'bg-secondary'))}" style="width: ${pct}%;"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Incidents by Academic Department -->
                <div class="col-lg-6">
                    <div class="card card-custom h-100">
                        <div class="card-header bg-white">
                            <span><i class="fa-solid fa-building-columns me-2 text-info"></i>Reporting Distribution by Department</span>
                        </div>
                        <div class="card-body">
                            <c:forEach var="entry" items="${requestScope.byDept}">
                                <c:set var="pct" value="${(entry.value * 100) / totalCount}" />
                                <div class="progress-container">
                                    <div class="progress-label">
                                        <span><strong>${entry.key}</strong></span>
                                        <span class="text-muted">${entry.value} (${String.format("%.1f", pct)}%)</span>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill bg-info" style="width: ${pct}%;"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
