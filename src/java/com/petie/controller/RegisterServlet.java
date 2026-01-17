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
        UserBean userBean = new UserBean();
        userBean.setIcNumber(request.getParameter("icNumber"));
        userBean.setUsername(request.getParameter("username"));
        userBean.setEmail(request.getParameter("email"));
        userBean.setPassword(request.getParameter("password"));
        userBean.setFullName(request.getParameter("fullname"));
        userBean.setPhoneNumber(request.getParameter("phone"));

        UserDao userDao = new UserDao();
        String result = userDao.registerUser(userBean);

        if (result.equals("SUCCESS")) {
            request.setAttribute("errMessage", "Registration Successful! Please Login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errMessage", result);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}