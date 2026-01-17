package com.petie.controller;

import com.petie.bean.StraysBean;
import com.petie.bean.UserBean;
import com.petie.dao.StraysDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig; // Needed for file upload
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;

@MultipartConfig // Crucial annotation for file uploads
public class ReportStrayServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("userSession");

        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        StraysBean stray = new StraysBean();
        stray.setIcNumber(user.getIcNumber());
        stray.setPetType(request.getParameter("petType"));
        stray.setLocationFound(request.getParameter("location"));
        stray.setDateFound(request.getParameter("dateFound"));
        stray.setSituation(request.getParameter("situation"));

        // File Upload Handling
        Part filePart = request.getPart("petPhoto");
        String fileName = filePart.getSubmittedFileName();
        // NOTE: In a real server, save the file to a directory and store path. 
        // For simple lab, we just store the filename string in DB.
        stray.setPetPhoto(fileName);

        StraysDao strayDao = new StraysDao();
        String result = strayDao.addReport(stray);

        if(result.equals("SUCCESS")) {
            request.setAttribute("msg", "Report Submitted Successfully!");
        } else {
            request.setAttribute("msg", "Error submitting report.");
        }
        request.getRequestDispatcher("/report_stray.jsp").forward(request, response);
    }
}