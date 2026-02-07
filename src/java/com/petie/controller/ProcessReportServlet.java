package com.petie.controller;

// --- CHECK THESE IMPORTS ---
import com.petie.bean.UserBean;
import com.petie.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
// ---------------------------

public class ProcessReportServlet extends HttpServlet {
    // ... rest of the code ...
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("userSession");
        
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String strayId = request.getParameter("id");
        String action = request.getParameter("action"); 
        String role = user.getRole();
        String currentStatus = request.getParameter("currentStatus"); // Needed for Admin logic

        String newStatus = "PENDING";

        // --- STAFF LOGIC (PROPOSALS) ---
        if ("STAFF".equals(role)) {
            if ("centre".equals(action)) newStatus = "WAITING_ADMIN_CENTRE"; // Propose Centre
            if ("foster".equals(action)) newStatus = "WAITING_ADMIN_FOSTER"; // Propose Foster
            if ("reject".equals(action)) newStatus = "REJECTED";             // Staff can Reject outright
        } 
        
        // --- ADMIN LOGIC (FINAL APPROVAL) ---
        else if ("ADMIN".equals(role)) {
            if ("approve".equals(action)) {
                // Check what the Staff proposed, and finalize it
                if ("WAITING_ADMIN_CENTRE".equals(currentStatus)) newStatus = "IN_CENTRE";
                else if ("WAITING_ADMIN_FOSTER".equals(currentStatus)) newStatus = "FOSTERED";
                else newStatus = "IN_CENTRE"; // Default fallback
            } 
            else if ("reject".equals(action)) {
                newStatus = "REJECTED"; // Admin overrides Staff and rejects it
            }
        }

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
        
        response.sendRedirect("admin_checklist.jsp");
    }
}