<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Kalau sudah login, langsung lempar ke index2
    if (session.getAttribute("user_id") != null) {
        response.sendRedirect("index2.jsp");
        return;
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/sound_project", "postgres", "PASSWORD_PGADMIN_LO");
            
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, pass);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // NYALAIN SESSION DI SINI
                session.setAttribute("user_id", rs.getInt("id"));
                session.setAttribute("username", rs.getString("username"));
                
                response.sendRedirect("index2.jsp");
                return;
            } else {
                out.println("<script>alert('Email atau Password Salah!');</script>");
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
    <title>Login - The Hype Machine</title>
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
            <p class="text-gray-300 mt-2">Login untuk melanjutkan pengalaman musik Anda</p>
        </div>

        <div class="bg-white/10 backdrop-blur-lg rounded-2xl shadow-2xl p-8 hover-lift border border-white/20">
            <h2 class="text-3xl heading-font text-white text-center mb-8">Login</h2>
            
            <%-- Pesan Error Jika Login Gagal (Opsional) --%>
            <% if (request.getParameter("error") != null) { %>
                <div class="bg-red-500/50 text-white p-3 rounded-lg mb-6 text-center text-sm border border-red-500">
                    Username atau Password salah!
                </div>
            <% } %>
            
            <%-- Action diarahkan ke process_login.jsp --%>
            <form action="process_login.jsp" method="POST" class="space-y-6">
                <div>
                    <label for="username" class="block text-white font-semibold mb-2">
                        <i class="fas fa-user mr-2"></i>Username
                    </label>
                    <input type="text" 
                           id="username" 
                           name="username" 
                           required
                           class="w-full bg-white/20 border border-white/30 rounded-xl px-4 py-3 text-white placeholder-gray-300 focus:bg-white/30 focus:border-white/50 focus:ring-2 focus:ring-white/50 transition duration-300"
                           placeholder="Masukkan username Anda">
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
                           placeholder="Masukkan password Anda">
                </div>
                
                <button type="submit" 
                        class="w-full bg-gradient-to-r from-yellow-400 to-orange-500 text-indigo-900 py-4 rounded-xl font-bold hover:from-yellow-300 hover:to-orange-400 transform hover:scale-105 transition duration-300 shadow-lg">
                    <i class="fas fa-sign-in-alt mr-2"></i>Login
                </button>
            </form>
            
            <div class="mt-6 text-center">
                <p class="text-gray-300">
                    Belum punya akun? 
                    <a href="register.jsp" class="text-yellow-400 hover:text-yellow-300 font-semibold transition duration-300">
                        Daftar di sini
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