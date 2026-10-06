package com.smartcampus.dao;

import com.smartcampus.model.Assignment;
import com.smartcampus.model.Incident;
import com.smartcampus.model.IncidentUpdate;
import com.smartcampus.model.User;
import com.smartcampus.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AssignmentDAO manages staff incident assignments, acceptance, and completion workflows.
 */
public class AssignmentDAO {

    /**
     * Assigns an incident to a staff member by an admin.
     * Executes in transaction:
     * 1. Inserts assignment record
     * 2. Sets incident status to ASSIGNED
     * 3. Records timeline update
     * 4. Sends notifications to staff and student
     */
    public boolean assignIncident(int incidentId, int staffId, int adminId, String note) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Get staff details
            UserDAO userDAO = new UserDAO();
            User staff = userDAO.getUserById(staffId);
            IncidentDAO incidentDAO = new IncidentDAO();
            Incident incident = incidentDAO.getIncidentById(incidentId);

            if (staff == null || incident == null) {
                conn.rollback();
                return false;
            }

            // 1. Insert or update assignment record
            String insertAssignSql = "INSERT INTO assignments (incident_id, assigned_to, assigned_by, assignment_status) VALUES (?, ?, ?, 'ASSIGNED')";
            try (PreparedStatement ps = conn.prepareStatement(insertAssignSql)) {
                ps.setInt(1, incidentId);
                ps.setInt(2, staffId);
                ps.setInt(3, adminId);
                ps.executeUpdate();
            }

