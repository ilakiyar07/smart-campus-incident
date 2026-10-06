package com.smartcampus.controller;

import com.smartcampus.dao.UserDAO;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Admin User & Staff Management (View, Add Staff, Enable/Disable, Delete).
 */
@WebServlet(name = "UserManagementServlet", urlPatterns = {"/admin/users", "/admin/add-staff", "/admin/toggle-user", "/admin/delete-user"})
public class UserManagementServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/admin/toggle-user".equals(servletPath)) {
            handleToggleUser(request, response);
            return;
        }

        if ("/admin/delete-user".equals(servletPath)) {
            handleDeleteUser(request, response);
            return;
        }

        // Default: display users list
        String roleFilter = request.getParameter("role");
        List<User> users;
        if (roleFilter != null && !roleFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleFilter)) {
            users = userDAO.getUsersByRole(roleFilter.toUpperCase());
        } else {
            users = userDAO.getAllUsers();
        }

        request.setAttribute("users", users);
        request.setAttribute("roleFilter", roleFilter != null ? roleFilter : "ALL");
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/admin/add-staff".equals(servletPath)) {
            handleAddStaff(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void handleAddStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String department = request.getParameter("department");
        String password = request.getParameter("password");

        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Name, Email, and Password are required to create a staff account.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        if (userDAO.emailExists(email.trim())) {
            session.setAttribute("errorMessage", "A user with email " + email + " already exists.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        User staff = new User(
                fullName.trim(),
                email.trim(),
                password.trim(),
                phone != null ? phone.trim() : "",
                "STAFF",
                department != null ? department.trim() : "Campus Security"
        );

        boolean success = userDAO.register(staff);
        if (success) {
            session.setAttribute("successMessage", "Staff member " + staff.getFullName() + " registered successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to add staff member due to database error.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void handleToggleUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String userIdStr = request.getParameter("id");
        String targetStatus = request.getParameter("status");

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDAO.getUserById(userId);
            if (user == null) {
                session.setAttribute("errorMessage", "User not found.");
            } else if (user.isAdmin()) {
                session.setAttribute("errorMessage", "Cannot deactivate Administrator accounts.");
            } else {
                userDAO.updateUserStatus(userId, targetStatus);
                session.setAttribute("successMessage", "User status updated to " + targetStatus + ".");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid user ID.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String userIdStr = request.getParameter("id");

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDAO.getUserById(userId);
            if (user == null) {
                session.setAttribute("errorMessage", "User not found.");
            } else if (user.isAdmin()) {
                session.setAttribute("errorMessage", "Cannot delete an Administrator account.");
            } else if (!userDAO.canDeleteUser(userId)) {
                session.setAttribute("errorMessage", "Cannot delete user '" + user.getFullName() + "' because they have associated incident or assignment records. Deactivate the user instead to preserve data integrity.");
            } else {
                userDAO.deleteUser(userId);
                session.setAttribute("successMessage", "User deleted successfully.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid user ID.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
