package com.petie.dao;

import com.petie.bean.StraysBean;
import com.petie.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class StraysDao {

    // 1. ADD REPORT (Matches STRAY_REPORT Table)
    public String addReport(StraysBean stray) {
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            // Note: STATUS uses DEFAULT (Pending) defined in the Database
            String sql = "INSERT INTO STRAY_REPORT (USER_ID, PET_TYPE, LOCATION_FOUND, PET_PHOTO, DATE_FOUND, SITUATION, STATUS) VALUES (?, ?, ?, ?, ?, ?, DEFAULT)";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setInt(1, stray.getUserId());
            ps.setString(2, stray.getPetType());
            ps.setString(3, stray.getLocationFound());
            ps.setString(4, stray.getPetPhoto());
            
            // Handle Date
            if(stray.getDateFound() == null || stray.getDateFound().isEmpty()) {
                ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            } else {
                ps.setDate(5, Date.valueOf(stray.getDateFound()));
            }
            
            ps.setString(6, stray.getSituation());

            int i = ps.executeUpdate();
            if (i != 0) return "SUCCESS";
            
        } catch (SQLException e) {
            e.printStackTrace();
            return "SQL Error: " + e.getMessage();
        } catch (Exception e) {
            e.printStackTrace();
            return "Java Error: " + e.getMessage();
        }
        return "Unknown Failure";
    }

    // 2. GET ALL REPORTS (For ManageReportsServlet)
    public List<StraysBean> getAllReports() {
        List<StraysBean> list = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            con = DBConnection.createConnection();
            
            // We join with USERS table to get the reporter's Full Name
            String sql = "SELECT r.*, u.FULL_NAME FROM STRAY_REPORT r " +
                         "JOIN USERS u ON r.USER_ID = u.USER_ID " +
                         "ORDER BY r.DATE_FOUND DESC";
            
            stmt = con.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                StraysBean bean = new StraysBean();
                
                // --- UPDATED: Use STRAY_ID ---
                bean.setStrayId(rs.getInt("STRAY_ID")); // Matches DB Column
                
                bean.setUserId(rs.getInt("USER_ID"));
                bean.setPetType(rs.getString("PET_TYPE"));
                bean.setLocationFound(rs.getString("LOCATION_FOUND"));
                bean.setPetPhoto(rs.getString("PET_PHOTO"));
                
                // Convert SQL Date to String for the Bean
                Date sqlDate = rs.getDate("DATE_FOUND");
                bean.setDateFound(sqlDate != null ? sqlDate.toString() : "");
                
                bean.setSituation(rs.getString("SITUATION"));
                bean.setStatus(rs.getString("STATUS"));
                
                // Add the reporter's name
                bean.setReporterName(rs.getString("FULL_NAME"));
                
                list.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null) rs.close(); if(stmt!=null) stmt.close(); if(con!=null) con.close(); } catch(Exception e){}
        }
        return list;
    }

    // 3. UPDATE STATUS (For Foster/Reject/Center actions)
    public boolean updateReportStatus(int strayId, String newStatus) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.createConnection();
            
            // --- UPDATED: Use STRAY_ID in WHERE clause ---
            String sql = "UPDATE STRAY_REPORT SET STATUS = ? WHERE STRAY_ID = ?";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, strayId);
            
            int i = ps.executeUpdate();
            return i > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if(ps!=null) ps.close(); if(con!=null) con.close(); } catch(Exception e){}
        }
    }
}