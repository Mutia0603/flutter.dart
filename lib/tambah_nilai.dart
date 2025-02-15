import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahNilaiPage extends StatefulWidget {
  @override
  State<TambahNilaiPage> createState() => _TambahNilaiPageState();
}

class _TambahNilaiPageState extends State<TambahNilaiPage> {
  final _formKey = GlobalKey<FormState>();
  final _nisnController = TextEditingController();
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _nilaiController = TextEditingController();

  Future<void> _submitData() async {
    final response = await http.post(
      Uri.parse('http://localhost/api_nilai/create.php'),
      body: {
        'nisn': _nisnController.text,
        'nama': _namaController.text,
        'kelas': _kelasController.text,
        'nilai': _nilaiController.text,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan!')),
      );
      Navigator.pop(context, true); // Return true to refresh data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan data!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Nilai'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nisnController,
                decoration: const InputDecoration(labelText: 'NISN'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextFormField(
                controller: _kelasController,
                decoration: const InputDecoration(labelText: 'Kelas'),
              ),
              TextFormField(
                controller: _nilaiController,
                decoration: const InputDecoration(labelText: 'Nilai'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}