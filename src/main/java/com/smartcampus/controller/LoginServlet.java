package com.smartcampus.controller;

import com.smartcampus.dao.NotificationDAO;
import com.smartcampus.dao.UserDAO;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles user authentication, session initialization, and role-based redirect.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            redirectToDashboard(user, response, request.getContextPath());
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and Password are required.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(email.trim(), password.trim());

        if (user != null) {
            // Establish session
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userDept", user.getDepartment());

            // Load initial unread notification count
            int unreadCount = notificationDAO.getUnreadCount(user.getId());
            session.setAttribute("unreadNotifications", unreadCount);

            redirectToDashboard(user, response, request.getContextPath());
        } else {
            request.setAttribute("errorMessage", "Invalid email or password, or account is disabled.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void redirectToDashboard(User user, HttpServletResponse response, String contextPath) throws IOException {
        if (user.isAdmin()) {
            response.sendRedirect(contextPath + "/admin/dashboard");
        } else if (user.isStaff()) {
            response.sendRedirect(contextPath + "/staff/dashboard");
        } else {
            response.sendRedirect(contextPath + "/student/dashboard");
        }
    }
}
