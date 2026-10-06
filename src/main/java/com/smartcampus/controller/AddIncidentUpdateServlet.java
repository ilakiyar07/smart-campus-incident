package com.smartcampus.controller;

import com.smartcampus.dao.IncidentDAO;
import com.smartcampus.dao.IncidentUpdateDAO;
import com.smartcampus.dao.NotificationDAO;
import com.smartcampus.model.Incident;
import com.smartcampus.model.IncidentUpdate;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller to add a note or additional information to an existing incident's timeline.
 */
@WebServlet(name = "AddIncidentUpdateServlet", urlPatterns = {"/incident/add-note"})
public class AddIncidentUpdateServlet extends HttpServlet {

    private IncidentDAO incidentDAO;
    private IncidentUpdateDAO updateDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
        updateDAO = new IncidentUpdateDAO();
        notificationDAO = new NotificationDAO();
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
        String note = request.getParameter("note");

        if (note == null || note.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Note content cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/incident/details?id=" + incidentIdStr);
            return;
        }

        try {
            int incidentId = Integer.parseInt(incidentIdStr);
            Incident incident = incidentDAO.getIncidentById(incidentId);

            if (incident == null) {
                session.setAttribute("errorMessage", "Incident not found.");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            // Student can only update their own report
            if (user.isStudent() && incident.getReportedBy() != user.getId()) {
                session.setAttribute("errorMessage", "Unauthorized action.");
                response.sendRedirect(request.getContextPath() + "/student/my-incidents");
                return;
            }

            IncidentUpdate iu = new IncidentUpdate(
                    incidentId,
                    user.getId(),
                    incident.getStatus(),
                    incident.getStatus(),
                    note.trim()
            );

            boolean success = updateDAO.addUpdate(iu);

            if (success) {
                session.setAttribute("successMessage", "Note added to timeline successfully.");

                // If student added info, notify admin and assigned staff
                if (user.isStudent()) {
                    notificationDAO.notifyRole("ADMIN", incidentId,
                            "Student " + user.getFullName() + " added notes to Incident #" + incidentId + ".");
                    if (incident.getAssignedStaffId() != null) {
                        notificationDAO.createNotification(new com.smartcampus.model.Notification(
                                incident.getAssignedStaffId(), incidentId,
                                "Student added new information on Incident #" + incidentId + ": \"" + note.trim() + "\""));
                    }
                }
            } else {
                session.setAttribute("errorMessage", "Failed to add note.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/incident/details?id=" + incidentIdStr);
    }
}
