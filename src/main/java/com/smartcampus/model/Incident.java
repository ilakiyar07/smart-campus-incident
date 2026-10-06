package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Incident model representing campus incidents & emergencies.
 */
public class Incident implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int reportedBy;
    private String reportedByName;
    private String reportedByEmail;
    private String reportedByPhone;
    private String reportedByDepartment;
    
    private String title;
    private String description;
    private String category; // MEDICAL, FIRE, SECURITY, HARASSMENT, SUSPICIOUS_ACTIVITY, ELECTRICAL, PLUMBING, INFRASTRUCTURE, ACCIDENT, OTHER
    private String priority; // LOW, MEDIUM, HIGH, CRITICAL
    private String location;
    private String incidentDate;
    private String status; // REPORTED, ASSIGNED, IN_PROGRESS, RESOLVED, CLOSED
    private String evidencePath;
    
    private Integer assignedStaffId;
    private String assignedStaffName;
    private String assignedStaffDepartment;
    private String assignmentStatus;
    
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Incident() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReportedBy() {
        return reportedBy;
    }

    public void setReportedBy(int reportedBy) {
        this.reportedBy = reportedBy;
    }

    public String getReportedByName() {
        return reportedByName;
    }

    public void setReportedByName(String reportedByName) {
        this.reportedByName = reportedByName;
    }

    public String getReportedByEmail() {
        return reportedByEmail;
    }

    public void setReportedByEmail(String reportedByEmail) {
        this.reportedByEmail = reportedByEmail;
    }

    public String getReportedByPhone() {
        return reportedByPhone;
    }

    public void setReportedByPhone(String reportedByPhone) {
        this.reportedByPhone = reportedByPhone;
    }

    public String getReportedByDepartment() {
        return reportedByDepartment;
    }

    public void setReportedByDepartment(String reportedByDepartment) {
        this.reportedByDepartment = reportedByDepartment;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getIncidentDate() {
        return incidentDate;
    }

    public void setIncidentDate(String incidentDate) {
        this.incidentDate = incidentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEvidencePath() {
        return evidencePath;
    }

    public void setEvidencePath(String evidencePath) {
        this.evidencePath = evidencePath;
    }

    public Integer getAssignedStaffId() {
        return assignedStaffId;
    }

    public void setAssignedStaffId(Integer assignedStaffId) {
        this.assignedStaffId = assignedStaffId;
    }

    public String getAssignedStaffName() {
        return assignedStaffName;
    }

    public void setAssignedStaffName(String assignedStaffName) {
        this.assignedStaffName = assignedStaffName;
    }

    public String getAssignedStaffDepartment() {
        return assignedStaffDepartment;
    }

    public void setAssignedStaffDepartment(String assignedStaffDepartment) {
        this.assignedStaffDepartment = assignedStaffDepartment;
    }

    public String getAssignmentStatus() {
        return assignmentStatus;
    }

    public void setAssignmentStatus(String assignmentStatus) {
        this.assignmentStatus = assignmentStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getPriorityBadgeClass() {
        if ("CRITICAL".equalsIgnoreCase(priority)) return "badge-critical";
        if ("HIGH".equalsIgnoreCase(priority)) return "badge-high";
        if ("MEDIUM".equalsIgnoreCase(priority)) return "badge-medium";
        return "badge-low";
    }

    public String getStatusBadgeClass() {
        if ("REPORTED".equalsIgnoreCase(status)) return "badge-status-reported";
        if ("ASSIGNED".equalsIgnoreCase(status)) return "badge-status-assigned";
        if ("IN_PROGRESS".equalsIgnoreCase(status)) return "badge-status-progress";
        if ("RESOLVED".equalsIgnoreCase(status)) return "badge-status-resolved";
        if ("CLOSED".equalsIgnoreCase(status)) return "badge-status-closed";
        return "badge-secondary";
    }

    public String getCategoryDisplayName() {
        if (category == null) return "General";
        return category.replace("_", " ");
    }
}
