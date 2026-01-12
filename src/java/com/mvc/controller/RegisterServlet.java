package com.mvc.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.mvc.bean.RegisterBean;
import com.mvc.dao.RegisterDao;

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // Fetching data from Register.jsp
        String name = request.getParameter("userName");
        String email = request.getParameter("userEmail");
        String pass = request.getParameter("userPass");
        String role = request.getParameter("userRole"); // e.g., 'Worker' or 'User'

        RegisterBean registerBean = new RegisterBean();
        registerBean.setUserName(name);
        registerBean.setUserEmail(email);
        registerBean.setUserPass(pass);
        registerBean.setUserRole(role);

        RegisterDao registerDao = new RegisterDao();
        String userRegistered = registerDao.registerUser(registerBean);

        if(userRegistered.equals("SUCCESS")) {
            request.setAttribute("errMessage", "Registration Successful! Please Login.");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
        } else {
            request.setAttribute("errMessage", userRegistered);
            request.getRequestDispatcher("/Register.jsp").forward(request, response);
        }
    }
}