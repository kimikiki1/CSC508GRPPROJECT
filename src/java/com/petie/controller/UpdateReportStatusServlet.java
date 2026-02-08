package com.petie.controller;

import com.petie.dao.StraysDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


public class UpdateReportStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");

        if (idStr != null && status != null) {
            try {
                int reportId = Integer.parseInt(idStr);
                
                // 1. Update the Database
                StraysDao dao = new StraysDao();
                dao.updateReportStatus(reportId, status);
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        // 2. CRITICAL FIX: Ensure this matches your JSP file name exactly!
        response.sendRedirect("manage_reports.jsp"); 
    }
}