<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Logika Sesi PHP: session_start() dan pengecekan user_id
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
    
    html {
      scroll-behavior: smooth;
    }
    
    body {
      font-family: 'Montserrat', sans-serif;
      color: var(--light);
      background-color: var(--primary);
    }
    
    h1, h2, h3, h4, h5, h6, .heading-font {
      font-family: 'Bebas Neue', sans-serif;
      letter-spacing: 1.5px;
    }
    
    .slider-track {
      display: flex;
      width: max-content;
      animation: scroll 40s linear infinite;
    }
    
    @keyframes scroll {
      0% { transform: translateX(0); }
      100% { transform: translateX(-50%); }
    }
    
    .hover-lift {
      transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }
    
    .hover-lift:hover {
      transform: translateY(-8px);
      box-shadow: 0 20px 40px rgba(0,0,0,0.3);
    }
    
    .pulse-glow {
      animation: pulse-glow 3s infinite;
    }
    
    @keyframes pulse-glow {
      0%, 100% { 
        box-shadow: 0 0 15px rgba(233, 69, 96, 0.5); 
      }
      50% { 
        box-shadow: 0 0 25px rgba(233, 69, 96, 0.8), 0 0 35px rgba(233, 69, 96, 0.4); 
      }
    }
    
    .modal {
      display: none;
      position: fixed;
      z-index: 100;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.85);
      overflow: auto;
      backdrop-filter: blur(5px);
    }
    
    .modal-content {
      background: linear-gradient(145deg, var(--secondary), var(--primary));
      margin: 10% auto;
      padding: 30px;
      border: none;
      width: 90%;
      max-width: 500px;
      border-radius: 16px;
      position: relative;
      box-shadow: 0 15px 30px rgba(0,0,0,0.4);
    }
    
    .close {
      color: #aaa;
      position: absolute;
      top: 15px;
      right: 20px;
      font-size: 28px;
      font-weight: bold;
      cursor: pointer;
      transition: color 0.3s;
    }
    
    .close:hover {
      color: var(--highlight);
    }
    
    .countdown-box {
      background: rgba(255, 255, 255, 0.08);
      backdrop-filter: blur(12px);
      border-radius: 16px;
      padding: 20px;
      min-width: 100px;
      border: 1px solid rgba(255, 255, 255, 0.1);
      transition: all 0.3s ease;
    }
    
    .countdown-box:hover {
      background: rgba(255, 255, 255, 0.12);
      transform: translateY(-5px);
    }
    
    .nav-link {
      position: relative;
      overflow: hidden;
    }
    
    .nav-link::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      width: 0;
      height: 2px;
      background: var(--highlight);
      transition: width 0.3s ease;
    }
    
    .nav-link:hover::after {
      width: 100%;
    }
    
    .gradient-text {
      background: linear-gradient(90deg, var(--gold), var(--highlight));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
    
    .section-divider {
      height: 2px;
      background: linear-gradient(90deg, transparent, var(--highlight), transparent);
      margin: 40px 0;
    }
    
    .ticket-card {
      position: relative;
      overflow: hidden;
      border-radius: 20px;
      background: linear-gradient(145deg, var(--secondary), var(--primary));
      box-shadow: 0 10px 30px rgba(0,0,0,0.3);
      transition: all 0.4s ease;
    }
    
    .ticket-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 5px;
      background: linear-gradient(90deg, var(--gold), var(--highlight));
    }
    
    .ticket-card:hover {
      transform: translateY(-10px);
      box-shadow: 0 20px 40px rgba(0,0,0,0.4);
    }
    
    .artist-card {
      position: relative;
      overflow: hidden;
      border-radius: 12px;
      transition: all 0.4s ease;
    }
    
    .artist-card::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      width: 100%;
      height: 50%;
      background: linear-gradient(transparent, rgba(0,0,0,0.7));
      border-radius: 12px;
    }
    
    .artist-name {
      position: absolute;
      bottom: 15px;
      left: 15px;
      z-index: 2;
      color: white;
      font-weight: 600;
      font-size: 1.1rem;
    }
    
    .btn-primary {
      background: linear-gradient(90deg, var(--highlight), #ff6b8b);
      color: white;
      border: none;
      border-radius: 50px;
      padding: 12px 30px;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 5px 15px rgba(233, 69, 96, 0.3);
    }
    
    .btn-primary:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 20px rgba(233, 69, 96, 0.4);
    }
    
    .btn-secondary {
      background: transparent;
      color: var(--light);
      border: 2px solid var(--highlight);
      border-radius: 50px;
      padding: 10px 28px;
      font-weight: 600;
      transition: all 0.3s ease;
    }
    
    .btn-secondary:hover {
      background: var(--highlight);
      color: white;
      transform: translateY(-3px);
    }
    
    .mobile-menu {
      background: linear-gradient(145deg, var(--primary), var(--secondary));
      backdrop-filter: blur(10px);
    }
    
    .logo-glow {
      filter: drop-shadow(0 0 10px rgba(255, 215, 0, 0.5));
    }
    
    .floating-element {
      animation: float 6s ease-in-out infinite;
    }
    
    @keyframes float {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-15px); }
    }
    
    .text-shadow {
      text-shadow: 0 2px 10px rgba(0,0,0,0.5);
    }
    
    .glass-effect {
      background: rgba(255, 255, 255, 0.05);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .section-bg {
      position: relative;
      overflow: hidden;
    }

    .section-bg::before {
      content: '';
      position: absolute;
      inset: 0;
      z-index: 0;
      background: linear-gradient(180deg, rgba(26,26,46,0.70), rgba(22,33,62,0.55));
      pointer-events: none;
    }

    .section-bg > * {
      position: relative;
      z-index: 10;
    }
  </style>
</head>
<body class="bg-gray-900 text-white">
  <header class="fixed top-0 left-0 w-full flex justify-between items-center px-4 md:px-6 py-4 glass-effect z-50">
    <div class="logo transform hover:scale-105 transition duration-300 logo-glow">
      <img src="images/Logo.png" alt="Logo" class="h-10 md:h-14">
    </div>
    
    <nav class="hidden md:flex gap-6 md:gap-8">
      <a href="#home" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300 text-sm md:text-base">Home</a>
      <a href="#about" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300 text-sm md:text-base">About</a>
      <a href="#lineup" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300 text-sm md:text-base">Line Up</a>
      <a href="#ticket" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300 text-sm md:text-base">Ticket</a>
      <a href="#rundown" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300 text-sm md:text-base">Rundown</a>
      <a href="#gallery" class="nav-link font-medium text-white hover:text-gray-200 transition duration-300 text-sm md:text-base">Gallery</a>
    </nav>
    
    <button id="mobile-menu-btn" class="md:hidden text-white text-2xl">
      <i class="fas fa-bars"></i>
    </button>
    
    <div id="mobile-menu" class="fixed top-0 right-0 w-64 h-full mobile-menu z-50 transform translate-x-full transition-transform duration-300">
      <div class="flex justify-between items-center p-4 border-b border-gray-700">
        <h3 class="text-xl font-bold">Menu</h3>
        <button id="close-menu" class="text-2xl text-white">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <nav class="flex flex-col p-4">
        <a href="#home" class="py-3 font-medium hover:text-gray-200 transition duration-300 border-b border-gray-700">Home</a>
        <a href="#about" class="py-3 font-medium hover:text-gray-200 transition duration-300 border-b border-gray-700">About</a>
        <a href="#lineup" class="py-3 font-medium hover:text-gray-200 transition duration-300 border-b border-gray-700">Line Up</a>
        <div class="mt-6 space-y-3">
          <button onclick="window.location.href='login.jsp'" class="w-full btn-primary">
            <i class="fas fa-ticket-alt mr-2"></i>Buy Ticket
          </button>
          <button onclick="window.location.href='login.jsp'" class="w-full btn-secondary">
            <i class="fas fa-user mr-2"></i>Account
          </button>
        </div>
      </nav>
    </div>
    
    <div class="hidden md:flex gap-3">
      <button onclick="window.location.href='login.jsp'" class="btn-primary pulse-glow">
        <i class="fas fa-ticket-alt mr-2"></i>Buy Ticket
      </button>
      <button onclick="window.location.href='login.jsp'" class="btn-secondary">
        <i class="fas fa-user mr-2"></i>Account
      </button>
    </div>
  </header>

  <section id="home" class="relative h-screen overflow-hidden section-bg">
    <div class="absolute inset-0 bg-gradient-to-br from-gray-900 via-purple-900 to-violet-900 z-0"></div>
    <div class="absolute inset-0 z-10">
      <img src="images/sound1.webp" alt="Main Banner" class="w-full h-full object-cover opacity-80">
    </div>
    <div class="absolute inset-0 z-20 flex flex-col justify-center items-center text-center px-4">
      <div class="floating-element mb-6">
        <img src="images/Logo.png" alt="Logo" class="h-24 md:h-32 mx-auto logo-glow">
      </div>
      <h1 class="text-5xl md:text-7xl lg:text-8xl heading-font mb-4 text-shadow">THE HYPE MACHINE</h1>
      <p class="text-xl md:text-2xl max-w-2xl mx-auto mb-8 text-gray-200 text-shadow">Where Music Meets Extraordinary Experience</p>
      <div class="flex flex-col sm:flex-row gap-4">
        <button onclick="window.location.href='#ticket'" class="btn-primary text-lg px-8 py-3">
          <i class="fas fa-ticket-alt mr-2"></i>GET TICKETS
        </button>
        <button onclick="window.location.href='#about'" class="btn-secondary text-lg px-8 py-3">
          <i class="fas fa-play-circle mr-2"></i>DISCOVER MORE
        </button>
      </div>
    </div>
  </section>

  <section id="lineup" class="py-20 section-bg">
    <div class="max-w-7xl mx-auto px-4">
      <h2 class="text-4xl md:text-5xl heading-font text-center mb-4 gradient-text" data-aos="fade-up">Line Up</h2>
      <div class="overflow-x-auto pb-4">
        <div class="flex gap-6 min-w-max md:min-w-0 md:justify-center md:flex-wrap" data-aos="fade-up" data-aos-delay="400">
          <% 
            // Konversi Logika Looping PHP ke JSP (Java)
            for(int i=1; i<=10; i++) {
                String artistName = "Artist " + i;
                String songsJson = "['Song 1', 'Song 2', 'Song 3']";
          %>
            <div class="artist-card cursor-pointer flex-shrink-0" onclick="showArtistSongs(<%= i %>, '<%= artistName %>', <%= songsJson %>)">
              <img src="images/lineup<%= i %>.png" alt="<%= artistName %>" class="w-48 md:w-56 h-64 object-cover rounded-xl">
              <div class="artist-name"><%= artistName %></div>
            </div>
          <% } %>
        </div>
      </div>
    </div>
  </section>

  <section id="ticket" class="py-20 section-bg">
    <div class="max-w-7xl mx-auto px-4">
      <h2 class="text-4xl md:text-5xl heading-font text-center mb-4 gradient-text" data-aos="fade-up">Tickets</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div class="ticket-card flex flex-col h-full" data-aos="zoom-in">
          <div class="relative w-full overflow-hidden">
            <img src="images/D1.png" alt="DAY 1" class="w-full h-auto object-contain transition-transform duration-500 hover:scale-105">
            <div class="absolute inset-x-0 bottom-0 flex flex-col justify-end text-white p-6" style="height:45%; background: linear-gradient(to top, rgba(0,0,0,0.6), rgba(0,0,0,0));">
              <h3 class="text-2xl heading-font mb-1">DAY 1</h3>
              <p class="text-xl font-semibold">IDR 350K</p>
            </div>
          </div>
          <div class="p-6 flex flex-col flex-grow">
            <ul class="mb-8 space-y-3">
              <li class="flex items-start text-gray-300"><i class="fas fa-check text-green-500 mr-3 mt-1"></i><span>Basic Access</span></li>
              <li class="flex items-start text-gray-300"><i class="fas fa-check text-green-500 mr-3 mt-1"></i><span>General Area</span></li>
            </ul>
            <button onclick="window.location.href='login.jsp'" class="w-full btn-primary py-3 mt-auto">BUY NOW</button>
          </div>
        </div>
        </div>
    </div>
  </section>

  <div id="artistModal" class="modal">
    <div class="modal-content">
      <span class="close">&times;</span>
      <h2 id="artistName" class="text-2xl heading-font mb-4 gradient-text"></h2>
      <h3 class="text-lg font-semibold mb-2 text-gray-300">Songs to be performed:</h3>
      <ul id="artistSongs" class="space-y-3"></ul>
    </div>
  </div>

  <footer class="bg-gradient-to-r from-gray-900 to-purple-900 py-16 px-6">
    <div class="max-w-6xl mx-auto text-center">
      <p class="text-sm text-gray-500">© 2026 The Hype Machine. All Rights Reserved.</p>
    </div>
  </footer>

  <script>
    document.addEventListener('DOMContentLoaded', function() {
      AOS.init({ duration: 1000, once: true });
      
      const mobileMenuBtn = document.getElementById('mobile-menu-btn');
      const mobileMenu = document.getElementById('mobile-menu');
      const closeMenu = document.getElementById('close-menu');
      
      mobileMenuBtn.onclick = () => mobileMenu.style.transform = 'translateX(0)';
      closeMenu.onclick = () => mobileMenu.style.transform = 'translateX(100%)';

      const modal = document.getElementById('artistModal');
      const modalClose = document.getElementsByClassName('close')[0];
      modalClose.onclick = () => modal.style.display = 'none';
      window.onclick = (e) => { if(e.target == modal) modal.style.display = 'none'; };
    });

    function showArtistSongs(id, name, songs) {
      document.getElementById('artistName').innerText = name;
      const list = document.getElementById('artistSongs');
      list.innerHTML = '';
      songs.forEach(song => {
        const li = document.createElement('li');
        li.className = 'flex items-center text-gray-300 bg-white/5 p-3 rounded-lg';
        li.innerHTML = `<i class="fas fa-music mr-3 text-highlight"></i> ${song}`;
        list.appendChild(li);
      });
      document.getElementById('artistModal').style.display = 'block';
    }
  </script>
</body>
</html>