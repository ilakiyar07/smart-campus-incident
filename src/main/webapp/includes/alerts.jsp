<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Flash Success Message from Session or Request --%>
<c:if test="${not empty sessionScope.successMessage}">
    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
        <i class="fa-solid fa-circle-check me-2 fs-5"></i>
        <div>${sessionScope.successMessage}</div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="successMessage" scope="session" />
</c:if>

<c:if test="${not empty requestScope.successMessage}">
    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
        <i class="fa-solid fa-circle-check me-2 fs-5"></i>
        <div>${requestScope.successMessage}</div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<%-- Flash Error Message from Session or Request --%>
<c:if test="${not empty sessionScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
        <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
        <div>${sessionScope.errorMessage}</div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="errorMessage" scope="session" />
</c:if>

<c:if test="${not empty requestScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
        <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
        <div>${requestScope.errorMessage}</div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<%-- General Info Message --%>
<c:if test="${not empty requestScope.infoMessage}">
    <div class="alert alert-info alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
        <i class="fa-solid fa-circle-info me-2 fs-5"></i>
        <div>${requestScope.infoMessage}</div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
