package com.petie.dao;

import com.petie.bean.UserBean;
import com.petie.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDao {

    // 1. LOGIN (Authenticate)
    public UserBean authenticateUser(UserBean loginBean) {
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            // No IC_NUMBER in query
            String sql = "SELECT USER_ID, USERNAME, EMAIL, PASSWORD, FULL_NAME, PHONE_NUMBER, ROLE FROM USERS WHERE EMAIL = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, loginBean.getEmail());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                if (loginBean.getPassword().equals(rs.getString("PASSWORD"))) {
                    UserBean fullUser = new UserBean();
                    fullUser.setUserId(rs.getInt("USER_ID"));
                    fullUser.setUsername(rs.getString("USERNAME"));
                    fullUser.setEmail(rs.getString("EMAIL"));
                    fullUser.setPassword(rs.getString("PASSWORD"));
                    fullUser.setFullName(rs.getString("FULL_NAME"));
                    fullUser.setPhoneNumber(rs.getString("PHONE_NUMBER"));
                    fullUser.setRole(rs.getString("ROLE"));
                    return fullUser;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 2. REGISTER
    public String registerUser(UserBean user) {
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            // No IC_NUMBER in insert
            String sql = "INSERT INTO USERS (USERNAME, EMAIL, PASSWORD, FULL_NAME, PHONE_NUMBER) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getPhoneNumber());

            int i = ps.executeUpdate();
            if (i != 0) return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Registration Failed";
    }
    
    // 3. UPDATE PROFILE (This was missing!)
    public String updateUser(UserBean user) {
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            String sql = "UPDATE USERS SET FULL_NAME=?, USERNAME=?, PHONE_NUMBER=?, PASSWORD=? WHERE USER_ID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getPassword());
            ps.setInt(5, user.getUserId());

            int i = ps.executeUpdate();
            if (i != 0) return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Update Failed";
    }
}