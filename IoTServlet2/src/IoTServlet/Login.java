package IoTServlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Login() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String formHtml = "<html><head>"
				+ "<link rel=\"stylesheet\" href=\"https://rsms.me/inter/inter.css\">"
				+ "<style> *{ font-family: Inter; } </style>"
				+ "<title>Login</title></head>"
				+ "<body style=\"position: relative; width: 100%; height: 100%;\">"
				+ "<div style=\"position: absolute; left: 50%; top: 50%; border: 1px solid #000; border-radius: 2px;"
				+ "padding: 5px 15px;"
				+ "transform: translate(-50%, -50%);\"><h1>Login!</h1>"
				+ "<form method=\"post\">"
				+ "Username:<input type=\"text\" name=\"UName\"> <br/>"
				+ "Password: <input type=\"password\" name=\"Password\"><br/>" + "<input type=\"submit\">"
				+ "</form></div></body></html>";
		response.getWriter().println(formHtml);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		boolean loggedIn = false;
		Connection conn;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/iotproject","root","renn");
			java.sql.Statement st = conn.createStatement();
			var uName = request.getParameter("UName");
			var pwd = request.getParameter("Password");
			java.sql.ResultSet rs = st.executeQuery("Select * from users WHERE FirstName=\"" 
					+ uName + "\" AND Password=\"" + pwd + "\";");
			while (rs.next()) {
				if (rs.getString(1).equals(uName) && rs.getString(3).equals(pwd)) {
					loggedIn = true;
					response.getWriter().println("Logged in!");
					Cookie cook = new Cookie("username", uName);
					response.addCookie(cook);
					response.sendRedirect("Dashboard.jsp");
				} 
			}
			if (!loggedIn) {
				response.getWriter().println("<script> alert('Invalid Username and/or Password'); </script>");
				doGet(request, response);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
