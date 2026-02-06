package com.petie.controller;

import com.petie.bean.UserBean;
import com.petie.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RequestAdoptionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserBean user = (UserBean) request.getSession().getAttribute("userSession");
        if(user == null) { response.sendRedirect("login.jsp"); return; }

        String strayId = request.getParameter("id");
        int uId = user.getUserId();
        int sId = Integer.parseInt(strayId);

        try {
            Connection con = DBConnection.createConnection();
            
            // 1. CHECK FOR DUPLICATE
            String checkSql = "SELECT COUNT(*) FROM ADOPTION_REQUESTS WHERE USER_ID = ? AND STRAY_ID = ?";
            PreparedStatement psCheck = con.prepareStatement(checkSql);
            psCheck.setInt(1, uId);
            psCheck.setInt(2, sId);
            ResultSet rs = psCheck.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // Already exists! Don't insert.
                con.close();
                response.sendRedirect("adopt_me.jsp?msg=duplicate");
                return;
            }

            // 2. INSERT IF NEW
            String sql = "INSERT INTO ADOPTION_REQUESTS (USER_ID, STRAY_ID) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, uId);
            ps.setInt(2, sId);
            ps.executeUpdate();
            con.close();
            
            response.sendRedirect("adopt_me.jsp?msg=success");
            
        } catch (Exception e) { e.printStackTrace(); }
    }
}