package com.smartcampus.controller;

import com.smartcampus.dao.IncidentDAO;
import com.smartcampus.dao.IncidentUpdateDAO;
import com.smartcampus.dao.UserDAO;
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
import java.util.List;

/**
 * Loads incident details, timeline history, and routes to appropriate role-specific detail view.
 */
@WebServlet(name = "ViewIncidentServlet", urlPatterns = {"/incident/details"})
public class ViewIncidentServlet extends HttpServlet {

    private IncidentDAO incidentDAO;
    private IncidentUpdateDAO updateDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
        updateDAO = new IncidentUpdateDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Incident incident = incidentDAO.getIncidentById(id);

            if (incident == null) {
                request.setAttribute("errorMessage", "Incident not found (ID: " + id + ").");
                forwardToFallback(request, response, user);
                return;
            }

            // Access check: Student can only view their own incidents unless Admin/Staff
            if (user.isStudent() && incident.getReportedBy() != user.getId()) {
                request.setAttribute("errorMessage", "Access Denied: You cannot view reports submitted by other students.");
                response.sendRedirect(request.getContextPath() + "/student/my-incidents");
                return;
            }

            List<IncidentUpdate> updates = updateDAO.getUpdatesByIncidentId(id);
            request.setAttribute("incident", incident);
            request.setAttribute("timeline", updates);

            if (user.isAdmin()) {
                List<User> staffList = userDAO.getUsersByRole("STAFF");
                request.setAttribute("staffList", staffList);
                request.getRequestDispatcher("/admin/incident-details.jsp").forward(request, response);
            } else if (user.isStaff()) {
                request.getRequestDispatcher("/staff/incident-details.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/student/incident-details.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void forwardToFallback(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/incidents");
        } else if (user.isStaff()) {
            response.sendRedirect(request.getContextPath() + "/staff/assigned-incidents");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/my-incidents");
        }
    }
}
