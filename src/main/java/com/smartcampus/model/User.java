package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * User model representing STUDENT, STAFF, or ADMIN.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String role; // STUDENT, STAFF, ADMIN
    private String department;
    private String status; // ACTIVE, INACTIVE
    private Timestamp createdAt;

    public User() {
    }

    public User(int id, String fullName, String email, String password, String phone, String role, String department, String status, Timestamp createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.department = department;
        this.status = status;
        this.createdAt = createdAt;
    }

    public User(String fullName, String email, String password, String phone, String role, String department) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.department = department;
        this.status = "ACTIVE";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isStudent() {
        return "STUDENT".equalsIgnoreCase(this.role);
    }

    public boolean isStaff() {
        return "STAFF".equalsIgnoreCase(this.role);
    }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.role);
    }

    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(this.status);
    }
}
