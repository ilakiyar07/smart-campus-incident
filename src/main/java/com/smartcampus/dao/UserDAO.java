package com.smartcampus.dao;

import com.smartcampus.model.User;
import com.smartcampus.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * User Data Access Object handling all user persistence operations.
 */
public class UserDAO {

    /**
     * Authenticates a user with email and password.
     */
    public User authenticate(String email, String password) {
        String sql = "SELECT id, full_name, email, password, phone, role, department, status, created_at FROM users WHERE email = ? AND password = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email != null ? email.trim() : "");
            ps.setString(2, password != null ? password.trim() : "");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.authenticate error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Checks if an email is already registered.
     */
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email != null ? email.trim().toLowerCase() : "");
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.emailExists error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Registers a new student or user.
     */
    public boolean register(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, role, department, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail().trim().toLowerCase());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole() != null ? user.getRole() : "STUDENT");
            ps.setString(6, user.getDepartment() != null ? user.getDepartment() : "General");
            ps.setString(7, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.register error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Gets a single user by ID.
     */
    public User getUserById(int id) {
        String sql = "SELECT id, full_name, email, password, phone, role, department, status, created_at FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.getUserById error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves all users ordered by creation date.
     */
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, full_name, email, password, phone, role, department, status, created_at FROM users ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.getAllUsers error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Retrieves users filtered by role (STUDENT, STAFF, ADMIN).
     */
    public List<User> getUsersByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, full_name, email, password, phone, role, department, status, created_at FROM users WHERE role = ? ORDER BY full_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.getUsersByRole error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Toggles or updates user status (ACTIVE / INACTIVE).
     */
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("UserDAO.updateUserStatus error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Checks if a user can be safely deleted without breaking foreign key relationships.
     */
    public boolean canDeleteUser(int userId) {
        String checkIncidents = "SELECT COUNT(*) FROM incidents WHERE reported_by = ?";
        String checkAssignments = "SELECT COUNT(*) FROM assignments WHERE assigned_to = ? OR assigned_by = ?";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(checkIncidents)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) return false;
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(checkAssignments)) {
                ps.setInt(1, userId);
                ps.setInt(2, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) return false;
                }
            }
            return true;
        } catch (SQLException e) {
            System.err.println("UserDAO.canDeleteUser error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Deletes user if safe.
     */
    public boolean deleteUser(int userId) {
        if (!canDeleteUser(userId)) {
            return false;
        }
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("UserDAO.deleteUser error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Counts users with a given role.
     */
    public int countUsersByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.countUsersByRole error: " + e.getMessage());
        }
        return 0;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        user.setDepartment(rs.getString("department"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
