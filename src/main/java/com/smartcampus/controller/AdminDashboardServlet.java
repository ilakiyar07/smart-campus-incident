package com.smartcampus.controller;

import com.smartcampus.dao.IncidentDAO;
import com.smartcampus.dao.NotificationDAO;
import com.smartcampus.dao.UserDAO;
import com.smartcampus.model.Incident;
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
 * Admin Dashboard controller with high-level statistics and critical incident monitoring.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private IncidentDAO incidentDAO;
    private UserDAO userDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
        userDAO = new UserDAO();
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

        Map<String, Integer> stats = incidentDAO.getStatistics();
        int totalStudents = userDAO.countUsersByRole("STUDENT");
        int totalStaff = userDAO.countUsersByRole("STAFF");

        List<Incident> recentIncidents = incidentDAO.getAllIncidents(null, null, null, null);
        List<Incident> criticalIncidents = incidentDAO.getAllIncidents(null, "CRITICAL", null, null);

        // Load all available staff members for quick assign modal
        List<User> staffList = userDAO.getUsersByRole("STAFF");

        int unreadCount = notificationDAO.getUnreadCount(user.getId());
        session.setAttribute("unreadNotifications", unreadCount);

        request.setAttribute("stats", stats);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("recentIncidents", recentIncidents.size() > 8 ? recentIncidents.subList(0, 8) : recentIncidents);
        request.setAttribute("criticalIncidents", criticalIncidents);
        request.setAttribute("staffList", staffList);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
