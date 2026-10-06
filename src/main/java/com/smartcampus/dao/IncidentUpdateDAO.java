package com.smartcampus.dao;

import com.smartcampus.model.IncidentUpdate;
import com.smartcampus.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * IncidentUpdateDAO manages timeline history and status change audit trails.
 */
public class IncidentUpdateDAO {

    /**
     * Adds an audit/timeline update entry.
     */
    public boolean addUpdate(IncidentUpdate update) {
        String sql = "INSERT INTO incident_updates (incident_id, updated_by, old_status, new_status, note) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, update.getIncidentId());
            ps.setInt(2, update.getUpdatedBy());
            ps.setString(3, update.getOldStatus());
            ps.setString(4, update.getNewStatus());
            ps.setString(5, update.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("IncidentUpdateDAO.addUpdate error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Overload to add update using an existing database connection (for transactions).
     */
    public boolean addUpdate(Connection conn, IncidentUpdate update) throws SQLException {
        String sql = "INSERT INTO incident_updates (incident_id, updated_by, old_status, new_status, note) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, update.getIncidentId());
            ps.setInt(2, update.getUpdatedBy());
            ps.setString(3, update.getOldStatus());
            ps.setString(4, update.getNewStatus());
            ps.setString(5, update.getNote());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Retrieves all timeline updates for a given incident in chronological order.
     */
    public List<IncidentUpdate> getUpdatesByIncidentId(int incidentId) {
        List<IncidentUpdate> list = new ArrayList<>();
        String sql = "SELECT iu.id, iu.incident_id, iu.updated_by, iu.old_status, iu.new_status, iu.note, iu.created_at, " +
                     "u.full_name AS updated_by_name, u.role AS updated_by_role " +
                     "FROM incident_updates iu " +
                     "JOIN users u ON iu.updated_by = u.id " +
                     "WHERE iu.incident_id = ? " +
                     "ORDER BY iu.created_at ASC, iu.id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, incidentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    IncidentUpdate iu = new IncidentUpdate();
                    iu.setId(rs.getInt("id"));
                    iu.setIncidentId(rs.getInt("incident_id"));
                    iu.setUpdatedBy(rs.getInt("updated_by"));
                    iu.setOldStatus(rs.getString("old_status"));
                    iu.setNewStatus(rs.getString("new_status"));
                    iu.setNote(rs.getString("note"));
                    iu.setCreatedAt(rs.getTimestamp("created_at"));
                    iu.setUpdatedByName(rs.getString("updated_by_name"));
                    iu.setUpdatedByRole(rs.getString("updated_by_role"));
                    list.add(iu);
                }
            }
        } catch (SQLException e) {
            System.err.println("IncidentUpdateDAO.getUpdatesByIncidentId error: " + e.getMessage());
        }
        return list;
    }
}
