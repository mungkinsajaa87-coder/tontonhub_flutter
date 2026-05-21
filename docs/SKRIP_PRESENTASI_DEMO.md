# Skrip Presentasi Demo

Assalamualaikum Pak/Bu, saya akan mendemokan aplikasi TontonHub. Aplikasi ini adalah Video Streaming Platform berbasis Flutter dan Firebase.

Aplikasi ini memiliki dua role utama, yaitu Creator dan Subscriber. Creator dapat mengelola info, menambahkan video, mengupload thumbnail, dan melihat data subscribe. Subscriber dapat register, login, mengedit profil, melihat video, menonton video melalui video player, memberi komentar, subscribe channel, serta melihat riwayat tontonan.

Backend aplikasi menggunakan Firebase. Firebase Authentication digunakan untuk login/register, Cloud Firestore digunakan sebagai database, dan Firebase Storage digunakan untuk upload media seperti foto profil, gambar info, dan thumbnail video.

Sekarang saya login sebagai Subscriber. Di dashboard terdapat info terbaru dan video terbaru. Di halaman video, subscriber bisa melakukan pencarian, membuka detail video, memutar video, memberi komentar, subscribe channel, dan menyimpan riwayat tontonan.

Selanjutnya saya logout dan login sebagai Creator. Di dashboard creator terdapat jumlah info, video, dan subscribe. Creator dapat menambahkan info, menambahkan video, mengupload thumbnail, dan mengisi URL video.

Aplikasi ini juga sudah memiliki loading state, validasi form, error handling sederhana, testing, dokumentasi, serta bisa dijalankan minimal di dua platform, yaitu web dan mobile.
