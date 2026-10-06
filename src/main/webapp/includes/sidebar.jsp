<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="sidebar">
    <div>
        <div class="px-3 mb-4">
            <small class="text-muted fw-bold text-uppercase" style="font-size: 0.7rem; letter-spacing: 0.05em;">Navigation Menu</small>
        </div>

        <ul class="sidebar-menu">
            <!-- ADMIN MENU -->
            <c:if test="${sessionScope.userRole == 'ADMIN'}">
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${param.active == 'dashboard' ? 'active' : ''}">
                        <i class="fa-solid fa-gauge"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/admin/incidents" class="sidebar-link ${param.active == 'incidents' ? 'active' : ''}">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <span>All Incidents</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/admin/assignments" class="sidebar-link ${param.active == 'assignments' ? 'active' : ''}">
                        <i class="fa-solid fa-user-check"></i>
                        <span>Assignments</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link ${param.active == 'reports' ? 'active' : ''}">
                        <i class="fa-solid fa-chart-pie"></i>
                        <span>Reports & Stats</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link ${param.active == 'users' ? 'active' : ''}">
                        <i class="fa-solid fa-users-gear"></i>
                        <span>User Management</span>
                    </a>
                </li>
            </c:if>

            <!-- STAFF MENU -->
            <c:if test="${sessionScope.userRole == 'STAFF'}">
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/staff/dashboard" class="sidebar-link ${param.active == 'dashboard' ? 'active' : ''}">
                        <i class="fa-solid fa-gauge"></i>
                        <span>Staff Overview</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/staff/assigned-incidents" class="sidebar-link ${param.active == 'assigned' ? 'active' : ''}">
                        <i class="fa-solid fa-clipboard-list"></i>
                        <span>My Assigned Tasks</span>
                    </a>
                </li>
            </c:if>

            <!-- STUDENT MENU -->
            <c:if test="${sessionScope.userRole == 'STUDENT'}">
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-link ${param.active == 'dashboard' ? 'active' : ''}">
                        <i class="fa-solid fa-gauge"></i>
                        <span>Student Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/student/report-incident" class="sidebar-link ${param.active == 'report' ? 'active' : ''} text-danger fw-bold">
                        <i class="fa-solid fa-circle-plus"></i>
                        <span>Report Incident</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/student/my-incidents" class="sidebar-link ${param.active == 'my-incidents' ? 'active' : ''}">
                        <i class="fa-solid fa-list-check"></i>
                        <span>My Reports</span>
                    </a>
                </li>
            </c:if>

            <!-- COMMON FOR ALL LOGGED IN USERS -->
            <li class="sidebar-item mt-3">
                <a href="${pageContext.request.contextPath}/notifications" class="sidebar-link ${param.active == 'notifications' ? 'active' : ''}">
                    <i class="fa-regular fa-bell"></i>
                    <span>Notifications</span>
                    <c:if test="${sessionScope.unreadNotifications > 0}">
                        <span class="badge bg-danger ms-auto">${sessionScope.unreadNotifications}</span>
                    </c:if>
                </a>
            </li>
        </ul>
    </div>

    <!-- Campus Emergency Hotline Pill at Bottom of Sidebar -->
    <div class="p-3 bg-light rounded-3 border">
        <div class="d-flex align-items-center gap-2 text-danger fw-bold small mb-1">
            <i class="fa-solid fa-phone-volume"></i>
            <span>Campus Hotline</span>
        </div>
        <div class="fw-bold text-dark" style="font-size: 0.95rem;">Ext: 911 / +1-555-0100</div>
        <small class="text-muted" style="font-size: 0.72rem;">24/7 Rapid Response Unit</small>
    </div>
</aside>
