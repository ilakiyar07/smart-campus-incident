<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="bg-white border-top py-3 mt-auto">
    <div class="container text-center text-muted small">
        <div class="row align-items-center">
            <div class="col-md-6 text-md-start">
                <strong>Smart Campus Emergency & Incident Management System</strong> &copy; <%= java.time.Year.now().getValue() %>
            </div>
            <div class="col-md-6 text-md-end">
                <span class="badge bg-light text-dark border me-2"><i class="fa-solid fa-code me-1 text-primary"></i>Java Servlets & JSP</span>
                <span class="badge bg-light text-dark border"><i class="fa-solid fa-database me-1 text-primary"></i>MySQL + JDBC</span>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5.3 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JavaScript -->
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
