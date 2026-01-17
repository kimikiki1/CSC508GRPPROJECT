package com.petie.dao;

import com.petie.bean.StraysBean;
import com.petie.util.DBConnection;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class StraysDao {
    public String addReport(StraysBean strayBean) {
        Connection con = null;
        PreparedStatement statement = null;

        try {
            con = DBConnection.createConnection();
            String query = "INSERT INTO STRAY_REPORT (IC_NUMBER, PET_TYPE, LOCATION_FOUND, SITUATION, DATE_FOUND, PET_PHOTO) VALUES (?, ?, ?, ?, ?, ?)";
            statement = con.prepareStatement(query);
            
            statement.setString(1, strayBean.getIcNumber());
            statement.setString(2, strayBean.getPetType());
            statement.setString(3, strayBean.getLocationFound());
            statement.setString(4, strayBean.getSituation());
            // Converting String date to SQL Date
            statement.setDate(5, Date.valueOf(strayBean.getDateFound())); 
            statement.setString(6, strayBean.getPetPhoto());

            int result = statement.executeUpdate();
            if (result != 0) return "SUCCESS";
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Failed to submit report";
    }
}