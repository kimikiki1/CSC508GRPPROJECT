package com.petie.controller;

import com.petie.bean.UserBean;
import com.petie.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Get input (This only has Email & Password)
        UserBean tempUser = new UserBean();
        tempUser.setEmail(request.getParameter("email"));
        tempUser.setPassword(request.getParameter("password"));

        // 2. Ask DAO for the FULL User details
        UserDao dao = new UserDao();
        UserBean loggedInUser = dao.authenticateUser(tempUser); 

        // 3. Check if we got a user back
        if (loggedInUser != null) {
           HttpSession session = request.getSession();
            session.setAttribute("userSession", loggedInUser); 
            
            // REDIRECT BASED ON ROLE
            String role = loggedInUser.getRole();
            
            if ("ADMIN".equals(role)) {
                response.sendRedirect("admin_dashboard.jsp");
            } else if ("STAFF".equals(role)) {
                response.sendRedirect("staff_dashboard.jsp"); // <--- NEW LINE
            } else {
                response.sendRedirect("home.jsp");
            }
        } else {
            // FAIL
            request.setAttribute("errMessage", "Invalid email or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}