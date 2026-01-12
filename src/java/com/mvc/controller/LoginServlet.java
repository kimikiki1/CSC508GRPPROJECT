package com.mvc.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // For session management
import com.mvc.bean.LoginBean;
import com.mvc.dao.LoginDao;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String email = request.getParameter("userEmail"); // Using email as login ID
        String password = request.getParameter("userPass");

        LoginBean loginBean = new LoginBean();
        loginBean.setUserEmail(email);
        loginBean.setUserPass(password);

        LoginDao loginDao = new LoginDao();
        String userValidate = loginDao.authenticateUser(loginBean);

        if(userValidate.equals("SUCCESS")) {
            // Create a session to keep user logged in
            HttpSession session = request.getSession();
            session.setAttribute("userEmail", email); 
            
            request.getRequestDispatcher("/Home.jsp").forward(request, response);
        } else {
            request.setAttribute("errMessage", userValidate);
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
        }
    }
}