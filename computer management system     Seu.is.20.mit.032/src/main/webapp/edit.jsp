<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Bootstrap and Font Awesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  
  <title>Computer Management System</title>
  <style>
    /* Fullscreen background image with blue tones */
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      
      background-size: cover;
      background-position: center;
      background-attachment: fixed;
      color: #ffffff;
    }

    /* Gradient overlay with blue tones */
    .overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(to bottom right, rgba(0, 74, 173, 0.7), rgba(0, 43, 88, 0.7));
    }

    /* Navbar with a blue color scheme */
    .navbar {
      background-color: #0056b3; /* Deep blue */
    }

    /* Content container with semi-transparent background */
    .content-container {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
      padding: 30px;
      background-color: rgba(0, 43, 88, 0.9); /* Dark blue overlay */
      border-radius: 15px;
      width: 80%;
      max-width: 800px;
    }

    /* Form styling with blue buttons */
    .form-container {
      width: 100%;
      max-width: 600px;
      margin: 0 auto;
    }

    .btn-success {
      background-color: #0069d9; /* Blue tone */
      border-color: #0056b3;
      width: 100%;
      margin-top: 15px;
    }

    .btn-success:hover {
      background-color: #0056b3;
      border-color: #004085;
    }

    .btn-danger {
      background-color: #dc3545; /* Red for contrast */
      border-color: #c82333;
      margin-top: 10px;
      width: 100%;
    }

    .btn-danger:hover {
      background-color: #c82333;
      border-color: #bd2130;
    }
  </style>
</head>
<body>
  <div class="overlay"></div>

  <!-- Navigation bar -->
  <nav class="navbar navbar-light justify-content-center fs-3 mb-5 text-light">
    	Computer Management System
  </nav>

  <!-- Content Container -->
  <div class="container content-container">
    <div class="text-center mb-4">
      <h3>Edit Item Information</h3>
      <p class="text-muted">Click update after changing any information</p>
    </div>

    <%
      String id = request.getParameter("id");
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      
      String name = "";
      String brand = "";
      boolean available = false;
      String status = "";

      // Database connection details
      String url = "jdbc:mysql://localhost:3307/stuff";  // Change to your database URL
      String user = "root";  // Your database username
      String password = "kushi";  // Your database password

      try {
          Class.forName("com.mysql.cj.jdbc.Driver");

          conn = DriverManager.getConnection(url, user, password);

          if (request.getMethod().equalsIgnoreCase("GET")) {
              String selectSQL = "SELECT * FROM items WHERE id = ?";
              pstmt = conn.prepareStatement(selectSQL);
              pstmt.setInt(1, Integer.parseInt(id));
              rs = pstmt.executeQuery();

              if (rs.next()) {
                  name = rs.getString("name");
                  brand = rs.getString("brand");
                  available = rs.getBoolean("available");
                  status = rs.getString("status");
              }
          }

          if (request.getMethod().equalsIgnoreCase("POST")) {
              name = request.getParameter("name");
              brand = request.getParameter("brand");
              available = request.getParameter("available") != null;
              status = request.getParameter("status");

              String updateSQL = "UPDATE items SET name = ?, brand = ?, available = ?, status = ? WHERE id = ?";
              pstmt = conn.prepareStatement(updateSQL);
              pstmt.setString(1, name);
              pstmt.setString(2, brand);
              pstmt.setBoolean(3, available);
              pstmt.setString(4, status);
              pstmt.setInt(5, Integer.parseInt(id));

              int rowsUpdated = pstmt.executeUpdate();

              if (rowsUpdated > 0) {
                  out.println("<div class='alert alert-success'>Item information updated successfully!</div>");
              } else {
                  out.println("<div class='alert alert-danger'>Failed to update item information.</div>");
              }
          }
      } catch (Exception e) {
          e.printStackTrace();
      } finally {
          try {
              if (rs != null) rs.close();
              if (pstmt != null) pstmt.close();
              if (conn != null) conn.close();
          } catch (SQLException e) {
              e.printStackTrace();
          }
      }
    %>

    <!-- Form for editing item information -->
    <div class="form-container">
      <form action="edit.jsp?id=<%= id %>" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        
        <div class="mb-3">
          <label class="form-label">Name:</label>
          <input type="text" class="form-control" name="name" value="<%= name %>" required>
        </div>

        <div class="mb-3">
          <label class="form-label">Brand:</label>
          <input type="text" class="form-control" name="brand" value="<%= brand %>" required>
        </div>

        <div class="mb-3 form-check">
          <input type="checkbox" class="form-check-input" name="available" <%= available ? "checked" : "" %>>
          <label class="form-check-label">Available</label>
        </div>

        <div class="mb-3">
          <label class="form-label">Status:</label><br>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="status" value="Brand New" <%= "Brand New".equals(status) ? "checked" : "" %>>
            <label class="form-check-label">Brand New</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="status" value="Used" <%= "Used".equals(status) ? "checked" : "" %>>
            <label class="form-check-label">Used</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="status" value="Broken" <%= "Broken".equals(status) ? "checked" : "" %>>
            <label class="form-check-label">Broken</label>
          </div>
        </div>

        <div class="d-flex justify-content-between">
          <button type="submit" class="btn btn-success" name="submit">Update</button>
          <a href="index.jsp" class="btn btn-danger">Cancel</a>
        </div>
      </form>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
