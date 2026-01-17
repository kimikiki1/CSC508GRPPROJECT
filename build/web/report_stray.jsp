<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head><title>Report Stray Pet</title></head>
<body style="background-color: #87ceeb;">
    <div style="background-color: #003366; color: white; padding: 10px;">
        <a href="home.jsp" style="color:white; margin-right: 15px;">Home</a>
        <a href="LogoutServlet" style="color:white; float: right;">Log Out</a>
    </div>

    <center>
        <h2>REPORT STRAY PET</h2>
        <h3 style="color: green;">${msg}</h3>
        
        <div style="background-color: white; width: 50%; padding: 20px;">
            <form action="ReportStrayServlet" method="post" enctype="multipart/form-data">
                <table cellpadding="10">
                    <tr>
                        <td>Upload Pet Photo:</td>
                        <td><input type="file" name="petPhoto" required></td>
                    </tr>
                    <tr>
                        <td>Stray Pet Type:</td>
                        <td><input type="text" name="petType" placeholder="e.g. Cat, Dog"></td>
                    </tr>
                    <tr>
                        <td>Location Found:</td>
                        <td><input type="text" name="location"></td>
                    </tr>
                    <tr>
                        <td>Date Found:</td>
                        <td><input type="date" name="dateFound"></td>
                    </tr>
                    <tr>
                        <td>Situation:</td>
                        <td><textarea name="situation"></textarea></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit" value="SUBMIT REPORT" style="background-color: grey; color: white;">
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </center>
</body>
</html>