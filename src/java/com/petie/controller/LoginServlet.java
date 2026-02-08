package com.petie.controller;

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
import java.sql.ResultSet;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.createConnection();
            
            // 2. Check Database for User
            String sql = "SELECT * FROM USERS WHERE EMAIL = ? AND PASSWORD = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password); // In a real app, hash this password!
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // 3. User Found - Create Session Bean
                UserBean user = new UserBean();
                user.setUserId(rs.getInt("USER_ID"));
                user.setUsername(rs.getString("USERNAME"));
                user.setEmail(rs.getString("EMAIL"));
                user.setFullName(rs.getString("FULL_NAME"));
                user.setPhoneNumber(rs.getString("PHONE_NUMBER"));
                user.setRole(rs.getString("ROLE")); // Critical for redirection
                
                // 4. Save to Session
                HttpSession session = request.getSession();
                session.setAttribute("userSession", user);
                
                // 5. ROLE BASED REDIRECTION (The Logic You Asked For)
                String role = user.getRole();
                
                if ("ADMIN".equals(role)) {
                    // Send Admin to their specific dashboard
                    response.sendRedirect("home.jsp");
                } 
                else if ("STAFF".equals(role)) {
                    // Send Staff to their command center
                    response.sendRedirect("home.jsp");
                } 
                else {
                    // Send Normal Users to the Home/Adopt page
                    response.sendRedirect("home.jsp");
                }
                
            } else {
                // 6. User Not Found - Error
                response.sendRedirect("login.jsp?error=Invalid email or password");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=System error: " + e.getMessage());
        } finally {
            // 7. Cleanup
            try { if(rs!=null) rs.close(); } catch(Exception e){}
            try { if(ps!=null) ps.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
    }
}