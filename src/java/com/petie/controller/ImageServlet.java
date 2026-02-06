package com.petie.controller;

import jakarta.servlet.ServletException;
// REMOVE THIS IMPORT: import jakarta.servlet.annotation.WebServlet; 
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

// --- IMPORTANT: THE @WebServlet ANNOTATION IS REMOVED ---
// We removed it because it is already defined in web.xml.
// Keeping both causes the "same url pattern" crash.

public class ImageServlet extends HttpServlet {

    // Your OneDrive Path
    private static final String UPLOAD_DIR = "C:\\Users\\USER\\OneDrive\\Documents\\GitHub\\CSC508GRPPROJECT\\images";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filename = request.getPathInfo();
        
        if (filename == null || filename.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        filename = filename.substring(1);
        File file = new File(UPLOAD_DIR, filename);

        if (file.exists()) {
            String mime = getServletContext().getMimeType(filename);
            if (mime == null) mime = "application/octet-stream";
            
            response.setContentType(mime);
            response.setContentLength((int) file.length());

            try (FileInputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}