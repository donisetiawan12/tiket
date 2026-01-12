<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Cek Sesi (PHP: session_start)
    if (session.getAttribute("user_id") != null) {
        response.sendRedirect("index2.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>The Hype Machine - Premium Music Experience</title>
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
    @keyframes pulse-glow { 0%, 100% { box-shadow: 0 0 15px rgba(233, 69, 96, 0.5); } 50% { box-shadow: 0 0 25px rgba(233, 69, 96, 0.8), 0 0 35px rgba(233, 69, 96, 0.4); } }
    
    .modal { display: none; position: fixed; z-index: 100; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.85); overflow: auto; backdrop-filter: blur(5px); }
    .modal-content { background: linear-gradient(145deg, var(--secondary), var(--primary)); margin: 10% auto; padding: 30px; border: none; width: 90%; max-width: 500px; border-radius: 16px; position: relative; }
    .close { color: #aaa; position: absolute; top: 15px; right: 20px; font-size: 28px; font-weight: bold; cursor: pointer; }
    .close:hover { color: var(--highlight); }
    
    .countdown-box { background: rgba(255, 255, 255, 0.08); backdrop-filter: blur(12px); border-radius: 16px; padding: 20px; min-width: 100px; border: 1px solid rgba(255, 255, 255, 0.1); }
    .nav-link { position: relative; overflow: hidden; }
    .nav-link::after { content: ''; position: absolute; bottom: 0; left: 0; width: 0; height: 2px; background: var(--highlight); transition: width 0.3s ease; }
    .nav-link:hover::after { width: 100%; }
    .gradient-text { background: linear-gradient(90deg, var(--gold), var(--highlight)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
    .section-divider { height: 2px; background: linear-gradient(90deg, transparent, var(--highlight), transparent); margin: 40px 0; }
    
    .ticket-card { position: relative; overflow: hidden; border-radius: 20px; background: linear-gradient(145deg, var(--secondary), var(--primary)); transition: all 0.4s ease; }
    .ticket-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 5px; background: linear-gradient(90deg, var(--gold), var(--highlight)); }
    .artist-card { position: relative; overflow: hidden; border-radius: 12px; transition: all 0.4s ease; }
    .artist-card::after { content: ''; position: absolute; bottom: 0; left: 0; width: 100%; height: 50%; background: linear-gradient(transparent, rgba(0,0,0,0.7)); border-radius: 12px; }
    .artist-name { position: absolute; bottom: 15px; left: 15px; z-index: 2; color: white; font-weight: 600; }
    
    .btn-primary { background: linear-gradient(90deg, var(--highlight), #ff6b8b); color: white; border-radius: 50px; padding: 12px 30px; font-weight: 600; transition: 0.3s; }
    .btn-secondary { background: transparent; color: var(--light); border: 2px solid var(--highlight); border-radius: 50px; padding: 10px 28px; font-weight: 600; transition: 0.3s; }
    .glass-effect { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1); }
    .section-bg { position: relative; overflow: hidden; }
    .section-bg::before { content: ''; position: absolute; inset: 0; z-index: 0; background: linear-gradient(180deg, rgba(26,26,46,0.7), rgba(22,33,62,0.55)); pointer-events: none; }
    .section-bg > * { position: relative; z-index: 10; }
  </style>
</head>
<body class="bg-gray-900 text-white">

  <header class="fixed top-0 left-0 w-full flex justify-between items-center px-4 md:px-6 py-4 glass-effect z-50">
    <div class="logo logo-glow"><img src="images/Logo.png" alt="Logo" class="h-10 md:h-14"></div>
    <nav class="hidden md:flex gap-6 md:gap-8">
      <a href="#home" class="nav-link text-white">Home</a>
      <a href="#about" class="nav-link text-white">About</a>
      <a href="#lineup" class="nav-link text-white">Line Up</a>
      <a href="#ticket" class="nav-link text-white">Ticket</a>
      <a href="#rundown" class="nav-link text-white">Rundown</a>
      <a href="#gallery" class="nav-link text-white">Gallery</a>
    </nav>
    <div class="hidden md:flex gap-3">
      <button onclick="window.location.href='login.jsp'" class="btn-primary">Buy Ticket</button>
      <button onclick="window.location.href='login.jsp'" class="btn-secondary">Account</button>
    </div>
  </header>
    
    <%
    String status = request.getParameter("status");
    if("loggedout".equals(status)) {
        out.println("<p style='color: yellow; text-align: center;'>Kamu telah berhasil keluar.</p>");
    }
    %>

  <section id="home" class="relative h-screen flex items-center justify-center section-bg">
    <div class="absolute inset-0 z-0"><img src="images/sound1.webp" class="w-full h-full object-cover opacity-50"></div>
    <div class="text-center">
      <h1 class="text-6xl md:text-8xl heading-font mb-4">THE HYPE MACHINE</h1>
      <p class="text-xl md:text-2xl mb-8 text-gray-200">Where Music Meets Extraordinary Experience</p>
      <div class="flex justify-center gap-4">
        <button onclick="window.location.href='#ticket'" class="btn-primary px-10">GET TICKETS</button>
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
          String[][] ticketData = {
            {"images/D1.png", "DAY 1", "IDR 350K", "General Access, Standard Stage"},
            {"images/D2.png", "DAY 2", "IDR 750K", "VIP Access, Premium View, Free Drink"},
            {"images/D3.png", "DAY 3", "IDR 1.5M", "VVIP Access, Backstage Tour, Meet & Greet"}
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
              <button onclick="window.location.href='login.jsp'" class="btn-primary w-full">BUY NOW</button>
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

 <script>
    AOS.init({ duration: 1000, once: true });

    // 1. Countdown Logic (Set untuk 21 hari dari sekarang)
    // Kita hitung waktu sekarang + (21 hari * 24 jam * 60 menit * 60 detik * 1000 milidetik)
    const eventTime = new Date().getTime() + (21 * 24 * 60 * 60 * 1000);

    function updateTimer() {
        const now = new Date().getTime();
        const diff = eventTime - now;

        if (diff > 0) {
            // Hitung kalkulasi waktu
            const d = Math.floor(diff / (1000 * 60 * 60 * 24));
            const h = Math.floor((diff / (1000 * 60 * 60)) % 24);
            const m = Math.floor((diff / 1000 / 60) % 60);
            const s = Math.floor((diff / 1000) % 60);

            // Update ke HTML dengan format 2 digit (01, 02, dst)
            document.getElementById('days').innerText = d < 10 ? "0" + d : d;
            document.getElementById('hours').innerText = h < 10 ? "0" + h : h;
            document.getElementById('minutes').innerText = m < 10 ? "0" + m : m;
            document.getElementById('seconds').innerText = s < 10 ? "0" + s : s;
        } else {
            // Kalau waktu habis
            document.getElementById('days').innerText = "00";
            document.getElementById('hours').innerText = "00";
            document.getElementById('minutes').innerText = "00";
            document.getElementById('seconds').innerText = "00";
        }
    }
    
    // Jalankan setiap detik
    setInterval(updateTimer, 1000);
    updateTimer(); // Panggil langsung supaya angka gak kedip 00 pas reload

    // 2. Modal Logic (Tetap rapih)
    const modal = document.getElementById("artistModal");
    const closeBtn = document.querySelector(".close");
    
    if (closeBtn) {
        closeBtn.onclick = () => {
            modal.style.display = "none";
        };
    }

    window.onclick = (e) => { 
        if (e.target == modal) {
            modal.style.display = "none"; 
        }
    };

    function showArtistSongs(id, name, songs) {
        document.getElementById("modalArtistName").innerText = name;
        const list = document.getElementById("modalSongsList");
        
        // Memastikan songs adalah array, kalau string kita split (antisipasi data dari DB)
        const songArray = Array.isArray(songs) ? songs : songs.split(',');
        
        list.innerHTML = songArray.map(s => `
            <li class="bg-white/10 p-4 rounded-xl border border-white/5 flex items-center transform transition hover:translate-x-2">
                <i class="fas fa-play-circle text-yellow-400 mr-3 opacity-70"></i> 
                <span class="font-medium">${s.trim()}</span>
            </li>
        `).join('');
        
        modal.style.display = "flex"; // Pakai flex biar modal ke tengah
    }
</script>
</body>
</html>