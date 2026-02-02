package com.petie.controller;

import com.petie.bean.StraysBean;
import com.petie.bean.UserBean;
import com.petie.dao.StraysDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
                 maxFileSize = 1024 * 1024 * 10, 
                 maxRequestSize = 1024 * 1024 * 50)
public class ReportStrayServlet extends HttpServlet {

    // YOUR PATH (Double check this folder exists on your computer!)
    private static final String UPLOAD_DIR = "C:\\Users\\USER\\OneDrive\\Documents\\NetBeansProjects\\TRYGIT\\images";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("userSession");

        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            StraysBean stray = new StraysBean();
            stray.setUserId(user.getUserId());
            stray.setPetType(request.getParameter("petType"));
            stray.setLocationFound(request.getParameter("location"));
            stray.setDateFound(request.getParameter("dateFound"));
            stray.setSituation(request.getParameter("situation"));

            // --- NEW SAFE FILE SAVING METHOD ---
            Part filePart = request.getPart("petPhoto");
            String fileName = "no-image.jpg";

            if (filePart != null && filePart.getSize() > 0) {
                // 1. Create a unique filename
                fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
                
                // 2. Prepare the folder
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // 3. FORCE SAVE using InputStream (Bypasses GlassFish path errors)
                File file = new File(uploadDir, fileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            }
            // -----------------------------------
            
            stray.setPetPhoto(fileName); 

            StraysDao dao = new StraysDao();
            String result = dao.addReport(stray);

            if(result.equals("SUCCESS")) {
                request.setAttribute("msg", "Report Submitted Successfully!");
            } else {
                request.setAttribute("msg", "DB ERROR: " + result);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // This will show us if the path is still wrong
            request.setAttribute("msg", "SAVE ERROR: " + e.getMessage());
        }

        request.getRequestDispatcher("report_stray.jsp").forward(request, response);
    }

    // Helper method to safely get filename (Older browsers compatibility)
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return "unknown.jpg";
    }
}