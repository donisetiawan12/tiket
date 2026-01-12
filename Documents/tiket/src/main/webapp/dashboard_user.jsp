<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // Deklarasi awal
    String name = "", email = "", phone = "", address = "";
    Map<String, List<Map<String, Object>>> groupedTickets = new LinkedHashMap<>();
    
    // Cek Session
    Object uidObj = session.getAttribute("user_id");
    if (uidObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (Integer) uidObj;

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/db_hype", "postgres", "admin");

        // 1. Ambil Data Profil
        PreparedStatement psU = conn.prepareStatement("SELECT username, email, phone, address FROM users WHERE id = ?");
        psU.setInt(1, userId);
        ResultSet rsU = psU.executeQuery();
        if(rsU.next()) {
            name = rsU.getString("username") != null ? rsU.getString("username") : "User";
            email = rsU.getString("email") != null ? rsU.getString("email") : "";
            phone = rsU.getString("phone") != null ? rsU.getString("phone") : "";
            address = rsU.getString("address") != null ? rsU.getString("address") : "";
        }

        // 2. Ambil Tiket & Grouping
        String sql = "SELECT c.day_number, c.name as c_name, c.date, ca.quantity, ca.id as cart_id " +
                     "FROM cart ca JOIN concerts c ON ca.concert_id = c.id " +
                     "WHERE ca.user_id = ? AND ca.status = 'SUCCESS' " + 
                     "ORDER BY c.day_number ASC";
        
        PreparedStatement psT = conn.prepareStatement(sql);
        psT.setInt(1, userId);
        ResultSet rsT = psT.executeQuery();

        while(rsT.next()) {
            String label = "DAY " + rsT.getInt("day_number");
            Map<String, Object> t = new HashMap<>();
            t.put("concert_name", rsT.getString("c_name"));
            t.put("date", rsT.getString("date"));
            t.put("quantity", rsT.getInt("quantity"));
            t.put("cart_id", rsT.getInt("cart_id"));

            if (!groupedTickets.containsKey(label)) {
                groupedTickets.put(label, new ArrayList<>());
            }
            groupedTickets.get(label).add(t);
        }
        conn.close();
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - The Hype Machine</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&display=swap" rel="stylesheet">
    <style>
        h1, h2, h3, h4, h5, h6, .heading-font { font-family: 'Bebas Neue', sans-serif; letter-spacing: 1px; }
        .hover-lift { transition: all 0.3s ease; }
        .hover-lift:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.15); }
    </style>
