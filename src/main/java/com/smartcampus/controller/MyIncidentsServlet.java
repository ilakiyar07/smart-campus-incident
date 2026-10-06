package com.smartcampus.controller;

import com.smartcampus.dao.IncidentDAO;
import com.smartcampus.model.Incident;
import com.smartcampus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Lists incidents reported by the logged-in student with status filter pills.
 */
@WebServlet(name = "MyIncidentsServlet", urlPatterns = {"/student/my-incidents"})
public class MyIncidentsServlet extends HttpServlet {

    private IncidentDAO incidentDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String statusFilter = request.getParameter("status");
        List<Incident> list = incidentDAO.getIncidentsByReporter(user.getId(), statusFilter);

        request.setAttribute("incidents", list);
        request.setAttribute("currentFilter", statusFilter != null ? statusFilter : "ALL");

        request.getRequestDispatcher("/student/my-incidents.jsp").forward(request, response);
    }
}
