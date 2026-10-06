package com.smartcampus.dao;

import com.smartcampus.model.Notification;
import com.smartcampus.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * NotificationDAO manages in-app notifications and alerts.
 */
public class NotificationDAO {

    /**
     * Creates a new notification.
     */
    public boolean createNotification(Notification notification) {
        String sql = "INSERT INTO notifications (user_id, incident_id, message, is_read) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notification.getUserId());
            if (notification.getIncidentId() != null) {
                ps.setInt(2, notification.getIncidentId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, notification.getMessage());
            ps.setBoolean(4, notification.isRead());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("NotificationDAO.createNotification error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Creates a notification using existing connection (for transactions).
     */
    public boolean createNotification(Connection conn, int userId, Integer incidentId, String message) throws SQLException {
        String sql = "INSERT INTO notifications (user_id, incident_id, message, is_read) VALUES (?, ?, ?, FALSE)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (incidentId != null) {
                ps.setInt(2, incidentId);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, message);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Broadcasts notification to all users of a specific role (e.g. all ADMINs).
     */
    public void notifyRole(String role, Integer incidentId, String message) {
        String sql = "INSERT INTO notifications (user_id, incident_id, message, is_read) " +
                     "SELECT id, ?, ?, FALSE FROM users WHERE role = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (incidentId != null) {
                ps.setInt(1, incidentId);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, message);
            ps.setString(3, role);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("NotificationDAO.notifyRole error: " + e.getMessage());
        }
    }

    /**
     * Retrieves notifications for a user.
     */
    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT n.id, n.user_id, n.incident_id, n.message, n.is_read, n.created_at, " +
                     "i.title AS incident_title " +
                     "FROM notifications n " +
                     "LEFT JOIN incidents i ON n.incident_id = i.id " +
                     "WHERE n.user_id = ? " +
                     "ORDER BY n.created_at DESC LIMIT 50";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getInt("id"));
                    n.setUserId(rs.getInt("user_id"));
                    int incId = rs.getInt("incident_id");
                    if (!rs.wasNull()) {
                        n.setIncidentId(incId);
                    }
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getBoolean("is_read"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    n.setIncidentTitle(rs.getString("incident_title"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.getNotificationsByUserId error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Counts unread notifications for a user.
     */
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.getUnreadCount error: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Marks a specific notification as read.
     */
    public boolean markAsRead(int notificationId, int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("NotificationDAO.markAsRead error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Marks all notifications as read for a user.
     */
    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("NotificationDAO.markAllAsRead error: " + e.getMessage());
        }
        return false;
    }
}
