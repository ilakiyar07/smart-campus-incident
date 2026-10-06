package com.smartcampus.controller;

import com.smartcampus.dao.IncidentDAO;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller for Admin deletion of inappropriate/spam incident reports.
 */
@WebServlet(name = "DeleteIncidentServlet", urlPatterns = {"/incident/delete"})
public class DeleteIncidentServlet extends HttpServlet {

    private IncidentDAO incidentDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String incidentIdStr = request.getParameter("incidentId");
        try {
            int incidentId = Integer.parseInt(incidentIdStr);
            boolean success = incidentDAO.deleteIncident(incidentId);

            if (success) {
                session.setAttribute("successMessage", "Incident #" + incidentId + " and all related records were removed.");
            } else {
                session.setAttribute("errorMessage", "Failed to delete incident.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid incident ID: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/incidents");
    }
}
