package com.smartcampus.controller;

import com.smartcampus.dao.IncidentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

/**
 * Controller for Admin visual reports and statistical breakdown.
 */
@WebServlet(name = "ReportsServlet", urlPatterns = {"/admin/reports"})
public class ReportsServlet extends HttpServlet {

    private IncidentDAO incidentDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, Integer> stats = incidentDAO.getStatistics();
        Map<String, Integer> byCategory = incidentDAO.getCountByField("category");
        Map<String, Integer> byPriority = incidentDAO.getCountByField("priority");
        Map<String, Integer> byStatus = incidentDAO.getCountByField("status");
        Map<String, Integer> byDept = incidentDAO.getCountByField("department");

        request.setAttribute("stats", stats);
        request.setAttribute("byCategory", byCategory);
        request.setAttribute("byPriority", byPriority);
        request.setAttribute("byStatus", byStatus);
        request.setAttribute("byDept", byDept);

        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}
