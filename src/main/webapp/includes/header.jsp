<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String currentRole = (String) session.getAttribute("userRole");
    String currentUserName = (String) session.getAttribute("userName");
    Integer unreadCount = (Integer) session.getAttribute("unreadNotifications");
    if (unreadCount == null) unreadCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Campus Incident & Emergency System</title>
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts (Inter) -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Custom Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fa-solid fa-shield-halved text-primary"></i>
            <span>SMART CAMPUS</span>
            <span class="brand-badge ms-1">EMERGENCY SYSTEM</span>
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <ul class="navbar-nav ms-auto align-items-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <!-- Notification Bell -->
                        <li class="nav-item">
                            <a class="nav-link position-relative text-dark px-3" href="${pageContext.request.contextPath}/notifications" title="Notifications">
                                <i class="fa-regular fa-bell fa-lg"></i>
                                <c:if test="${sessionScope.unreadNotifications > 0}">
                                    <span class="position-absolute top-1 start-70 translate-middle badge rounded-pill bg-danger">
                                        ${sessionScope.unreadNotifications}
                                    </span>
                                </c:if>
                            </a>
                        </li>

                        <!-- User Profile Pill -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2 bg-light px-3 py-1 rounded-pill border" href="#" role="button" data-bs-toggle="dropdown">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 0.85rem; font-weight: 700;">
                                    ${sessionScope.userName.substring(0, 1).toUpperCase()}
                                </div>
                                <div class="text-start me-1">
                                    <div class="fw-bold text-dark" style="font-size: 0.85rem; line-height: 1.1;">${sessionScope.userName}</div>
                                    <small class="text-muted text-uppercase" style="font-size: 0.7rem;">${sessionScope.userRole}</small>
                                </div>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                <c:if test="${sessionScope.userRole == 'ADMIN'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-gauge me-2 text-primary"></i>Admin Dashboard</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/incidents"><i class="fa-solid fa-list-check me-2 text-primary"></i>Manage Incidents</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reports"><i class="fa-solid fa-chart-pie me-2 text-primary"></i>Analytics & Reports</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users me-2 text-primary"></i>Manage Users</a></li>
                                </c:if>
                                <c:if test="${sessionScope.userRole == 'STAFF'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/dashboard"><i class="fa-solid fa-gauge me-2 text-primary"></i>Staff Dashboard</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/assigned-incidents"><i class="fa-solid fa-list-check me-2 text-primary"></i>Assigned Tasks</a></li>
                                </c:if>
                                <c:if test="${sessionScope.userRole == 'STUDENT'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/dashboard"><i class="fa-solid fa-gauge me-2 text-primary"></i>Dashboard</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/report-incident"><i class="fa-solid fa-circle-plus me-2 text-danger"></i>Report Incident</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/my-incidents"><i class="fa-solid fa-clipboard-list me-2 text-primary"></i>My Incidents</a></li>
                                </c:if>
                                <li><hr class="dropdown-menu-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="fa-solid fa-right-from-bracket me-2"></i>Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link text-dark fw-medium" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-outline-primary btn-sm px-3 ms-2 rounded-pill fw-semibold" href="${pageContext.request.contextPath}/login.jsp">
                                <i class="fa-solid fa-right-to-bracket me-1"></i> Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm px-3 ms-1 rounded-pill fw-semibold" href="${pageContext.request.contextPath}/register.jsp">
                                <i class="fa-solid fa-user-plus me-1"></i> Student Register
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
