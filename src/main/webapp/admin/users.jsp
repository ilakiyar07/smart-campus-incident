<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="app-container">
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="active" value="users" />
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid p-0">
            <jsp:include page="/includes/alerts.jsp" />

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1"><i class="fa-solid fa-users-gear text-primary me-2"></i>Campus User Management</h2>
                    <p class="text-muted mb-0">Oversee student accounts, provision staff members, and configure account access statuses.</p>
                </div>
                <button type="button" class="btn btn-primary fw-bold" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                    <i class="fa-solid fa-user-plus me-1"></i> Add New Staff Member
                </button>
            </div>

            <!-- Role Filter Pills -->
            <div class="card card-custom p-3 mb-4">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div class="btn-group flex-wrap" role="group">
                        <a href="${pageContext.request.contextPath}/admin/users?role=ALL" class="btn btn-sm ${requestScope.roleFilter == 'ALL' ? 'btn-primary' : 'btn-outline-secondary'}">All Accounts</a>
                        <a href="${pageContext.request.contextPath}/admin/users?role=STUDENT" class="btn btn-sm ${requestScope.roleFilter == 'STUDENT' ? 'btn-primary' : 'btn-outline-secondary'}">Students</a>
                        <a href="${pageContext.request.contextPath}/admin/users?role=STAFF" class="btn btn-sm ${requestScope.roleFilter == 'STAFF' ? 'btn-primary' : 'btn-outline-secondary'}">Staff Responders</a>
                        <a href="${pageContext.request.contextPath}/admin/users?role=ADMIN" class="btn btn-sm ${requestScope.roleFilter == 'ADMIN' ? 'btn-primary' : 'btn-outline-secondary'}">Administrators</a>
                    </div>

                    <div class="input-group" style="max-width: 300px;">
                        <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                        <input type="text" id="tableSearchInput" class="form-control form-control-sm" placeholder="Search users...">
                    </div>
                </div>
            </div>

            <!-- Users Table -->
            <div class="card card-custom">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-custom table-hover filterable-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Full Name</th>
                                    <th>Email Address</th>
                                    <th>Role</th>
                                    <th>Department</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <th>Registered Date</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${requestScope.users}">
                                    <tr>
                                        <td><strong>#${u.id}</strong></td>
                                        <td>
                                            <div class="fw-bold text-dark">${u.fullName}</div>
                                        </td>
                                        <td>
                                            <a href="mailto:${u.email}" class="text-decoration-none">${u.email}</a>
                                        </td>
                                        <td>
                                            <span class="badge ${u.admin ? 'bg-danger' : (u.staff ? 'bg-primary' : 'bg-success')}">
                                                ${u.role}
                                            </span>
                                        </td>
                                        <td>${u.department}</td>
                                        <td><small class="text-muted">${u.phone != null ? u.phone : '-'}</small></td>
                                        <td>
                                            <span class="badge ${u.active ? 'bg-success-subtle text-success border border-success' : 'bg-danger-subtle text-danger border border-danger'}">
                                                ${u.status}
                                            </span>
                                        </td>
                                        <td class="small text-muted">${u.createdAt}</td>
                                        <td class="text-end">
                                            <c:choose>
                                                <c:when test="${u.admin}">
                                                    <span class="badge bg-light text-muted border">System Admin</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="d-flex gap-1 justify-content-end">
                                                        <!-- Toggle Active / Inactive -->
                                                        <c:choose>
                                                            <c:when test="${u.active}">
                                                                <a href="${pageContext.request.contextPath}/admin/toggle-user?id=${u.id}&status=INACTIVE" class="btn btn-sm btn-outline-warning" title="Deactivate Account" onclick="return confirmAction('Deactivate this user account?');">
                                                                    <i class="fa-solid fa-user-slash"></i>
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/admin/toggle-user?id=${u.id}&status=ACTIVE" class="btn btn-sm btn-outline-success" title="Activate Account">
                                                                    <i class="fa-solid fa-user-check"></i>
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <!-- Delete Account with Safeguard -->
                                                        <a href="${pageContext.request.contextPath}/admin/delete-user?id=${u.id}" class="btn btn-sm btn-outline-danger" title="Delete User" onclick="return confirmAction('Delete this user? (Will only succeed if no incidents are tied to this account)');">
                                                            <i class="fa-solid fa-trash"></i>
                                                        </a>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
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

<!-- Modal: Add Staff Member -->
<div class="modal fade" id="addStaffModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/add-staff" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-shield text-primary me-2"></i>Provision Campus Staff</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="staffFullName" class="form-label fw-semibold">Staff Full Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="staffFullName" name="fullName" placeholder="e.g. Officer Mark Wilson" required>
                    </div>

                    <div class="mb-3">
                        <label for="staffEmail" class="form-label fw-semibold">Institutional Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="staffEmail" name="email" placeholder="staff@campus.com" required>
                    </div>

                    <div class="mb-3">
                        <label for="staffPhone" class="form-label fw-semibold">Contact Phone</label>
                        <input type="text" class="form-control" id="staffPhone" name="phone" placeholder="+1-555-0150">
                    </div>

                    <div class="mb-3">
                        <label for="staffDepartment" class="form-label fw-semibold">Response Department <span class="text-danger">*</span></label>
                        <select class="form-select" id="staffDepartment" name="department" required>
                            <option value="Campus Security">Campus Security</option>
                            <option value="Health & Medical Services">Health & Medical Services</option>
                            <option value="Facilities & Maintenance">Facilities & Maintenance</option>
                            <option value="Electrical Services">Electrical Services</option>
                            <option value="Student Welfare & Safety">Student Welfare & Safety</option>
                            <option value="IT & Network Support">IT & Network Support</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="staffPassword" class="form-label fw-semibold">Temporary Password <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="staffPassword" name="password" placeholder="Min 6 characters" required minlength="6">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary fw-bold">Create Staff Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
