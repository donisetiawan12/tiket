<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role").toString())) {
        response.sendRedirect("login.jsp");
        return;
    }
    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres";
    String dbPass = "admin"; 
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Hype Admin - Manage Events</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&display=swap" rel="stylesheet">
    <style>
        .font-bebas { font-family: 'Bebas Neue', sans-serif; }
        input::-webkit-outer-spin-button, input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
    </style>
</head>
<body class="bg-slate-900 text-white min-h-screen">

    <nav class="bg-slate-800 border-b border-slate-700 px-8 py-4 flex justify-between items-center sticky top-0 z-40">
        <h1 class="text-3xl font-bebas tracking-widest text-indigo-500">HYPE ADMIN PANEL</h1>
        <div class="flex items-center gap-6">
            <span class="text-sm text-slate-400">Admin: <strong class="text-white uppercase"><%= session.getAttribute("user") %></strong></span>
            <a href="logout.jsp" class="bg-red-600 hover:bg-red-700 px-4 py-2 rounded-lg font-bold text-sm transition">LOGOUT</a>
        </div>
    </nav>

    <div class="p-8 max-w-7xl mx-auto">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
            <div class="lg:col-span-1">
                <div class="bg-slate-800 p-6 rounded-2xl border border-slate-700 shadow-xl sticky top-28">
                    <h2 class="text-xl font-bebas mb-6 text-indigo-400 text-center">Add New Event</h2>
                    <form action="save_concert.jsp" method="POST" class="space-y-4">
                        <div>
                            <label class="text-[10px] uppercase text-slate-500 font-bold">Event Name</label>
                            <input type="text" name="name" class="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl outline-none focus:border-indigo-500" placeholder="Tulus, Sheila On 7, Maliq & D'essentials" required>
                        </div>
                        <div>
                            <label class="text-[10px] uppercase text-slate-500 font-bold">Price (IDR)</label>
                            <input type="number" name="price" class="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl outline-none focus:border-indigo-500" placeholder="Rp.50.000" required>
                        </div>
                        <div>
                            <label class="text-[10px] uppercase text-slate-500 font-bold">Day Number</label>
                            <input type="number" name="day_number" class="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl outline-none focus:border-indigo-500" placeholder="1" required>
                        </div>
                        <div>
                        <label class="text-[10px] uppercase text-slate-500 font-bold">Event Date</label>
                        <input type="date" name="date" id="edit_date" class="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl outline-none focus:border-yellow-500" required>
                    </div>
                        <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-500 py-3 rounded-xl font-bold transition">Tambahkan Tiket</button>
                    </form>
                </div>
            </div>

            <div class="lg:col-span-3">
                <div class="bg-slate-800 rounded-2xl border border-slate-700 shadow-xl overflow-hidden">
                    <div class="p-6 border-b border-slate-700">
                        <h2 class="text-xl font-bebas text-indigo-400">Active Concerts List</h2>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead class="bg-slate-900 text-slate-400 text-xs uppercase">
                                <tr>
                                    <th class="p-4">Event Details</th>
                                    <th class="p-4 text-center">Price</th>
                                    <th class="p-4 text-center">Date</th>
                                    <th class="p-4 text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-700">
                                <%
                                    try {
                                        Class.forName("org.postgresql.Driver");
                                        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                                        Statement st = conn.createStatement();
                                        // Ambil data urut dari yang lama ke baru (yang baru di bawah)
                                        ResultSet rs = st.executeQuery("SELECT id, name, date, price, day_number FROM concerts ORDER BY id ASC");
                                        while(rs.next()){
                                            String rawDate = rs.getString("date");
                                            // Ambil 10 karakter pertama (YYYY-MM-DD) supaya input type="date" mau nampilin datanya
                                            String safeDate = (rawDate != null && rawDate.length() >= 10) ? rawDate.substring(0, 10) : rawDate;
                                %>
                                <tr class="hover:bg-slate-700/50 transition">
                                    <td class="p-4">
                                        <div class="font-bold text-indigo-100 uppercase"><%= rs.getString("name") %></div>
                                        <div class="text-[10px] text-slate-500 mt-1">Day: <%= rs.getInt("day_number") %></div>
                                    </td>
                                    <td class="p-4 text-center font-bold text-green-400">
                                        Rp <%= String.format("%,.0f", rs.getDouble("price")) %>
                                    </td>
                                    <td class="p-4 text-center text-slate-300 text-sm">
                                        <%= rawDate %>
                                    </td>
                                    <td class="p-4 text-center">
                                        <div class="flex gap-4 justify-center">
                                            <%-- Gunakan safeDate untuk parameter ke-5 --%>
                                            <button onclick="openEditModal('<%= rs.getInt("id") %>', '<%= rs.getString("name").replace("'", "\\'") %>', '<%= rs.getDouble("price") %>', '<%= rs.getInt("day_number") %>', '<%= safeDate %>')" 
                                                    class="text-yellow-500 hover:text-yellow-300 transition text-lg">
                                                <i class="fas fa-edit"></i>
                                            </button> 
                                            <button onclick="confirmDelete(<%= rs.getInt("id") %>)" class="text-red-500 hover:text-red-400 transition text-lg">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                        } 
                                        conn.close(); 
                                    } catch(Exception e) { 
                                        out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>"); 
                                    } 
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

   <div id="editModal" class="hidden fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
    <div class="bg-slate-800 border border-slate-700 w-full max-w-md rounded-2xl p-6 shadow-2xl">
        <h2 class="text-2xl font-bebas text-yellow-400 tracking-wider mb-6">Update Concert</h2>
        <form action="update_concert.jsp" method="POST" class="space-y-4">
            <input type="hidden" name="id" id="edit_id">
            
            <div>
                <label class="text-[10px] uppercase text-slate-500 font-bold ml-1">Event Name</label>
                <input type="text" name="name" id="edit_name" class="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl outline-none focus:border-yellow-500" required>
            </div>

            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="text-[10px] uppercase text-slate-500 font-bold ml-1">Price</label>
                    <input type="number" name="price" id="edit_price" class="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl outline-none focus:border-yellow-500" required>
                </div>
                <div>
                    <label class="text-[10px] uppercase text-slate-500 font-bold ml-1">Day Number</label>
                    <input type="number" name="day_number" id="edit_day_number" class="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl outline-none focus:border-yellow-500" required>
                </div>
            </div>

            <div>
                <label class="text-[10px] uppercase text-slate-500 font-bold ml-1">Event Date</label>
                <input type="date" name="date" id="edit_date" class="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl outline-none focus:border-yellow-500" required>
            </div>

            <div class="flex gap-2 mt-6">
                <button type="button" onclick="closeEditModal()" class="flex-1 bg-slate-700 hover:bg-slate-600 py-3 rounded-xl font-bold transition">CANCEL</button>
                <button type="submit" class="flex-1 bg-yellow-500 hover:bg-yellow-400 text-slate-900 py-3 rounded-xl font-bold transition text-sm">SAVE CHANGES</button>
            </div>
        </form>
    </div>
