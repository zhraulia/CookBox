import 'package:flutter/material.dart';

// --- MODEL DATA (Dikirim sebagai Result ke Navigation) ---
class ReportModel {
  final String id;
  final String category;
  final String title;
  final String description;
  final String status;
  final DateTime date;

  ReportModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });
}

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  // 1. STATE & CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String _selectedCategory = 'Akun & Profil';
  bool _isLoading = false;

  final List<String> _categories = [
    'Akun & Profil',
    'Kendala Aplikasi',
    'Pertanyaan Layanan',
    'Lainnya',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // 2. LOGIC SUBMIT & VALIDATION
  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // State Loading On
      });

      // Simulasi proses async / API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _isLoading = false; // State Loading Off
      });

      // 3. FEEDBACK (SUCCESS DIALOG)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
          title: const Text('Berhasil!'),
          content: const Text('Laporan kamu berhasil dikirim ke pengelola.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Tutup dialog

                // 4. NAVIGATION & RESULT (Balik sambil bawa data)
                final newReport = ReportModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  category: _selectedCategory,
                  title: _titleController.text,
                  description: _descController.text,
                  status: 'Pending',
                  date: DateTime.now(),
                );

                Navigator.of(context).pop(newReport);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirim Laporan / Bantuan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // INPUT 1: Dropdown Kategori
              const Text('Kategori Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              // INPUT 2: Judul Laporan (With Validation)
              const Text('Judul Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan judul laporan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul laporan wajib diisi!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // INPUT 3: Deskripsi Laporan (With Validation)
              const Text('Deskripsi Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Jelaskan kendala kamu secara detail...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi laporan tidak boleh kosong!';
                  }
                  if (value.trim().length < 10) {
                    return 'Deskripsi terlalu singkat (minimal 10 karakter)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // SUBMIT BUTTON (With Loading Feedback)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Kirim Laporan', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}