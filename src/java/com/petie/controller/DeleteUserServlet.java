package com.petie.controller;

import com.petie.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("id");
        
        if(userId != null) {
            try {
                Connection con = DBConnection.createConnection();
                // We delete related records first if necessary, or just the user if you have cascading delete setup
                // For safety, let's just delete the user.
                String sql = "DELETE FROM USERS WHERE USER_ID = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(userId));
                ps.executeUpdate();
                con.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        }
        // Redirect back to the management page
        response.sendRedirect("manage_users.jsp");
    }
}