<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Ambil User ID dari Session
    Object uidObj = session.getAttribute("user_id");
    if (uidObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (Integer) uidObj;

    Connection conn = null;
    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/db_hype", "postgres", "admin");
        
        // Mulai transaksi biar aman
        conn.setAutoCommit(false);

        // 2. Hapus data di tabel terkait (Constraint Handling)
        // Hapus keranjang/tiket dulu karena dia foreign key ke users
        PreparedStatement psCart = conn.prepareStatement("DELETE FROM cart WHERE user_id = ?");
        psCart.setInt(1, userId);
        psCart.executeUpdate();

        // 3. Hapus User utamanya
        PreparedStatement psUser = conn.prepareStatement("DELETE FROM users WHERE id = ?");
        psUser.setInt(1, userId);
        psUser.executeUpdate();

        // Commit perubahan
        conn.commit();

        // 4. Hapus Session & Tendang ke Index
        session.invalidate();
        response.sendRedirect("index.jsp?status=account_deleted");

    } catch (Exception e) {
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
        e.printStackTrace();
        out.println("Gagal menghapus akun: " + e.getMessage());
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ex) {}
    }
%>