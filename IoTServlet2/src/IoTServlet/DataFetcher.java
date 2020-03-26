package IoTServlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DataFetcher")
public class DataFetcher extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public DataFetcher() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Connection conn;
		try {
			var temp = request.getParameter("temp");
			var humi = request.getParameter("humidity");
			var lumx = request.getParameter("lux");
			var fans = request.getParameter("fanSpeed");
			
			if (temp==null || humi == null || lumx== null) {
				humi="0";
				temp="0";
				lumx = "0";
			}
			if (temp != null) {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/iotproject", "root", "renn");
				PreparedStatement pq = conn.prepareStatement("Insert into temperatures values(?,?);");
				PreparedStatement pq2 = conn.prepareStatement("Insert into humidity values(?,?);");
				PreparedStatement pq3 = conn.prepareStatement("Insert into light values(?,?);");
				PreparedStatement pq4 = conn.prepareStatement("Insert into fanspeed values(?,?);");
				long timeNow = System.currentTimeMillis();
				java.sql.Timestamp ts = new java.sql.Timestamp(timeNow);
				pq.setTimestamp(1, ts);
				pq.setFloat(2, Float.parseFloat(temp));
				pq2.setTimestamp(1, ts);
				pq2.setInt(2, ((int)Float.parseFloat(humi)));
				pq3.setTimestamp(1, ts);
				pq3.setInt(2, Integer.parseInt(lumx));
				pq4.setTimestamp(1, ts);
				pq4.setInt(2, Integer.parseInt(fans));
				pq.execute();
				pq2.execute();
				pq3.execute();
				pq4.execute();
				response.getWriter().println("Temperature is " + temp + "<br />");
				response.getWriter().println("Humidity is " + humi);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
		
	}

}
