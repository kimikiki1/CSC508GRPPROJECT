// StatsBean.java
package com.petie.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.petie.util.DBConnection;

public class StatsBean {
    private int availablePets;
    private int adoptedThisMonth;
    private int reportsSubmitted;
    private int happyFamilies;
    
    public StatsBean() {
        // Default constructor
    }
    
    public StatsBean(int userId, String role) {
        fetchStatsFromDatabase(userId, role);
    }
    
    private void fetchStatsFromDatabase(int userId, String role) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.createConnection();
            
            // 1. Get available pets count - fallback to reports if no pets table
            try {
                String availablePetsQuery = "SELECT COUNT(*) FROM PETS WHERE STATUS = 'Available'";
                pstmt = conn.prepareStatement(availablePetsQuery);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    this.availablePets = rs.getInt(1);
                }
            } catch (Exception e) {
                // If PETS table doesn't exist, use STRAY_REPORT
                String fallbackQuery = "SELECT COUNT(*) FROM STRAY_REPORT WHERE STATUS = 'Open'";
                pstmt = conn.prepareStatement(fallbackQuery);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    this.availablePets = rs.getInt(1);
                }
            }
            
            // 2. Get adopted this month count
            String adoptedQuery = "SELECT COUNT(*) FROM ADOPTIONS " +
                                 "WHERE MONTH(ADOPTION_DATE) = MONTH(CURRENT_DATE) " +
                                 "AND YEAR(ADOPTION_DATE) = YEAR(CURRENT_DATE)";
            try {
                pstmt = conn.prepareStatement(adoptedQuery);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    this.adoptedThisMonth = rs.getInt(1);
                }
            } catch (Exception e) {
                // If ADOPTIONS table doesn't exist, use STRAY_REPORT
                String fallbackQuery = "SELECT COUNT(*) FROM STRAY_REPORT " +
                                     "WHERE SITUATION LIKE '%Adopted%' " +
                                     "AND MONTH(DATE_FOUND) = MONTH(CURRENT_DATE) " +
                                     "AND YEAR(DATE_FOUND) = YEAR(CURRENT_DATE)";
                pstmt = conn.prepareStatement(fallbackQuery);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    this.adoptedThisMonth = rs.getInt(1);
                }
            }
            
            // 3. Get reports submitted count (user-specific if not admin/staff)
            String reportsQuery;
            if ("ADMIN".equals(role) || "STAFF".equals(role)) {
                reportsQuery = "SELECT COUNT(*) FROM STRAY_REPORT";
                pstmt = conn.prepareStatement(reportsQuery);
            } else {
                reportsQuery = "SELECT COUNT(*) FROM STRAY_REPORT WHERE USER_ID = ?";
                pstmt = conn.prepareStatement(reportsQuery);
                pstmt.setInt(1, userId);
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                this.reportsSubmitted = rs.getInt(1);
            }
            
            // 4. Get happy families count (total successful adoptions)
            String familiesQuery = "SELECT COUNT(DISTINCT ADOPTER_ID) FROM ADOPTIONS WHERE STATUS = 'Completed'";
            try {
                pstmt = conn.prepareStatement(familiesQuery);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    this.happyFamilies = rs.getInt(1);
                }
            } catch (Exception e) {
                // If ADOPTIONS table doesn't exist, use STRAY_REPORT
                String fallbackQuery = "SELECT COUNT(*) FROM STRAY_REPORT WHERE SITUATION LIKE '%Adopted%' OR SITUATION LIKE '%Rescued%'";
                pstmt = conn.prepareStatement(fallbackQuery);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    this.happyFamilies = rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Set default values in case of error
            this.availablePets = 0;
            this.adoptedThisMonth = 0;
            this.reportsSubmitted = 0;
            this.happyFamilies = 0;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
    // Getters
    public int getAvailablePets() { 
        return availablePets > 0 ? availablePets : 0; // Default to 0
    }
    public int getAdoptedThisMonth() { 
        return adoptedThisMonth > 0 ? adoptedThisMonth : 0; // Default to 0
    }
    public int getReportsSubmitted() { 
        return reportsSubmitted > 0 ? reportsSubmitted : 0; // Default to 0
    }
    public int getHappyFamilies() { 
        return happyFamilies > 0 ? happyFamilies : 0; // Default to 0
    }
}