            // 2. Update incident status to ASSIGNED
            String updateIncidentSql = "UPDATE incidents SET status = 'ASSIGNED' WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateIncidentSql)) {
                ps.setInt(1, incidentId);
                ps.executeUpdate();
            }

            // 3. Record timeline history
            String auditMsg = "Assigned to staff " + staff.getFullName() + " (" + staff.getDepartment() + ")." +
                    (note != null && !note.trim().isEmpty() ? " Instructions: " + note.trim() : "");
            IncidentUpdateDAO updateDAO = new IncidentUpdateDAO();
            updateDAO.addUpdate(conn, new IncidentUpdate(incidentId, adminId, incident.getStatus(), "ASSIGNED", auditMsg));

            // 4. Notify Staff
            NotificationDAO notificationDAO = new NotificationDAO();
            notificationDAO.createNotification(conn, staffId, incidentId,
                    "You have been assigned to Incident #" + incidentId + ": \"" + incident.getTitle() + "\" at " + incident.getLocation() + ".");

            // 5. Notify Student
            notificationDAO.createNotification(conn, incident.getReportedBy(), incidentId,
                    "Your incident #" + incidentId + " has been assigned to " + staff.getFullName() + " (" + staff.getDepartment() + ").");

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("AssignmentDAO.assignIncident error: " + e.getMessage());
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
     * Staff accepts the assigned incident and marks work as IN_PROGRESS.
     */
    public boolean acceptAssignment(int incidentId, int staffId, String progressNote) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            IncidentDAO incidentDAO = new IncidentDAO();
            Incident incident = incidentDAO.getIncidentById(incidentId);
            if (incident == null) {
                conn.rollback();
                return false;
            }

            // 1. Update assignment status
            String updateAssignSql = "UPDATE assignments SET assignment_status = 'ACCEPTED', accepted_at = CURRENT_TIMESTAMP WHERE incident_id = ? AND assigned_to = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateAssignSql)) {
                ps.setInt(1, incidentId);
                ps.setInt(2, staffId);
                ps.executeUpdate();
            }

            // 2. Update incident status
            String updateIncidentSql = "UPDATE incidents SET status = 'IN_PROGRESS' WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateIncidentSql)) {
                ps.setInt(1, incidentId);
                ps.executeUpdate();
            }

            // 3. Timeline log
            String noteText = (progressNote != null && !progressNote.trim().isEmpty()) ? progressNote.trim() : "Staff accepted assignment and initiated response.";
            IncidentUpdateDAO updateDAO = new IncidentUpdateDAO();
            updateDAO.addUpdate(conn, new IncidentUpdate(incidentId, staffId, "ASSIGNED", "IN_PROGRESS", noteText));

            // 4. Notify reporting student
            NotificationDAO notificationDAO = new NotificationDAO();
            notificationDAO.createNotification(conn, incident.getReportedBy(), incidentId,
                    "Work is now IN PROGRESS for your incident #" + incidentId + ".");

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("AssignmentDAO.acceptAssignment error: " + e.getMessage());
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
     * Staff marks work as RESOLVED.
     */
    public boolean completeAssignment(int incidentId, int staffId, String resolutionNote) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            IncidentDAO incidentDAO = new IncidentDAO();
            Incident incident = incidentDAO.getIncidentById(incidentId);
            if (incident == null) {
                conn.rollback();
                return false;
            }

            // 1. Update assignment status
            String updateAssignSql = "UPDATE assignments SET assignment_status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE incident_id = ? AND assigned_to = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateAssignSql)) {
                ps.setInt(1, incidentId);
                ps.setInt(2, staffId);
                ps.executeUpdate();
            }

            // 2. Update incident status
            String updateIncidentSql = "UPDATE incidents SET status = 'RESOLVED' WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateIncidentSql)) {
                ps.setInt(1, incidentId);
                ps.executeUpdate();
            }

            // 3. Timeline log
            String noteText = (resolutionNote != null && !resolutionNote.trim().isEmpty()) ? resolutionNote.trim() : "Staff resolved the issue and marked completed.";
            IncidentUpdateDAO updateDAO = new IncidentUpdateDAO();
            updateDAO.addUpdate(conn, new IncidentUpdate(incidentId, staffId, "IN_PROGRESS", "RESOLVED", noteText));

            // 4. Notify Student & Admin
            NotificationDAO notificationDAO = new NotificationDAO();
            notificationDAO.createNotification(conn, incident.getReportedBy(), incidentId,
                    "Good news! Your incident #" + incidentId + " (\"" + incident.getTitle() + "\") has been marked as RESOLVED by staff.");

            notificationDAO.notifyRole("ADMIN", incidentId,
                    "Staff marked Incident #" + incidentId + " as RESOLVED. Ready for admin verification/closure.");

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("AssignmentDAO.completeAssignment error: " + e.getMessage());
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
     * Retrieves all assignments with details for Admin assignments view.
     */
    public List<Assignment> getAllAssignments() {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT a.id, a.incident_id, a.assigned_to, a.assigned_by, a.assigned_at, a.accepted_at, a.completed_at, a.assignment_status, " +
                     "i.title AS incident_title, i.category AS incident_category, i.priority AS incident_priority, i.location AS incident_location, i.status AS incident_status, " +
                     "s.full_name AS staff_name, s.email AS staff_email, s.phone AS staff_phone, s.department AS staff_dept, " +
                     "admin.full_name AS admin_name " +
                     "FROM assignments a " +
                     "JOIN incidents i ON a.incident_id = i.id " +
                     "JOIN users s ON a.assigned_to = s.id " +
                     "JOIN users admin ON a.assigned_by = admin.id " +
                     "ORDER BY a.assigned_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Assignment a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setIncidentId(rs.getInt("incident_id"));
                a.setAssignedTo(rs.getInt("assigned_to"));
                a.setAssignedBy(rs.getInt("assigned_by"));
                a.setAssignedAt(rs.getTimestamp("assigned_at"));
                a.setAcceptedAt(rs.getTimestamp("accepted_at"));
                a.setCompletedAt(rs.getTimestamp("completed_at"));
                a.setAssignmentStatus(rs.getString("assignment_status"));
                a.setIncidentTitle(rs.getString("incident_title"));
                a.setIncidentCategory(rs.getString("incident_category"));
                a.setIncidentPriority(rs.getString("incident_priority"));
                a.setIncidentLocation(rs.getString("incident_location"));
                a.setIncidentCurrentStatus(rs.getString("incident_status"));
                a.setAssignedToName(rs.getString("staff_name"));
                a.setAssignedToEmail(rs.getString("staff_email"));
                a.setAssignedToPhone(rs.getString("staff_phone"));
                a.setAssignedToDepartment(rs.getString("staff_dept"));
                a.setAssignedByName(rs.getString("admin_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            System.err.println("AssignmentDAO.getAllAssignments error: " + e.getMessage());
        }
        return list;
    }
}
