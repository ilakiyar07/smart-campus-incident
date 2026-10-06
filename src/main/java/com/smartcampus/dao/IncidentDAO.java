package com.smartcampus.dao;

import com.smartcampus.model.Incident;
import com.smartcampus.model.IncidentUpdate;
import com.smartcampus.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * IncidentDAO handles all incident persistence, status workflow transitions, and analytics.
 */
public class IncidentDAO {

    /**
     * Creates a new incident with atomic transaction:
     * 1. Inserts incident record (Status = REPORTED)
     * 2. Adds initial entry to incident_updates
     * 3. Sends confirmation notification to student
     * 4. Broadcasts alert notification to admins
     */
    public int createIncident(Incident incident) {
        String insertIncidentSql = "INSERT INTO incidents (reported_by, title, description, category, priority, location, incident_date, status, evidence_path) VALUES (?, ?, ?, ?, ?, ?, ?, 'REPORTED', ?)";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int incidentId = 0;
            try (PreparedStatement ps = conn.prepareStatement(insertIncidentSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, incident.getReportedBy());
                ps.setString(2, incident.getTitle());
                ps.setString(3, incident.getDescription());
                ps.setString(4, incident.getCategory());
                ps.setString(5, incident.getPriority() != null ? incident.getPriority() : "MEDIUM");
                ps.setString(6, incident.getLocation());
                ps.setString(7, incident.getIncidentDate());
                ps.setString(8, incident.getEvidencePath());

                int affected = ps.executeUpdate();
                if (affected > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            incidentId = rs.getInt(1);
                        }
                    }
                }
            }

            if (incidentId > 0) {
                // 2. Add initial audit log
                IncidentUpdateDAO updateDAO = new IncidentUpdateDAO();
                IncidentUpdate initUpdate = new IncidentUpdate(
                        incidentId,
                        incident.getReportedBy(),
                        null,
                        "REPORTED",
                        "Incident initially reported: " + incident.getTitle()
                );
                updateDAO.addUpdate(conn, initUpdate);

                // 3. Notify reporting user
                NotificationDAO notificationDAO = new NotificationDAO();
                notificationDAO.createNotification(conn, incident.getReportedBy(), incidentId,
                        "Your incident report #" + incidentId + " (\"" + incident.getTitle() + "\") has been successfully logged.");

                // 4. Notify Admins
                String notifyAdminSql = "INSERT INTO notifications (user_id, incident_id, message, is_read) " +
                                       "SELECT id, ?, ?, FALSE FROM users WHERE role = 'ADMIN' AND status = 'ACTIVE'";
                try (PreparedStatement psAdmin = conn.prepareStatement(notifyAdminSql)) {
                    psAdmin.setInt(1, incidentId);
                    psAdmin.setString(2, "New " + incident.getPriority() + " priority incident reported: #" + incidentId + " (\"" + incident.getTitle() + "\") at " + incident.getLocation());
                    psAdmin.executeUpdate();
                }

                conn.commit();
                return incidentId;
            } else {
                conn.rollback();
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.createIncident error: " + e.getMessage());
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
        return 0;
    }

    /**
     * Retrieves an incident by ID with reporter information and assigned staff details.
     */
    public Incident getIncidentById(int id) {
        String sql = "SELECT i.id, i.reported_by, i.title, i.description, i.category, i.priority, i.location, " +
                     "i.incident_date, i.status, i.evidence_path, i.created_at, i.updated_at, " +
                     "u.full_name AS reporter_name, u.email AS reporter_email, u.phone AS reporter_phone, u.department AS reporter_department, " +
                     "a.assigned_to AS staff_id, s.full_name AS staff_name, s.department AS staff_department, a.assignment_status " +
                     "FROM incidents i " +
                     "JOIN users u ON i.reported_by = u.id " +
                     "LEFT JOIN assignments a ON i.id = a.incident_id " +
                     "LEFT JOIN users s ON a.assigned_to = s.id " +
                     "WHERE i.id = ? ORDER BY a.id DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToIncident(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.getIncidentById error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves incidents with dynamic multi-criteria filtering for Admin.
     */
    public List<Incident> getAllIncidents(String category, String priority, String status, String search) {
        List<Incident> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.id, i.reported_by, i.title, i.description, i.category, i.priority, i.location, " +
                "i.incident_date, i.status, i.evidence_path, i.created_at, i.updated_at, " +
                "u.full_name AS reporter_name, u.email AS reporter_email, u.phone AS reporter_phone, u.department AS reporter_department, " +
                "a.assigned_to AS staff_id, s.full_name AS staff_name, s.department AS staff_department, a.assignment_status " +
                "FROM incidents i " +
                "JOIN users u ON i.reported_by = u.id " +
                "LEFT JOIN assignments a ON i.id = a.incident_id " +
                "LEFT JOIN users s ON a.assigned_to = s.id " +
                "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append(" AND i.category = ? ");
            params.add(category.trim());
        }
        if (priority != null && !priority.trim().isEmpty() && !"ALL".equalsIgnoreCase(priority)) {
            sql.append(" AND i.priority = ? ");
            params.add(priority.trim());
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append(" AND i.status = ? ");
            params.add(status.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (i.title LIKE ? OR i.location LIKE ? OR i.description LIKE ? OR u.full_name LIKE ?) ");
            String term = "%" + search.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
        }

        sql.append(" ORDER BY CASE WHEN i.priority = 'CRITICAL' THEN 1 WHEN i.priority = 'HIGH' THEN 2 WHEN i.priority = 'MEDIUM' THEN 3 ELSE 4 END, i.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToIncident(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.getAllIncidents error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Retrieves incidents reported by a specific student.
     */
    public List<Incident> getIncidentsByReporter(int reporterId, String statusFilter) {
        List<Incident> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.id, i.reported_by, i.title, i.description, i.category, i.priority, i.location, " +
                "i.incident_date, i.status, i.evidence_path, i.created_at, i.updated_at, " +
                "u.full_name AS reporter_name, u.email AS reporter_email, u.phone AS reporter_phone, u.department AS reporter_department, " +
                "a.assigned_to AS staff_id, s.full_name AS staff_name, s.department AS staff_department, a.assignment_status " +
                "FROM incidents i " +
                "JOIN users u ON i.reported_by = u.id " +
                "LEFT JOIN assignments a ON i.id = a.incident_id " +
                "LEFT JOIN users s ON a.assigned_to = s.id " +
                "WHERE i.reported_by = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(reporterId);

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND i.status = ? ");
            params.add(statusFilter.trim());
        }

        sql.append(" ORDER BY i.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToIncident(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.getIncidentsByReporter error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Retrieves incidents assigned to a specific staff member.
     */
    public List<Incident> getIncidentsByStaff(int staffId, String statusFilter) {
        List<Incident> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.id, i.reported_by, i.title, i.description, i.category, i.priority, i.location, " +
                "i.incident_date, i.status, i.evidence_path, i.created_at, i.updated_at, " +
                "u.full_name AS reporter_name, u.email AS reporter_email, u.phone AS reporter_phone, u.department AS reporter_department, " +
                "a.assigned_to AS staff_id, s.full_name AS staff_name, s.department AS staff_department, a.assignment_status " +
                "FROM incidents i " +
                "JOIN users u ON i.reported_by = u.id " +
                "JOIN assignments a ON i.id = a.incident_id " +
                "JOIN users s ON a.assigned_to = s.id " +
                "WHERE a.assigned_to = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(staffId);

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND i.status = ? ");
            params.add(statusFilter.trim());
        }

        sql.append(" ORDER BY CASE WHEN i.priority = 'CRITICAL' THEN 1 WHEN i.priority = 'HIGH' THEN 2 ELSE 3 END, i.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToIncident(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.getIncidentsByStaff error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Validates whether a requested status transition is allowed by system workflow rules.
     * Allowed transitions:
     * - REPORTED -> ASSIGNED
     * - ASSIGNED -> IN_PROGRESS
     * - IN_PROGRESS -> RESOLVED
     * - RESOLVED -> CLOSED
     */
    public boolean isValidTransition(String currentStatus, String targetStatus) {
        if (currentStatus == null || targetStatus == null) return false;
        if (currentStatus.equalsIgnoreCase(targetStatus)) return true;

        switch (currentStatus.toUpperCase()) {
            case "REPORTED":
                return "ASSIGNED".equalsIgnoreCase(targetStatus);
            case "ASSIGNED":
                return "IN_PROGRESS".equalsIgnoreCase(targetStatus);
            case "IN_PROGRESS":
                return "RESOLVED".equalsIgnoreCase(targetStatus);
            case "RESOLVED":
                return "CLOSED".equalsIgnoreCase(targetStatus);
            case "CLOSED":
                return false; // Terminal state
            default:
                return false;
        }
    }

    /**
     * Updates incident status with workflow validation, timeline recording, and notifications.
     */
    public boolean updateStatus(int incidentId, String newStatus, int updatedBy, String note) {
        Incident incident = getIncidentById(incidentId);
        if (incident == null) return false;

        String oldStatus = incident.getStatus();
        if (!isValidTransition(oldStatus, newStatus)) {
            System.err.println("Invalid status transition attempt: " + oldStatus + " -> " + newStatus);
            return false;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Update status on incidents table
            String updateSql = "UPDATE incidents SET status = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, newStatus);
                ps.setInt(2, incidentId);
                ps.executeUpdate();
            }

            // 2. If transitioning to IN_PROGRESS or RESOLVED, also update assignments table
            if ("IN_PROGRESS".equalsIgnoreCase(newStatus)) {
                String updateAssignSql = "UPDATE assignments SET assignment_status = 'ACCEPTED', accepted_at = CURRENT_TIMESTAMP WHERE incident_id = ? AND assignment_status = 'ASSIGNED'";
                try (PreparedStatement ps = conn.prepareStatement(updateAssignSql)) {
                    ps.setInt(1, incidentId);
                    ps.executeUpdate();
                }
            } else if ("RESOLVED".equalsIgnoreCase(newStatus) || "CLOSED".equalsIgnoreCase(newStatus)) {
                String completeAssignSql = "UPDATE assignments SET assignment_status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE incident_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(completeAssignSql)) {
                    ps.setInt(1, incidentId);
                    ps.executeUpdate();
                }
            }

            // 3. Record timeline audit history
            IncidentUpdateDAO updateDAO = new IncidentUpdateDAO();
            IncidentUpdate updateLog = new IncidentUpdate(
                    incidentId,
                    updatedBy,
                    oldStatus,
                    newStatus,
                    (note != null && !note.trim().isEmpty()) ? note.trim() : "Status updated from " + oldStatus + " to " + newStatus
            );
            updateDAO.addUpdate(conn, updateLog);

            // 4. Notify reporting student
            NotificationDAO notificationDAO = new NotificationDAO();
            notificationDAO.createNotification(conn, incident.getReportedBy(), incidentId,
                    "Status update for Incident #" + incidentId + ": Moved to " + newStatus + ". " + (note != null ? "\"" + note + "\"" : ""));

            // If staff exists and admin closed or changed it, notify staff as well
            if (incident.getAssignedStaffId() != null && incident.getAssignedStaffId() != updatedBy) {
                notificationDAO.createNotification(conn, incident.getAssignedStaffId(), incidentId,
                        "Incident #" + incidentId + " status was updated to " + newStatus + ".");
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("IncidentDAO.updateStatus error: " + e.getMessage());
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
        return false;
    }

    /**
     * Admin modification of incident priority or category.
     */
    public boolean updateIncidentClassification(int incidentId, String priority, String category, int adminId, String note) {
        Incident incident = getIncidentById(incidentId);
        if (incident == null) return false;

        String sql = "UPDATE incidents SET priority = ?, category = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, priority);
            ps.setString(2, category);
            ps.setInt(3, incidentId);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                IncidentUpdateDAO updateDAO = new IncidentUpdateDAO();
                String auditNote = "Classification updated: Priority=" + priority + ", Category=" + category + ". " + (note != null ? note : "");
                updateDAO.addUpdate(new IncidentUpdate(incidentId, adminId, incident.getStatus(), incident.getStatus(), auditNote));
                return true;
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.updateIncidentClassification error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Deletes an incident and its associated records.
     */
    public boolean deleteIncident(int incidentId) {
        String sql = "DELETE FROM incidents WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, incidentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("IncidentDAO.deleteIncident error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Dashboard statistical counts for admin/student/staff.
     */
    public Map<String, Integer> getStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) AS total_incidents, " +
                     "SUM(CASE WHEN priority = 'CRITICAL' AND status != 'CLOSED' THEN 1 ELSE 0 END) AS critical_incidents, " +
                     "SUM(CASE WHEN status IN ('REPORTED', 'ASSIGNED', 'IN_PROGRESS') THEN 1 ELSE 0 END) AS active_incidents, " +
                     "SUM(CASE WHEN status = 'RESOLVED' THEN 1 ELSE 0 END) AS resolved_incidents, " +
                     "SUM(CASE WHEN status = 'CLOSED' THEN 1 ELSE 0 END) AS closed_incidents, " +
                     "SUM(CASE WHEN status = 'REPORTED' THEN 1 ELSE 0 END) AS pending_assignments " +
                     "FROM incidents";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("total", rs.getInt("total_incidents"));
                stats.put("critical", rs.getInt("critical_incidents"));
                stats.put("active", rs.getInt("active_incidents"));
                stats.put("resolved", rs.getInt("resolved_incidents"));
                stats.put("closed", rs.getInt("closed_incidents"));
                stats.put("pending_assignment", rs.getInt("pending_assignments"));
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.getStatistics error: " + e.getMessage());
        }
        return stats;
    }

    /**
     * Student-specific dashboard stats.
     */
    public Map<String, Integer> getStudentStats(int studentId) {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) AS total, " +
                     "SUM(CASE WHEN status IN ('REPORTED', 'ASSIGNED', 'IN_PROGRESS') THEN 1 ELSE 0 END) AS active, " +
                     "SUM(CASE WHEN status IN ('RESOLVED', 'CLOSED') THEN 1 ELSE 0 END) AS resolved " +
                     "FROM incidents WHERE reported_by = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("total", rs.getInt("total"));
                    stats.put("active", rs.getInt("active"));
                    stats.put("resolved", rs.getInt("resolved"));
                }
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.getStudentStats error: " + e.getMessage());
        }
        return stats;
    }

    /**
     * Staff-specific dashboard stats.
     */
    public Map<String, Integer> getStaffStats(int staffId) {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(i.id) AS total_assigned, " +
                     "SUM(CASE WHEN a.assignment_status = 'ASSIGNED' THEN 1 ELSE 0 END) AS pending_acceptance, " +
                     "SUM(CASE WHEN i.status = 'IN_PROGRESS' THEN 1 ELSE 0 END) AS in_progress, " +
                     "SUM(CASE WHEN i.status IN ('RESOLVED', 'CLOSED') THEN 1 ELSE 0 END) AS resolved " +
                     "FROM assignments a JOIN incidents i ON a.incident_id = i.id " +
                     "WHERE a.assigned_to = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("total_assigned", rs.getInt("total_assigned"));
                    stats.put("pending_acceptance", rs.getInt("pending_acceptance"));
                    stats.put("in_progress", rs.getInt("in_progress"));
                    stats.put("resolved", rs.getInt("resolved"));
                }
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.getStaffStats error: " + e.getMessage());
        }
        return stats;
    }

    /**
     * Distribution reports.
     */
    public Map<String, Integer> getCountByField(String fieldName) {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql;
        if ("department".equalsIgnoreCase(fieldName)) {
            sql = "SELECT COALESCE(u.department, 'General') AS label, COUNT(i.id) AS count " +
                  "FROM incidents i JOIN users u ON i.reported_by = u.id GROUP BY label ORDER BY count DESC";
        } else {
            sql = "SELECT " + fieldName + " AS label, COUNT(*) AS count FROM incidents GROUP BY " + fieldName + " ORDER BY count DESC";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("label"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            System.err.println("IncidentDAO.getCountByField error for " + fieldName + ": " + e.getMessage());
        }
        return map;
    }

    private Incident mapResultSetToIncident(ResultSet rs) throws SQLException {
        Incident i = new Incident();
        i.setId(rs.getInt("id"));
        i.setReportedBy(rs.getInt("reported_by"));
        i.setTitle(rs.getString("title"));
        i.setDescription(rs.getString("description"));
        i.setCategory(rs.getString("category"));
        i.setPriority(rs.getString("priority"));
        i.setLocation(rs.getString("location"));
        i.setIncidentDate(rs.getString("incident_date"));
        i.setStatus(rs.getString("status"));
        i.setEvidencePath(rs.getString("evidence_path"));
        i.setCreatedAt(rs.getTimestamp("created_at"));
        i.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Joined columns
        try {
            i.setReportedByName(rs.getString("reporter_name"));
            i.setReportedByEmail(rs.getString("reporter_email"));
            i.setReportedByPhone(rs.getString("reporter_phone"));
            i.setReportedByDepartment(rs.getString("reporter_department"));
        } catch (SQLException ignored) {}

        try {
            int staffId = rs.getInt("staff_id");
            if (!rs.wasNull()) {
                i.setAssignedStaffId(staffId);
                i.setAssignedStaffName(rs.getString("staff_name"));
                i.setAssignedStaffDepartment(rs.getString("staff_department"));
                i.setAssignmentStatus(rs.getString("assignment_status"));
            }
        } catch (SQLException ignored) {}

        return i;
    }
}
