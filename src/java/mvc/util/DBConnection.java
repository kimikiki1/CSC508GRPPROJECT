/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mvc.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection createConnection() {
        Connection con = null;
        String url = "jdbc:mysql://localhost:3306/petieadoptie"; // Ensure database name is 'customers'
        String username = "root";
        String password = ""; // LEAVE EMPTY for XAMPP

        try {
            // 1. Load the new driver for Connector/J 9.x
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            
            // 2. Establish connection
            con = DriverManager.getConnection(url, username, password);
            
        } catch (Exception e) {
            // This prints the REAL error to your NetBeans output window
            e.printStackTrace(); 
        }
        return con;
    }
}

