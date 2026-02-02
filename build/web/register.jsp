<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head><title>Register - Petie Adoptie</title></head>
<body style="background-color: #87ceeb; text-align: center;">
    <h1>REGISTER</h1>
    <p style="color:red">${errMessage}</p>
    
    <div style="background-color: white; width: 400px; margin: auto; padding: 20px; border-radius: 10px;">
        <form action="RegisterServlet" method="post">
            Username: <input type="text" name="username" required><br><br>
            Email: <input type="email" name="email" required><br><br>
            Password: <input type="password" name="password" required><br><br>
            Full Name: <input type="text" name="fullname" required><br><br>
            Phone: <input type="text" name="phone" required><br><br>
            <input type="submit" value="SIGN UP" style="background-color: #28a745; color: white; padding: 10px 20px; border: none;">
        </form>
        <a href="login.jsp">Already have an account? Log in</a>
    </div>
</body>
</html>