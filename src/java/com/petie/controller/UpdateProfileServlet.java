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

        if(user != null) {
            // Get new data from form
            user.setFullName(request.getParameter("fullname"));
            user.setUsername(request.getParameter("username"));
            user.setPhoneNumber(request.getParameter("phone"));
            user.setPassword(request.getParameter("password")); // Ensure this is handled safely in real apps

            UserDao dao = new UserDao();
            String result = dao.updateUser(user);
            
            if(result.equals("SUCCESS")) {
                session.setAttribute("userSession", user); // Update session with new data
            }
        }
        response.sendRedirect("account_settings.jsp");
    }
}