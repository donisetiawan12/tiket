<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // 1. Ambil input dari form login
    String userLogin = request.getParameter("username");
    String passLogin = request.getParameter("password");

    // 2. Setting Database Postgres (GANTI PASSWORDNYA!)
    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres";
    String dbPass = "ISI_PASSWORD_PGADMIN_LO"; 

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        // 3. Query ambil id, username, dan role
        // Pastikan kolom role sudah ada di tabel users lo
        String sql = "SELECT id, username, role FROM users WHERE username=? AND password=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userLogin);
        pstmt.setString(2, passLogin);
        
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // LOGIN BERHASIL
            int userId = rs.getInt("id");
            String username = rs.getString("username");
            String role = rs.getString("role");

            // Jika role di database kosong, set default sebagai 'user'
            if (role == null) role = "user";

            // 4. Simpan ke Session
            session.setAttribute("user_id", userId);
            session.setAttribute("user", username);
            session.setAttribute("role", role);

            // 5. Redirect berdasarkan role
            // Kalau dia admin, lempar ke halaman CRUD konser yang kita buat tadi
            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect("admin_concerts.jsp");
            } else {
                // Kalau user biasa, lempar ke halaman belanja
                response.sendRedirect("index2.jsp");
            }
            
        } else {
            // LOGIN GAGAL - Balikin ke login.jsp dengan pesan error
            response.sendRedirect("login.jsp?error=invalid");
        }
        
    } catch (Exception e) {
        // Tampilkan error jika ada masalah koneksi atau query
        out.println("<div style='color:red; font-family:sans-serif;'>");
        out.println("<h2>Login System Error</h2>");
        out.println("Pesan: " + e.getMessage());
        out.println("</div>");
    } finally {
        // 6. Tutup koneksi di blok finally biar gak bocor (resource leak)
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>