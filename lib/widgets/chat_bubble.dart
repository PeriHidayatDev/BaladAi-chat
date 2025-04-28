import 'package:flutter/material.dart'; // Paket untuk mendesain UI aplikasi.

import 'avatar.dart'; // File eksternal untuk widget avatar.

enum BubbleType {
  // Enum untuk menentukan jenis balon obrolan.
  top, // Balon di bagian atas (biasanya untuk pesan pertama dalam grup).
  middle, // Balon di bagian tengah (biasanya untuk pesan di tengah grup).
  bottom, // Balon di bagian bawah (biasanya untuk pesan terakhir dalam grup).
  alone, // Balon tunggal (tidak tergabung dalam grup).
}

enum Direction {
  // Enum untuk menentukan arah balon obrolan.
  left, // Balon di kiri (pesan dari lawan bicara/chatbot).
  right, // Balon di kanan (pesan dari pengguna).
}

class ChatBubble extends StatelessWidget {
  // Widget utama untuk balon obrolan.
  const ChatBubble({
    Key? key,
    required this.direction, // Arah balon obrolan (kiri/kanan).
    required this.message, // Isi pesan dalam balon obrolan.
    required this.type, // Jenis balon obrolan (top/middle/bottom/alone).
    this.photoUrl, // URL untuk foto profil (opsional).
  }) : super(key: key);

  final Direction direction; // Properti untuk arah balon.
  final String message; // Properti untuk teks pesan.
  final String? photoUrl; // Properti opsional untuk URL foto.
  final BubbleType type; // Properti untuk jenis balon.

  @override
  Widget build(BuildContext context) {
    final isOnLeft =
        direction == Direction.left; // Cek apakah balon berada di kiri.
    return Row(
      // Menyusun elemen dalam satu baris (Row).
      mainAxisAlignment: isOnLeft
          ? MainAxisAlignment.start
          : MainAxisAlignment.end, // Posisi balon (kiri/kanan).
      crossAxisAlignment:
          CrossAxisAlignment.end, // Menyelaraskan elemen ke bawah.
      children: [
        if (isOnLeft)
          _buildLeading(type), // Tambahkan avatar jika balon di kiri.
        SizedBox(width: isOnLeft ? 4 : 0), // Jarak antara avatar dan balon.
        Container(
          // Container untuk balon obrolan.
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  0.8), // Maksimal lebar 80% layar.
          padding: const EdgeInsets.all(8), // Padding dalam balon.
          decoration: BoxDecoration(
            borderRadius: _borderRadius(direction,
                type), // Bentuk sudut balon berdasarkan arah dan jenis.
            color: isOnLeft
                ? Colors.grey[200] // Warna untuk balon di kiri.
                : Theme.of(context).primaryColor, // Warna untuk balon di kanan.
          ),
          child: Text(
            // Teks pesan di dalam balon.
            message,
            style: TextStyle(
              fontWeight: FontWeight.w400, // Berat teks.
              color: isOnLeft
                  ? Colors.black
                  : Colors.white, // Warna teks berdasarkan arah.
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeading(BubbleType type) {
    // Fungsi untuk menampilkan avatar.
    if (type == BubbleType.alone || type == BubbleType.bottom) {
      // Jika balon tunggal atau di bawah.
      if (photoUrl != null) {
        // Jika URL foto tersedia.
        return CircleAvatar(
          radius: 13, // Ukuran avatar.
          backgroundImage: NetworkImage(photoUrl!), // Gambar avatar dari URL.
        );
      }
      return const Avatar(
        // Avatar default jika URL tidak ada.
        radius: 12,
      );
    }
    return const SizedBox(width: 24); // Ruang kosong untuk balon lainnya.
  }

  BorderRadius _borderRadius(Direction dir, BubbleType type) {
    // Fungsi untuk menentukan bentuk sudut balon.
    const radius1 = Radius.circular(15); // Radius besar.
    const radius2 = Radius.circular(5); // Radius kecil.
    switch (type) {
      case BubbleType.top: // Jika balon berada di atas.
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius2,
              );

      case BubbleType.middle: // Jika balon berada di tengah.
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius2,
              );

      case BubbleType.bottom: // Jika balon berada di bawah.
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius1,
              );

      case BubbleType.alone: // Jika balon tunggal.
        return BorderRadius.circular(15); // Bentuk balon bulat sempurna.
    }
  }
}
