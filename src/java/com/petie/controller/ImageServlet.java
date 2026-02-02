package com.petie.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/images/*") 
public class ImageServlet extends HttpServlet {

    // --- CRITICAL FIX: THIS MUST MATCH YOUR REPORT SERVLET PATH EXACTLY ---
    private static final String UPLOAD_DIR = "C:\\Users\\USER\\OneDrive\\Documents\\NetBeansProjects\\TRYGIT\\images";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filename = request.getPathInfo();
        
        // Safety check: if no filename, return 404
        if (filename == null || filename.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Remove the leading slash "/" (e.g., "/cat.jpg" becomes "cat.jpg")
        filename = filename.substring(1);
        
        File file = new File(UPLOAD_DIR, filename);

        // Debugging: Print to GlassFish server log to see what it is looking for
        System.out.println("ImageServlet Looking for: " + file.getAbsolutePath());

        if (file.exists()) {
            // Determine content type (jpg, png, etc.)
            String mime = getServletContext().getMimeType(filename);
            if (mime == null) mime = "application/octet-stream";
            
            response.setContentType(mime);
            response.setContentLength((int) file.length());

            // Send file to browser
            try (FileInputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } else {
            // If file not found, print error to log
            System.out.println("ImageServlet ERROR: File not found!");
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}