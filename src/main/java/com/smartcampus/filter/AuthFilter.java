package com.smartcampus.filter;

import com.smartcampus.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication and Role-Based Authorization Filter.
 * Ensures unauthenticated users cannot access restricted paths and users cannot cross role boundaries.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/student/*", "/staff/*", "/admin/*", "/incident/*", "/notifications/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Prevent browser caching of protected pages
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        // 1. Check if user is logged in
        if (currentUser == null) {
            httpRequest.getSession(true).setAttribute("errorMessage", "Please log in to access this page.");
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // 2. Role-Based Access Control checks
        String role = currentUser.getRole();

        if (path.startsWith("/admin") && !"ADMIN".equalsIgnoreCase(role)) {
            httpRequest.setAttribute("errorMessage", "Access Denied: You do not have administrative privileges.");
            forwardToAppropriateDashboard(httpRequest, httpResponse, role);
            return;
        }

        if (path.startsWith("/staff") && !"STAFF".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
            httpRequest.setAttribute("errorMessage", "Access Denied: You do not have staff permissions.");
            forwardToAppropriateDashboard(httpRequest, httpResponse, role);
            return;
        }

        if (path.startsWith("/student") && !"STUDENT".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
            httpRequest.setAttribute("errorMessage", "Access Denied: Student portal only.");
            forwardToAppropriateDashboard(httpRequest, httpResponse, role);
            return;
        }

        // User is authorized for this route
        chain.doFilter(request, response);
    }

    private void forwardToAppropriateDashboard(HttpServletRequest request, HttpServletResponse response, String role) throws IOException, ServletException {
        String target = request.getContextPath() + "/index.jsp";
        if ("ADMIN".equalsIgnoreCase(role)) {
            target = request.getContextPath() + "/admin/dashboard";
        } else if ("STAFF".equalsIgnoreCase(role)) {
            target = request.getContextPath() + "/staff/dashboard";
        } else if ("STUDENT".equalsIgnoreCase(role)) {
            target = request.getContextPath() + "/student/dashboard";
        }
        response.sendRedirect(target);
    }

    @Override
    public void destroy() {
    }
}
