// ==================== screens/kegiatan_page.dart ====================
import 'package:flutter/material.dart';
import '../models/kegiatan_model.dart';
import '../services/api_service.dart';

class KegiatanPage extends StatefulWidget {
  @override
  _KegiatanPageState createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _namaKegiatanController = TextEditingController();
  final _deskripsiController = TextEditingController();
  DateTime? _selectedDate;

  List<KegiatanModel> kegiatanList = [];
  List<KegiatanModel> paginatedList = [];
  bool isLoading = false;
  bool isSubmitting = false;

  int currentPage = 1;
  int itemsPerPage = 4;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchKegiatan();
  }

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> fetchKegiatan() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await _apiService.getKegiatan();
      setState(() {
        kegiatanList = data;
        totalPages = (kegiatanList.length / itemsPerPage).ceil();
        if (totalPages == 0) totalPages = 1;
        updatePaginatedList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar('Error: $e');
    }
  }

  void updatePaginatedList() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (endIndex > kegiatanList.length) endIndex = kegiatanList.length;

    paginatedList = kegiatanList.sublist(startIndex, endIndex);
  }

  void goToPage(int page) {
    setState(() {
      currentPage = page;
      updatePaginatedList();
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        showSnackBar('Silakan pilih tanggal kegiatan');
        return;
      }

      setState(() {
        isSubmitting = true;
      });

      try {
        final kegiatan = KegiatanModel(
          namaKegiatan: _namaKegiatanController.text,
          deskripsi: _deskripsiController.text,
          tanggal: formatDate(_selectedDate!),
        );

        final success = await _apiService.addKegiatan(kegiatan);

        setState(() {
          isSubmitting = false;
        });

        if (success) {
          showSnackBar('Data berhasil ditambahkan');
          _formKey.currentState!.reset();
          _namaKegiatanController.clear();
          _deskripsiController.clear();
          _selectedDate = null;
          fetchKegiatan();
        }
      } catch (e) {
        setState(() {
          isSubmitting = false;
        });
        showSnackBar('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manajemen Kegiatan'), elevation: 2),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FORM INPUT
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambah Kegiatan Baru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _namaKegiatanController,
                        decoration: InputDecoration(
                          labelText: 'Nama Kegiatan',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.event_note),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama kegiatan harus diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _deskripsiController,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi harus diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Tanggal Kegiatan',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? 'Pilih tanggal'
                                : formatDate(_selectedDate!),
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedDate == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: isSubmitting
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Simpan Kegiatan',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            // TABEL DATA
            Text(
              'Daftar Kegiatan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            isLoading
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : kegiatanList.isEmpty
                ? Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.inbox, size: 60, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              'Belum ada data kegiatan',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // Table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          border: TableBorder.all(color: Colors.grey.shade300),
                          headingRowColor: MaterialStateProperty.all(
                            Colors.blue.shade50,
                          ),
                          columns: [
                            DataColumn(
                              label: Text(
                                'No',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Nama Kegiatan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Deskripsi',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Tanggal',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: paginatedList.asMap().entries.map((entry) {
                            int idx = entry.key;
                            KegiatanModel kegiatan = entry.value;
                            int rowNumber =
                                (currentPage - 1) * itemsPerPage + idx + 1;

                            return DataRow(
                              cells: [
                                DataCell(Text(rowNumber.toString())),
                                DataCell(
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 150),
                                    child: Text(kegiatan.namaKegiatan),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 200),
                                    child: Text(
                                      kegiatan.deskripsi ?? '-',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(kegiatan.tanggal)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Pagination
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: currentPage > 1
                                ? () => goToPage(currentPage - 1)
                                : null,
                            icon: Icon(Icons.chevron_left),
                          ),
                          SizedBox(width: 8),
                          ...List.generate(totalPages, (index) {
                            int pageNumber = index + 1;
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                onPressed: () => goToPage(pageNumber),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentPage == pageNumber
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  foregroundColor: currentPage == pageNumber
                                      ? Colors.white
                                      : Colors.black,
                                  minimumSize: Size(40, 40),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(pageNumber.toString()),
                              ),
                            );
                          }),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: currentPage < totalPages
                                ? () => goToPage(currentPage + 1)
                                : null,
                            icon: Icon(Icons.chevron_right),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),
                      Text(
                        'Halaman $currentPage dari $totalPages (Total: ${kegiatanList.length} data)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
