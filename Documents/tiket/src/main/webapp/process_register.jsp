<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- BARIS DI BAWAH INI WAJIB ADA --%>
<%@ page import="java.sql.*" %> 

<%
    String user = request.getParameter("username");
    String email = request.getParameter("email");
    String pass = request.getParameter("password");

    // Setting Database Postgres
    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres"; 
    String dbPass = "ISI_PASSWORD_PGADMIN_KAMU"; 

    try {
        // Load Driver
        Class.forName("org.postgresql.Driver");
        
        // Buat Koneksi
        Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        // Query (Gunakan casting ::user_role untuk Postgres)
        String query = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, 'user'::user_role)";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, user);
        ps.setString(2, email);
        ps.setString(3, pass);
        
        ps.executeUpdate();
        
        // Tutup koneksi
        ps.close();
        con.close();
        
        response.sendRedirect("login.jsp?status=success");
        
    } catch (Exception e) {
        // Ini buat nampilin error kalau koneksi gagal (misal pass salah)
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    }
%>