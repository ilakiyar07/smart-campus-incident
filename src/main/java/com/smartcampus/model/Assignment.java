package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Assignment model representing an incident assigned to a staff member by an admin.
 */
public class Assignment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int incidentId;
    private String incidentTitle;
    private String incidentCategory;
    private String incidentPriority;
    private String incidentLocation;
    private String incidentCurrentStatus;

    private int assignedTo;
    private String assignedToName;
    private String assignedToEmail;
    private String assignedToPhone;
    private String assignedToDepartment;

    private int assignedBy;
    private String assignedByName;

    private Timestamp assignedAt;
    private Timestamp acceptedAt;
    private Timestamp completedAt;
    private String assignmentStatus; // ASSIGNED, ACCEPTED, COMPLETED

    public Assignment() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIncidentId() {
        return incidentId;
    }

    public void setIncidentId(int incidentId) {
        this.incidentId = incidentId;
    }

    public String getIncidentTitle() {
        return incidentTitle;
    }

    public void setIncidentTitle(String incidentTitle) {
        this.incidentTitle = incidentTitle;
    }

    public String getIncidentCategory() {
        return incidentCategory;
    }

    public void setIncidentCategory(String incidentCategory) {
        this.incidentCategory = incidentCategory;
    }

    public String getIncidentPriority() {
        return incidentPriority;
    }

    public void setIncidentPriority(String incidentPriority) {
        this.incidentPriority = incidentPriority;
    }

    public String getIncidentLocation() {
        return incidentLocation;
    }

    public void setIncidentLocation(String incidentLocation) {
        this.incidentLocation = incidentLocation;
    }

    public String getIncidentCurrentStatus() {
        return incidentCurrentStatus;
    }

    public void setIncidentCurrentStatus(String incidentCurrentStatus) {
        this.incidentCurrentStatus = incidentCurrentStatus;
    }

    public int getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(int assignedTo) {
        this.assignedTo = assignedTo;
    }

    public String getAssignedToName() {
        return assignedToName;
    }

    public void setAssignedToName(String assignedToName) {
        this.assignedToName = assignedToName;
    }

    public String getAssignedToEmail() {
        return assignedToEmail;
    }

    public void setAssignedToEmail(String assignedToEmail) {
        this.assignedToEmail = assignedToEmail;
    }

    public String getAssignedToPhone() {
        return assignedToPhone;
    }

    public void setAssignedToPhone(String assignedToPhone) {
        this.assignedToPhone = assignedToPhone;
    }

    public String getAssignedToDepartment() {
        return assignedToDepartment;
    }

    public void setAssignedToDepartment(String assignedToDepartment) {
        this.assignedToDepartment = assignedToDepartment;
    }

    public int getAssignedBy() {
        return assignedBy;
    }

    public void setAssignedBy(int assignedBy) {
        this.assignedBy = assignedBy;
    }

    public String getAssignedByName() {
        return assignedByName;
    }

    public void setAssignedByName(String assignedByName) {
        this.assignedByName = assignedByName;
    }

    public Timestamp getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Timestamp assignedAt) {
        this.assignedAt = assignedAt;
    }

    public Timestamp getAcceptedAt() {
        return acceptedAt;
    }

    public void setAcceptedAt(Timestamp acceptedAt) {
        this.acceptedAt = acceptedAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public String getAssignmentStatus() {
        return assignmentStatus;
    }

    public void setAssignmentStatus(String assignmentStatus) {
        this.assignmentStatus = assignmentStatus;
    }
}
