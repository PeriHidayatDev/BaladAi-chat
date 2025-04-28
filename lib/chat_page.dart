import 'package:flutter/cupertino.dart'; // Paket untuk widget Cupertino (gaya iOS).
import 'package:flutter/material.dart'; // Paket untuk widget Material (gaya Android).
import 'package:google_generative_ai/google_generative_ai.dart'; // Paket untuk menggunakan Google Generative AI.

import 'widgets/chat_bubble.dart'; // File eksternal yang berisi widget custom untuk balon chat.

const apiKey =
    'AIzaSyAM4lTF6hVQgQy21ixwkhUs96LGzS6-LBk'; // Kunci API untuk mengakses layanan Google Generative AI.

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key}); // Widget utama yang digunakan untuk halaman chat.

  @override
  State<ChatPage> createState() =>
      _ChatPageState(); // Membuat state untuk widget ChatPage.
}

class _ChatPageState extends State<ChatPage> {
  final model = GenerativeModel(
    // Inisialisasi model Generative AI dari Google.
    model: 'gemini-1.5-flash-latest', // Versi model yang digunakan.
    apiKey: apiKey, // API key untuk autentikasi.
  );

  TextEditingController messageController =
      TextEditingController(); // Controller untuk mengelola input teks pengguna.
  bool isLoading = false; // Status untuk menampilkan indikator loading.

  // Daftar balon chat untuk ditampilkan dalam UI.
  List<ChatBubble> chatBubbles = [
    const ChatBubble(
      direction: Direction.left, // Arah pesan ke kiri (dari chatbot).
      message:
          'Hallo, saya Balad AI. Ada yang bisa saya bantu?', // Pesan awal dari chatbot.
      photoUrl:
          'https://img.freepik.com/free-vector/ai-technology-robot-cyborg-illustrations_24640-134419.jpg?t=st=1735816485~exp=1735820085~hmac=770d33fceb7d197c7930f5eb00527f5b8159c18be1e20c471caa0f3d89702351&w=740', // URL foto chatbot.
      type: BubbleType.alone, // Jenis balon chat (pesan tunggal).
    ),
  ];

  List<Map<String, String>> searchHistory =
      []; // Daftar untuk menyimpan riwayat pencarian.

  void addToHistory(String query, String response) {
    // Fungsi untuk menambahkan pencarian ke riwayat.
    setState(() {
      searchHistory.add({'query': query, 'response': response});
    });
  }

  void viewHistory() {
    // Fungsi untuk melihat riwayat pencarian.
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: searchHistory.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(searchHistory[index]['query']!),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Detail Pencarian'),
                      content: Text(searchHistory[index]['response']!),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Header halaman chat.
        title: const Text('Balad AI Assistant', // Judul aplikasi.
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey, // Warna latar belakang AppBar.
        actions: [
          CupertinoButton(
            // Tombol history.
            child: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: viewHistory, // Panggil fungsi untuk melihat history.
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              // Menggunakan ListView.separated untuk memberikan jarak antar elemen.
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()), // Efek scroll yang lembut.
              reverse:
                  true, // Membalikkan urutan pesan (pesan terbaru di bawah).
              padding: const EdgeInsets.all(10), // Margin sekitar pesan.
              itemBuilder: (context, index) {
                return chatBubbles.reversed
                    .toList()[index]; // Menampilkan balon chat.
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                    height: 10); // Jarak vertikal antar balon chat.
              },
              itemCount: chatBubbles.length, // Total jumlah pesan.
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8), // Margin dalam balon input.
            decoration: BoxDecoration(
              color: Colors.white, // Warna latar belakang balon input.
              borderRadius: BorderRadius.circular(25), // Sudut melengkung.
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Bayangan lembut.
                  blurRadius: 5, // Intensitas blur.
                  offset: const Offset(0, 3), // Posisi bayangan.
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        messageController, // Controller untuk input teks.
                    decoration: const InputDecoration(
                      hintText:
                          'Kirim pesan ke Balad AI...', // Placeholder input.
                      border: InputBorder.none, // Hilangkan garis border.
                    ),
                  ),
                ),
                isLoading // Tampilkan loading spinner jika sedang memproses.
                    ? const CircularProgressIndicator.adaptive()
                    : IconButton(
                        icon: const Icon(Icons.send,
                            color: Colors.blue), // Ikon tombol kirim.
                        onPressed: () async {
                          setState(() {
                            isLoading = true; // Status loading aktif.
                          });

                          // Buat konten dari input pengguna.
                          final content = [
                            Content.text(messageController.text)
                          ];

                          // Mengirim permintaan ke model AI.
                          final GenerateContentResponse response =
                              await model.generateContent(content);

                          // Menyimpan pencarian ke riwayat.
                          addToHistory(messageController.text,
                              response.text ?? 'Maaf, saya tidak mengerti');

                          // Tambahkan balon chat untuk pesan pengguna.
                          chatBubbles = [
                            ...chatBubbles,
                            ChatBubble(
                              direction: Direction.right,
                              message: messageController.text,
                              photoUrl: null,
                              type: BubbleType.alone,
                            ),
                          ];

                          // Tambahkan balon chat untuk respons AI.
                          chatBubbles = [
                            ...chatBubbles,
                            ChatBubble(
                              direction: Direction.left,
                              message:
                                  response.text ?? 'Maaf, saya tidak mengerti',
                              photoUrl:
                                  'https://img.freepik.com/free-vector/ai-technology-robot-cyborg-illustrations_24640-134419.jpg?t=st=1735816485~exp=1735820085~hmac=770d33fceb7d197c7930f5eb00527f5b8159c18be1e20c471caa0f3d89702351&w=740',
                              type: BubbleType.alone,
                            ),
                          ];

                          messageController.clear(); // Bersihkan input.
                          setState(() {
                            isLoading = false; // Status loading selesai.
                          });
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
