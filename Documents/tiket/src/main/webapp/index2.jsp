<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Cek Session (PHP: session_start + isset)
    String usernameSession = (String) session.getAttribute("user");
    // Karena di process_login kamu set 'user', kita pakai itu sebagai kunci login
    if (usernameSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Ambil detail user dari Database Postgres (PHP: PDO fetch)
    String dbUrl = "jdbc:postgresql://localhost:5432/db_hype";
    String dbUser = "postgres";
    String dbPass = "ISI_PASSWORD_PGADMIN_LO"; // Ganti sesuai pass kamu

    String userEmail = "";
    String userRole = "";
    
    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        // Ambil semua kolom untuk user yang sedang login
        String sql = "SELECT * FROM users WHERE username = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, usernameSession);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            userEmail = rs.getString("email");
            userRole = rs.getString("role");
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error Loading Profile: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>The Hype Machine - Member Area</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
  <style>
    :root {
      --primary: #1a1a2e;
      --secondary: #16213e;
      --accent: #0f3460;
      --highlight: #e94560;
      --gold: #ffd700;
      --light: #f5f5f5;
    }
    
    html { scroll-behavior: smooth; }
    body { font-family: 'Montserrat', sans-serif; color: var(--light); background-color: var(--primary); }
    h1, h2, h3, h4, h5, h6, .heading-font { font-family: 'Bebas Neue', sans-serif; letter-spacing: 1.5px; }
    
    .slider-track { display: flex; width: max-content; animation: scroll 40s linear infinite; }
    @keyframes scroll { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }
    
    .hover-lift { transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
    .hover-lift:hover { transform: translateY(-8px); box-shadow: 0 20px 40px rgba(0,0,0,0.3); }
    
    .pulse-glow { animation: pulse-glow 3s infinite; }
    @keyframes pulse-glow {
      0%, 100% { box-shadow: 0 0 15px rgba(233, 69, 96, 0.5); }
      50% { box-shadow: 0 0 25px rgba(233, 69, 96, 0.8), 0 0 35px rgba(233, 69, 96, 0.4); }
    }
    
    .welcome-popup { animation: welcomeSlideIn 0.8s ease-out; }
    @keyframes welcomeSlideIn {
      0% { opacity: 0; transform: translateY(-50px) scale(0.8); }
      100% { opacity: 1; transform: translateY(0) scale(1); }
    }
    
    .nav-link { position: relative; overflow: hidden; }
    .nav-link::after { content: ''; position: absolute; bottom: 0; left: 0; width: 0; height: 2px; background: var(--highlight); transition: width 0.3s ease; }
    .nav-link:hover::after { width: 100%; }
    
    .gradient-text { background: linear-gradient(90deg, var(--gold), var(--highlight)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
    .section-divider { height: 2px; background: linear-gradient(90deg, transparent, var(--highlight), transparent); margin: 40px 0; }
    
    .ticket-card { position: relative; overflow: hidden; border-radius: 20px; background: linear-gradient(145deg, var(--secondary), var(--primary)); box-shadow: 0 10px 30px rgba(0,0,0,0.3); transition: all 0.4s ease; }
    .ticket-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 5px; background: linear-gradient(90deg, var(--gold), var(--highlight)); }
    
    .artist-card { position: relative; overflow: hidden; border-radius: 12px; transition: all 0.4s ease; }
    .artist-card::after { content: ''; position: absolute; bottom: 0; left: 0; width: 100%; height: 50%; background: linear-gradient(transparent, rgba(0,0,0,0.7)); border-radius: 12px; }
    .artist-name { position: absolute; bottom: 15px; left: 15px; z-index: 2; color: white; font-weight: 600; font-size: 1.1rem; }
    
    .btn-primary { background: linear-gradient(90deg, var(--highlight), #ff6b8b); color: white; border: none; border-radius: 50px; padding: 12px 30px; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 5px 15px rgba(233, 69, 96, 0.3); }
    .btn-secondary { background: transparent; color: var(--light); border: 2px solid var(--highlight); border-radius: 50px; padding: 10px 28px; font-weight: 600; transition: all 0.3s ease; }
    
    .glass-effect { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1); }
    .countdown-box { background: rgba(255, 255, 255, 0.08); backdrop-filter: blur(12px); border-radius: 16px; padding: 20px; min-width: 100px; border: 1px solid rgba(255, 255, 255, 0.1); }

    .section-bg { position: relative; overflow: hidden; }
    .section-bg::before { content: ''; position: absolute; inset: 0; z-index: 0; background: linear-gradient(180deg, rgba(26,26,46,0.70), rgba(22,33,62,0.55)); pointer-events: none; }
    .section-bg > * { position: relative; z-index: 10; }
    
    #artistModal { display: none; position: fixed; z-index: 100; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.8); }
    .modal-content { background-color: var(--secondary); margin: 15% auto; padding: 20px; border: 1px solid var(--highlight); width: 80%; max-width: 500px; border-radius: 20px; }
  </style>
</head>
<body class="bg-gray-900 text-white">

  <div id="welcomePopup" class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 welcome-popup">
    <div class="bg-gradient-to-br from-indigo-600 to-purple-700 text-white rounded-3xl p-8 max-w-md mx-4 text-center shadow-2xl">
      <div class="w-20 h-20 bg-yellow-400 rounded-full flex items-center justify-center mx-auto mb-6">
        <i class="fas fa-music text-3xl text-indigo-900"></i>
      </div>
      <h2 class="text-3xl heading-font mb-4">Welcome Back!</h2>
      <p class="text-xl mb-2">Hello, <span class="font-bold text-yellow-400"><%= usernameSession %></span>!</p>
      <p class="text-lg mb-6 opacity-90">Ready to continue your festival experience?</p>
      <button onclick="closeWelcomePopup()" class="bg-yellow-400 text-indigo-900 px-8 py-3 rounded-full font-bold hover:bg-yellow-300 transform hover:scale-105 transition duration-300">
        Let's Go! <i class="fas fa-arrow-right ml-2"></i>
      </button>
    </div>
  </div>

  <header class="fixed top-0 left-0 w-full flex justify-between items-center px-4 md:px-6 py-4 glass-effect z-50">
    <div class="logo transform hover:scale-105 transition duration-300">
      <img src="images/Logo.png" alt="Logo" class="h-10 md:h-14">
    </div>
    
    <nav class="hidden md:flex gap-6 md:gap-8">
      <a href="#home" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300">Home</a>
      <a href="#about" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300">About</a>
      <a href="#lineup" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300">Line Up</a>
      <a href="#ticket" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300">Ticket</a>
       <a href="#rundown" class="nav-link text-white">Rundown</a>
      <a href="#gallery" class="nav-link text-white">Gallery</a>
    </nav>
    
    <div class="hidden md:flex gap-3">
      <button onclick="window.location.href='cart.jsp'" class="btn-primary pulse-glow">
        <i class="fas fa-shopping-cart mr-2"></i>Cart
      </button>
      <button onclick="window.location.href='logout.jsp'" class="bg-red-600 text-white px-4 py-2 rounded-full font-semibold hover:bg-red-700 transition duration-300">
        <i class="fas fa-sign-out-alt mr-2"></i>Logout
      </button>
    </div>
  </header>

  <section id="home" class="relative h-screen overflow-hidden section-bg flex items-center justify-center">
    <div class="absolute inset-0 z-0 bg-gray-900">
        <img src="images/sound1.webp" alt="Main Banner" class="w-full h-full object-cover opacity-40">
    </div>
    <div class="relative z-20 text-center px-4">
      <h1 class="text-5xl md:text-8xl heading-font mb-4">THE HYPE MACHINE</h1>
      <p class="text-xl md:text-2xl mb-8">Welcome Back, <%= usernameSession %>!</p>
      <div class="flex justify-center gap-4">
        <a href="#ticket" class="btn-primary">GET TICKETS</a>
        <a href="#lineup" class="btn-secondary">SEE LINEUP</a>
      </div>
    </div>
  </section>
      
      <section id="countdown" class="relative h-screen min-h-screen overflow-hidden section-bg">
  <video autoplay muted loop playsinline class="absolute inset-0 w-full h-full object-cover z-0">
    <source src="<%= request.getContextPath() %>/videos/bg.mp4" type="video/mp4">
    <img src="images/sound1.webp" alt="Fallback" class="w-full h-full object-cover">
  </video>
  
  <div class="absolute inset-0 bg-black/40 z-5"></div>
    
  <div class="relative z-10 max-w-7xl mx-auto px-4 text-center flex flex-col justify-center h-full">
      <div class="text-center text-white mb-16">
        <h2 class="text-5xl md:text-7xl heading-font mb-6 gradient-text" data-aos="fade-down">THE COUNTDOWN IS ON</h2>
        <p class="text-xl md:text-2xl text-gray-300 max-w-3xl mx-auto" data-aos="fade-up" data-aos-delay="200">Prepare yourself for the ultimate music experience of the year</p>
      </div>
      
      <div class="flex flex-wrap justify-center gap-6 md:gap-10 mb-16" data-aos="zoom-in" data-aos-delay="400">
        <div class="countdown-box">
          <div id="days" class="text-4xl md:text-6xl font-bold text-white mb-2">00</div>
          <div class="text-sm md:text-base text-gray-300 uppercase tracking-wider">Days</div>
        </div>
        <div class="countdown-box">
          <div id="hours" class="text-4xl md:text-6xl font-bold text-white mb-2">00</div>
          <div class="text-sm md:text-base text-gray-300 uppercase tracking-wider">Hours</div>
        </div>
        <div class="countdown-box">
          <div id="minutes" class="text-4xl md:text-6xl font-bold text-white mb-2">00</div>
          <div class="text-sm md:text-base text-gray-300 uppercase tracking-wider">Minutes</div>
        </div>
        <div class="countdown-box">
          <div id="seconds" class="text-4xl md:text-6xl font-bold text-white mb-2">00</div>
          <div class="text-sm md:text-base text-gray-300 uppercase tracking-wider">Seconds</div>
        </div>
      </div>
  </div>
</section>

  <section id="lineup" class="py-20 section-bg">
    <div class="max-w-7xl mx-auto px-4 text-center">
      <h2 class="text-5xl heading-font mb-12 gradient-text" data-aos="fade-up">Line Up</h2>
      <div class="flex flex-wrap justify-center gap-6" data-aos="fade-up">
        <% for(int i=1; i<=10; i++) { %>
          <div class="artist-card cursor-pointer" onclick="showArtistSongs(<%= i %>, 'Artist <%= i %>', ['Hit Song A', 'Hit Song B', 'Exclusive Set'])">
            <img src="images/lineup<%= i %>.png" alt="Artist <%= i %>" class="w-48 h-64 object-cover">
            <div class="artist-name">Artist <%= i %></div>
          </div>
        <% } %>
      </div>
    </div>
  </section>

  <section id="about" class="py-20 section-bg">
    <div class="max-w-6xl mx-auto px-4 grid md:grid-cols-2 gap-12 items-center">
      <div data-aos="fade-right">
        <h2 class="text-5xl heading-font mb-6 gradient-text">About The Hype Machine</h2>
        <p class="text-gray-300 text-lg mb-4">Indonesia's premier music festival experience, bringing together the biggest names in music.</p>
        <div class="grid grid-cols-2 gap-4 mt-8">
          <div class="glass-effect p-4 rounded-lg"><i class="fas fa-users text-highlight"></i> 50,000+ Fans</div>
          <div class="glass-effect p-4 rounded-lg"><i class="fas fa-music text-highlight"></i> 50+ Artists</div>
        </div>
      </div>
      <div class="grid grid-cols-2 gap-4" data-aos="fade-left">
        <img src="images/p1.png" class="rounded-xl hover-lift">
        <img src="images/p2.png" class="rounded-xl hover-lift mt-8">
      </div>
    </div>
  </section>

  <section id="ticket" class="py-20 section-bg">
    <div class="max-w-7xl mx-auto px-4 text-center">
      <h2 class="text-5xl heading-font mb-12 gradient-text">Tickets</h2>
      <div class="grid md:grid-cols-3 gap-8">
        <% 
          // Data: {Gambar, Label, Harga, Fitur, ID_Konser}
          String[][] ticketData = {
            {"images/D1.png", "DAY 1", "IDR 350K", "General Access, Standard Stage", "1"},
            {"images/D2.png", "DAY 2", "IDR 750K", "VIP Access, Premium View, Free Drink", "2"},
            {"images/D3.png", "DAY 3", "IDR 1.5M", "VVIP Access, Backstage Tour, Meet & Greet", "3"}
          };
          for(int i=0; i<3; i++) { 
        %>
          <div class="ticket-card flex flex-col" data-aos="zoom-in">
            <img src="<%= ticketData[i][0] %>" class="w-full h-auto">
            <div class="p-6 flex-grow">
              <h3 class="text-2xl font-bold mb-2"><%= ticketData[i][1] %></h3>
              <p class="text-xl text-highlight font-bold mb-4"><%= ticketData[i][2] %></p>
              <ul class="text-left text-sm text-gray-400 mb-6">
                <% for(String feature : ticketData[i][3].split(", ")) { %>
                  <li><i class="fas fa-check text-green-500 mr-2"></i> <%= feature %></li>
                <% } %>
              </ul>
              
              <%-- FUNGSI TOMBOL: Langsung kirim ID ke cart.jsp --%>
              <button onclick="window.location.href='cart.jsp?action=add&id=<%= ticketData[i][4] %>'" class="btn-primary w-full">
                ADD TO CART
              </button>
            </div>
          </div>
        <% } %>
      </div>
    </div>
</section>

  <section id="rundown" class="py-20 section-bg text-center">
    <h2 class="text-5xl heading-font mb-12 gradient-text">Rundown</h2>
    <div class="max-w-4xl mx-auto glass-effect p-4 rounded-2xl">
      <img src="images/Rundown.png" alt="Rundown Schedule" class="w-full rounded-xl">
    </div>
  </section>

  <section id="gallery" class="py-20 section-bg text-center overflow-hidden">
    <h2 class="text-5xl heading-font mb-12 gradient-text">Gallery</h2>
    <div class="slider-track">
      <% for(int j=0; j<2; j++) { // Duplicate for infinite scroll %>
        <% for(int i=1; i<=10; i++) { %>
          <div class="mx-2"><img src="images/p<%= i %>.png" class="w-72 h-80 object-cover rounded-xl shadow-2xl"></div>
        <% } %>
      <% } %>
    </div>
  </section>

  <footer class="py-16 px-6 bg-black/50 text-center">
    <h4 class="gradient-text text-3xl heading-font mb-4">The Hype Machine</h4>
    <p class="text-gray-400 italic">"More Than A Scene. It's The Engine of Noise."</p>
    <div class="flex justify-center gap-6 mt-8">
      <a href="#"><i class="fab fa-instagram text-2xl"></i></a>
      <a href="#"><i class="fab fa-youtube text-2xl"></i></a>
    </div>
    <p class="mt-8 text-xs text-gray-600">© 2026 The Hype Machine. Jakarta, Indonesia.</p>
  </footer>

  <div id="artistModal" class="modal">
    <div class="modal-content">
      <span class="close">&times;</span>
      <h2 id="modalArtistName" class="text-3xl heading-font gradient-text mb-4"></h2>
      <ul id="modalSongsList" class="space-y-2"></ul>
    </div>
  </div>
    
  <div id="artistModal">
    <div class="modal-content text-white">
      <h2 id="modalName" class="text-3xl heading-font mb-4"></h2>
      <p>Performance details coming soon!</p>
      <button onclick="document.getElementById('artistModal').style.display='none'" class="mt-6 btn-secondary">Close</button>
    </div>
  </div>

<script>
    // 1. Inisialisasi AOS (Animation On Scroll)
    // Digabung jadi satu agar tidak redundan
    AOS.init({ 
        duration: 1000, 
        once: true,
        offset: 100 
    });

    // 2. Welcome Popup Logic
    function closeWelcomePopup() {
        const popup = document.getElementById('welcomePopup');
        if (popup) {
            // Tambahkan efek fade out sebelum hilang
            popup.style.opacity = '0';
            setTimeout(() => {
                popup.style.display = 'none';
            }, 500);
        }
    }

    // Auto close popup setelah 5 detik
    setTimeout(closeWelcomePopup, 5000);

    // 3. Countdown Logic (3 Minggu / 21 Hari dari Sekarang)
    // Kita set target: Waktu sekarang + 21 hari
    const eventTime = new Date().getTime() + (21 * 24 * 60 * 60 * 1000);

    function updateTimer() {
        const now = new Date().getTime();
        const diff = eventTime - now;

        if (diff > 0) {
            const d = Math.floor(diff / (1000 * 60 * 60 * 24));
            const h = Math.floor((diff / (1000 * 60 * 60)) % 24);
            const m = Math.floor((diff / 1000 / 60) % 60);
            const s = Math.floor((diff / 1000) % 60);

            // Update ke HTML dengan format padding 0 (contoh: 09 bukannya 9)
            document.getElementById('days').innerText = d.toString().padStart(2, '0');
            document.getElementById('hours').innerText = h.toString().padStart(2, '0');
            document.getElementById('minutes').innerText = m.toString().padStart(2, '0');
            document.getElementById('seconds').innerText = s.toString().padStart(2, '0');
        } else {
            // Jika waktu habis, tampilkan 00
            document.querySelectorAll('.countdown-box div[id]').forEach(el => el.innerText = "00");
        }
    }

    // Jalankan timer setiap detik dan panggil sekali di awal
    setInterval(updateTimer, 1000);
    updateTimer();

    // 4. Modal Artist Logic
    const modal = document.getElementById("artistModal");
    const closeBtn = document.querySelector(".close");

    // Tutup lewat tombol X
    if (closeBtn) {
        closeBtn.onclick = () => {
            modal.style.opacity = '0';
            setTimeout(() => modal.style.display = "none", 300);
        };
    }

    // Tutup lewat klik area luar modal
    window.onclick = (e) => { 
        if (e.target == modal) {
            modal.style.opacity = '0';
            setTimeout(() => modal.style.display = "none", 300);
        }
    };

    function showArtistSongs(id, name, songs) {
        const artistNameEl = document.getElementById("modalArtistName");
        const listEl = document.getElementById("modalSongsList");

        if (artistNameEl && listEl) {
            artistNameEl.innerText = name;
            
            // Konversi ke array jika data yang masuk berupa string dipisah koma
            const songArray = Array.isArray(songs) ? songs : songs.split(',');

            listEl.innerHTML = songArray.map(s => `
                <li class="bg-white/10 p-4 rounded-xl border border-white/5 flex items-center transform transition hover:translate-x-2 hover:bg-white/20">
                    <i class="fas fa-play-circle text-yellow-400 mr-3 text-xl"></i>
                    <span class="font-semibold tracking-wide">${s.trim()}</span>
                </li>
            `).join('');

            // Tampilkan modal dengan transisi
            modal.style.display = "flex";
            setTimeout(() => modal.style.opacity = '1', 10);
        }
    }
    
    function addToCart(concertId) {
    // Kita arahkan ke cart.jsp sambil bawa ID konser
    // Contoh: cart.jsp?action=add&id=1
    window.location.href = "cart.jsp?action=add&id=" + concertId;
}
</script>
</body>
</html>