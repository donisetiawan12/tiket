<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONObject" %>
<%
    // Ambil data yang dikirim dari JavaScript
    int userId = Integer.parseInt(request.getParameter("userId"));
    String concertName = request.getParameter("concertName");
    int quantity = Integer.parseInt(request.getParameter("quantity"));
    long price = Long.parseLong(request.getParameter("price"));

    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres";
    String dbPass = "ISI_PASSWORD_LO"; 

    JSONObject jsonResponse = new JSONObject();

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        String sql = "INSERT INTO cart (user_id, concert_name, quantity, price) VALUES (?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        pstmt.setString(2, concertName);
        pstmt.setInt(3, quantity);
        pstmt.setLong(4, price);
        
        int row = pstmt.executeUpdate();
        if(row > 0) {
            jsonResponse.put("status", "success");
        }
        
        conn.close();
    } catch (Exception e) {
        jsonResponse.put("status", "error");
        jsonResponse.put("message", e.getMessage());
    }
    
    out.print(jsonResponse.toString());
%>