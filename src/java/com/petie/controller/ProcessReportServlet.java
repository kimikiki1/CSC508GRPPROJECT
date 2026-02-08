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
        String id = request.getParameter("id");
        String action = request.getParameter("action");
        String newStatus = "";

        // DETERMINE NEW STATUS BASED ON ACTION
        if ("propose_centre".equals(action)) {
            newStatus = "WAITING_ADMIN_CENTRE"; // Staff -> Admin
        } else if ("propose_foster".equals(action)) {
            newStatus = "WAITING_ADMIN_FOSTER"; // Staff -> Admin
        } else if ("confirm_centre".equals(action)) {
            newStatus = "IN_CENTRE"; // Admin Final (Public can see)
        } else if ("confirm_foster".equals(action)) {
            newStatus = "FOSTERED"; // Admin Final
        } else if ("reject".equals(action)) {
            newStatus = "REJECTED"; // End of line
        }

        if (!newStatus.isEmpty()) {
            try {
                Connection con = DBConnection.createConnection();
                String sql = "UPDATE STRAY_REPORT SET STATUS = ? WHERE STRAY_ID = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, newStatus);
                ps.setInt(2, Integer.parseInt(id));
                ps.executeUpdate();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("admin_checklist.jsp");
    }
}