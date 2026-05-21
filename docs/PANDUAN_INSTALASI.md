# Mulai dari Sini

Karena tema 7 sudah diambil, project ini dipindahkan ke:

- Nomor tema: 4
- Tema: Video Streaming Platform
- Nama aplikasi: TontonHub
- Role: Creator dan Subscriber

## Urutan Kerja Cepat

1. Extract ZIP.
2. Buka folder `tontonhub_flutter`.
3. Jalankan:

```bash
flutter create . --platforms=android,web,windows
flutter pub get
```

4. Hubungkan Firebase:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Aktifkan Firebase Authentication, Firestore, dan Storage.
6. Jalankan:

```bash
flutter run -d chrome
```

7. Register akun Creator dengan kode `CREATOR123`.
8. Tambahkan beberapa video dari menu Creator.
9. Register akun Subscriber.
10. Coba tonton video, komentar, subscribe, dan lihat riwayat.

## Yang Harus Discreenshot

- Aplikasi jalan di Chrome/web
- Aplikasi jalan di Android/mobile
- Login page
- Register page
- Dashboard Subscriber
- Dashboard Creator
- Profil pengguna
- Upload foto profil
- Tambah video
- Upload thumbnail video
- Video player
- Komentar video
- Subscribe channel
- Riwayat tontonan
- Firestore database
- Firebase Authentication
- Firebase Storage
- Hasil `flutter test`
