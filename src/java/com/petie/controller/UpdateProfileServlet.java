package com.petie.controller;

import com.petie.bean.UserBean;
import com.petie.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("userSession");

        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get current user ID
            int userId = user.getUserId();
            
            // Get new data from form
            String fullName = request.getParameter("fullname");
            String username = request.getParameter("username");
            String phoneNumber = request.getParameter("phone");
            
            // Debug: Print received parameters
            System.out.println("DEBUG - Received parameters:");
            System.out.println("User ID: " + userId);
            System.out.println("Full Name: " + fullName);
            System.out.println("Username: " + username);
            System.out.println("Phone: " + phoneNumber);
            
            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty()) {
                session.setAttribute("error", "Full name is required");
                response.sendRedirect("account_settings.jsp");
                return;
            }
            
            if (username == null || username.trim().isEmpty()) {
                session.setAttribute("error", "Username is required");
                response.sendRedirect("account_settings.jsp");
                return;
            }
            
            // Update the user object
            user.setFullName(fullName);
            user.setUsername(username);
            user.setPhoneNumber(phoneNumber);
            
            // Update in database
            UserDao dao = new UserDao();
            String result = dao.updateUser(user);
            
            System.out.println("DEBUG - Update result: " + result);
            
            if(result.equals("SUCCESS")) {
                // Update session with new data
                session.setAttribute("userSession", user);
                session.setAttribute("msg", "Profile updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update profile. Please try again.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error updating profile: " + e.getMessage());
        }
        
        response.sendRedirect("account_settings.jsp");
    }
}