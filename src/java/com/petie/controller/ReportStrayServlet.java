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
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ReportStrayServlet extends HttpServlet {

    // YOUR PATH (This matches your GitHub/OneDrive setup)
    private static final String UPLOAD_DIR = "C:\\Users\\USER\\OneDrive\\Documents\\GitHub\\CSC508GRPPROJECT\\images";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("userSession");

        // 1. Security Check
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 2. Create Bean and Populate Data
            StraysBean stray = new StraysBean();
            stray.setUserId(user.getUserId());
            stray.setPetType(request.getParameter("petType"));
            stray.setLocationFound(request.getParameter("location"));
            
            // Handle Date (Ensure your Bean has setDateFound accepting String, or convert to java.sql.Date)
            String dateStr = request.getParameter("dateFound");
            if(dateStr != null && !dateStr.isEmpty()) {
                stray.setDateFound(java.sql.Date.valueOf(dateStr)); 
            } else {
                stray.setDateFound(new java.sql.Date(System.currentTimeMillis()));
            }
            
            stray.setSituation(request.getParameter("situation"));
            stray.setStatus("PENDING"); // Default status

            // 3. FILE UPLOAD HANDLING
            Part filePart = request.getPart("petPhoto");
            String fileName = "no-image.jpg";

            if (filePart != null && filePart.getSize() > 0) {
                // A. Generate Unique Filename to prevent overwriting
                String originalName = getSubmittedFileName(filePart);
                fileName = System.currentTimeMillis() + "_" + originalName;
                
                // B. Create Directory if missing
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // C. Save File using NIO (More robust for OneDrive paths)
                File file = new File(uploadDir, fileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            }
            
            stray.setPetPhoto(fileName); 

            // 4. Save to Database
            StraysDao dao = new StraysDao();
            String result = dao.addReport(stray); // Ensure your DAO has this method!

            if ("SUCCESS".equals(result)) {
                // Success - Redirect with message
                String msg = URLEncoder.encode("Report submitted successfully!", "UTF-8");
                response.sendRedirect("report_stray.jsp?msg=" + msg);
            } else {
                // DB Failure
                String err = URLEncoder.encode("Database Error: " + result, "UTF-8");
                response.sendRedirect("report_stray.jsp?error=" + err);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // System/IO Failure
            String err = URLEncoder.encode("System Error: " + e.getMessage(), "UTF-8");
            response.sendRedirect("report_stray.jsp?error=" + err);
        }
    }

    // Helper method to safely extract filename
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