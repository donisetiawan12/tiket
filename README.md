# 🎫 THE HYPE MACHINE – Concert Ticket Booking System

![Java](https://img.shields.io/badge/Java-ED8B00?logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-Servlet-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Development-yellow)

**THE HYPE MACHINE** adalah aplikasi **pemesanan tiket konser berbasis web** yang dikembangkan menggunakan  
**Java Server Pages (JSP)**, **Java (Servlet & JPA)**, dan **PostgreSQL**.

Project ini dibuat sebagai **simulasi sistem ticketing konser modern** dengan pemisahan **hak akses user dan admin**.

---

## ✨ Fitur Aplikasi

### 👤 User
- Registrasi & Login akun
- Melihat daftar konser
- Menambahkan tiket ke keranjang
- Checkout tiket
- Melihat dashboard user
- Menghapus akun

### 🛠️ Admin
- Login admin
- Dashboard admin
- Manajemen data konser (Create, Read, Update, Delete)
- Menghapus konser
- Monitoring data pemesanan tiket

---

## 🧱 Teknologi yang Digunakan

| Layer | Teknologi |
|------|----------|
| Frontend | JSP, HTML, CSS |
| Backend | Java, Servlet, JPA |
| Database | PostgreSQL |
| Build Tool | Maven |
| Server | Apache Tomcat |
| IDE | NetBeans / VS Code |

---
## 📁 Struktur Project

```text
tiket/
├── src/
│   └── main/
│       ├── java/
│       │   ├── controller/
│       │   │   ├── LoginServlet.java
│       │   │   ├── RegisterServlet.java
│       │   │   ├── LogoutServlet.java
│       │   │   ├── ConcertServlet.java
│       │   │   ├── CartServlet.java
│       │   │   ├── OrderServlet.java
│       │   │   └── AdminServlet.java
│       │   │
│       │   ├── model/
│       │   │   ├── User.java
│       │   │   ├── Admin.java
│       │   │   ├── Concert.java
│       │   │   ├── Ticket.java
│       │   │   ├── Cart.java
│       │   │   └── Order.java
│       │   │
│       │   ├── dao/
│       │   │   ├── UserDAO.java
│       │   │   ├── ConcertDAO.java
│       │   │   ├── CartDAO.java
│       │   │   └── OrderDAO.java
│       │   │
│       │   ├── service/
│       │   │   ├── AuthService.java
│       │   │   ├── ConcertService.java
│       │   │   └── OrderService.java
│       │   │
│       │   └── util/
│       │       ├── DBUtil.java
│       │       ├── HibernateUtil.java
│       │       └── SessionUtil.java
│       │
│       └── resources/
│           └── META-INF/
│               └── persistence.xml
│
├── webapp/
│   ├── META-INF/
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── views/
│   │       ├── user/
│   │       │   ├── index.jsp
│   │       │   ├── login.jsp
│   │       │   ├── register.jsp
│   │       │   ├── cart.jsp
│   │       │   ├── checkout.jsp
│   │       │   └── dashboard_user.jsp
│   │       │
│   │       └── admin/
│   │           ├── admin_dashboard.jsp
│   │           ├── admin_concerts.jsp
│   │           ├── admin_orders.jsp
│   │           └── admin_users.jsp
│   │
│   ├── assets/
│   │   ├── css/
│   │   │   └── style.css
│   │   ├── js/
│   │   │   └── script.js
│   │   └── images/
│   │
│   ├── error/
│   │   ├── 404.jsp
│   │   └── 500.jsp
│   │
│   └── index.jsp
│
├── db/
│   ├── database.sql
│   └── sample_data.sql
│
├── logs/
│   └── app.log
│
├── pom.xml
├── .gitignore
└── README.md

🧩 Penjelasan Fungsi Folder (Ringkas & Jelas)

🔹 controller

Menangani request dari user (Servlet):
Login, register, cart, checkout
Request admin & user

🔹 model

Entity JPA:
Mapping tabel database
Representasi data (User, Concert, Ticket)

🔹 dao

Akses database:
Query CRUD
Pisah logic DB dari controller

🔹 service

Business logic:
Validasi
Proses order
Auth & role checking

🔹 util

Helper:
Koneksi database
Session handler
Utility umum

🔹 webapp/WEB-INF/views

JSP tidak bisa diakses langsung
Lebih aman & profesional


🗄️ Database
Aplikasi ini menggunakan PostgreSQL sebagai database utama dengan konfigurasi JPA yang terdapat pada:

text
Salin kode
src/main/resources/META-INF/persistence.xml
Pastikan database sudah dibuat sebelum menjalankan aplikasi.

Contoh pembuatan database:

sql
Salin kode
CREATE DATABASE tiket_konser;
⚙️ Cara Menjalankan Project
1️⃣ Clone Repository
bash
Salin kode
git clone https://github.com/donisetiawan12/tiket.git
2️⃣ Import Database
Buka pgAdmin

Buat database PostgreSQL

Import file SQL dari folder:

text
Salin kode
/db/database.sql
3️⃣ Konfigurasi Database
Sesuaikan username, password, dan nama database di file:

text
Salin kode
src/main/resources/META-INF/persistence.xml
4️⃣ Jalankan Aplikasi
Deploy project ke Apache Tomcat

Jalankan dari IDE (NetBeans / VS Code)

Akses melalui browser:

bash
Salin kode
http://localhost:8080/tiket
🔐 Keamanan
Autentikasi user dan admin

Session management

Validasi input dasar

Pemisahan hak akses admin & user

🎯 Tujuan Project
Project pembelajaran Java Web

Tugas kampus / UTS / UAS PBO

Simulasi sistem pemesanan tiket konser

Portfolio Backend Java Developer

🚀 Pengembangan Selanjutnya
Integrasi Payment Gateway

QR Code tiket

Email notifikasi

Role Based Access Control (RBAC)

REST API version

👨‍💻 Developer
Doni Setiawan
Java Web Developer | Student Project

📄 License
Project ini menggunakan lisensi MIT
Bebas digunakan untuk pembelajaran dan pengembangan.
