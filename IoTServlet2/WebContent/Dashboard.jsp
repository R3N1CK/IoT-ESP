<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.sql.*"%>
<%! String username = ""; 
    	String admin = "Admin";
    	%>
<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@300;400;500&display=swap" rel="stylesheet">
<style>

* {
	font-family: Rubik, sans;
}
td {
	border: 1px solid black;
	padding: 1px;
	text-align: center;
}

table {
	border: 1px solid black;
	border-collapse: collapse;
	display: flex;
	align-self: center;
	justify-self: center;
}

section.cards {
	width: 90%;
	max-width: 1240px;
	margin: 0 auto;
	display: grid;
	grid-template-rows: auto;
	grid-gap: 2rem;
	grid-column-gap: 1rem;
	grid-row-gap: 2.5rem;
	grid-template-columns: 1fr 1fr 1fr 1fr;
	height: 200px;
	padding-bottom: 50px;
}

.cards .card {
	background: white;
	max-width: 400px;
	text-decoration: none;
	color: #444;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
	display: flex;
	flex-direction: column;
	min-height: 100%;
	height: auto;
	padding: 0.75rem;
	transition: 500ms ease;
	color: #444;
	border-bottom: 4rem;
	align-items: center;
}
</style>
<% 
		boolean found = false;
		Cookie[] cooki = request.getCookies();
		if (cooki == null) response.sendRedirect("Login");
		else {
		for (Cookie coo: cooki) {
			if (coo.getName().equals("username")) {
				found = true;
				username = coo.getValue();
				break;
			}
		} if (!found) {
			response.sendRedirect("Login");
		}
		}
	%>
<meta charset="ISO-8859-1">
<title>DashBoard <%= (username.equals("Admin"))? " - Admin" : "" %></title>
</head>
<body>
	<% if (username.equals("Admin")) { %>
	<div style="display: flex; flex-direction: column;">
		<h2>Hello, Administrator!</h2>
		<%
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/iotproject", "root", "renn");
		java.sql.Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery("Select * from users;");%>
		<table>
			<tr>
				<td style="font-weight: 600">First Name</td>
				<td style="font-weight: 600">Last Name</td>
				<td style="font-weight: 600">Email</td>
				<td style="font-weight: 600">Phone</td>
				<td style="font-weight: 600">Address</td>
				<td style="font-weight: 600">Gender</td>
				<td style="font-weight: 600">Date of Birth</td>
			</tr>
			<%while (rs.next()) { %>
			<tr>
				<td><%= rs.getString(1) %></td>
				<td><%= rs.getString(2) %></td>
				<td><%= rs.getString(4) %></td>
				<td><%= rs.getString(5) %></td>
				<td><%= rs.getString(6) %></td>
				<td><%= rs.getString(7) %></td>
				<td><%= rs.getString(8) %></td>
			</tr>
			<% } %>
		</table>
	</div>
	<% } else { %>
	<div style="width: 100vw; display: flex; flex-direction: column;">
		<h2>
			Hello,
			<%= username %>!
		</h2>
		<div style="display: flex; justify-self: center; align-self: center; padding-bottom: 30px;">
			<form action="Dashboard.jsp" method="Post">
				Select Latest <input type="text" name="vals"> Values. &nbsp;
				&nbsp; <input type="submit" value="Go">
			</form>
		</div>
		<%
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/iotproject", "root", "renn");
		Statement st = conn.createStatement();
		Statement st2 = conn.createStatement();
		String dynamicQuery = "Select temperatures.Time, Temperature, humidity.humidity"
				+ ", light.light, fanspeed.Fanspeed from temperatures INNER JOIN humidity,light,fanspeed WHERE "
				+ "temperatures.Time = humidity.Time AND temperatures.Time = light.Time AND "
				+ "temperatures.Time = fanspeed.Time ORDER BY temperatures.Time DESC LIMIT 1";
		ResultSet rs2 = st2.executeQuery(dynamicQuery);
		rs2.next();%>
		<section class="cards">
			<div class="card">
				<h4>Temperature</h4>
				<h2><%= rs2.getFloat(2) %></h2>
			</div>
			<div class="card">
				<h4>Humidity</h4>
				<h2><%= rs2.getFloat(3) %></h2>
			</div>
			<div class="card">
				<h4>Brightness</h4>
				<h2><%= rs2.getInt(4) %></h2>
			</div>
			<div class="card">
				<h4>Fan Speed</h4>
				<h2><%= rs2.getInt(5) %></h2>
			</div>
		</section>
		<% String query = "Select temperatures.Time, Temperature, humidity.humidity"
				+ ", light.light, fanspeed.Fanspeed from temperatures INNER JOIN humidity,light,fanspeed WHERE "
				+ "temperatures.Time = humidity.Time AND temperatures.Time = light.Time AND "
				+ "temperatures.Time = fanspeed.Time";
		if (request.getParameter("vals")!=null) {
			query += " ORDER BY temperatures.Time DESC LIMIT " + request.getParameter("vals") + ";";
		} else {
			query += ";";
		}
		ResultSet rs = st.executeQuery(query);%>
		<table>
			<tr>
				<td style="font-weight: 600">Time</td>
				<td style="font-weight: 600">Temperature</td>
				<td style="font-weight: 600">Humidity</td>
				<td style="font-weight: 600">Luminous Intensity</td>
				<td style="font-weight: 600">Fan Speed</td>
			</tr>
			<%while (rs.next()) { %>
			<tr>
				<td><%= rs.getTimestamp(1) %></td>
				<td><%= rs.getFloat(2) %></td>
				<td><%= rs.getFloat(3) %></td>
				<td><%= rs.getInt(4) %></td>
				<td><%= rs.getInt(5) %></td>
			</tr>
			<% } %>
		</table>

	</div>
	<% } %>
</body>
</html>