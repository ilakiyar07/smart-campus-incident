package com.smartcampus.controller;

import com.smartcampus.dao.IncidentDAO;
import com.smartcampus.dao.NotificationDAO;
import com.smartcampus.model.Incident;
import com.smartcampus.model.Notification;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Loads staff dashboard statistics and assigned tasks.
 */
@WebServlet(name = "StaffDashboardServlet", urlPatterns = {"/staff/dashboard"})
public class StaffDashboardServlet extends HttpServlet {

    private IncidentDAO incidentDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Map<String, Integer> stats = incidentDAO.getStaffStats(user.getId());
        List<Incident> assignedIncidents = incidentDAO.getIncidentsByStaff(user.getId(), null);
        List<Notification> notifications = notificationDAO.getNotificationsByUserId(user.getId());

        int unreadCount = notificationDAO.getUnreadCount(user.getId());
        session.setAttribute("unreadNotifications", unreadCount);

        request.setAttribute("stats", stats);
        request.setAttribute("assignedIncidents", assignedIncidents);
        request.setAttribute("notifications", notifications);

        request.getRequestDispatcher("/staff/dashboard.jsp").forward(request, response);
    }
}
