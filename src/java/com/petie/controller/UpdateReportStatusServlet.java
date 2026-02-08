package com.petie.controller;

import com.petie.dao.StraysDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateReportStatusServlet")
public class UpdateReportStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Get ID and Status from URL (e.g., ?id=5&status=FOSTER)
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");

        if (idStr != null && status != null) {
            try {
                int reportId = Integer.parseInt(idStr);
                
                // 2. Call DAO to update
                StraysDao dao = new StraysDao();
                dao.updateReportStatus(reportId, status);
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        // 3. Redirect back to the list to see changes
        response.sendRedirect("ManageReportsServlet");
    }
}