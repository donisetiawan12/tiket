<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String id = request.getParameter("id");
    if (id != null) {
        Connection conn = null;
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/db_hype", "postgres", "admin");
            
            // Kita pakai transaksi supaya kalau satu gagal, semua batal
            conn.setAutoCommit(false);

            // 1. Hapus dulu data di tabel cart yang berhubungan sama konser ini
            PreparedStatement pstmt1 = conn.prepareStatement("DELETE FROM cart WHERE concert_id = ?");
            pstmt1.setInt(1, Integer.parseInt(id));
            pstmt1.executeUpdate();

            // 2. Baru hapus data di tabel concerts
            PreparedStatement pstmt2 = conn.prepareStatement("DELETE FROM concerts WHERE id = ?");
            pstmt2.setInt(1, Integer.parseInt(id));
            pstmt2.executeUpdate();

            conn.commit(); // Simpan perubahan
            response.sendRedirect("admin_concerts.jsp?status=delete_success");
            
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            // Cetak error ke console server buat debug
            e.printStackTrace(); 
            response.sendRedirect("admin_concerts.jsp?status=error");
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ex) {}
        }
    }
%>