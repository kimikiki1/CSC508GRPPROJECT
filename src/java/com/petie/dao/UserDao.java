package com.petie.dao;

import com.petie.bean.UserBean;
import com.petie.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
    
    
    // 4. GET ALL USERS (For Admin Dashboard)
public List<UserBean> getAllUsers() {
    List<UserBean> users = new ArrayList<>();
    Connection con = null;
    try {
        con = DBConnection.createConnection();
        String sql = "SELECT USER_ID, USERNAME, EMAIL, FULL_NAME, PHONE_NUMBER, ROLE FROM USERS";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            UserBean user = new UserBean();
            user.setUserId(rs.getInt("USER_ID"));
            user.setUsername(rs.getString("USERNAME"));
            user.setEmail(rs.getString("EMAIL"));
            user.setFullName(rs.getString("FULL_NAME"));
            user.setPhoneNumber(rs.getString("PHONE_NUMBER"));
            user.setRole(rs.getString("ROLE"));
            users.add(user);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return users;
}

// 5. GET USER BY ID (For Edit Page)
public UserBean getUserById(int id) {
    UserBean user = null;
    try {
        Connection con = DBConnection.createConnection();
        String sql = "SELECT * FROM USERS WHERE USER_ID = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            user = new UserBean();
            user.setUserId(rs.getInt("USER_ID"));
            user.setUsername(rs.getString("USERNAME"));
            user.setEmail(rs.getString("EMAIL"));
            user.setFullName(rs.getString("FULL_NAME"));
            user.setPhoneNumber(rs.getString("PHONE_NUMBER"));
            user.setRole(rs.getString("ROLE"));
            // We usually don't fetch password for display security
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return user;
}

// 6. ADMIN UPDATE USER (Handles Role & Conditional Password)
public boolean adminUpdateUser(UserBean user) {
    Connection con = null;
    try {
        con = DBConnection.createConnection();
        
        // Check if password is empty (meaning admin didn't change it)
        boolean updatePassword = user.getPassword() != null && !user.getPassword().trim().isEmpty();
        
        String sql;
        if (updatePassword) {
            sql = "UPDATE USERS SET FULL_NAME=?, USERNAME=?, EMAIL=?, PHONE_NUMBER=?, ROLE=?, PASSWORD=? WHERE USER_ID=?";
        } else {
            sql = "UPDATE USERS SET FULL_NAME=?, USERNAME=?, EMAIL=?, PHONE_NUMBER=?, ROLE=? WHERE USER_ID=?";
        }
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getUsername());
        ps.setString(3, user.getEmail());
        ps.setString(4, user.getPhoneNumber());
        ps.setString(5, user.getRole());
        
        if (updatePassword) {
            ps.setString(6, user.getPassword());
            ps.setInt(7, user.getUserId());
        } else {
            ps.setInt(6, user.getUserId());
        }

        int i = ps.executeUpdate();
        return i > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

// 7. DELETE USER
public boolean deleteUser(int id) {
    try {
        Connection con = DBConnection.createConnection();
        String sql = "DELETE FROM USERS WHERE USER_ID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        int i = ps.executeUpdate();
        return i > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
    
}