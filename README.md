# Kelompok 1 – Layanan Autentikasi & Profil Pengguna (Identity Service)

Proyek ini adalah implementasi dari **Identity Service** yang menyediakan layanan autentikasi (registrasi, login) dan manajemen profil pengguna untuk mahasiswa, dosen, dan admin. Layanan ini juga menghasilkan JWT (JSON Web Token) yang akan digunakan oleh layanan lain (Kelompok 2–5) untuk otorisasi.

Repository ini berisi kode sumber untuk aplikasi mobile Flutter yang berfungsi sebagai antarmuka pengguna untuk layanan identitas ini.

## Fitur Utama

### Backend (Identity Service)
-   **Registrasi User**: Endpoint untuk pendaftaran pengguna baru (Mahasiswa/Dosen).
-   **Login & Autentikasi**: Verifikasi kredensial dan penerbitan JWT Token.
-   **Manajemen User**:
    -   Mendapatkan profil pengguna saat ini (`/me`).
    -   Melihat detail pengguna berdasarkan ID.
    -   Filter pengguna berdasarkan role (Mahasiswa, Dosen, Admin).
-   **JWT Token**: Token yang dihasilkan aman dan standar untuk digunakan antar layanan.
-   **Dokumentasi API**: Tersedia dokumentasi lengkap menggunakan Postman/Swagger.

### Mobile (Flutter App)
-   **Login Screen**: Antarmuka untuk masuk ke dalam sistem.
-   **Register Screen**: Antarmuka untuk pendaftaran akun baru.
-   **Profile Screen**: Menampilkan informasi detail pengguna yang sedang login.
-   **Navigasi**: Perpindahan halaman yang mulus dan penanganan status login.

## Endpoint API

Layanan ini menyediakan endpoint berikut untuk dikonsumsi oleh aplikasi mobile dan layanan kelompok lain:

| Method | Endpoint | Deskripsi |
| :--- | :--- | :--- |
| `POST` | `/login` | Autentikasi user dan mendapatkan JWT Token. |
| `POST` | `/register` | Mendaftarkan pengguna baru (Dummy/Fungsional). |
| `GET` | `/me` | Mendapatkan data profil user yang sedang login (butuh Token). |
| `GET` | `/users/{id}` | Mendapatkan detail user berdasarkan ID. |
| `GET` | `/users?role=...` | Mendapatkan daftar user dengan filter role tertentu. |

## Teknologi yang Digunakan

-   **Mobile**: Flutter (Dart)
-   **Backend**: (Tuliskan teknologi backend yang digunakan, misalnya: Node.js / Laravel / Go)
-   **Database**: (Tuliskan database yang digunakan, misalnya: MySQL / PostgreSQL)

## Cara Menjalankan Aplikasi Mobile

Pastikan Anda telah menginstal [Flutter SDK](https://flutter.dev/docs/get-started/install) pada komputer Anda.

1.  **Clone Repository**
    ```bash
    git clone https://github.com/Meyla-chan/Flutter.git
    cd Flutter
    ```

2.  **Instal Dependensi**
    ```bash
    flutter pub get
    ```

3.  **Konfigurasi API**
    -   Buka file konfigurasi API (biasanya di `lib/services/api_service.dart` atau `lib/utils/constants.dart`).
    -   Sesuaikan `BASE_URL` dengan alamat server backend Anda berjalan (misal: `http://localhost:3000` atau IP address komputer jika menggunakan emulator HP fisik).

4.  **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

## Dokumentasi API

Untuk detail payload request dan response, silakan merujuk pada dokumentasi Postman/Swagger yang telah disediakan oleh tim Backend.

---
**Anggota Kelompok 1:**
*   Ardhan Aghsal Dwi Putra
*   Diva Resti Nurcahyani
*   Deva Muhammad Syaiful Arifin
*   Mela Firdini Azzahra
*   Sasa Billa Febrianti
