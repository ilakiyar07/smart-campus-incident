package com.smartcampus.controller;

import com.smartcampus.dao.NotificationDAO;
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

/**
 * Controller to view notifications and mark them as read.
 */
@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications", "/notifications/mark-read", "/notifications/mark-all-read"})
public class NotificationServlet extends HttpServlet {

    private NotificationDAO notificationDAO;

    @Override
    public void init() {
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

        String servletPath = request.getServletPath();

        if ("/notifications/mark-read".equals(servletPath)) {
            String notifIdStr = request.getParameter("id");
            try {
                int notifId = Integer.parseInt(notifIdStr);
                notificationDAO.markAsRead(notifId, user.getId());
            } catch (Exception ignored) {}

            int unread = notificationDAO.getUnreadCount(user.getId());
            session.setAttribute("unreadNotifications", unread);

            String redirect = request.getParameter("redirect");
            if (redirect != null && !redirect.trim().isEmpty()) {
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/notifications");
            }
            return;
        }

        if ("/notifications/mark-all-read".equals(servletPath)) {
            notificationDAO.markAllAsRead(user.getId());
            session.setAttribute("unreadNotifications", 0);
            response.sendRedirect(request.getContextPath() + "/notifications");
            return;
        }

        // Default view
        List<Notification> list = notificationDAO.getNotificationsByUserId(user.getId());
        int unreadCount = notificationDAO.getUnreadCount(user.getId());
        session.setAttribute("unreadNotifications", unreadCount);

        request.setAttribute("notifications", list);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/student/notifications.jsp").forward(request, response);
    }
}
