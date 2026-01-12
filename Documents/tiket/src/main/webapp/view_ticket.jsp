<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Ambil ID Tiket dari URL (Format: IDCart-Urutan)
    String rawId = request.getParameter("tid");
    if (rawId == null || rawId.isEmpty()) {
        out.println("Tiket tidak valid!");
        return;
    }

    // Pecah ID untuk ambil cart_id-nya saja
    String cartId = rawId.contains("-") ? rawId.split("-")[0] : rawId;

    // Inisialisasi variabel data
    String ownerName = "-", concertName = "-", concertDate = "-", venue = "Gelora Bung Karno, Jakarta"; 

    // 2. Tarik data dari Database
    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/db_hype", "postgres", "admin");

        String sql = "SELECT u.username, c.name, c.date " +
                     "FROM cart ca " +
                     "JOIN users u ON ca.user_id = u.id " +
                     "JOIN concerts c ON ca.concert_id = c.id " +
                     "WHERE ca.id = ?";
        
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(cartId));
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            ownerName = rs.getString("username");
            concertName = rs.getString("name");
            concertDate = rs.getString("date");
        }
        conn.close();
    } catch (Exception e) {
        // Jika error database, tampilkan log tapi tetap lanjut
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Ticket - <%= ownerName %></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .heading-font { font-family: 'Bebas Neue', sans-serif; letter-spacing: 1px; }
        body { background: #1e1b4b; font-family: 'Inter', sans-serif; }
        .ticket-cut { position: relative; }
        .ticket-cut::before, .ticket-cut::after {
            content: '';
            position: absolute;
            width: 30px;
            height: 30px;
            background: #1e1b4b;
            border-radius: 50%;
            top: 50%;
            transform: translateY(-50%);
        }
        .ticket-cut::before { left: -15px; }
        .ticket-cut::after { right: -15px; }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-4">
    <div class="max-w-sm w-full bg-white rounded-3xl overflow-hidden shadow-2xl border-4 border-yellow-400">
        <div class="bg-indigo-900 text-white p-6 text-center">
            <h1 class="text-4xl heading-font mb-1 text-yellow-400">THE HYPE MACHINE</h1>
            <p class="text-[10px] tracking-[0.2em] opacity-80 uppercase font-bold">Official Digital Entry Ticket</p>
        </div>

        <div class="p-6 pb-4 border-b border-dashed border-gray-200">
            <div class="grid grid-cols-2 gap-4 text-left">
                <div>
                    <p class="text-[10px] text-gray-400 font-bold uppercase">Pemilik Tiket</p>
                    <p class="text-sm font-bold text-indigo-900"><%= ownerName %></p>
                </div>
                <div class="text-right">
                    <p class="text-[10px] text-gray-400 font-bold uppercase">Venue</p>
                    <p class="text-sm font-bold text-indigo-900"><%= venue %></p>
                </div>
                <div class="col-span-2">
                    <p class="text-[10px] text-gray-400 font-bold uppercase">Acara & Tanggal</p>
                    <p class="text-sm font-bold text-indigo-900 uppercase"><%= concertName %></p>
                    <p class="text-xs text-indigo-700"><%= concertDate %></p>
                </div>
            </div>
        </div>

        <div class="p-8 text-center ticket-cut bg-gray-50">
            <div class="mb-4">
                <span class="bg-green-500 text-white px-4 py-1 rounded-full text-[10px] font-black tracking-widest uppercase">
                    <i class="fas fa-check-circle mr-1"></i> Valid / Lunas
                </span>
            </div>

            <div class="bg-white p-4 rounded-2xl inline-block shadow-inner border border-gray-100 mb-6">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=VALID-TICKET-<%= rawId %>" 
                     alt="QR Code" class="w-44 h-44 mx-auto">
            </div>

            <div class="space-y-1 text-indigo-900">
                <p class="text-[10px] text-gray-400 font-bold uppercase">Kode Unik Tiket</p>
                <p class="text-xl font-mono font-black tracking-tighter">KODE : HYPE-<%= rawId %></p>
            </div>
        </div>

        <div class="px-8 py-4 text-center">
            <p class="text-[9px] text-gray-400 font-medium italic">
                Pegang layar ini untuk ditunjukkan kepada petugas di gate masuk. 
                Dilarang membagikan kode QR ini kepada siapapun.
            </p>
        </div>

        <div class="bg-indigo-50 p-4 text-center border-t border-gray-100">
            <button onclick="window.print()" class="flex items-center justify-center w-full space-x-2 text-indigo-600 text-xs font-bold uppercase">
                <i class="fas fa-download"></i>
                <span>Simpan Tiket (PDF)</span>
            </button>
        </div>
    </div>
</body>
</html>