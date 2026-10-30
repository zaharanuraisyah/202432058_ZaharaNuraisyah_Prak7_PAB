// Kode pada Langkah 4: kerangka TabBar, isi tiap tab masih teks sementara.
// Jalankan dengan: flutter run -t contoh_langkah/langkah4_tabbar.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const DompetkuApp());
}

class DompetkuApp extends StatelessWidget {
  const DompetkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dompetku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // harus sama dengan jumlah Tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dompetku'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.receipt_long), text: 'Transaksi'),
              Tab(icon: Icon(Icons.category), text: 'Kategori'),
              Tab(icon: Icon(Icons.person), text: 'Profil'),
            ],
          ),
        ),
        // urutan halaman mengikuti urutan Tab di atas
        body: const TabBarView(
          children: [
            Center(child: Text('Halaman Transaksi')),
            Center(child: Text('Halaman Kategori')),
            Center(child: Text('Halaman Profil')),
          ],
        ),
      ),
    );
  }
}
