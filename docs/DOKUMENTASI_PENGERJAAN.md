# Langkah Detail Pengerjaan 1 Hari

## 1. Setup Project

```bash
cd tontonhub_flutter
flutter create . --platforms=android,web,windows
flutter pub get
```

## 2. Setup Firebase

```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

Aktifkan:

- Authentication Email/Password
- Cloud Firestore
- Firebase Storage

## 3. Jalankan Aplikasi

```bash
flutter run -d chrome
```

## 4. Buat Akun Creator

Register dengan role Creator dan kode:

```text
CREATOR123
```

## 5. Input Data Video

Masuk sebagai Creator, lalu isi:

- Judul video
- Deskripsi
- Nama channel
- Durasi
- URL video
- Thumbnail

## 6. Buat Akun Subscriber

Register sebagai Subscriber, lalu cek:

- Dashboard
- Profil
- Daftar video
- Search video
- Video player
- Komentar
- Subscribe
- Riwayat

## 7. Testing

```bash
flutter test
```

## 8. Dokumentasi

Isi template laporan pada folder `docs/`, lalu export menjadi PDF.
