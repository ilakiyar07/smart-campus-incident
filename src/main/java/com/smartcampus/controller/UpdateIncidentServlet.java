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
 * Controller for modifying incident category and priority (Admin only).
 */
@WebServlet(name = "UpdateIncidentServlet", urlPatterns = {"/incident/update-details"})
public class UpdateIncidentServlet extends HttpServlet {

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
        String priority = request.getParameter("priority");
        String category = request.getParameter("category");
        String note = request.getParameter("note");

        try {
            int incidentId = Integer.parseInt(incidentIdStr);
            boolean success = incidentDAO.updateIncidentClassification(incidentId, priority, category, user.getId(), note);

            if (success) {
                session.setAttribute("successMessage", "Incident classification updated successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to update incident classification.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid parameters: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/incident/details?id=" + incidentIdStr);
    }
}
