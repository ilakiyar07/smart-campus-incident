package com.smartcampus.controller;

import com.smartcampus.dao.IncidentDAO;
import com.smartcampus.model.Incident;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Handles new incident submission by students or staff.
 */
@WebServlet(name = "ReportIncidentServlet", urlPatterns = {"/student/report-incident"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15   // 15 MB
)
public class ReportIncidentServlet extends HttpServlet {

    private IncidentDAO incidentDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/student/report-incident.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String priority = request.getParameter("priority");
        String location = request.getParameter("location");
        String incidentDate = request.getParameter("incidentDate");
        String description = request.getParameter("description");

        // Validation
        if (title == null || title.trim().isEmpty() ||
            category == null || category.trim().isEmpty() ||
            location == null || location.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Please fill in all required fields (Title, Category, Location, Description).");
            request.getRequestDispatcher("/student/report-incident.jsp").forward(request, response);
            return;
        }

        if (priority == null || priority.trim().isEmpty()) {
            priority = "MEDIUM";
        }

        if (incidentDate == null || incidentDate.trim().isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            incidentDate = sdf.format(new Date());
        }

        // Handle optional evidence file upload
        String evidencePath = null;
        try {
            Part filePart = request.getPart("evidenceFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (fileName != null && !fileName.trim().isEmpty()) {
                    String cleanName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9.-]", "_");
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + File.separator + cleanName);
                    evidencePath = "uploads/" + cleanName;
                }
            }
        } catch (Exception e) {
            System.err.println("File upload error (continuing without file): " + e.getMessage());
        }

        Incident incident = new Incident();
        incident.setReportedBy(user.getId());
        incident.setTitle(title.trim());
        incident.setCategory(category.trim());
        incident.setPriority(priority.trim());
        incident.setLocation(location.trim());
        incident.setIncidentDate(incidentDate.trim());
        incident.setDescription(description.trim());
        incident.setEvidencePath(evidencePath);

        int newId = incidentDAO.createIncident(incident);

        if (newId > 0) {
            request.getSession().setAttribute("successMessage", "Incident #" + newId + " reported successfully! Campus authorities have been alerted.");
            response.sendRedirect(request.getContextPath() + "/student/my-incidents");
        } else {
            request.setAttribute("errorMessage", "Failed to submit incident report. Please try again.");
            request.getRequestDispatcher("/student/report-incident.jsp").forward(request, response);
        }
    }
}
