<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // 1. AMBIL SESSION USER
    Object uidObj = session.getAttribute("user_id");
    if (uidObj == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    int userId = (Integer) uidObj;

    // 2. CONFIG DATABASE (WAJIB ADA BIAR TIDAK NULL)
    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres";
    String dbPass = "admin";

    Connection conn = null;
    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        // Transaksi dimulai
        conn.setAutoCommit(false);

        // A. Ambil semua item di cart yang statusnya PENDING untuk user ini
        String sqlSelect = "SELECT concert_id, quantity FROM cart WHERE user_id = ? AND status = 'PENDING'";
        PreparedStatement psSelect = conn.prepareStatement(sqlSelect);
        psSelect.setInt(1, userId);
        ResultSet rs = psSelect.executeQuery();

        // B. Update kolom tickets_sold di tabel concerts berdasarkan isi cart
        String sqlUpdateStock = "UPDATE concerts SET tickets_sold = tickets_sold + ? WHERE id = ?";
        PreparedStatement psUpdateStock = conn.prepareStatement(sqlUpdateStock);

        boolean hasItems = false;
        while(rs.next()) {
            hasItems = true;
            int concertId = rs.getInt("concert_id");
            int qty = rs.getInt("quantity");

            psUpdateStock.setInt(1, qty);
            psUpdateStock.setInt(2, concertId);
            psUpdateStock.executeUpdate();
        }

        if (hasItems) {
            // C. Update status cart menjadi 'SUCCESS'
            String sqlUpdateCart = "UPDATE cart SET status = 'SUCCESS' WHERE user_id = ? AND status = 'PENDING'";
            PreparedStatement psUpdateCart = conn.prepareStatement(sqlUpdateCart);
            psUpdateCart.setInt(1, userId);
            psUpdateCart.executeUpdate();

            // D. Commit semua perubahan
            conn.commit();
            
            // Redirect ke dashboard dengan pesan sukses
            response.sendRedirect("dashboard_user.jsp?status=payment_success");
        } else {
            // Jika tidak ada item, langsung balik aja
            response.sendRedirect("cart.jsp");
        }

    } catch (Exception e) {
        if (conn != null) {
            try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        out.println("Error Pembayaran: " + e.getMessage());
    } finally {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>