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

Minimal 5 collection sudah terpenuhi:

1. `users`
2. `announcements`
3. `videos`
4. `subscriptions`
5. `activity_history`
6. `watch_history`
7. `media_uploads`
8. `videos/{videoId}/comments`

## Cara Menjalankan

Extract ZIP, lalu buka terminal di folder project:

```bash
cd tontonhub_flutter
flutter create . --platforms=android,web,windows
flutter pub get
```

Untuk Mac bisa pakai:

```bash
flutter create . --platforms=android,web,macos,ios
flutter pub get
```

Setup Firebase:

```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

Aktifkan di Firebase Console:

1. Authentication -> Email/Password
2. Cloud Firestore
3. Firebase Storage

Jalankan di web:

```bash
flutter run -d chrome
```

Jalankan di Android:

```bash
flutter run
```

Testing:

```bash
flutter test
```

## Akun Demo

Buat akun melalui halaman register.

### Creator

- Role: Creator
- Kode creator: `CREATOR123`

### Subscriber

- Role: Subscriber
- Tidak perlu kode khusus

## Data Video Demo

Gunakan data video dari `docs/DATA_DUMMY_DEMO.md`. Untuk URL video, pakai URL MP4 publik atau upload video ke Firebase Storage lalu copy download URL.

## Catatan Penting

File `lib/firebase_options.dart` masih template. Jalankan `flutterfire configure` agar file tersebut otomatis diganti dengan konfigurasi Firebase asli milikmu.
