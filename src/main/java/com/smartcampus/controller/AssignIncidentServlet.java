package com.smartcampus.controller;

import com.smartcampus.dao.AssignmentDAO;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles assignment of an incident to a campus staff member.
 */
@WebServlet(name = "AssignIncidentServlet", urlPatterns = {"/admin/assign-incident"})
public class AssignIncidentServlet extends HttpServlet {

    private AssignmentDAO assignmentDAO;

    @Override
    public void init() {
        assignmentDAO = new AssignmentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (admin == null || !admin.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String incidentIdStr = request.getParameter("incidentId");
        String staffIdStr = request.getParameter("staffId");
        String note = request.getParameter("note");
        String redirectUrl = request.getParameter("redirectUrl");

        try {
            int incidentId = Integer.parseInt(incidentIdStr);
            int staffId = Integer.parseInt(staffIdStr);

            boolean success = assignmentDAO.assignIncident(incidentId, staffId, admin.getId(), note);
            if (success) {
                session.setAttribute("successMessage", "Incident #" + incidentId + " assigned to staff successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to assign incident. Please verify the staff selection.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid request parameters: " + e.getMessage());
        }

        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/incidents");
        }
    }
}
