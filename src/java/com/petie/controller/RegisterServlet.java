package com.petie.controller;

import com.petie.bean.UserBean;
import com.petie.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserBean user = new UserBean();
        // REMOVED: user.setIcNumber(request.getParameter("icNumber"));
        
        user.setUsername(request.getParameter("username"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(request.getParameter("password"));
        user.setFullName(request.getParameter("fullname"));
        user.setPhoneNumber(request.getParameter("phone"));

        UserDao dao = new UserDao();
        String result = dao.registerUser(user);

        if(result.equals("SUCCESS")) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("errMessage", result);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}