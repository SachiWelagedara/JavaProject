<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String msg = "";
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        String available = request.getParameter("available") != null ? "Yes" : "No";
        String status = request.getParameter("status");

        String url = "jdbc:mysql://localhost:3307/stuff"; 
        String user = "root"; 
        String password = "kushi"; 

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                String sql = "INSERT INTO items (name, brand, available, status) VALUES (?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, brand);
                stmt.setString(3, available);
                stmt.setString(4, status);

                int result = stmt.executeUpdate();

                if (result > 0) {
                    response.sendRedirect("index.jsp?msg=Item added successfully");
                } else {
                    msg = "Failed to add item.";
                }
            } catch (SQLException e) {
                msg = "Error: " + e.getMessage();
            }
        } catch (ClassNotFoundException e) {
            msg = "JDBC Driver not found: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Computer Management System</title>

    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&family=Open+Sans:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Open Sans', sans-serif;
            background-image: url('background3.jpg');
            background-size: cover;
            background-position: center center;
            background-attachment: fixed;
            color: #ffffff;
            height: 100vh;
        }

        .navbar {
            background-color: #0a4275;
            color: white;
        }

        .container {
            margin-top: 50px;
            margin-bottom: 50px;
        }

        h3 {
            color: #0a74da;
            font-weight: 600;
        }

        .form-container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
        }

        .form-wrapper {
    width: 60vw;
    min-width: 320px;
    background-color: rgba(15, 52, 96, 0.7); 
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

        .form-wrapper h3 {
            text-align: center;
            margin-bottom: 20px;
        }

        .btn-success {
            background-color: #0a74da;
            border: none;
        }

        .btn-success:hover {
            background-color: #063e75;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
        }

        label.form-label {
            color: #0a74da;
            font-weight: 600;
        }

        input[type="text"], input[type="checkbox"], input[type="radio"] {
            border-color: #1e3a8a;
        }

        input[type="text"]:focus, input[type="checkbox"]:focus, input[type="radio"]:focus {
            box-shadow: 0 0 5px rgba(30, 58, 138, 0.5);
        }
    </style>
</head>

<body>
    <nav class="navbar navbar-light justify-content-center fs-3 mb-5">
        Computer Management System
    </nav>

    <div class="container">
        <div class="text-center mb-4">
            <h3>Add New Item</h3>
            <p class="text-muted">Fill in the details below to add a new item to inventory</p>
        </div>

        <div class="form-container">
            <% if (!msg.isEmpty()) { %>
                <div class="alert alert-danger"><%= msg %></div>
            <% } %>

            <div class="form-wrapper">
                <form action="add-new.jsp" method="post">
                    <div class="mb-3">
                        <label class="form-label">Name:</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Brand:</label>
                        <input type="text" class="form-control" name="brand" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Available:</label><br>
                        <input type="checkbox" name="available"> In Stock
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Status:</label><br>
                        <input type="radio" name="status" value="Brand New" required> Brand New<br>
                        <input type="radio" name="status" value="Used" required> Used<br>
                        <input type="radio" name="status" value="Broken" required> Broken
                    </div>

                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-success" name="submit">Add Item</button>
                        <a href="index.jsp" class="btn btn-danger">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
