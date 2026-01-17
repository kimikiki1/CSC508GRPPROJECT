<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head><title>Login - Petie Adoptie</title></head>
<body style="background-color: #87ceeb; text-align: center;">
    <h1>LOGIN</h1>
    <p style="color:red">${errMessage}</p>
    
    <div style="background-color: white; width: 300px; margin: auto; padding: 20px; border-radius: 10px;">
        <form action="LoginServlet" method="post">
            Email: <br>
            <input type="email" name="email" required><br><br>
            Password: <br>
            <input type="password" name="password" required><br><br>
            <input type="submit" value="LOG IN" style="background-color: #28a745; color: white; padding: 10px 20px; border: none;">
        </form>
        <br>
        <a href="register.jsp">Don't have an account? Sign in here.</a>
    </div>
</body>
</html>