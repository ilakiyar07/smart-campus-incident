<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<jsp:include page="/includes/header.jsp" />

<div class="container my-5 text-center">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card card-custom p-5 shadow">
                <div class="text-warning mb-3">
                    <i class="fa-solid fa-triangle-exclamation" style="font-size: 4rem;"></i>
                </div>
                <h2 class="fw-bold mb-2">Something Went Wrong</h2>
                <p class="text-muted mb-4">
                    The system encountered an unexpected condition. Please return to your dashboard or report this issue if it persists.
                </p>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary px-4">
                    <i class="fa-solid fa-house me-2"></i> Return Home
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
