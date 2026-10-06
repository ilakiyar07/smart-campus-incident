-- ====================================================================
-- SMART CAMPUS EMERGENCY & INCIDENT MANAGEMENT SYSTEM
-- Database Schema & Sample Data for MySQL
-- ====================================================================

DROP DATABASE IF EXISTS smart_campus_incident;
CREATE DATABASE smart_campus_incident CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_campus_incident;

-- --------------------------------------------------------------------
-- 1. USERS TABLE
-- --------------------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    role ENUM('STUDENT', 'STAFF', 'ADMIN') NOT NULL DEFAULT 'STUDENT',
    department VARCHAR(100) DEFAULT 'General',
    status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 2. INCIDENTS TABLE
-- --------------------------------------------------------------------
CREATE TABLE incidents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reported_by INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category ENUM(
        'MEDICAL', 
        'FIRE', 
        'SECURITY', 
        'HARASSMENT', 
        'SUSPICIOUS_ACTIVITY', 
        'ELECTRICAL', 
        'PLUMBING', 
        'INFRASTRUCTURE', 
        'ACCIDENT', 
        'OTHER'
    ) NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') NOT NULL DEFAULT 'MEDIUM',
    location VARCHAR(200) NOT NULL,
    incident_date VARCHAR(50) DEFAULT NULL,
    status ENUM('REPORTED', 'ASSIGNED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') NOT NULL DEFAULT 'REPORTED',
    evidence_path VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_incidents_user FOREIGN KEY (reported_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 3. ASSIGNMENTS TABLE
-- --------------------------------------------------------------------
CREATE TABLE assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    incident_id INT NOT NULL,
    assigned_to INT NOT NULL,
    assigned_by INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    accepted_at TIMESTAMP NULL DEFAULT NULL,
    completed_at TIMESTAMP NULL DEFAULT NULL,
    assignment_status ENUM('ASSIGNED', 'ACCEPTED', 'COMPLETED') NOT NULL DEFAULT 'ASSIGNED',
    CONSTRAINT fk_assignments_incident FOREIGN KEY (incident_id) REFERENCES incidents(id) ON DELETE CASCADE,
    CONSTRAINT fk_assignments_to_user FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_assignments_by_user FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 4. INCIDENT_UPDATES (TIMELINE AUDIT HISTORY) TABLE
-- --------------------------------------------------------------------
CREATE TABLE incident_updates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    incident_id INT NOT NULL,
    updated_by INT NOT NULL,
    old_status VARCHAR(50) DEFAULT NULL,
    new_status VARCHAR(50) NOT NULL,
    note TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_updates_incident FOREIGN KEY (incident_id) REFERENCES incidents(id) ON DELETE CASCADE,
    CONSTRAINT fk_updates_user FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 5. NOTIFICATIONS TABLE
-- --------------------------------------------------------------------
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    incident_id INT DEFAULT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_notifications_incident FOREIGN KEY (incident_id) REFERENCES incidents(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ====================================================================
-- SEED SAMPLE DATA
-- ====================================================================

-- 1. Sample Users (Admin, Staff, Student)
INSERT INTO users (id, full_name, email, password, phone, role, department, status, created_at) VALUES
(1, 'Dr. Robert Admin', 'admin@campus.com', 'admin123', '+1-555-0101', 'ADMIN', 'Campus Administration', 'ACTIVE', '2026-01-01 08:00:00'),
(2, 'Chief James Thorne', 'security@campus.com', 'staff123', '+1-555-0102', 'STAFF', 'Campus Security', 'ACTIVE', '2026-01-02 08:30:00'),
(3, 'Nurse Sarah Jenkins', 'medical@campus.com', 'staff123', '+1-555-0103', 'STAFF', 'Health & Medical Services', 'ACTIVE', '2026-01-02 08:45:00'),
(4, 'Mark Davis', 'electrical@campus.com', 'staff123', '+1-555-0104', 'STAFF', 'Facilities & Maintenance', 'ACTIVE', '2026-01-03 09:00:00'),
(5, 'Alice Johnson', 'student@campus.com', 'student123', '+1-555-0105', 'STUDENT', 'Computer Science', 'ACTIVE', '2026-01-10 10:00:00'),
(6, 'David Miller', 'david.student@campus.com', 'student123', '+1-555-0106', 'STUDENT', 'Mechanical Engineering', 'ACTIVE', '2026-01-11 11:15:00'),
(7, 'Emily Clark', 'emily.student@campus.com', 'student123', '+1-555-0107', 'STUDENT', 'Electrical Engineering', 'ACTIVE', '2026-01-12 14:20:00');

-- 2. Sample Incidents
-- Incident 1: Smoke detected near laboratory (REPORTED)
INSERT INTO incidents (id, reported_by, title, description, category, priority, location, incident_date, status, created_at, updated_at) VALUES
(1, 5, 'Smoke detected near laboratory', 'Strong smell of smoke and haze noticed outside Chemistry Lab 302. No open flames visible yet.', 'FIRE', 'HIGH', 'Block A - Chemistry Lab', '2026-10-04 09:15', 'REPORTED', '2026-10-04 09:15:00', '2026-10-04 09:15:00');

INSERT INTO incident_updates (incident_id, updated_by, old_status, new_status, note, created_at) VALUES
(1, 5, NULL, 'REPORTED', 'Incident reported by student Alice Johnson.', '2026-10-04 09:15:00');

INSERT INTO notifications (user_id, incident_id, message, is_read, created_at) VALUES
(1, 1, 'New HIGH priority FIRE incident reported: "Smoke detected near laboratory" at Block A - Chemistry Lab.', FALSE, '2026-10-04 09:15:00'),
(5, 1, 'Your incident report #1 has been logged successfully and sent to campus safety.', TRUE, '2026-10-04 09:15:00');

-- Incident 2: Student fainted near cafeteria (IN_PROGRESS)
INSERT INTO incidents (id, reported_by, title, description, category, priority, location, incident_date, status, created_at, updated_at) VALUES
(2, 6, 'Student fainted near cafeteria', 'A student collapsed suddenly near the north entrance of the cafeteria. First aid required immediately.', 'MEDICAL', 'CRITICAL', 'Main Cafeteria', '2026-10-04 10:00', 'IN_PROGRESS', '2026-10-04 10:00:00', '2026-10-04 10:20:00');

INSERT INTO assignments (id, incident_id, assigned_to, assigned_by, assigned_at, accepted_at, assignment_status) VALUES
(1, 2, 3, 1, '2026-10-04 10:05:00', '2026-10-04 10:10:00', 'ACCEPTED');

INSERT INTO incident_updates (incident_id, updated_by, old_status, new_status, note, created_at) VALUES
(2, 6, NULL, 'REPORTED', 'Critical medical emergency reported near main cafeteria.', '2026-10-04 10:00:00'),
(2, 1, 'REPORTED', 'ASSIGNED', 'Assigned to Nurse Sarah Jenkins (Medical Team).', '2026-10-04 10:05:00'),
(2, 3, 'ASSIGNED', 'IN_PROGRESS', 'Nurse en route with emergency medical kit and wheelchair.', '2026-10-04 10:20:00');

INSERT INTO notifications (user_id, incident_id, message, is_read, created_at) VALUES
(3, 2, 'Urgent: You have been assigned to CRITICAL Medical Incident #2 at Main Cafeteria.', TRUE, '2026-10-04 10:05:00'),
(6, 2, 'Medical staff Nurse Sarah Jenkins has responded and is on the way.', TRUE, '2026-10-04 10:20:00');

-- Incident 3: Broken electrical socket (ASSIGNED)
INSERT INTO incidents (id, reported_by, title, description, category, priority, location, incident_date, status, created_at, updated_at) VALUES
(3, 7, 'Broken electrical socket with exposed wires', 'Power socket in classroom 204 is cracked with sparking wires when plugging in laptop.', 'ELECTRICAL', 'MEDIUM', 'Block B - Room 204', '2026-10-04 11:30', 'ASSIGNED', '2026-10-04 11:30:00', '2026-10-04 11:45:00');

INSERT INTO assignments (id, incident_id, assigned_to, assigned_by, assigned_at, assignment_status) VALUES
(2, 3, 4, 1, '2026-10-04 11:45:00', 'ASSIGNED');

INSERT INTO incident_updates (incident_id, updated_by, old_status, new_status, note, created_at) VALUES
(3, 7, NULL, 'REPORTED', 'Electrical hazard reported by Emily Clark.', '2026-10-04 11:30:00'),
(3, 1, 'REPORTED', 'ASSIGNED', 'Assigned to Mark Davis (Facilities Maintenance).', '2026-10-04 11:45:00');

INSERT INTO notifications (user_id, incident_id, message, is_read, created_at) VALUES
(4, 3, 'You have been assigned Incident #3: "Broken electrical socket with exposed wires".', FALSE, '2026-10-04 11:45:00');

-- Incident 4: Suspicious activity near parking area (RESOLVED)
INSERT INTO incidents (id, reported_by, title, description, category, priority, location, incident_date, status, created_at, updated_at) VALUES
(4, 5, 'Suspicious activity near parking area', 'Two individuals without visitor badges attempting to tamper with bicycle locks in east parking lot.', 'SUSPICIOUS_ACTIVITY', 'HIGH', 'Parking Area - East Lot', '2026-10-03 14:00', 'RESOLVED', '2026-10-03 14:00:00', '2026-10-03 15:30:00');

INSERT INTO assignments (id, incident_id, assigned_to, assigned_by, assigned_at, accepted_at, completed_at, assignment_status) VALUES
(3, 4, 2, 1, '2026-10-03 14:10:00', '2026-10-03 14:15:00', '2026-10-03 15:30:00', 'COMPLETED');

INSERT INTO incident_updates (incident_id, updated_by, old_status, new_status, note, created_at) VALUES
(4, 5, NULL, 'REPORTED', 'Suspicious activity reported by Alice Johnson.', '2026-10-03 14:00:00'),
(4, 1, 'REPORTED', 'ASSIGNED', 'Assigned to Chief James Thorne (Security).', '2026-10-03 14:10:00'),
(4, 2, 'ASSIGNED', 'IN_PROGRESS', 'Security patrol dispatched to East Lot.', '2026-10-03 14:20:00'),
(4, 2, 'IN_PROGRESS', 'RESOLVED', 'Individuals questioned, escorted off campus. Bicycle locks inspected and secured.', '2026-10-03 15:30:00');

INSERT INTO notifications (user_id, incident_id, message, is_read, created_at) VALUES
(5, 4, 'Incident #4 "Suspicious activity near parking area" has been marked as RESOLVED by Campus Security.', TRUE, '2026-10-03 15:30:00');

-- Incident 5: Water pipe leakage in restroom (CLOSED)
INSERT INTO incidents (id, reported_by, title, description, category, priority, location, incident_date, status, created_at, updated_at) VALUES
(5, 6, 'Water pipe leakage flooding hallway', 'Plumbing pipe burst in 2nd floor restroom causing minor flooding into the corridor.', 'PLUMBING', 'MEDIUM', 'Block C - 2nd Floor Restroom', '2026-10-01 08:30', 'CLOSED', '2026-10-01 08:30:00', '2026-10-01 12:00:00');

INSERT INTO assignments (id, incident_id, assigned_to, assigned_by, assigned_at, accepted_at, completed_at, assignment_status) VALUES
(4, 5, 4, 1, '2026-10-01 08:45:00', '2026-10-01 08:50:00', '2026-10-01 11:30:00', 'COMPLETED');

INSERT INTO incident_updates (incident_id, updated_by, old_status, new_status, note, created_at) VALUES
(5, 6, NULL, 'REPORTED', 'Plumbing burst reported.', '2026-10-01 08:30:00'),
(5, 1, 'REPORTED', 'ASSIGNED', 'Assigned to Mark Davis.', '2026-10-01 08:45:00'),
(5, 4, 'ASSIGNED', 'IN_PROGRESS', 'Main valve shut off; replacing cracked joint.', '2026-10-01 09:00:00'),
(5, 4, 'IN_PROGRESS', 'RESOLVED', 'New joint fitted and floor dried.', '2026-10-01 11:30:00'),
(5, 1, 'RESOLVED', 'CLOSED', 'Work verified and case officially closed by admin.', '2026-10-01 12:00:00');

INSERT INTO notifications (user_id, incident_id, message, is_read, created_at) VALUES
(6, 5, 'Your reported incident #5 has been CLOSED by Administrator.', TRUE, '2026-10-01 12:00:00');
