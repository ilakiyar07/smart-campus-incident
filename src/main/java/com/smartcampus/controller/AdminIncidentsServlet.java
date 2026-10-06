package com.smartcampus.controller;

import com.smartcampus.dao.IncidentDAO;
import com.smartcampus.dao.UserDAO;
import com.smartcampus.model.Incident;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Admin to browse, filter, search, and manage all campus incidents.
 */
@WebServlet(name = "AdminIncidentsServlet", urlPatterns = {"/admin/incidents"})
public class AdminIncidentsServlet extends HttpServlet {

    private IncidentDAO incidentDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String category = request.getParameter("category");
        String priority = request.getParameter("priority");
        String status = request.getParameter("status");
        String search = request.getParameter("search");

        List<Incident> list = incidentDAO.getAllIncidents(category, priority, status, search);
        List<User> staffList = userDAO.getUsersByRole("STAFF");

        request.setAttribute("incidents", list);
        request.setAttribute("staffList", staffList);
        request.setAttribute("selectedCategory", category != null ? category : "ALL");
        request.setAttribute("selectedPriority", priority != null ? priority : "ALL");
        request.setAttribute("selectedStatus", status != null ? status : "ALL");
        request.setAttribute("searchQuery", search != null ? search : "");

        request.getRequestDispatcher("/admin/incidents.jsp").forward(request, response);
    }
}
