<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // 1. CEK SESSION
    Object uidObj = session.getAttribute("user_id");
    if (uidObj == null) { response.sendRedirect("login.jsp"); return; }
    int userId = (Integer) uidObj;

    // 2. CONFIG DB
    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres";
    String dbPass = "admin";

    // 3. DEKLARASI VARIABEL
    List<Map<String, Object>> cartItems = new ArrayList<>();
    List<Map<String, Object>> concerts = new ArrayList<>(); 
    double totalBayar = 0; 
    int totalItem = 0;     

    Connection conn = null;
    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // --- AMBIL DATA KERANJANG (PENDING) ---
        String sqlCart = "SELECT ca.id, c.name, c.price, ca.quantity FROM cart ca " +
                         "JOIN concerts c ON ca.concert_id = c.id " +
                         "WHERE ca.user_id = ? AND ca.status = 'PENDING'";
        PreparedStatement psCart = conn.prepareStatement(sqlCart);
        psCart.setInt(1, userId);
        ResultSet rsCart = psCart.executeQuery();

        while (rsCart.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("cart_id", rsCart.getInt("id"));
            item.put("name", rsCart.getString("name"));
            item.put("price", rsCart.getDouble("price"));
            item.put("qty", rsCart.getInt("quantity"));
            
            double subtotal = rsCart.getDouble("price") * rsCart.getInt("quantity");
            totalBayar += subtotal;
            totalItem += rsCart.getInt("quantity");
            cartItems.add(item);
        }

        // --- AMBIL DATA SEMUA KONSER ---
        String sqlAll = "SELECT * FROM concerts ORDER BY day_number ASC";
        PreparedStatement psAll = conn.prepareStatement(sqlAll);
        ResultSet rsAll = psAll.executeQuery();
        while(rsAll.next()){
            Map<String, Object> c = new HashMap<>();
            c.put("id", rsAll.getInt("id")); // Tambahin ID buat form beli
            c.put("name", rsAll.getString("name"));
            c.put("day", rsAll.getInt("day_number"));
            c.put("price", rsAll.getDouble("price"));
            c.put("total", 500); 
            c.put("sold", 0);    
            concerts.add(c);
        }
    } catch (Exception e) {
        out.println("");
    } 
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buy Ticket - The Hype Machine</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&display=swap" rel="stylesheet">
    
    <style>
        h1, h2, h3, h4, h5, h6, .heading-font {
            font-family: 'Bebas Neue', sans-serif;
            letter-spacing: 1px;
        }
        .hover-lift { transition: all 0.3s ease; }
        .hover-lift:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.15); }
        .pulse-glow { animation: pulse-glow 2s infinite; }
        @keyframes pulse-glow {
            0%, 100% { box-shadow: 0 0 15px rgba(255, 215, 0, 0.6); }
            50% { box-shadow: 0 0 25px rgba(255, 215, 0, 0.9); }
        }
        .lineup-day {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            margin-bottom: 12px;
            font-weight: bold;
        }
        .artist-list { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 16px; }
        .artist-tag {
            background: rgba(255,255,255,0.2);
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 12px;
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
        }
        .cart-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #facc15;
            color: #1e1b4b;
            font-size: 10px;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 99px;
            border: 2px solid white;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-indigo-50 to-purple-50 min-h-screen">

    <header class="fixed top-0 left-0 w-full flex justify-between items-center px-4 md:px-6 py-3 bg-white/95 backdrop-blur-lg z-40 shadow-lg">
        <div class="logo transform hover:scale-105 transition duration-300">
            <a href="index.jsp"><img src="images/Logo.png" alt="Logo" class="h-10 md:h-14"></a>
        </div>
        <div class="flex gap-3 items-center">
            <div class="relative group">
                <button class="relative bg-indigo-600 text-white p-3 rounded-full hover:bg-indigo-700 transition shadow-lg">
                    <i class="fas fa-shopping-cart"></i>
                    <span class="cart-badge"><%= totalItem %></span>
                </button>

                <div class="absolute right-0 mt-2 w-72 bg-white rounded-2xl shadow-2xl border border-indigo-50 p-4 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 z-50">
                    <h4 class="heading-font text-indigo-900 border-b pb-2 mb-3 tracking-widest">Item Keranjang</h4>

                    <div class="max-h-60 overflow-y-auto">
                        <% if(cartItems.isEmpty()) { %>
                            <p class="text-center text-gray-400 py-4 text-xs">Keranjang kosong</p>
                        <% } else { 
                            for(Map<String, Object> item : cartItems) { %>
                            <div class="flex justify-between items-center mb-3 bg-indigo-50/50 p-2 rounded-lg border border-indigo-100">
                                <div class="flex-1">
                                    <p class="text-[10px] font-black text-indigo-900 uppercase"><%= item.get("name") %></p>
                                    <p class="text-[9px] text-gray-500 font-semibold">
                                        <%= item.get("qty") %> x Rp <%= String.format("%,.0f", item.get("price")) %>
                                    </p>
                                </div>
                                <a href="remove_item.jsp?cart_id=<%= item.get("cart_id") %>" class="text-red-400 hover:text-red-600 ml-2 transition">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </div>
                        <% } } %>
                    </div>

                    <div class="border-t pt-3 mt-2">
                        <div class="flex justify-between items-center mb-3">
                            <span class="text-[10px] font-bold text-gray-400 uppercase">Total</span>
                            <span class="text-sm font-black text-indigo-900">Rp <%= String.format("%,.0f", totalBayar) %></span>
                        </div>

                        <% if(totalBayar > 0) { %>
                            <button onclick="openModal()" class="w-full bg-indigo-600 text-white py-2.5 rounded-xl font-bold hover:bg-indigo-700 transition shadow-md uppercase text-[10px] tracking-wider flex items-center justify-center gap-2">
                                <i class="fas fa-credit-card"></i> Bayar Sekarang
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>
             <a href="dashboard_user.jsp" class="bg-indigo-100 text-indigo-900 px-3 py-2 rounded-full font-bold hover:bg-indigo-200 transition text-xs md:text-sm">
                <i class="fas fa-user mr-1"></i> Profile
            </a>
            <a href="logout.jsp" class="bg-red-600 text-white px-4 py-2 rounded-full font-semibold text-sm">Logout</a>
        </div>
    </header>

    <div class="pt-24 pb-12 px-4 max-w-7xl mx-auto">
        <%
            String status = request.getParameter("status");
            if("success".equals(status)) {
        %>
            <div class="max-w-4xl mx-auto mb-6 bg-green-500 text-white p-4 rounded-xl shadow-lg flex items-center justify-between">
                <div class="flex items-center">
                    <i class="fas fa-check-circle mr-3"></i>
                    <span>Tiket berhasil ditambahkan ke keranjang!</span>
                </div>
                <button onclick="this.parentElement.remove()" class="text-white">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        <% } %>
        <h1 class="text-4xl md:text-5xl heading-font text-center mb-2 text-indigo-900 uppercase">Buy Ticket</h1>
        <p class="text-lg text-center text-gray-600 mb-8">Kelola tiket konser Anda</p>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            <div class="lg:col-span-2 space-y-8">
                
                <div class="bg-white rounded-2xl shadow-2xl p-6 hover-lift">
                    <h3 class="text-2xl heading-font mb-6 text-indigo-900">Lineup Artis</h3>
                    
                    <% 
                    for(int i=0; i < concerts.size(); i++) { 
                        String names = (String) concerts.get(i).get("name");
                        String[] artists = names.split(","); 
                    %>
                    <div class="mb-6">
                        <div class="lineup-day">DAY <%= i+1 %></div>
                        <div class="artist-list bg-indigo-600/10 p-4 rounded-xl"> <% for(String a : artists) { %>
                                <span class="artist-tag bg-indigo-500/80 uppercase font-bold"><%= a.trim() %></span>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>

                <div class="bg-white rounded-2xl shadow-2xl p-6 hover-lift">
                    <h3 class="text-2xl heading-font mb-6 text-indigo-900">Pilih Tiket Konser</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <% 
                        int counter = 1; 
                        for(Map<String, Object> c : concerts) { 
                        %>
                        <div class="bg-gradient-to-br from-indigo-50 to-white border-2 border-indigo-100 rounded-xl p-4 hover-lift">
                            <h4 class="text-xl font-bold text-indigo-900 mb-1 uppercase">DAY <%= counter++ %></h4>

                            <div class="space-y-0.5 text-sm text-gray-600 mb-4">
                                <% 
                                    double harga = (c.get("price") != null) ? (Double)c.get("price") : 0.0;
                                    int total = (c.get("total") != null) ? (Integer)c.get("total") : 0;
                                    int sold = (c.get("sold") != null) ? (Integer)c.get("sold") : 0;
                                %>
                                <p>💰 Harga: Rp <%= String.format("%,.0f", harga) %></p>
                                <p class="text-[12px] opacity-70">🎫 Sisa Tiket: <%= (total - sold) %></p>
                            </div>

                            <form action="process_cart.jsp" method="GET" class="flex gap-2 items-center">
                                <input type="hidden" name="concert_id" value="<%= c.get("id") %>">
                                <input type="number" name="quantity" value="1" min="1" 
                                       class="flex-1 h-9 border-2 border-indigo-200 rounded-lg px-3 font-bold focus:border-indigo-500 outline-none text-xs bg-white">

                                <button type="submit" class="h-9 bg-indigo-600 text-white px-4 rounded-lg hover:bg-indigo-700 transition flex items-center justify-center gap-2">
                                    <i class="fas fa-plus text-[10px]"></i>
                                    <span class="text-[11px] font-bold uppercase tracking-tighter">Tambah</span>
                                </button>
                            </form>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

           <div class="lg:col-span-1">
                <div class="bg-gradient-to-br from-indigo-600 to-purple-700 text-white rounded-2xl shadow-2xl p-6 sticky top-32 hover-lift">
                    <h3 class="text-2xl heading-font mb-6 uppercase">Ringkasan Pembelian</h3>

                    <div class="space-y-4 mb-6">
                        <div class="flex justify-between items-center text-sm border-b border-white/10 pb-2">
                            <span>Jumlah Tiket:</span>
                            <span class="font-bold"><%= totalItem %> Pcs</span>
                        </div>

                        <div class="flex justify-between items-center text-lg border-b border-white/20 pb-2">
                            <span>Total:</span>
                            <span class="font-bold text-2xl text-yellow-400">
                                Rp <%= String.format("%,.0f", totalBayar) %>
                            </span>
                        </div>

                        <div class="flex justify-between items-center">
                            <span>Metode:</span>
                            <span class="font-semibold bg-white/20 px-3 py-1 rounded-lg">QRIS</span>
                        </div>
                    </div>

                    <% if(totalBayar > 0) { %>
                        <button onclick="openModal()" class="w-full bg-yellow-400 text-indigo-900 py-4 rounded-xl font-bold hover:bg-yellow-300 transition pulse-glow text-lg uppercase">
                            Bayar Sekarang
                        </button>
                    <% } else { %>
                        <button disabled class="w-full bg-gray-400 text-white py-4 rounded-xl font-bold cursor-not-allowed text-lg uppercase">
                            Keranjang Kosong
                        </button>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
                
    <div id="paymentModal" class="fixed inset-0 bg-black/80 z-[100] hidden flex items-center justify-center p-4 backdrop-blur-sm">
    <div class="bg-white rounded-3xl max-w-md w-full p-8 shadow-2xl relative">
        <span onclick="closeModal()" class="absolute top-4 right-6 text-3xl text-gray-400 hover:text-red-500 cursor-pointer transition">&times;</span>
        
        <h2 class="text-3xl heading-font mb-6 text-center text-indigo-900 uppercase tracking-wider">Pembayaran QRIS</h2>
        
        <div class="text-center space-y-6">
            <div class="bg-indigo-50 rounded-2xl p-5 border-2 border-indigo-100">
                <p class="text-xs font-black text-indigo-400 uppercase tracking-widest mb-1">Total Pembayaran:</p>
                <p class="text-3xl font-black text-indigo-900">
                    Rp <%= String.format("%,.0f", totalBayar) %>
                </p>
            </div>
            
            <p class="text-gray-600 text-sm font-medium">Scan kode QR di bawah untuk membayar:</p>
            
            <div class="bg-white p-4 rounded-2xl inline-block border-2 border-gray-100 shadow-inner">
                <img id="qrisImage" 
                     src="https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=PAY-HYPE-<%= userId %>-<%= (int)totalBayar %>" 
                     alt="QRIS Code" 
                     class="w-56 h-56 mx-auto">
            </div>
            
            <p class="text-[11px] text-gray-400 leading-relaxed px-4">
                Pastikan nominal transfer sesuai. Setelah pembayaran selesai, klik tombol <span class="text-indigo-600 font-bold uppercase">Konfirmasi</span> di bawah.
            </p>
        </div>
        
        <div class="flex gap-3 mt-8">
            <button type="button" 
                    class="flex-1 bg-gray-100 text-gray-500 py-4 rounded-2xl font-bold hover:bg-gray-200 transition duration-300 uppercase text-xs" 
                    onclick="closeModal()">
                Tutup
            </button>
            <a href="process_payment.jsp" 
               class="flex-1 bg-green-600 text-white py-4 rounded-2xl font-bold hover:bg-green-700 transform hover:scale-105 transition duration-300 shadow-lg shadow-green-200 uppercase text-xs text-center flex items-center justify-center">
                Konfirmasi Pembayaran
            </a>
        </div>
    </div>
</div>

<script>
    function openModal() { document.getElementById('paymentModal').classList.remove('hidden'); }
    function closeModal() { document.getElementById('paymentModal').classList.add('hidden'); }
</script>

<%
    if (conn != null) {
        try { conn.close(); } catch (SQLException e) { }
    }
%>
</body>
</html>