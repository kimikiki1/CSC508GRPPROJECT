package com.petie.controller;

import com.petie.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class UpdateUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        
        try {
            Connection con = DBConnection.createConnection();
            String sql = "UPDATE USERS SET FULL_NAME=?, USERNAME=?, EMAIL=?, PHONE_NUMBER=?, ROLE=? WHERE USER_ID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, username);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, role);
            ps.setInt(6, Integer.parseInt(id));
            
            ps.executeUpdate();
            con.close();
            
            // Success! Go back to list
            response.sendRedirect("manage_users.jsp?msg=updated");
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit_user.jsp?id=" + id + "&error=true");
        }
    }
}