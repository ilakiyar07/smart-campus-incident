package com.smartcampus.controller;

import com.smartcampus.dao.AssignmentDAO;
import com.smartcampus.dao.IncidentDAO;
import com.smartcampus.model.Incident;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Enforces valid status transitions according to the Incident Workflow:
 * REPORTED -> ASSIGNED -> IN_PROGRESS -> RESOLVED -> CLOSED
 */
@WebServlet(name = "UpdateStatusServlet", urlPatterns = {"/incident/update-status"})
public class UpdateStatusServlet extends HttpServlet {

    private IncidentDAO incidentDAO;
    private AssignmentDAO assignmentDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
        assignmentDAO = new AssignmentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String incidentIdStr = request.getParameter("incidentId");
        String action = request.getParameter("action"); // accept, start_work, resolve, close, or custom status
        String targetStatus = request.getParameter("targetStatus");
        String note = request.getParameter("note");
        String redirectUrl = request.getParameter("redirectUrl");

        try {
            int incidentId = Integer.parseInt(incidentIdStr);
            Incident incident = incidentDAO.getIncidentById(incidentId);

            if (incident == null) {
                session.setAttribute("errorMessage", "Incident not found.");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            boolean success = false;

            // 1. Staff accepting assignment & starting work
            if ("accept".equalsIgnoreCase(action) || "start_work".equalsIgnoreCase(action) || "IN_PROGRESS".equalsIgnoreCase(targetStatus)) {
                if (!user.isStaff() && !user.isAdmin()) {
                    session.setAttribute("errorMessage", "Only assigned staff can accept and start work on incidents.");
                } else if (!"ASSIGNED".equalsIgnoreCase(incident.getStatus())) {
                    session.setAttribute("errorMessage", "Incident must be in ASSIGNED status to begin work.");
                } else {
                    success = assignmentDAO.acceptAssignment(incidentId, user.getId(), note);
                    if (success) {
                        session.setAttribute("successMessage", "Assignment accepted and status updated to IN PROGRESS.");
                    }
                }
            }
            // 2. Staff marking incident as RESOLVED
            else if ("resolve".equalsIgnoreCase(action) || "RESOLVED".equalsIgnoreCase(targetStatus)) {
                if (!user.isStaff() && !user.isAdmin()) {
                    session.setAttribute("errorMessage", "Only assigned staff or admin can mark incidents as resolved.");
                } else if (!"IN_PROGRESS".equalsIgnoreCase(incident.getStatus())) {
                    session.setAttribute("errorMessage", "Incident must be IN PROGRESS before it can be marked as RESOLVED.");
                } else {
                    success = assignmentDAO.completeAssignment(incidentId, user.getId(), note);
                    if (success) {
                        session.setAttribute("successMessage", "Incident #" + incidentId + " marked as RESOLVED.");
                    }
                }
            }
            // 3. Admin closing a RESOLVED incident
            else if ("close".equalsIgnoreCase(action) || "CLOSED".equalsIgnoreCase(targetStatus)) {
                if (!user.isAdmin()) {
                    session.setAttribute("errorMessage", "Only administrators can officially close incidents.");
                } else if (!"RESOLVED".equalsIgnoreCase(incident.getStatus())) {
                    session.setAttribute("errorMessage", "Incident must be RESOLVED before it can be CLOSED. Current status: " + incident.getStatus());
                } else {
                    success = incidentDAO.updateStatus(incidentId, "CLOSED", user.getId(), (note != null && !note.trim().isEmpty()) ? note : "Incident reviewed and officially closed by administrator.");
                    if (success) {
                        session.setAttribute("successMessage", "Incident #" + incidentId + " has been closed successfully.");
                    }
                }
            }
            // 4. Generic status change with workflow validator
            else if (targetStatus != null && !targetStatus.trim().isEmpty()) {
                if (!incidentDAO.isValidTransition(incident.getStatus(), targetStatus)) {
                    session.setAttribute("errorMessage", "Invalid status transition from " + incident.getStatus() + " to " + targetStatus + ".");
                } else {
                    success = incidentDAO.updateStatus(incidentId, targetStatus, user.getId(), note);
                    if (success) {
                        session.setAttribute("successMessage", "Status updated to " + targetStatus + ".");
                    }
                }
            }

            if (!success && session.getAttribute("errorMessage") == null) {
                session.setAttribute("errorMessage", "Failed to update incident status.");
            }

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error updating status: " + e.getMessage());
        }

        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/incident/details?id=" + incidentIdStr);
        }
    }
}
