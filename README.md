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
│       │   └── controller/
│       │   └── model/
│       │   └── util/
│       │
│       └── resources/
│           └── META-INF/
│               └── persistence.xml
│
├── webapp/
│   ├── META-INF/
│   ├── WEB-INF/
│   │
│   ├── images/
│   ├── videos/
│   │
│   ├── index.jsp
│   ├── login.jsp
│   ├── cart.jsp
│   ├── add_to_cart.jsp
│   ├── dashboard_user.jsp
│   │
│   ├── admin_dashboard.jsp
│   ├── admin_concerts.jsp
│   ├── delete_concert.jsp
│   └── delete_account.jsp
│
├── db/
│   └── database.sql
│
├── pom.xml
└── README.md
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
