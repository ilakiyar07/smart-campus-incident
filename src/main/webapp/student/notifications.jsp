<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/includes/header.jsp" />

<div class="app-container">
    <jsp:include page="/includes/sidebar.jsp">
        <jsp:param name="active" value="notifications" />
    </jsp:include>

    <main class="main-content">
        <div class="container-fluid p-0">
            <jsp:include page="/includes/alerts.jsp" />

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1"><i class="fa-regular fa-bell text-primary me-2"></i>Campus Notifications & Alerts</h2>
                    <p class="text-muted mb-0">Stay informed on incident progress, assignments, and resolution updates.</p>
                </div>
                <c:if test="${requestScope.unreadCount > 0}">
                    <a href="${pageContext.request.contextPath}/notifications/mark-all-read" class="btn btn-outline-primary btn-sm">
                        <i class="fa-solid fa-check-double me-1"></i> Mark All as Read
                    </a>
                </c:if>
            </div>

            <div class="card card-custom">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty requestScope.notifications}">
                            <div class="text-center py-5 text-muted">
                                <i class="fa-regular fa-bell-slash fs-1 mb-2 d-block opacity-50"></i>
                                <p class="mb-0">You have no notifications at this time.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group list-group-flush">
                                <c:forEach var="n" items="${requestScope.notifications}">
                                    <div class="list-group-item p-3 d-flex justify-content-between align-items-center ${!n.read ? 'bg-primary-subtle border-start border-primary border-3' : ''}">
                                        <div class="d-flex align-items-start gap-3">
                                            <div class="mt-1">
                                                <i class="fa-solid ${!n.read ? 'fa-envelope-open-text text-primary' : 'fa-check text-muted'} fs-5"></i>
                                            </div>
                                            <div>
                                                <div class="text-dark ${!n.read ? 'fw-bold' : ''}">${n.message}</div>
                                                <div class="d-flex align-items-center gap-3 mt-1">
                                                    <small class="text-muted"><i class="fa-regular fa-clock me-1"></i>${n.formattedTime}</small>
                                                    <c:if test="${not empty n.incidentId}">
                                                        <a href="${pageContext.request.contextPath}/incident/details?id=${n.incidentId}" class="small text-primary text-decoration-none fw-semibold">
                                                            View Incident #${n.incidentId} <i class="fa-solid fa-arrow-up-right-from-square ms-1" style="font-size: 0.7rem;"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                        <c:if test="${!n.read}">
                                            <a href="${pageContext.request.contextPath}/notifications/mark-read?id=${n.id}" class="btn btn-sm btn-light border" title="Mark as Read">
                                                <i class="fa-solid fa-check"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
