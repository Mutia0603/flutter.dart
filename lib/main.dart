import 'package:flutter/material.dart' ;
import 'home.dart'; //import halaman home.dart
import 'tambah_nilai.dart'; //import halaman tambah_nilai
import 'update_nilai.dart'; // Import Halaman Update Nilai

void main () {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'latihan Nilai',
      initialRoute: '/home', //set halaman awal menjadi home
      routes: {
        '/home': (context) => const HalamanNilai(),//halaman utama
        '/tambah': (context) => TambahNilaiPage(),
        '/update': (context) => UpdateNilaiPage(), // Route to Update page
      },
    );

  }
}