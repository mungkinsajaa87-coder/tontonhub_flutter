# LAPORAN PROYEK APLIKASI FLUTTER MULTIPLATFORM

## Judul

Pengembangan Aplikasi Video Streaming Platform Berbasis Flutter dan Firebase pada Aplikasi TontonHub

## Identitas

Nama Kelompok: Solo Dev Team  
Nama Aplikasi: TontonHub  
Tema Aplikasi: Video Streaming Platform  
Ketua Kelompok: [Nama Kamu]  
Anggota: [Nama Kamu]

## Pembagian Tugas

Karena proyek dikerjakan secara individu, seluruh bagian pengembangan dikerjakan oleh saya sendiri, meliputi:

- Perancangan konsep aplikasi
- Desain UI/UX
- Pembuatan project Flutter
- Integrasi Firebase Authentication
- Pembuatan database Firestore
- Upload media dengan Firebase Storage
- Pembuatan role Creator dan Subscriber
- Pembuatan fitur video streaming
- Pembuatan fitur search
- Pembuatan fitur komentar
- Pembuatan fitur subscribe
- Pembuatan fitur riwayat
- Testing sederhana
- Dokumentasi dan demo

## Latar Belakang

Video streaming merupakan salah satu bentuk layanan digital yang banyak digunakan untuk menyampaikan konten edukasi, hiburan, dan informasi. Berdasarkan kebutuhan tersebut, dibuat aplikasi TontonHub sebagai platform streaming sederhana yang dapat digunakan oleh Creator untuk mengelola video dan Subscriber untuk menonton serta berinteraksi dengan konten.

## Tujuan

Tujuan pembuatan aplikasi ini adalah:

1. Membuat aplikasi Flutter multiplatform.
2. Menerapkan backend Firebase.
3. Membuat fitur login/register.
4. Menerapkan role Creator dan Subscriber.
5. Membuat fitur upload media.
6. Membuat fitur video player, komentar, subscribe, search, dan riwayat.

## Teknologi

- Flutter
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- video_player
- image_picker
- intl

## Fitur Aplikasi

### Subscriber

- Login/register
- Dashboard
- Profil pengguna
- Upload foto profil
- Melihat info
- Melihat video
- Search video
- Video player
- Komentar video
- Subscribe channel
- Riwayat tontonan

### Creator

- Login/register role Creator
- Dashboard Creator
- Tambah info
- Upload gambar info
- Tambah video
- Upload thumbnail video
- Input URL video
- Melihat data subscribe
- Mengubah status subscribe

## Database

Collection yang digunakan:

1. users
2. announcements
3. videos
4. subscriptions
5. activity_history
6. watch_history
7. media_uploads
8. comments subcollection pada videos

## Pengujian

Testing sederhana dilakukan dengan `flutter test` untuk memastikan aplikasi dapat dirender dan halaman awal muncul.

## Kesimpulan

Aplikasi TontonHub berhasil dibuat sebagai aplikasi Video Streaming Platform berbasis Flutter dan Firebase. Aplikasi memiliki fitur login/register, role pengguna, profil, upload media, video player, search, komentar, subscribe, riwayat, error handling, testing sederhana, dan dokumentasi.
