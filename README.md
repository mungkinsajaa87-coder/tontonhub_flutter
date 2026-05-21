# TontonHub - Video Streaming Platform

TontonHub adalah aplikasi Flutter multiplatform bertema **Video Streaming Platform**. Aplikasi ini dibuat sebagai proyek lintas platform dengan backend Firebase, database Firestore, login/register, role pengguna, upload media, pencarian, komentar, subscribe, riwayat tontonan, testing sederhana, dan dokumentasi.

## Tema

- Nomor tema: 4
- Tema: Video Streaming Platform
- Nama aplikasi: TontonHub
- Role minimal: Creator dan Subscriber

## Fitur

### Subscriber

- Register dan login
- Dashboard subscriber
- Edit profil
- Upload foto profil
- Melihat info/update platform
- Melihat daftar video
- Video player dari URL video
- Search video/channel/info
- Subscribe channel/creator
- Komentar video
- Simpan riwayat tontonan
- Logout

### Creator

- Register/login sebagai creator dengan kode `CREATOR123`
- Dashboard creator
- Tambah info/update platform
- Upload gambar info
- Tambah video
- Upload thumbnail video
- Input URL video
- Lihat data subscribe
- Ubah status subscribe
- Logout

## Teknologi

- Flutter
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- video_player
- image_picker
- intl

## Collection Database

1. `users`
2. `announcements`
3. `videos`
4. `subscriptions`
5. `activity_history`
6. `watch_history`
7. `media_uploads`
8. `videos/{videoId}/comments`
