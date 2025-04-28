import 'package:flutter/material.dart'; // Paket Flutter untuk membangun UI.

class Avatar extends StatelessWidget {
  // Widget stateless untuk menampilkan avatar.
  const Avatar({Key? key, this.radius}) : super(key: key);
  // Konstruktor untuk inisialisasi widget.
  // `radius` adalah properti opsional yang menentukan ukuran avatar.

  final double? radius; // Properti untuk menentukan jari-jari lingkaran avatar.

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      // Menggunakan widget bawaan `CircleAvatar` untuk menampilkan lingkaran.
      backgroundColor:
          Colors.black12, // Warna latar belakang lingkaran (abu-abu terang).
      radius: radius, // Ukuran lingkaran ditentukan oleh nilai `radius`.
      child: Icon(Icons.person, size: radius),
      // Ikon bawaan dengan gambar orang, ukurannya disesuaikan dengan `radius`.
    );
  }
}