</div>

   <script>
    function openEditModal(id, name, price, day, date) {
        // Mapping data ke form
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_name').value = name;
        document.getElementById('edit_price').value = price;
        document.getElementById('edit_day_number').value = day;
        
        // Handling input date (pastiin format YYYY-MM-DD)
        const dateInput = document.getElementById('edit_date');
        if(dateInput) {
            dateInput.value = date;
        }
        
        // Tampilkan Modal
        document.getElementById('editModal').classList.remove('hidden');
    }

    function closeEditModal() {
        document.getElementById('editModal').classList.add('hidden');
    }

    function confirmDelete(id) {
        Swal.fire({
            title: 'Hapus Tiket?',
            text: "Data ini bakal ilang permanen dari database!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#334155',
            confirmButtonText: 'Ya, Hapus!'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'delete_concert.jsp?id=' + id;
            }
        })
    }

    // Tangkap Status Notifikasi
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');
    
    if(status === 'add_success') Swal.fire('Berhasil!', 'Konser baru udah dipublish.', 'success');
    if(status === 'update_success') Swal.fire('Updated!', 'Data konser berhasil diubah.', 'success');
    if(status === 'delete_success') Swal.fire('Deleted!', 'Konser udah dihapus.', 'success');
    if(status === 'error') Swal.fire('Gagal!', 'Terjadi kesalahan sistem.', 'error');
</script>
</body>
</html>