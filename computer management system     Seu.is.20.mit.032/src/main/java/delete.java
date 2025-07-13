

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class delete
 */
@WebServlet("/delete")
public class delete extends HttpServlet {
	private static final long serialVersionUID = 1L;
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    // Retrieve the 'id' parameter from the request
	    String id = request.getParameter("id");

	    // Database connection details
	    String url = "jdbc:mysql://localhost:3307/stuff"; // Changed to stuff database
	    String user = "root";
	    String password = "kushi";

	    // Check if 'id' is provided
	    if (id != null && !id.isEmpty()) {
	        try (Connection conn = DriverManager.getConnection(url, user, password)) {
	            // SQL query to delete record from items table based on 'id'
	            String sql = "DELETE FROM items WHERE id = ?";
	            PreparedStatement pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, Integer.parseInt(id));

	            int result = pstmt.executeUpdate();

	            if (result > 0) {
	                response.sendRedirect("index.jsp?msg=Item deleted successfully");
	            } else {
	                response.getWriter().println("Failed to delete item.");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.getWriter().println("Error: " + e.getMessage());
	        }
	    } else {
	        response.getWriter().println("Invalid or missing item ID.");
	    }
	}
}
