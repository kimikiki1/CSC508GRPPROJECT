package com.petie.controller;

import com.petie.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("id");

        if (userIdStr != null) {
            Connection con = null;
            try {
                con = DBConnection.createConnection();
                int userId = Integer.parseInt(userIdStr);

                // --- 1. DELETE USER'S ADOPTION REQUESTS FIRST ---
                String sql1 = "DELETE FROM ADOPTION_REQUESTS WHERE USER_ID = ?";
                PreparedStatement ps1 = con.prepareStatement(sql1);
                ps1.setInt(1, userId);
                ps1.executeUpdate();
                ps1.close();

                // --- 2. DELETE USER'S STRAY REPORTS SECOND ---
                String sql2 = "DELETE FROM STRAY_REPORT WHERE USER_ID = ?";
                PreparedStatement ps2 = con.prepareStatement(sql2);
                ps2.setInt(1, userId);
                ps2.executeUpdate();
                ps2.close();

                // --- 3. FINALLY, DELETE THE USER ---
                String sql3 = "DELETE FROM USERS WHERE USER_ID = ?";
                PreparedStatement ps3 = con.prepareStatement(sql3);
                ps3.setInt(1, userId);
                ps3.executeUpdate();
                ps3.close();
                
            } catch (Exception e) {
                e.printStackTrace(); // Check your server logs if it still fails
            } finally {
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        }

        // Redirect back to the list
        response.sendRedirect("manage_users.jsp");
    }
}