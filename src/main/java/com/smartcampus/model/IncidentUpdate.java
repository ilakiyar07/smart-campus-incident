package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * IncidentUpdate model representing a change in status or a timeline note.
 */
public class IncidentUpdate implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int incidentId;
    private int updatedBy;
    private String updatedByName;
    private String updatedByRole; // STUDENT, STAFF, ADMIN
    private String oldStatus;
    private String newStatus;
    private String note;
    private Timestamp createdAt;

    public IncidentUpdate() {
    }

    public IncidentUpdate(int incidentId, int updatedBy, String oldStatus, String newStatus, String note) {
        this.incidentId = incidentId;
        this.updatedBy = updatedBy;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.note = note;
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

    public int getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(int updatedBy) {
        this.updatedBy = updatedBy;
    }

    public String getUpdatedByName() {
        return updatedByName;
    }

    public void setUpdatedByName(String updatedByName) {
        this.updatedByName = updatedByName;
    }

    public String getUpdatedByRole() {
        return updatedByRole;
    }

    public void setUpdatedByRole(String updatedByRole) {
        this.updatedByRole = updatedByRole;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getFormattedTime() {
        if (createdAt == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy - hh:mm a");
        return sdf.format(createdAt);
    }
}
