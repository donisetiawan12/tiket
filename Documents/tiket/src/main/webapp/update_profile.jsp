<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Ambil ID User dari Session (Biar tau profil siapa yg diupdate)
    Object uidObj = session.getAttribute("user_id");
    if (uidObj == null) { response.sendRedirect("login.jsp"); return; }
    int userId = (Integer) uidObj;

    // 2. Tangkap data dari Form Dashboard
    // Sesuai dengan atribut 'name' di input HTML lo
    String newName = request.getParameter("name");
    String newEmail = request.getParameter("email");
    String newPhone = request.getParameter("phone");
    String newAddress = request.getParameter("address");

    // 3. DB CONFIG
    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres";
    String dbPass = "admin";

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // 4. QUERY UPDATE
        // Kita pakai 'username' sesuai struktur tabel lo tadi
        String sql = "UPDATE users SET username = ?, email = ?, phone = ?, address = ? WHERE id = ?";
        
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, newName);
        ps.setString(2, newEmail);
        ps.setString(3, newPhone);
        ps.setString(4, newAddress);
        ps.setInt(5, userId);

        int rowUpdated = ps.executeUpdate();
        
        if (rowUpdated > 0) {
            // Update juga session-nya biar kalau pindah halaman namanya langsung berubah
            session.setAttribute("user_name", newName);
            session.setAttribute("user_email", newEmail);
            
            // Balik ke dashboard dengan pesan sukses
            response.sendRedirect("dashboard_user.jsp?status=success");
        } else {
            response.sendRedirect("dashboard_user.jsp?status=failed");
        }

        conn.close();
    } catch (Exception e) {
        out.println("Error Update: " + e.getMessage());
    }
%>