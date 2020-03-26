<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.io.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Register</title>
</head>
<body>
<h1>Registering, please wait!</h1>
	<%
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/iotproject", "root", "renn");
		PreparedStatement pq = conn.prepareStatement("INSERT INTO users values (?,?,?,?,?,?,?,?)");
		pq.setString(1, request.getParameter("fname"));
		pq.setString(2, request.getParameter("lname"));
		pq.setString(3, request.getParameter("pwd"));
		pq.setString(4, request.getParameter("email"));
		pq.setString(5, request.getParameter("phone"));
		pq.setString(6, request.getParameter("address"));
		pq.setString(8, request.getParameter("dob"));
		String female = request.getParameter("f");
		String male = request.getParameter("m");
		String gender = "F";
		if (male!=null) {
			gender="M";
		}
		pq.setString(7, gender);
		pq.execute();
		response.sendRedirect("Login");
	} catch (Exception exp) {
		out.println(exp);
	}
	%>
	
	<%= request.getParameter("fname") %>
	<%= request.getParameter("lname") %>
	<%= request.getParameter("pwd") %>
	<%= request.getParameter("email") %>
	<%= request.getParameter("phone") %>
	<%= request.getParameter("address") %>
	<%= request.getParameter("dob") %>
	
</body>
</html>