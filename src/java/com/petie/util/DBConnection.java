package com.petie.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection createConnection() {
        Connection con = null;
        String url = "jdbc:derby://localhost:1527/PetieAdoptieDB"; // Derby URL
        String username = "app";
        String password = "app";

        try {
            // Loading Derby Client Driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            con = DriverManager.getConnection(url, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}