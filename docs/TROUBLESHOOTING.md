# Troubleshooting

## Firebase belum dikonfigurasi

Jika muncul halaman peringatan Firebase, jalankan:

```bash
flutterfire configure
```

Lalu restart aplikasi.

## Email/password tidak bisa login

Pastikan Firebase Console -> Authentication -> Sign-in method -> Email/Password sudah enabled.

## Firestore permission denied

Untuk demo, gunakan rules dari file:

```text
docs/firestore_rules_demo.txt
```

## Storage upload gagal

Pastikan Firebase Storage sudah dibuat dan rules demo sudah dipasang dari:

```text
docs/storage_rules_demo.txt
```

## Video player tidak muncul

Pastikan URL video yang diinput berupa URL video valid, misalnya MP4. Kalau URL kosong, aplikasi tetap jalan tetapi player menampilkan pesan bahwa URL belum valid.

## Package belum terinstall

Jalankan:

```bash
flutter pub get
```

## Platform belum ada

Jalankan:

```bash
flutter create . --platforms=android,web,windows
```
