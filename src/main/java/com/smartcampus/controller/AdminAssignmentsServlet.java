package com.smartcampus.controller;

import com.smartcampus.dao.AssignmentDAO;
import com.smartcampus.model.Assignment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller to list all staff incident assignments for Admin oversight.
 */
@WebServlet(name = "AdminAssignmentsServlet", urlPatterns = {"/admin/assignments"})
public class AdminAssignmentsServlet extends HttpServlet {

    private AssignmentDAO assignmentDAO;

    @Override
    public void init() {
        assignmentDAO = new AssignmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Assignment> list = assignmentDAO.getAllAssignments();
        request.setAttribute("assignments", list);
        request.getRequestDispatcher("/admin/assignments.jsp").forward(request, response);
    }
}
