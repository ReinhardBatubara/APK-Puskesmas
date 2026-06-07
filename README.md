# 🏥 Puskesmas Silangit Digital - Layanan Kesehatan Masyarakat

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D%203.5.0-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D%203.5.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-blue?style=for-the-badge)](https://flutter.dev)
[![Developer](https://img.shields.io/badge/Developer-Reinhard%20Batubara-Green?style=for-the-badge)](https://github.com/ReinhardBatubara)

Aplikasi Digital Layanan Kesehatan Masyarakat **Puskesmas Silangit** adalah sebuah platform kesehatan digital berbasis mobile (cross-platform) yang dirancang untuk mendigitalisasi dan mempermudah operasional pelayanan kesehatan masyarakat. Aplikasi ini dibangun menggunakan framework **Flutter** dan bahasa pemrograman **Dart**, yang mendukung multi-aktor dalam satu ekosistem terpadu.

Dengan integrasi 6 dashboard aktor utama, aplikasi ini mengotomatiskan seluruh alur pelayanan kesehatan dari pendaftaran pasien, pemeriksaan dokter, penyiapan obat oleh apoteker, hingga pemantauan operasional dan tingkat kepuasan masyarakat oleh Kepala Puskesmas.

---

## ✨ Fitur Utama (Multi-Aktor)

Aplikasi ini mendukung **6 Peran Pengguna (Multi-Role)** yang terintegrasi secara dinamis:

### 1. 👨‍👩‍👧‍👦 Dashboard Pasien (Akses Publik/Masyarakat)
*   **Registrasi Mandiri & BPJS**: Pendaftaran antrean loket secara online dengan pilihan jalur pembayaran Mandiri atau BPJS Kesehatan.
*   **Edukasi Kesehatan**: Membaca artikel kesehatan terkurasi dan tips hidup sehat.
*   **Informasi Layanan**: Detail poli (klinik), jenis pelayanan kesehatan, jadwal dokter, serta kontak penting Puskesmas.
*   **Form Umpan Balik (Feedback)**: Mengirimkan evaluasi kepuasan pelayanan langsung ke sistem sebagai bahan evaluasi manajemen.
*   **Integrasi Lokasi & Kontak**: Akses langsung ke koordinat Google Maps Puskesmas Silangit dan kontak darurat.

### 2. 👤 Dashboard Petugas Loket (Pendaftaran & Alokasi)
*   **Registrasi Pasien Baru & Lama**: Mendaftarkan pasien dengan pencarian NIK (Nomor Induk Kependudukan) untuk mempercepat proses.
*   **Verifikasi BPJS & Mandiri**: Mengklasifikasikan data administratif pasien untuk keperluan klaim dan pencatatan.
*   **Alokasi Antrean & Poli**: Menyalurkan pasien ke klinik tujuan (Poli Umum, Poli Gigi, Poli KIA, dll.) secara otomatis.
*   **Cetak Tiket Antrean**: Membuat nomor antrean fisik/digital untuk ketertiban ruang tunggu.

### 3. ⚙️ Dashboard Admin (Pusat Kendali Sistem)
*   **Manajemen Antrean Loket**: Memantau dan mengatur antrean aktif secara real-time.
*   **Konsultasi Online (Chat)**: Menghubungkan pasien dengan layanan administrasi / konsultasi umum.
*   **Pengelolaan Artikel**: Menambah, mengedit, dan menghapus artikel edukasi kesehatan yang muncul di aplikasi pasien.
*   **Kelola Layanan & Departemen**: Mengonfigurasi poli aktif, layanan medis, dan jadwal operasional puskesmas.
*   **Manajemen Akun Pengguna**: Pengelolaan hak akses untuk Dokter, Apoteker, Petugas Loket, Kepala Puskesmas, dan Admin.

### 4. 🥼 Dashboard Dokter (Pemeriksaan & Rekam Medis)
*   **Pemeriksaan Medis**: Mencatat tanda-tanda vital pasien (tekanan darah, suhu tubuh, berat badan) dan keluhan utama.
*   **Rekam Medis Elektronik (E-RMR)**: Menyimpan catatan diagnosis penyakit (ICD-10) dan riwayat medis pasien secara teratur.
*   **E-Resep Obat**: Membuat resep obat digital yang terintegrasi langsung dengan apotek.
*   **Sistem Rujukan Digital**: Menerbitkan rujukan cepat ke Rumah Sakit tipe rujukan lebih tinggi (Tipe B/C) jika memerlukan tindakan intensif.

### 5. 💊 Dashboard Apoteker (Dispensasi Obat)
*   **Pemantauan Resep Masuk**: Menerima resep digital langsung dari meja dokter secara real-time.
*   **Manajemen Status Obat**: Mengubah status pengerjaan obat (*Sedang Disiapkan*, *Siap Diambil*, *Selesai*) untuk memberi notifikasi kepada pasien.
*   **Pustaka & Katalog Obat**: Manajemen persediaan obat, dosis, dan petunjuk pemakaian.

### 6. 📈 Dashboard Kepala Puskesmas (Analisis & Evaluasi)
*   **Analisis Kepuasan Masyarakat**: Grafik hasil umpan balik pasien berdasarkan survei Indeks Kepuasan Masyarakat (IKM).
*   **Grafik Distribusi Pasien**: Visualisasi interaktif grafik batang/garis penyebaran kunjungan pasien per Poli/Klinik.
*   **Laporan Kinerja Operasional**: Laporan statistik harian dan bulanan kunjungan pasien untuk pengambilan keputusan strategis.

---

## 🛠️ Stack Teknologi & Libraries

Aplikasi ini dibangun menggunakan arsitektur Flutter modern dengan pustaka pendukung berikut:

| Pustaka / Tools | Versi | Deskripsi |
| --- | --- | --- |
| **Flutter SDK** | `>= 3.5.0` | Framework utama untuk kompilasi multi-platform |
| **Dart SDK** | `>= 3.5.0` | Bahasa pemrograman utama berorientasi objek |
| **google_fonts** | `^6.2.1` | Paket untuk tipografi modern (menggunakan font kustom terintegrasi) |
| **url_launcher** | `^6.3.1` | Integrasi panggilan telepon dan navigasi peta (Google Maps) |
| **shared_preferences** | `^2.3.3` | Penyimpanan lokal persisten untuk sesi login akun dummy dan status aplikasi |
| **intl** | `^0.19.0` | Pemformatan tanggal lokal (Indonesian Date Format) dan angka/mata uang |
| **cupertino_icons** | `^1.0.8` | Aset ikon bergaya iOS untuk keselarasan desain cross-platform |

---

## 📂 Struktur Direktori Proyek

```text
lib/
├── core/
│   └── utils/
│       ├── date_helper.dart            # Helper untuk format tanggal & waktu lokalan
│       ├── launcher_helper.dart        # Helper url_launcher untuk maps & telepon
│       └── local_storage_helper.dart   # Wrapper Shared Preferences untuk sesi login
├── data/
│   ├── dummy_accounts.dart            # Kredensial akun tiruan (6 Peran/Aktor)
│   └── dummy_data.dart                # Database tiruan (artikel, rekam medis, antrean)
├── models/
│   ├── user_model.dart                # Struktur data Pengguna & Aktor
│   ├── queue_model.dart               # Struktur data Antrean & Loket
│   ├── doctor_model.dart              # Struktur data Profil Dokter & Poli
│   ├── service_model.dart             # Struktur data Layanan Medis
│   ├── health_article_model.dart      # Struktur data Artikel Kesehatan
│   ├── consultation_model.dart        # Struktur data Riwayat Konsultasi Chat
│   └── feedback_model.dart            # Struktur data Feedback/Ulasan Layanan
├── screens/
│   ├── splash/                        # Layar awal Splash Screen animasi
│   ├── onboarding/                    # Layar perkenalan aplikasi / onboarding
│   ├── auth/                          # Layar Login dan Registrasi
│   ├── main/                          # Kontainer Navigasi Utama (Bottom Navbar)
│   ├── home/                          # Halaman Utama Dashboard dinamis sesuai Role
│   ├── admin/                         # Manajemen Admin (Kelola User, Layanan, Artikel)
│   ├── head/                          # Dashboard Statistik Kepala Puskesmas
│   ├── medical/                       # Dashboard Pemeriksaan Dokter (E-RM & Resep)
│   ├── officer/                       # Dashboard Registrasi & Alokasi Petugas Loket
│   ├── pharmacy/                      # Dashboard Pengelolaan Obat Apoteker
│   ├── queue/                         # Layar Antrean & Riwayat Antrean Pasien
│   ├── services/                      # Informasi Poli & Layanan Puskesmas
│   ├── articles/                      # Pembaca Artikel & Detail Edukasi
│   ├── consultation/                  # Konsultasi Chat (Form & Riwayat)
│   ├── feedback/                      # Form Umpan Balik Kepuasan Pelanggan
│   ├── profile/                       # Profil Pengguna & Kelola Logout
│   └── contact/                       # Kontak Puskesmas & Peta Lokasi
└── widgets/
    ├── app_card.dart                  # Kartu UI standard kustom
    ├── article_card.dart              # Kartu artikel dengan preview gambar
    ├── queue_card.dart                # Kartu tampilan nomor antrean
    ├── role_badge.dart                # Badge indikator role pengguna (warna dinamis)
    ├── custom_button.dart             # Tombol kustom berdesain Material 3
    └── [widgets lainnya...]           # Komponen UI modular pendukung
```

---

## 🚀 Panduan Instalasi & Menjalankan Proyek

Ikuti langkah-langkah di bawah ini untuk menjalankan aplikasi di lingkungan lokal Anda:

### 1. Prasyarat (Prerequisites)
Pastikan Anda sudah menginstal alat-alat berikut:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) versi terbaru (Direkomendasikan `>= 3.5.0`)
*   [Dart SDK](https://dart.dev/get-started) (Sudah sepaket dengan Flutter)
*   Android Studio / Xcode (Untuk Emulator Android/iOS)
*   VS Code / Android Studio dengan ekstensi **Flutter** dan **Dart** terpasang.

### 2. Klon Repositori
```bash
git clone https://github.com/ReinhardBatubara/APK-Puskesmas.git
cd APK-Puskesmas
```

### 3. Instal Dependensi
Jalankan perintah berikut di terminal proyek untuk mengunduh semua package yang dideklarasikan di `pubspec.yaml`:
```bash
flutter pub get
```

### 4. Jalankan Aplikasi
Hubungkan emulator atau perangkat fisik Anda, lalu jalankan perintah berikut:
```bash
# Untuk menjalankan secara default
flutter run

# Untuk build ke format release (Android APK)
flutter build apk --release
```

---

## 🔑 Akun Demo (Simulasi 6 Dashboard)

Untuk mencoba masing-masing dashboard, Anda dapat masuk menggunakan salah satu kredensial akun simulasi berikut (disimpan secara lokal via SharedPreferences):

| Role / Aktor | Username/Email | Sandi | Akses Halaman |
| --- | --- | --- | --- |
| **Pasien** | `pasien@gmail.com` | `pasien123` | Dashboard Layanan, Artikel, Feedback & Antrean |
| **Petugas Loket** | `loket@gmail.com` | `loket123` | Registrasi Pasien, Tiket Antrean & Alokasi Poli |
| **Dokter** | `dokter@gmail.com` | `dokter123` | Pemeriksaan Medis, Riwayat Diagnosa, E-Resep, & Rujukan |
| **Apoteker** | `apotek@gmail.com` | `apotek123` | Penyiapan Resep Obat & Manajemen Status Obat |
| **Kepala Puskesmas** | `kapus@gmail.com` | `kapus123` | Visualisasi Grafik Kepuasan & Statistik Pasien |
| **Administrator** | `admin@gmail.com` | `admin123` | Kontrol Penuh User, Artikel, Antrean, dan Data Poli |

---

## 🎨 Panduan Desain & Antarmuka (UI/UX)
*   **Material 3 Ready**: Mengadopsi pedoman desain Google Material 3 dengan sudut melengkung halus (*rounded corners*), tombol aksi melayang (*floating action buttons*), dan kartu terkelompok (*grouped cards*).
*   **Harmoni Warna Sehat**: Menggunakan kombinasi warna hijau daun (*emerald green*) dan biru toska (*teal*) yang merepresentasikan dunia medis yang bersih, tenang, dan profesional.
*   **Tipografi Modern**: Didukung oleh font modern dari Google Fonts untuk memastikan teks tetap nyaman dibaca pada berbagai ukuran layar.

---

## 👤 Pengembang (Developer)

*   **Nama**: Reinhard Batubara
*   **Pendidikan**: S1 Sistem Informasi - Institut Teknologi Del
*   **GitHub**: [@ReinhardBatubara](https://github.com/ReinhardBatubara)
*   **Email**: [reinhardbatubara607@gmail.com](mailto:reinhardbatubara607@gmail.com)

---
*Dibuat dengan 💚 untuk peningkatan kualitas layanan kesehatan di Puskesmas Silangit.*
