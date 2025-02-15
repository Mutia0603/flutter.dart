import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanNilai extends StatefulWidget {
  const HalamanNilai({super.key});

  @override
  State<HalamanNilai> createState() => _HalamanNilaiState();
}

class _HalamanNilaiState extends State<HalamanNilai> {
  List _listdata = [];
  bool _loading = true;

  Future<void> _getdata() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/api_nilai/read.php'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _listdata = data;
          _loading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> _hapusData(String nisn) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/api_nilai/delete.php'),
        body: {'nisn': nisn},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  void _logout() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _navigateToAddData() async {
    final result = await Navigator.pushNamed(context, '/tambah');
    if (result == true) {
      _getdata(); // Memuat ulang data setelah menambahkan
    }
  }

  void _navigateToUpdateData(Map<String, dynamic> data) async {
    final result = await Navigator.pushNamed(context, '/update', arguments: data);
    if (result == true) {
      _getdata(); // Memuat ulang data setelah pembaruan
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Nilai'),
        backgroundColor: const Color.fromARGB(255, 224, 157, 200),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('NISN')),
                  DataColumn(label: Text('Nama')),
                  DataColumn(label: Text('Kelas')),
                  DataColumn(label: Text('Nilai')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: _listdata.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data['nisn'].toString())),
                      DataCell(Text(data['nama'])),
                      DataCell(Text(data['kelas'])),
                      DataCell(Text(data['nilai'].toString())),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _navigateToUpdateData(data); // Navigasi ke halaman update
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool success = await _hapusData(data['nisn']);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Data berhasil dihapus!')),
                                  );
                                  _getdata(); // Memuat ulang data setelah penghapusan
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Gagal menghapus data')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddData,
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
