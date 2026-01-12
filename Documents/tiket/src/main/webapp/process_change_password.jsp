<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String oldPass = request.getParameter("old_password");
    String newPass = request.getParameter("new_password");
    int userId = (Integer) session.getAttribute("user_id");

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/db_hype", "postgres", "admin");

        // 1. Cek dulu password lama bener apa gak
        PreparedStatement psCheck = conn.prepareStatement("SELECT password FROM users WHERE id = ?");
        psCheck.setInt(1, userId);
        ResultSet rs = psCheck.executeQuery();

        if (rs.next()) {
            if (rs.getString("password").equals(oldPass)) {
                // 2. Kalau bener, update ke yang baru
                PreparedStatement psUpdate = conn.prepareStatement("UPDATE users SET password = ? WHERE id = ?");
                psUpdate.setString(1, newPass);
                psUpdate.setInt(2, userId);
                psUpdate.executeUpdate();
                
                response.sendRedirect("dashboard_user.jsp?status=pass_success");
            } else {
                response.sendRedirect("dashboard_user.jsp?status=pass_wrong");
            }
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("dashboard_user.jsp?status=error");
    }
%>