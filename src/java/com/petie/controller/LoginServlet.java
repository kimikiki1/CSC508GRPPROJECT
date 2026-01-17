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
        UserBean loginBean = new UserBean();
        loginBean.setEmail(request.getParameter("email"));
        loginBean.setPassword(request.getParameter("password"));

        UserDao loginDao = new UserDao();
        String validate = loginDao.authenticateUser(loginBean);

        if (validate.equals("SUCCESS")) {
            HttpSession session = request.getSession();
            session.setAttribute("userSession", loginBean); // Store entire bean in session
            session.setAttribute("role", loginBean.getRole());

            if (loginBean.getRole().equals("ADMIN")) {
                request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/home.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errMessage", validate);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}