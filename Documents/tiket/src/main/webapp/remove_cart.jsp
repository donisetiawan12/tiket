<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Ambil ID keranjang yang mau dihapus
    String cartIdStr = request.getParameter("cart_id");
    
    // 2. Cek session user biar orang lain gak bisa asal hapus
    Object uidObj = session.getAttribute("user_id");
    
    if (uidObj == null || cartIdStr == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) uidObj;
    int cartId = Integer.parseInt(cartIdStr);

    // 3. Konfigurasi Database
    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres";
    String dbPass = "PASSWORD_LO"; // GANTI DENGAN PASSWORD LO!

    Connection conn = null;
    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // 4. Query Delete (Sertakan user_id biar aman, hanya bisa hapus keranjang sendiri)
        String sql = "DELETE FROM cart WHERE id = ? AND user_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, cartId);
        pstmt.setInt(2, userId);
        
        pstmt.executeUpdate();

        // 5. Setelah dihapus, balikin ke halaman cart
        response.sendRedirect("cart.jsp");

    } catch (Exception e) {
        out.println("Error Delete: " + e.getMessage());
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>