# 🎫 THE HYPE MACHINE – Concert Ticket Booking System

![Java](https://img.shields.io/badge/Java-ED8B00?logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-Servlet-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Development-yellow)

**THE HYPE MACHINE** adalah aplikasi **pemesanan tiket konser berbasis web** yang dikembangkan menggunakan **Java Server Pages (JSP)**, **Java (Servlet/JPA)**, dan **PostgreSQL**.  
Project ini dibuat untuk mensimulasikan sistem ticketing konser modern dengan fitur **user & admin dashboard**.

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
- Manajemen data konser (CRUD)
- Menghapus konser
- Monitoring pemesanan tiket

---

## 🧱 Teknologi yang Digunakan

| Layer | Teknologi |
|-----|----------|
| Frontend | JSP, HTML, CSS |
| Backend | Java, Servlet, JPA |
| Database | PostgreSQL |
| Build Tool | Maven |
| Server | Apache Tomcat |
| IDE | NetBeans / VS Code |

---

## 📁 Struktur Project

tiket/
│
├── src/
│ └── main/
│ ├── java/
│ └── resources/
│ └── META-INF/
│ └── persistence.xml
│
├── webapp/
│ ├── META-INF/
│ ├── WEB-INF/
│ ├── images/
│ ├── videos/
│ │
│ ├── index.jsp
│ ├── login.jsp
│ ├── cart.jsp
│ ├── add_to_cart.jsp
│ ├── dashboard_user.jsp
│ │
│ ├── admin_dashboard.jsp
│ ├── admin_concerts.jsp
│ ├── delete_concert.jsp
│ └── delete_account.jsp
│
├── db/
│ └── database.sql
│
├── pom.xml
└── README.md

yaml
Salin kode

---

## 🗄️ Database

Database menggunakan **PostgreSQL** dengan konfigurasi JPA pada:

src/main/resources/META-INF/persistence.xml

sql
Salin kode

Pastikan database sudah dibuat sebelum menjalankan aplikasi.

Contoh:
```sql
CREATE DATABASE tiket_konser;
⚙️ Cara Menjalankan Project
1️⃣ Clone Repository
bash
Salin kode
git clone https://github.com/donisetiawan12/tiket.git
2️⃣ Import Database
Buka pgAdmin

Buat database PostgreSQL

Import file SQL dari folder /db

3️⃣ Konfigurasi Database
Sesuaikan username & password PostgreSQL di:

pgsql
Salin kode
persistence.xml
4️⃣ Jalankan Aplikasi
Deploy ke Apache Tomcat

Jalankan project dari IDE

Akses di browser:

bash
Salin kode
http://localhost:8080/tiket
🔐 Keamanan
Autentikasi user & admin

Session management

Validasi input dasar

Pemisahan hak akses admin & user

🎯 Tujuan Project
Project pembelajaran Java Web

Tugas kampus / UAS PBO

Simulasi sistem tiket konser

backend Java developer

🚀 Pengembangan Selanjutnya
Payment gateway integration

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
