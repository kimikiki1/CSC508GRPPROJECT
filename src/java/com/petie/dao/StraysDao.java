package com.petie.dao;

import com.petie.bean.StraysBean;
import com.petie.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StraysDao {

    // 1. ADD REPORT
    public String addReport(StraysBean stray) {
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            // Ensure these match your DB schema exactly:
            String sql = "INSERT INTO STRAY_REPORT (USER_ID, PET_TYPE, LOCATION_FOUND, PET_PHOTO, DATE_FOUND, SITUATION, STATUS) VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setInt(1, stray.getUserId());
            ps.setString(2, stray.getPetType());
            ps.setString(3, stray.getLocationFound());
            ps.setString(4, stray.getPetPhoto());
            
            // Handle Date
            if(stray.getDateFound() == null) {
                ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            } else {
                ps.setDate(5, stray.getDateFound());
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
        } finally {
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
        return "Unknown Failure";
    }

    // 2. GET ALL REPORTS
    public List<StraysBean> getAllReports() {
        List<StraysBean> list = new ArrayList<>();
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            
            // JOIN to get Reporter Name
            String sql = "SELECT r.*, u.FULL_NAME FROM STRAY_REPORT r " +
                         "JOIN USERS u ON r.USER_ID = u.USER_ID " +
                         "ORDER BY r.DATE_FOUND DESC";
            
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                StraysBean bean = new StraysBean();
                bean.setStrayId(rs.getInt("STRAY_ID"));
                bean.setUserId(rs.getInt("USER_ID"));
                bean.setPetType(rs.getString("PET_TYPE"));
                bean.setLocationFound(rs.getString("LOCATION_FOUND"));
                bean.setPetPhoto(rs.getString("PET_PHOTO"));
                bean.setDateFound(rs.getDate("DATE_FOUND")); // Direct Date set
                bean.setSituation(rs.getString("SITUATION"));
                bean.setStatus(rs.getString("STATUS"));
                bean.setReporterName(rs.getString("FULL_NAME"));
                
                list.add(bean);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
        return list;
    }
    // 3. UPDATE REPORT STATUS
    public boolean updateReportStatus(int strayId, String newStatus) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.createConnection();
            String sql = "UPDATE STRAY_REPORT SET STATUS = ? WHERE STRAY_ID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, strayId);
            
            int i = ps.executeUpdate();
            return i > 0; // Returns true if successful
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if(ps!=null) ps.close(); if(con!=null) con.close(); } catch(Exception e){}
        }
    }
    
}