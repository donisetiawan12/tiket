<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String name = request.getParameter("name");
    String price = request.getParameter("price");
    String day = request.getParameter("day_number");
    String date = request.getParameter("date");

    if (name != null && price != null && day != null && date != null) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/db_hype", "postgres", "admin");
            String sql = "INSERT INTO concerts (name, date, price, day_number, tickets_sold) VALUES (?, ?, ?, ?, 0)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, date);
            pstmt.setDouble(3, Double.parseDouble(price));
            pstmt.setInt(4, Integer.parseInt(day));
            pstmt.executeUpdate();
            conn.close();
            response.sendRedirect("admin_concerts.jsp?status=add_success");
        } catch (Exception e) { response.sendRedirect("admin_concerts.jsp?status=error"); }
    } else { out.println("Data tidak lengkap!"); }
%>