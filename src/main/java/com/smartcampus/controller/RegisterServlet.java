package com.smartcampus.controller;

import com.smartcampus.dao.UserDAO;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles self-registration for students.
 * Role is strictly enforced as STUDENT.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String department = request.getParameter("department");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Basic validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All required fields must be filled out.");
            preserveFields(request, fullName, email, phone, department);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            preserveFields(request, fullName, email, phone, department);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            preserveFields(request, fullName, email, phone, department);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.emailExists(email.trim())) {
            request.setAttribute("errorMessage", "An account with this email already exists. Please login instead.");
            preserveFields(request, fullName, email, phone, department);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create new student user (ROLE is hardcoded to STUDENT)
        User student = new User(
                fullName.trim(),
                email.trim(),
                password.trim(),
                phone != null ? phone.trim() : "",
                "STUDENT",
                department != null ? department.trim() : "General"
        );

        boolean success = userDAO.register(student);

        if (success) {
            request.setAttribute("successMessage", "Registration successful! You can now log in with your credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            preserveFields(request, fullName, email, phone, department);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void preserveFields(HttpServletRequest request, String fullName, String email, String phone, String department) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("department", department);
    }
}
