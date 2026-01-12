package com.mvc.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); // Fetch session if it exists
        
        if(session != null) {
            session.invalidate(); // Destroys the session
        }
        
        request.setAttribute("errMessage", "You have logged out successfully");
        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }
}