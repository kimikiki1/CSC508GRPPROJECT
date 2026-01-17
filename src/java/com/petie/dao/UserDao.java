package com.petie.dao;

import com.petie.bean.UserBean;
import com.petie.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDao {

    public String authenticateUser(UserBean loginBean) {
        String email = loginBean.getEmail();
        String password = loginBean.getPassword();

        Connection con = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        String emailDB = "";
        String passwordDB = "";
        String roleDB = "";
        int idDB = 0; // New variable for ID

        try {
            con = DBConnection.createConnection();
            // Fetch USER_ID as well
            statement = con.prepareStatement("SELECT USER_ID, EMAIL, PASSWORD, ROLE FROM USERS WHERE EMAIL = ?");
            statement.setString(1, email);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                emailDB = resultSet.getString("EMAIL");
                passwordDB = resultSet.getString("PASSWORD");
                roleDB = resultSet.getString("ROLE");
                idDB = resultSet.getInt("USER_ID"); // Get the ID

                if (email.equals(emailDB) && password.equals(passwordDB)) {
                    // Update bean with ID and Role
                    loginBean.setUserId(idDB);
                    loginBean.setRole(roleDB);
                    return "SUCCESS";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Invalid email or password";
    }

    public String registerUser(UserBean registerBean) {
        // We get everything EXCEPT the ID (Database creates ID)
        String icNumber = registerBean.getIcNumber();
        String email = registerBean.getEmail();
        String username = registerBean.getUsername();
        String password = registerBean.getPassword();
        String fullName = registerBean.getFullName();
        String phone = registerBean.getPhoneNumber();

        Connection con = null;
        PreparedStatement statement = null;

        try {
            con = DBConnection.createConnection();
            // REMOVED "USER_ID" from insert. Added "IC_NUMBER" as regular data.
            String query = "INSERT INTO USERS (IC_NUMBER, USERNAME, EMAIL, PASSWORD, FULL_NAME, PHONE_NUMBER) VALUES (?, ?, ?, ?, ?, ?)";
            
            statement = con.prepareStatement(query);
            statement.setString(1, icNumber);
            statement.setString(2, username);
            statement.setString(3, email);
            statement.setString(4, password);
            statement.setString(5, fullName);
            statement.setString(6, phone);

            int result = statement.executeUpdate();
            if (result != 0) {
                return "SUCCESS";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Registration Failed (Email might exist)";
    }
}