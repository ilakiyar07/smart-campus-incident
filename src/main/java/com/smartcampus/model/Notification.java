package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * Notification model for internal campus alerts.
 */
public class Notification implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private Integer incidentId;
    private String incidentTitle;
    private String message;
    private boolean isRead;
    private Timestamp createdAt;

    public Notification() {
    }

    public Notification(int userId, Integer incidentId, String message) {
        this.userId = userId;
        this.incidentId = incidentId;
        this.message = message;
        this.isRead = false;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getIncidentId() {
        return incidentId;
    }

    public void setIncidentId(Integer incidentId) {
        this.incidentId = incidentId;
    }

    public String getIncidentTitle() {
        return incidentTitle;
    }

    public void setIncidentTitle(String incidentTitle) {
        this.incidentTitle = incidentTitle;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
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
