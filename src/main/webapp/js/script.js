/**
 * SMART CAMPUS EMERGENCY & INCIDENT MANAGEMENT SYSTEM
 * Client-Side Interactivity, Validation, Search, and Modals
 */

document.addEventListener("DOMContentLoaded", function () {
    // 1. Auto-dismiss Bootstrap Alerts after 6 seconds
    const alerts = document.querySelectorAll(".alert-dismissible");
    alerts.forEach(function (alert) {
        setTimeout(function () {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) {
                bsAlert.close();
            }
        }, 6000);
    });

    // 2. Client-Side Instant Table Filter for Quick Search
    const liveSearchInput = document.getElementById("tableSearchInput");
    if (liveSearchInput) {
        liveSearchInput.addEventListener("keyup", function () {
            const filter = this.value.toLowerCase();
            const rows = document.querySelectorAll(".filterable-table tbody tr");
            rows.forEach(function (row) {
                const text = row.textContent.toLowerCase();
                row.style.display = text.indexOf(filter) > -1 ? "" : "none";
            });
        });
    }

    // 3. Password Confirmation Match Validation on Register Form
    const registerForm = document.getElementById("registerForm");
    if (registerForm) {
        registerForm.addEventListener("submit", function (e) {
            const pwd = document.getElementById("password").value;
            const confirmPwd = document.getElementById("confirmPassword").value;
            const errorDiv = document.getElementById("clientValidationMsg");

            if (pwd.length < 6) {
                e.preventDefault();
                if (errorDiv) {
                    errorDiv.textContent = "Password must be at least 6 characters long.";
                    errorDiv.classList.remove("d-none");
                }
                return false;
            }

            if (pwd !== confirmPwd) {
                e.preventDefault();
                if (errorDiv) {
                    errorDiv.textContent = "Passwords do not match! Please check again.";
                    errorDiv.classList.remove("d-none");
                }
                return false;
            }
        });
    }

    // 4. Incident Priority visual cue changes
    const prioritySelect = document.getElementById("incidentPrioritySelect");
    if (prioritySelect) {
        prioritySelect.addEventListener("change", function () {
            const alertBox = document.getElementById("criticalWarningBox");
            if (alertBox) {
                if (this.value === "CRITICAL" || this.value === "HIGH") {
                    alertBox.classList.remove("d-none");
                } else {
                    alertBox.classList.add("d-none");
                }
            }
        });
    }
});

/**
 * Quick Fill Demo Credentials on the Login Page for testing
 */
function fillDemoCredentials(role) {
    const emailField = document.getElementById("email");
    const passwordField = document.getElementById("password");

    if (!emailField || !passwordField) return;

    if (role === 'admin') {
        emailField.value = "admin@campus.com";
        passwordField.value = "admin123";
    } else if (role === 'staff') {
        emailField.value = "security@campus.com";
        passwordField.value = "staff123";
    } else if (role === 'medical') {
        emailField.value = "medical@campus.com";
        passwordField.value = "staff123";
    } else if (role === 'student') {
        emailField.value = "student@campus.com";
        passwordField.value = "student123";
    }
}

/**
 * Confirmation dialog for critical operations
 */
function confirmAction(message) {
    return confirm(message || "Are you sure you want to proceed with this action?");
}

/**
 * Set target incident ID and title for modals
 */
function prepareAssignModal(incidentId, incidentTitle) {
    const idInput = document.getElementById("modalIncidentId");
    const titleSpan = document.getElementById("modalIncidentTitle");
    if (idInput) idInput.value = incidentId;
    if (titleSpan) titleSpan.textContent = incidentTitle;
}
