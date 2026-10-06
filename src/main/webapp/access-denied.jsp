<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/includes/header.jsp" />

<div class="container my-5 text-center">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card card-custom p-5 shadow">
                <div class="text-danger mb-3">
                    <i class="fa-solid fa-hand text-danger" style="font-size: 4rem;"></i>
                </div>
                <h2 class="fw-bold text-danger mb-2">Access Denied</h2>
                <p class="text-muted mb-4">
                    ${not empty requestScope.errorMessage ? requestScope.errorMessage : "You do not have the required permissions to access this campus resource."}
                </p>
                <div class="d-flex justify-content-center gap-2">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary px-4">Home</a>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary px-4">Switch Account</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
