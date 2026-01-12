<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Ambil data dari form & session
    String concertId = request.getParameter("concert_id");
    String quantity = request.getParameter("quantity");
    Object uidObj = session.getAttribute("user_id");

    if (uidObj == null || concertId == null || quantity == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) uidObj;
    
    // 2. Koneksi ke Database
    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres";
    String dbPass = "admin";

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // 3. Cek dulu: Apakah tiket ini udah ada di keranjang user?
        // Kalau udah ada, kita cuma update jumlahnya (QTY)
        PreparedStatement checkSt = conn.prepareStatement(
            "SELECT id FROM cart WHERE user_id = ? AND concert_id = ? AND status = 'PENDING'"
        );
        checkSt.setInt(1, userId);
        checkSt.setInt(2, Integer.parseInt(concertId));
        ResultSet rs = checkSt.executeQuery();

        if (rs.next()) {
            // Jika ada, UPDATE QTY
            PreparedStatement updateSt = conn.prepareStatement(
                "UPDATE cart SET quantity = quantity + ? WHERE id = ?"
            );
            updateSt.setInt(1, Integer.parseInt(quantity));
            updateSt.setInt(2, rs.getInt("id"));
            updateSt.executeUpdate();
        } else {
            // Jika belum ada, INSERT BARU
            PreparedStatement insertSt = conn.prepareStatement(
                "INSERT INTO cart (user_id, concert_id, quantity, status) VALUES (?, ?, ?, 'PENDING')"
            );
            insertSt.setInt(1, userId);
            insertSt.setInt(2, Integer.parseInt(concertId));
            insertSt.setInt(3, Integer.parseInt(quantity));
            insertSt.executeUpdate();
        }

        conn.close();
        // 4. Balikin ke halaman cart dengan status sukses
        response.sendRedirect("cart.jsp?status=success");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>