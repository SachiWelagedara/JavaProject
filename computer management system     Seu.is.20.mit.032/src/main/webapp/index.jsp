<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <title>Computer Management System</title>

  <style>
    body {
      font-family: 'Open Sans', sans-serif;
      
      background-size: cover;
      background-position: center center;
      background-attachment: fixed;
      height: 100vh;
      margin: 0;
      padding: 0;
      color: #ffffff;
    }

    nav {
      background-color: #013a63; 
      color: white;
    }

    .container {
      margin-top: 40px;
      margin-bottom: 40px;
      background-color: rgba(1, 58, 99, 0.9); 
      border-radius: 8px;
      padding: 20px;
    }

    .table {
      background-color: #0369a1; 
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    .table th,
    .table td {
      padding: 12px;
    }

    .table-hover tbody tr:hover {
      background-color: #0284c7;
    }

    .btn-dark {
      background-color: #013a63;
      border: none;
    }

    .btn-dark:hover {
      background-color: #035388; /* Lighter bluish on hover */
    }

    .alert-warning {
      background-color: #0369a1; /* Light bluish alert */
      border-color: #025c91; /* Slightly darker bluish border for the alert */
      color: white;
    }

    .link-dark {
      color: white !important;
    }

    .link-dark:hover {
      color: #cce7f7 !important; /* Light blue for hover effect */
    }
  </style>
</head>

<body>
  <nav class="navbar navbar-light justify-content-center fs-3 mb-5">
    	computer Management System
  </nav>

  <div class="container">
    <% 
      String msg = request.getParameter("msg");
      if (msg != null) { 
    %>
      <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% 
      }

      // Database connection setup
      String url = "jdbc:mysql://localhost:3307/stuff";
      String user = "root";
      String password = "kushi";
      List<Map<String, Object>> itemsList = new ArrayList<>();
      
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM items")) {
                 
          while (rs.next()) {
            Map<String, Object> itemMap = new HashMap<>();
            itemMap.put("id", rs.getInt("id"));
            itemMap.put("name", rs.getString("name"));
            itemMap.put("brand", rs.getString("brand"));
            itemMap.put("available", rs.getBoolean("available"));
            itemMap.put("status", rs.getString("status"));
            itemsList.add(itemMap);
          }
        }
      } catch (SQLException e) {
        out.println("Error: " + e.getMessage());
      } catch (ClassNotFoundException e) {
        out.println("JDBC Driver not found: " + e.getMessage());
      }
    %>

    <a href="add-new.jsp" class="btn btn-dark mb-3">Add New</a>

    <table class="table table-hover text-center">
      <thead class="table-dark">
        <tr>
          <th scope="col">ID</th>
          <th scope="col">Name</th>
          <th scope="col">Brand</th>
          <th scope="col">Available</th>
          <th scope="col">Status</th>
          <th scope="col">Action</th>
        </tr>
      </thead>
      <tbody>
        <% 
          for (Map<String, Object> itemMap : itemsList) {
            boolean isAvailable = (boolean) itemMap.get("available");
            String status = (String) itemMap.get("status");
        %>
          <tr>
            <td><%= itemMap.get("id") %></td>
            <td><%= itemMap.get("name") %></td>
            <td><%= itemMap.get("brand") %></td>
            <td>
              <input type="checkbox" <%= isAvailable ? "checked" : "" %> disabled>
            </td>
            <td>
              <%= status.equals("brand new") ? "Brand New" : status.equals("used") ? "Used" : "Broken" %>
            </td>
            <td>
              <a href="edit.jsp?id=<%= itemMap.get("id") %>" class="link-dark"><i class="fa-solid fa-pen-to-square fs-5 me-3"></i></a>
              <a href="delete?id=<%= itemMap.get("id") %>" class="link-dark"><i class="fa-solid fa-trash fs-5"></i></a>
            </td>
          </tr>
        <% 
          }
        %>
      </tbody>
    </table>
  </div>

  <!-- Bootstrap -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>

</body>

</html>
