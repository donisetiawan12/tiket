<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String cartId = request.getParameter("cart_id");
    Object uidObj = session.getAttribute("user_id");

    if (uidObj != null && cartId != null) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/db_hype", "postgres", "admin");
            
            // Hapus item berdasarkan ID cart dan pastikan milik user yang login
            PreparedStatement ps = conn.prepareStatement("DELETE FROM cart WHERE id = ? AND user_id = ? AND status = 'PENDING'");
            ps.setInt(1, Integer.parseInt(cartId));
            ps.setInt(2, (Integer) uidObj);
            ps.executeUpdate();
            
            conn.close();
        } catch (Exception e) {}
    }
    // Balik ke cart, otomatis total harga di Ringkasan akan berkurang/nyesuain
    response.sendRedirect("cart.jsp");
%>