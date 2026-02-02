package com.petie.dao;

import com.petie.bean.StraysBean;
import com.petie.util.DBConnection;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class StraysDao {
    public String addReport(StraysBean stray) {
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            String sql = "INSERT INTO STRAY_REPORT (USER_ID, PET_TYPE, LOCATION_FOUND, PET_PHOTO, DATE_FOUND, SITUATION) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setInt(1, stray.getUserId());
            ps.setString(2, stray.getPetType());
            ps.setString(3, stray.getLocationFound());
            ps.setString(4, stray.getPetPhoto());
            
            // Handle Date
            if(stray.getDateFound() == null || stray.getDateFound().isEmpty()) {
                ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            } else {
                // This converts the HTML date (yyyy-mm-dd) to SQL Date
                ps.setDate(5, Date.valueOf(stray.getDateFound()));
            }
            
            ps.setString(6, stray.getSituation());

            int i = ps.executeUpdate();
            if (i != 0) return "SUCCESS";
            
        } catch (SQLException e) {
            e.printStackTrace();
            return "SQL Error: " + e.getMessage(); // Return the exact SQL error
        } catch (Exception e) {
            e.printStackTrace();
            return "Java Error: " + e.getMessage();
        }
        return "Unknown Failure";
    }
}