</head>
<body class="bg-gradient-to-br from-indigo-50 to-purple-50 min-h-screen">

    <header class="fixed top-0 left-0 w-full flex justify-between items-center px-4 md:px-6 py-3 bg-white/95 backdrop-blur-lg z-40 shadow-lg">
        <div class="logo transform hover:scale-105 transition duration-300">
            <a href="index.jsp"><img src="images/Logo.png" alt="Logo" class="h-10 md:h-14"></a>
        </div>
        <div class="flex gap-2 md:gap-3">
            <a href="cart.jsp" class="relative bg-indigo-600 text-white p-3 rounded-full hover:bg-indigo-700 transition shadow-lg">
                <i class="fas fa-shopping-cart"></i>
            </a>
            <a href="logout.jsp" class="inline-flex items-center justify-center bg-red-600 text-white px-5 py-2.5 rounded-xl font-bold hover:bg-red-700 transition-all">
                <i class="fas fa-sign-out-alt mr-2"></i> <span>Logout</span>
            </a>
        </div>
    </header>

    <div class="pt-24 pb-12 px-4 max-w-7xl mx-auto">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
            
            <div class="lg:col-span-1">
                <div class="bg-white rounded-2xl shadow-2xl p-6 sticky top-32">
                    <h3 class="text-2xl heading-font mb-6 text-indigo-900 border-b pb-2">Menu</h3>
                    <div class="space-y-2">
                        <button onclick="showSection('profile')" id="btn-profile" 
                            class="nav-item w-full text-left px-4 py-3 rounded-xl font-bold transition flex items-center">
                            <i class="fas fa-user-circle mr-3"></i>Profil Saya
                        </button>
                        <button onclick="showSection('tickets')" id="btn-tickets" 
                            class="nav-item w-full text-left px-4 py-3 rounded-xl font-bold transition flex items-center">
                            <i class="fas fa-ticket-alt mr-3"></i> Tiket Saya
                        </button>
                        <button onclick="showSection('password')" id="btn-password" 
                            class="nav-item w-full text-left px-4 py-3 rounded-xl font-bold transition flex items-center text-indigo-900 hover:bg-indigo-50">
                            <i class="fas fa-key mr-3"></i> Ganti Password
                        </button>
                        <hr class="my-4 border-gray-100">
                        <button onclick="confirmDelete()" class="w-full text-left px-4 py-3 rounded-xl font-bold text-red-500 hover:bg-red-50 transition flex items-center">
                            <i class="fas fa-trash-alt mr-3"></i> Hapus Akun
                        </button>
                    </div>
                </div>
            </div>

            <div class="lg:col-span-3">
                
                <div id="section-profile" class="bg-white rounded-2xl shadow-2xl p-6 md:p-8 hover-lift">
                    <h2 class="text-3xl heading-font mb-6 text-indigo-900 uppercase">Profil Saya</h2>
                    <form action="update_profile.jsp" method="POST" class="space-y-5">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                            <div>
                                <label class="block text-xs font-black text-gray-400 uppercase mb-2">Nama Lengkap</label>
                                <input type="text" name="name" value="<%= name %>" class="w-full border-2 border-indigo-50 bg-indigo-50/30 rounded-xl px-4 py-3 focus:border-indigo-500 outline-none font-bold text-indigo-900">
                            </div>
                            <div>
                                <label class="block text-xs font-black text-gray-400 uppercase mb-2">Alamat Email</label>
                                <input type="email" name="email" value="<%= email %>" class="w-full border-2 border-indigo-50 bg-indigo-50/30 rounded-xl px-4 py-3 focus:border-indigo-500 outline-none font-bold text-indigo-900">
                            </div>
                        </div>
                        <div>
                            <label class="block text-xs font-black text-gray-400 uppercase mb-2">Nomor Telepon</label>
                            <input type="text" name="phone" value="<%= phone %>" class="w-full border-2 border-indigo-50 bg-indigo-50/30 rounded-xl px-4 py-3 focus:border-indigo-500 outline-none font-bold text-indigo-900">
                        </div>
                        <div>
                            <label class="block text-xs font-black text-gray-400 uppercase mb-2">Alamat Pengiriman</label>
                            <textarea name="address" rows="3" class="w-full border-2 border-indigo-50 bg-indigo-50/30 rounded-xl px-4 py-3 focus:border-indigo-500 outline-none font-bold text-indigo-900"><%= address %></textarea>
                        </div>
                        <button type="submit" class="bg-indigo-600 text-white px-8 py-4 rounded-xl font-bold hover:bg-indigo-700 transform hover:scale-105 transition shadow-lg uppercase text-sm">
                            Simpan Perubahan
                        </button>
                    </form>
                </div>

                <div id="section-tickets" class="bg-white rounded-2xl shadow-2xl p-6 md:p-8 mt-8 hover-lift" style="display:none;">
                    <h2 class="text-3xl heading-font mb-6 text-indigo-900 uppercase">Tiket Saya</h2>
                    <% if (groupedTickets.isEmpty()) { %>
                        <div class="text-center py-12">
                            <i class="fas fa-ticket-alt text-6xl text-gray-300 mb-4"></i>
                            <p class="text-xl text-gray-500">Anda belum memiliki tiket.</p>
                        </div>
                    <% } else { %>
                        <div class="space-y-8">
                            <% for (Map.Entry<String, List<Map<String, Object>>> entry : groupedTickets.entrySet()) {
                                String dayLabel = entry.getKey();
                                List<Map<String, Object>> tickets = entry.getValue();
                                Map<String, Object> first = tickets.get(0);
                            %>
                                <div class="border-2 border-indigo-100 rounded-2xl overflow-hidden shadow-sm">
                                    <div class="bg-gradient-to-r from-indigo-600 to-purple-700 text-white p-5">
                                        <h4 class="text-2xl heading-font"><%= dayLabel %> - THE HYPE MACHINE</h4>
                                        <div class="flex flex-wrap gap-4 mt-2 text-xs opacity-90">
                                            <span><i class="fas fa-music mr-2"></i><%= first.get("concert_name") %></span>
                                            <span><i class="fas fa-calendar-alt mr-2"></i><%= first.get("date") %></span>
                                        </div>
                                    </div>
                                    <div class="p-5 bg-gray-50">
                                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                            <% for (Map<String, Object> t : tickets) {
                                                int qty = (int) t.get("quantity");
                                                for (int i = 1; i <= qty; i++) {
                                                    String uniqueId = t.get("cart_id") + "-" + i;
                                            %>
                                                <div class="bg-white border-2 border-yellow-200 rounded-2xl p-4 text-center relative shadow-sm">
                                                    <button onclick="copyTicketLink('<%= uniqueId %>')" class="absolute top-2 right-2 bg-indigo-600 text-white p-2 rounded-lg hover:bg-indigo-700 transition">
                                                        <i class="fas fa-share-alt"></i>
                                                    </button>
                                                    <div class="mb-3">
                                                        <p class="text-[10px] font-black text-indigo-900 uppercase tracking-widest">E-Ticket</p>
                                                        <p class="text-[9px] text-gray-400 font-mono">ID: HYPE-<%= uniqueId %></p>
                                                    </div>
                                                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=HYPE-<%= uniqueId %>" class="w-24 h-24 mx-auto mb-3 border p-1 rounded-lg">
                                                    <p class="text-[10px] font-bold text-gray-600 uppercase mb-2"><%= t.get("concert_name") %></p>
                                                    <span class="text-[9px] bg-green-500 text-white px-3 py-1 rounded-full font-black">LUNAS</span>
                                                </div>
                                            <% } } %>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
                
                <div id="section-password" class="bg-white rounded-2xl shadow-2xl p-6 md:p-8 mt-8 hover-lift" style="display:none;">
                    <h2 class="text-3xl heading-font mb-6 text-indigo-900 uppercase">Ganti Password</h2>

                    <form action="process_change_password.jsp" method="POST" class="space-y-5" onsubmit="return validatePassword()">
                        <div>
                            <label class="block text-xs font-black text-gray-400 uppercase mb-2">Password Saat Ini</label>
                            <input type="password" name="old_password" required class="w-full border-2 border-indigo-50 bg-indigo-50/30 rounded-xl px-4 py-3 focus:border-indigo-500 outline-none font-bold">
                        </div>
                        <div>
                            <label class="block text-xs font-black text-gray-400 uppercase mb-2">Password Baru</label>
                            <input type="password" id="new_password" name="new_password" required class="w-full border-2 border-indigo-50 bg-indigo-50/30 rounded-xl px-4 py-3 focus:border-indigo-500 outline-none font-bold">
                        </div>
                        <div>
                            <label class="block text-xs font-black text-gray-400 uppercase mb-2">Konfirmasi Password Baru</label>
                            <input type="password" id="confirm_password" name="confirm_password" required class="w-full border-2 border-indigo-50 bg-indigo-50/30 rounded-xl px-4 py-3 focus:border-indigo-500 outline-none font-bold">
                        </div>

                        <button type="submit" class="bg-indigo-600 text-white px-8 py-4 rounded-xl font-bold hover:bg-indigo-700 transition shadow-lg uppercase text-sm">
                            Update Password
                        </button>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function showSection(sectionId) {
            // Sembunyikan semua
            document.getElementById('section-profile').style.display = 'none';
            document.getElementById('section-tickets').style.display = 'none';

            // Tampilkan yang dipilih
            if (sectionId === 'profile') {
                document.getElementById('section-profile').style.display = 'block';
            } else if (sectionId === 'tickets') {
                document.getElementById('section-tickets').style.display = 'block';
            }

            // Update Menu Styling
            document.querySelectorAll('.nav-item').forEach(item => {
                item.classList.remove('bg-indigo-600', 'text-white');
                item.classList.add('text-indigo-900', 'hover:bg-indigo-50');
            });

            const activeBtn = document.getElementById('btn-' + sectionId);
            if (activeBtn) {
                activeBtn.classList.remove('text-indigo-900', 'hover:bg-indigo-50');
                activeBtn.classList.add('bg-indigo-600', 'text-white');
            }
        }

        function copyTicketLink(ticketId) {
            const pathArray = window.location.pathname.split('/');
            const projectName = pathArray[1]; 
            const baseUrl = window.location.origin + "/" + projectName + "/view_ticket.jsp";
            const finalLink = (baseUrl + "?tid=" + ticketId).trim();
            
            navigator.clipboard.writeText(finalLink).then(() => {
                Swal.fire({
                    icon: 'success',
                    title: 'Link Disalin!',
                    text: 'Silakan bagikan link tiket Anda.',
                    timer: 1500,
                    showConfirmButton: false,
                    toast: true,
                    position: 'top-end'
                });
            });
        }
        
        function confirmDelete() {
            Swal.fire({
                title: 'Yakin mau hapus akun?',
                text: "Semua data profil dan tiket akan hilang permanen!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Ya, Hapus Saja!',
                cancelButtonText: 'Gak jadi, deh'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "delete_account.jsp";
                }
            })
        }
        
        function showSection(sectionId) {
            document.getElementById('section-profile').style.display = 'none';
            document.getElementById('section-tickets').style.display = 'none';
            document.getElementById('section-password').style.display = 'none'; // Tambahin ini

            document.getElementById('section-' + sectionId).style.display = 'block';
            // ... sisa logic tombol aktif ...
        }
        
        document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');

        if (status === 'pass_wrong') {
            Swal.fire({
                icon: 'error',
                title: 'Gagal Ganti Password',
                text: 'Password saat ini yang anda masukin salah!',
                confirmButtonColor: '#4F46E5'
            });
            // Buka section password otomatis biar user gak bingung
            showSection('password');
        } 
        else if (status === 'pass_success') {
            Swal.fire({
                icon: 'success',
                title: 'Berhasil!',
                text: 'Password anda udah diupdate, jangan lupa ya!',
                confirmButtonColor: '#4F46E5'
            });
            showSection('password');
        }
        else if (status === 'error') {
            Swal.fire({
                icon: 'warning',
                title: 'Waduh...',
                text: 'Terjadi kesalahan sistem, coba lagi nanti.',
                confirmButtonColor: '#4F46E5'
            });
        }
    });

        document.addEventListener('DOMContentLoaded', () => showSection('profile'));
    </script>
</body>
</html>