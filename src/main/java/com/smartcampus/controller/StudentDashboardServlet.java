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
 * Loads student dashboard metrics, recent incidents, and notifications.
 */
@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {

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

        Map<String, Integer> stats = incidentDAO.getStudentStats(user.getId());
        List<Incident> recentIncidents = incidentDAO.getIncidentsByReporter(user.getId(), null);
        if (recentIncidents.size() > 5) {
            recentIncidents = recentIncidents.subList(0, 5);
        }

        List<Notification> recentNotifications = notificationDAO.getNotificationsByUserId(user.getId());
        if (recentNotifications.size() > 5) {
            recentNotifications = recentNotifications.subList(0, 5);
        }

        int unreadCount = notificationDAO.getUnreadCount(user.getId());
        session.setAttribute("unreadNotifications", unreadCount);

        request.setAttribute("stats", stats);
        request.setAttribute("recentIncidents", recentIncidents);
        request.setAttribute("recentNotifications", recentNotifications);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }
}
