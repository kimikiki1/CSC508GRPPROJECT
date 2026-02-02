<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Report Stray Pet</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #87ceeb; margin: 0; }
        .form-container { background-color: white; width: 50%; padding: 30px; margin: 50px auto; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.2); }
        h2 { color: #003366; text-align: center; }
        table { width: 100%; }
        td { padding: 10px; }
        input[type=text], input[type=date], textarea, input[type=file] { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .submit-btn { background-color: #003366; color: white; padding: 10px 20px; border: none; width: 100%; cursor: pointer; font-size: 16px; border-radius: 5px; }
        .submit-btn:hover { background-color: #002244; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="form-container">
        <h2>Report a Stray Pet</h2>
        <h4 style="color: green; text-align: center;">${msg}</h4>

        <form action="ReportStrayServlet" method="post" enctype="multipart/form-data">
            <table>
                <tr>
                    <td>Upload Photo:</td>
                    <td><input type="file" name="petPhoto" required></td>
                </tr>
                <tr>
                    <td>Pet Type:</td>
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
                    <td><textarea name="situation" placeholder="Injured? Friendly? Scared?"></textarea></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="SUBMIT REPORT" class="submit-btn">
                    </td>
                </tr>
            </table>
        </form>
    </div>

</body>
</html>