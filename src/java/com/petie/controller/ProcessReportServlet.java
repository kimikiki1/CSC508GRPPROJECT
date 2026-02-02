package com.petie.controller;

import com.petie.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class ProcessReportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String strayId = request.getParameter("id");
        String action = request.getParameter("action"); // "approve" or "reject"
        
        String newStatus = "PENDING";
        if("approve".equals(action)) newStatus = "APPROVED";
        if("reject".equals(action)) newStatus = "REJECTED";

        try {
            Connection con = DBConnection.createConnection();
            String sql = "UPDATE STRAY_REPORT SET STATUS = ? WHERE STRAY_ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, Integer.parseInt(strayId));
            ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Send them back to the list
        response.sendRedirect("admin_checklist.jsp");
    }
}