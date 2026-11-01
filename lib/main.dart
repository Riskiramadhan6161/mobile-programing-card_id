import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MainScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// Warna & gaya
// ---------------------------------------------------------------------------
const _paper = Color.fromARGB(255, 196, 140, 29);
const _ink = Color.fromARGB(255, 45, 129, 144);
const _line = Color.fromARGB(255, 121, 203, 217);
const _beige = Color.fromARGB(255, 155, 110, 52);
const _avatar = Color.fromARGB(255, 97, 168, 215);
const _fontFamily = 'cursive';

// ---------------------------------------------------------------------------
// Main Screen dengan Stateful Widget, Drawer, & BottomSheet (Chapter 5)
// ---------------------------------------------------------------------------
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // State Profile (Manajemen State - Hal. 68)
  String nama = 'Riski Rmadhan';
  String nim = '24090025';
  String kelas = '5C';
  String ttl = 'Tegal-30-10-2005';
  ImageProvider? photo = const AssetImage('assets/img/riski.jpeg');

  // Controller untuk TextField (Hal. 70)
  late TextEditingController _namaController;
  late TextEditingController _nimController;
  late TextEditingController _kelasController;
  late TextEditingController _ttlController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: nama);
    _nimController = TextEditingController(text: nim);
    _kelasController = TextEditingController(text: kelas);
    _ttlController = TextEditingController(text: ttl);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _kelasController.dispose();
    _ttlController.dispose();
    super.dispose();
  }

  // Menampilkan BottomSheet interaktif untuk mengedit data (Hal. 74)
  void _showEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _paper,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: _nimController,
                  decoration: const InputDecoration(labelText: 'NIM'),
                ),
                TextField(
                  controller: _kelasController,
                  decoration: const InputDecoration(labelText: 'Kelas'),
                ),
                TextField(
                  controller: _ttlController,
                  decoration: const InputDecoration(labelText: 'TTL'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _ink),
                    onPressed: () {
                      setState(() {
                        nama = _namaController.text;
                        nim = _nimController.text;
                        kelas = _kelasController.text;
                        ttl = _ttlController.text;
                      });
                      Navigator.pop(context);

                      // Menampilkan SnackBar saat data berhasil diubah (Hal. 70)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil berhasil diperbarui!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 225, 225),
      appBar: AppBar(
        title: const Text('Aplikasi Profil Mahasiswa', style: TextStyle(fontFamily: _fontFamily)),
        backgroundColor: _ink,
        foregroundColor: Colors.white,
      ),
      // Implementasi Drawer Navigasi (Hal. 75)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: _ink),
              child: Text(
                'Menu Navigasi\nChapter 5 - Flutter',
                style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: _fontFamily),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Saya'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profil'),
              onTap: () {
                Navigator.pop(context);
                _showEditBottomSheet(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileCard(
                nama: nama,
                nim: nim,
                kelas: kelas,
                ttl: ttl,
                photo: photo,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: _ink),
                onPressed: () => _showEditBottomSheet(context),
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text('Edit Data Profil', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kartu Profile
// ---------------------------------------------------------------------------
class ProfileCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String kelas;
  final String ttl;
  final ImageProvider? photo;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.kelas,
    required this.ttl,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
      decoration: BoxDecoration(
        color: _paper,
        border: Border.all(color: _line, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: _ink,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(height: 2, color: _line, margin: const EdgeInsets.symmetric(horizontal: 20)),
          const SizedBox(height: 28),
          _PhotoFrame(photo: photo),
          const SizedBox(height: 32),
          _Field(label: 'Nama:', value: nama),
          _Field(label: 'NIM:', value: nim),
          _Field(label: 'Kelas:', value: kelas),
          _Field(label: 'TTL:', value: ttl),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Baris isian: label + garis bawah
// ---------------------------------------------------------------------------
class _Field extends StatelessWidget {
  final String label;
  final String value;

  const _Field({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: _fontFamily,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 2),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _line, width: 2)),
              ),
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 22,
                  color: _ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bingkai foto: cincin luar + busur putus-putus + lingkaran beige
// ---------------------------------------------------------------------------
class _PhotoFrame extends StatelessWidget {
  final ImageProvider? photo;
  const _PhotoFrame({this.photo});

  @override
  Widget build(BuildContext context) {
    const size = 190.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(size, size), painter: _RingPainter()),
          Container(
            width: size * 0.8,
            height: size * 0.8,
            decoration: const BoxDecoration(color: _beige, shape: BoxShape.circle),
            child: ClipOval(
              child: photo != null
                  ? Image(image: photo!, fit: BoxFit.cover)
                  : const _Placeholder(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 34,
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(color: _avatar, shape: BoxShape.circle),
            child: const Icon(Icons.photo_camera, color: _beige, size: 22),
          ),
        ),
        Positioned(
          bottom: -2,
          child: Container(
            width: 84,
            height: 62,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              color: _avatar,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: const Text(
              'FOTO',
              style: TextStyle(
                color: _beige,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final paint = Paint()
      ..color = _line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Perbaikan: Cincin luar penuh (menggunakan tanda minus '-' yang benar)
    canvas.drawCircle(c, size.width / 2 - 1, paint);

    // Perbaikan: Cincin dalam putus-putus (4 busur)
    final rect = Rect.fromCircle(center: c, radius: size.width / 2 - 14);
    const sweep = math.pi / 2 - 0.2;
    for (var i = 0; i < 4; i++) {
      final start = -math.pi / 2 + 0.1 + i * math.pi / 2;
      canvas.drawArc(rect, start, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}