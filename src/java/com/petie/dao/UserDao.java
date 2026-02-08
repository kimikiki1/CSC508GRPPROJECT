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
            // Note: Column is FULL_NAME, not FULLNAME
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
                    fullUser.setFullName(rs.getString("FULL_NAME")); // Note: FULL_NAME
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
            // Note: Column is FULL_NAME, not FULLNAME
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
    
    // 3. UPDATE PROFILE - FIXED VERSION
    public String updateUser(UserBean user) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.createConnection();
            System.out.println("DEBUG - Updating user ID: " + user.getUserId());
            System.out.println("DEBUG - New full name: " + user.getFullName());
            System.out.println("DEBUG - New username: " + user.getUsername());
            System.out.println("DEBUG - New phone: " + user.getPhoneNumber());
            
            // FIXED: Using FULL_NAME (with underscore) to match database column
            String sql = "UPDATE USERS SET FULL_NAME = ?, USERNAME = ?, PHONE_NUMBER = ? WHERE USER_ID = ?";
            ps = con.prepareStatement(sql);
            
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getUsername());
            
            // Handle phone number (can be null)
            if (user.getPhoneNumber() != null && !user.getPhoneNumber().trim().isEmpty()) {
                ps.setString(3, user.getPhoneNumber().trim());
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
            }
            
            ps.setInt(4, user.getUserId());

            int i = ps.executeUpdate();
            System.out.println("DEBUG - Rows affected: " + i);
            
            if (i > 0) {
                return "SUCCESS";
            } else {
                return "No rows affected - user may not exist";
            }
            
        } catch (SQLException e) {
            System.err.println("SQL Error updating user: " + e.getMessage());
            e.printStackTrace();
            return "SQL Error: " + e.getMessage();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // 4. CHECK IF USERNAME EXISTS (for validation)
    public boolean checkUsernameExists(String username, int excludeUserId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.createConnection();
            String sql = "SELECT COUNT(*) FROM USERS WHERE USERNAME = ? AND USER_ID != ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setInt(2, excludeUserId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}