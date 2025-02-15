import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateNilaiPage extends StatefulWidget {
  @override
  State<UpdateNilaiPage> createState() => _UpdateNilaiPageState();
}

class _UpdateNilaiPageState extends State<UpdateNilaiPage> {
  final _formKey = GlobalKey<FormState>();
  final _nisnController = TextEditingController();
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _nilaiController = TextEditingController();

  Future<void> _updateData() async {
    final response = await http.post(
      Uri.parse('http://localhost/api_nilai/update.php'),
      body: {
        'nisn': _nisnController.text,
        'nama': _namaController.text,
        'kelas': _kelasController.text,
        'nilai': _nilaiController.text,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui!')),
      );
      Navigator.pop(context, true); // Return true to refresh data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui data!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Pre-fill the form fields with the existing data
    _nisnController.text = data['nisn'];
    _namaController.text = data['nama'];
    _kelasController.text = data['kelas'];
    _nilaiController.text = data['nilai'].toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data Nilai'),
        backgroundColor: const Color.fromARGB(255, 15, 93, 149),
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
                readOnly: true, // NISN should not be editable
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
                onPressed: _updateData,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}