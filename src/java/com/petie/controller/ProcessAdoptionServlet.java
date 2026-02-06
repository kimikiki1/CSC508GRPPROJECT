package com.petie.controller;

import com.petie.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ProcessAdoptionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reqId = request.getParameter("id");
        String action = request.getParameter("action");
        
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            
            // 1. First, find out which Pet (STRAY_ID) this request is for
            int strayId = 0;
            PreparedStatement psGetId = con.prepareStatement("SELECT STRAY_ID FROM ADOPTION_REQUESTS WHERE REQUEST_ID=?");
            psGetId.setInt(1, Integer.parseInt(reqId));
            ResultSet rs = psGetId.executeQuery();
            if (rs.next()) {
                strayId = rs.getInt("STRAY_ID");
            }

            if ("approve".equals(action)) {
                // A. Mark this specific request as APPROVED
                PreparedStatement ps1 = con.prepareStatement("UPDATE ADOPTION_REQUESTS SET STATUS='APPROVED' WHERE REQUEST_ID=?");
                ps1.setInt(1, Integer.parseInt(reqId));
                ps1.executeUpdate();
                
                // B. Mark the Pet as ADOPTED (This hides it from 'Adopt Me' page)
                PreparedStatement ps2 = con.prepareStatement("UPDATE STRAY_REPORT SET STATUS='ADOPTED' WHERE STRAY_ID=?");
                ps2.setInt(1, strayId);
                ps2.executeUpdate();
                
                // C. (Optional) Auto-Reject other requests for the same pet?
                // For now, let's keep it simple.
                
            } else if ("reject".equals(action)) {
                // Just mark request as REJECTED
                PreparedStatement ps3 = con.prepareStatement("UPDATE ADOPTION_REQUESTS SET STATUS='REJECTED' WHERE REQUEST_ID=?");
                ps3.setInt(1, Integer.parseInt(reqId));
                ps3.executeUpdate();
            }
            
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
        
        response.sendRedirect("manage_adoptions.jsp");
    }
}