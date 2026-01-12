<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String price = request.getParameter("price");
    String day = request.getParameter("day_number");
    String date = request.getParameter("date");

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/db_hype", "postgres", "admin");
        String sql = "UPDATE concerts SET name=?, price=?, day_number=?, date=? WHERE id=?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setDouble(2, Double.parseDouble(price));
        pstmt.setInt(3, Integer.parseInt(day));
        pstmt.setString(4, date);
        pstmt.setInt(5, Integer.parseInt(id));
        pstmt.executeUpdate();
        conn.close();
        response.sendRedirect("admin_concerts.jsp?status=update_success");
    } catch (Exception e) { response.sendRedirect("admin_concerts.jsp?status=error"); }
%>