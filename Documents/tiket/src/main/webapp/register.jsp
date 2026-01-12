<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String user = request.getParameter("username");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/sound_project", "postgres", "PASSWORD_PGADMIN_LO");
            
            String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user);
            pstmt.setString(2, email);
            pstmt.setString(3, pass);
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                out.println("<script>alert('Registrasi Berhasil! Silakan Login.'); window.location='login.jsp';</script>");
            }
            conn.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - The Hype Machine</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&display=swap" rel="stylesheet">
    <style>
        h1, h2, h3, h4, h5, h6, .heading-font {
            font-family: 'Bebas Neue', sans-serif;
            letter-spacing: 1px;
        }
        
        .hover-lift {
            transition: all 0.3s ease;
        }
        
        .hover-lift:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }
    </style>
</head>
<body class="bg-gradient-to-br from-indigo-900 via-purple-900 to-pink-800 min-h-screen flex items-center justify-center p-4">
    <div class="max-w-md w-full">
        <div class="text-center mb-8">
            <img src="images/Logo.png" alt="The Hype Machine" class="h-20 mx-auto mb-4">
            <h1 class="text-4xl heading-font text-white">The Hype Machine</h1>
            <p class="text-gray-300 mt-2">Bergabunglah dengan komunitas musik terbaik</p>
        </div>

        <div class="bg-white/10 backdrop-blur-lg rounded-2xl shadow-2xl p-8 hover-lift border border-white/20">
            <h2 class="text-3xl heading-font text-white text-center mb-8">Daftar Akun</h2>
            
            <%-- Form registrasi diarahkan ke process_register.jsp --%>
            <form action="process_register.jsp" method="POST" class="space-y-6">
                <div>
                    <label for="username" class="block text-white font-semibold mb-2">
                        <i class="fas fa-user mr-2"></i>Username
                    </label>
                    <input type="text" 
                           id="username" 
                           name="username" 
                           required
                           class="w-full bg-white/20 border border-white/30 rounded-xl px-4 py-3 text-white placeholder-gray-300 focus:bg-white/30 focus:border-white/50 focus:ring-2 focus:ring-white/50 transition duration-300"
                           placeholder="Pilih username unik">
                </div>
                
                <div>
                    <label for="email" class="block text-white font-semibold mb-2">
                        <i class="fas fa-envelope mr-2"></i>Email
                    </label>
                    <input type="email" 
                           id="email" 
                           name="email" 
                           required
                           class="w-full bg-white/20 border border-white/30 rounded-xl px-4 py-3 text-white placeholder-gray-300 focus:bg-white/30 focus:border-white/50 focus:ring-2 focus:ring-white/50 transition duration-300"
                           placeholder="Masukkan email aktif">
                </div>
                
                <div>
                    <label for="password" class="block text-white font-semibold mb-2">
                        <i class="fas fa-lock mr-2"></i>Password
                    </label>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           required
                           class="w-full bg-white/20 border border-white/30 rounded-xl px-4 py-3 text-white placeholder-gray-300 focus:bg-white/30 focus:border-white/50 focus:ring-2 focus:ring-white/50 transition duration-300"
                           placeholder="Buat password yang kuat">
                </div>
                
                <div>
                    <label for="confirm_password" class="block text-white font-semibold mb-2">
                        <i class="fas fa-lock mr-2"></i>Konfirmasi Password
                    </label>
                    <input type="password" 
                           id="confirm_password" 
                           name="confirm_password" 
                           required
                           class="w-full bg-white/20 border border-white/30 rounded-xl px-4 py-3 text-white placeholder-gray-300 focus:bg-white/30 focus:border-white/50 focus:ring-2 focus:ring-white/50 transition duration-300"
                           placeholder="Ulangi password Anda">
                </div>
                
                <button type="submit" 
                        class="w-full bg-gradient-to-r from-yellow-400 to-orange-500 text-indigo-900 py-4 rounded-xl font-bold hover:from-yellow-300 hover:to-orange-400 transform hover:scale-105 transition duration-300 shadow-lg">
                    <i class="fas fa-user-plus mr-2"></i>Daftar Sekarang
                </button>
            </form>
            
            <div class="mt-6 text-center">
                <p class="text-gray-300">
                    Sudah punya akun? 
                    <a href="login.jsp" class="text-yellow-400 hover:text-yellow-300 font-semibold transition duration-300">
                        Login di sini
                    </a>
                </p>
            </div>
            
            <div class="mt-6 pt-6 border-t border-white/20">
                <a href="index.jsp" class="flex items-center justify-center text-white hover:text-yellow-400 transition duration-300">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Kembali ke Halaman Utama
                </a>
            </div>
        </div>
    </div>
</body>
</html>