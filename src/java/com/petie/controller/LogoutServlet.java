package com.petie.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;

public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }
    
    private void processLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        try {
            // 1. Log the logout activity (for auditing)
            logLogoutActivity(session, request);
            
            if (session != null) {
                // 2. Clear all session attributes one by one (optional, but thorough)
                clearSessionAttributes(session);
                
                // 3. Invalidate the session (destroys all session data)
                session.invalidate();
            }
            
            // 4. Set cache control headers to prevent back button access
            setNoCacheHeaders(response);
            
            // 5. Set secure headers for additional protection
            setSecurityHeaders(response);
            
            // 6. Create a new empty session with logout flag for login page
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("logoutMessage", "You have been successfully logged out.");
            newSession.setAttribute("logoutTime", new Date());
            
            // 7. Redirect to login page with success message
            response.sendRedirect("login.jsp?logout=success");
            
        } catch (Exception e) {
            // Log any errors but still proceed with logout
            System.err.println("Error during logout: " + e.getMessage());
            e.printStackTrace();
            
            // Still redirect to login page even if there's an error
            response.sendRedirect("login.jsp");
        }
    }
    
    /**
     * Logs the logout activity for auditing purposes
     */
    private void logLogoutActivity(HttpSession session, HttpServletRequest request) {
        if (session != null) {
            String username = (String) session.getAttribute("username");
            String userId = (String) session.getAttribute("userId");
            String ipAddress = request.getRemoteAddr();
            String userAgent = request.getHeader("User-Agent");
            
            System.out.println("=== LOGOUT ACTIVITY ===");
            System.out.println("Time: " + new Date());
            System.out.println("Username: " + (username != null ? username : "Unknown"));
            System.out.println("User ID: " + (userId != null ? userId : "Unknown"));
            System.out.println("IP Address: " + ipAddress);
            System.out.println("User Agent: " + userAgent);
            System.out.println("Session ID: " + session.getId());
            System.out.println("=======================");
            
            // In a real application, you would write this to a database or log file
            // auditDAO.logLogout(userId, ipAddress, userAgent, new Date());
        }
    }
    
    /**
     * Clears all session attributes individually
     */
    private void clearSessionAttributes(HttpSession session) {
        // Remove user-specific attributes
        session.removeAttribute("userSession");
        session.removeAttribute("username");
        session.removeAttribute("userId");
        session.removeAttribute("userRole");
        session.removeAttribute("userEmail");
        session.removeAttribute("fullName");
        
        // Remove any other custom attributes your app might have
        session.removeAttribute("lastLoginTime");
        session.removeAttribute("userPermissions");
        session.removeAttribute("cartItems"); // if you have shopping cart
        session.removeAttribute("searchFilters"); // if you have search functionality
        
        // Clear any session attributes that start with "temp_"
        java.util.Enumeration<String> attrNames = session.getAttributeNames();
        while (attrNames.hasMoreElements()) {
            String attrName = attrNames.nextElement();
            if (attrName.startsWith("temp_") || attrName.startsWith("session_")) {
                session.removeAttribute(attrName);
            }
        }
    }
    
    /**
     * Sets HTTP headers to prevent caching of sensitive pages
     */
    private void setNoCacheHeaders(HttpServletResponse response) {
        // HTTP 1.1
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, max-age=0, private");
        
        // HTTP 1.0
        response.setHeader("Pragma", "no-cache");
        
        // Proxies
        response.setDateHeader("Expires", 0);
        response.setDateHeader("Last-Modified", new Date().getTime());
        
        // Additional headers for different browsers
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-XSS-Protection", "1; mode=block");
    }
    
    /**
     * Sets additional security headers
     */
    private void setSecurityHeaders(HttpServletResponse response) {
        // Prevent clickjacking
        response.setHeader("X-Frame-Options", "DENY");
        
        // Enable XSS protection in browsers
        response.setHeader("X-XSS-Protection", "1; mode=block");
        
        // Prevent MIME type sniffing
        response.setHeader("X-Content-Type-Options", "nosniff");
        
        // Referrer policy
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        
        // Content Security Policy (basic)
        response.setHeader("Content-Security-Policy", 
            "default-src 'self'; " +
            "script-src 'self' https://cdnjs.cloudflare.com; " +
            "style-src 'self' https://cdnjs.cloudflare.com 'unsafe-inline'; " +
            "img-src 'self' data: https:; " +
            "font-src 'self' https://cdnjs.cloudflare.com;");
    }
}