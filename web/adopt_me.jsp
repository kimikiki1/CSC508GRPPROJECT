<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Adopt Me - Find a Friend</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; }
        .gallery { display: flex; flex-wrap: wrap; justify-content: center; padding: 20px; }
        .pet-card { 
            background: white; width: 300px; margin: 15px; border-radius: 10px; 
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); overflow: hidden; 
            transition: transform 0.3s;
        }
        .pet-card:hover { transform: translateY(-5px); }
        .pet-img { width: 100%; height: 200px; object-fit: cover; background-color: #ddd; }
        .pet-info { padding: 15px; }
        .pet-name { font-size: 20px; font-weight: bold; color: #003366; }
        .pet-details { color: #555; font-size: 14px; margin: 5px 0; }
        .adopt-btn { display: block; width: 100%; padding: 10px; background-color: #28a745; color: white; text-align: center; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <h1 style="text-align:center; margin-top: 30px; color: #003366;">Find Your New Best Friend 🐶🐱</h1>

    <div class="gallery">
        <%
            Connection con = null;
            try {
                con = DBConnection.createConnection();
                // Select all reports
                String sql = "SELECT * FROM STRAY_REPORT"; 
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                while(rs.next()) {
                    String type = rs.getString("PET_TYPE");
                    String location = rs.getString("LOCATION_FOUND");
                    String situation = rs.getString("SITUATION");
                    String date = rs.getString("DATE_FOUND");
                    String photo = rs.getString("PET_PHOTO"); 
        %>
            <div class="pet-card">
                <img src="images/<%= photo %>" class="pet-img" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                
                <div class="pet-info">
                    <div class="pet-name"><%= type %></div>
                    <div class="pet-details">📍 Location: <%= location %></div>
                    <div class="pet-details">📅 Found: <%= date %></div>
                    <div class="pet-details">📝 Situation: <%= situation %></div>
                </div>
                <a href="#" class="adopt-btn" onclick="alert('Adoption request sent for this <%= type %>!')">Adopt Me</a>
            </div>
        <%
                }
                con.close();
            } catch (Exception e) {
                out.println("<p>Error loading pets: " + e.getMessage() + "</p>");
            }
        %>
    </div>

</body>
</html>