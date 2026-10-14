import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool _openFaq = true;
  String _category = 'Pesanan';

  // State untuk menyimpan daftar pengaduan (Riwayat)
  final List<Map<String, String>> _tickets = [
    {
      'title': 'Paket kurang berat',
      'body': 'Berat paket tidak sesuai rincian.',
      'status': 'Sedang Diproses',
      'type': 'warning',
    },
    {
      'title': 'Voucher tidak terpotong',
      'body': 'Voucher mahasiswa belum masuk di checkout.',
      'status': 'Selesai',
      'type': 'success',
    },
  ];

  void _addNewTicket(String category, String detail) {
    setState(() {
      _tickets.insert(0, {
        'title': '[$category] Laporan Baru',
        'body': detail,
        'status': 'Sedang Diproses',
        'type': 'warning',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9A3B00), Color(0xFFF16A3A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bantuan cepat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Dapat bantuan dari tim CS kami',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari bantuan...',
                      hintStyle: TextStyle(fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      prefixIcon: Icon(Icons.search, color: AppColors.primary, size: 17),
                      suffixIcon: Icon(Icons.send, color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Pesanan', 'Pengiriman', 'Pembayaran', 'Keamanan']
                  .map(
                    (item) => _CategoryChip(
                      label: item,
                      selected: _category == item,
                      onTap: () => setState(() => _category = item),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Panduan umum',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          _FaqCard(
            question: 'Bagaimana cara memesan?',
            answer:
                'Pilih paket, atur jumlah peserta, lalu tekan Tambah ke Keranjang. Setelah checkout, konfirmasi pembayaran dan pilih antar alamat atau ambil di UMKM.',
            expanded: _openFaq,
            onTap: () => setState(() => _openFaq = !_openFaq),
          ),
          const SizedBox(height: 8),
          _FaqCard(
            question: 'Berapa lama masa simpan bahan?',
            answer:
                'Simpan bahan pada suhu 4°C atau lebih rendah. Gunakan dalam waktu 3 hari sejak dibeli.',
            expanded: false,
            onTap: () {},
          ),
          const SizedBox(height: 18),

          _ComplaintForm(
            category: _category,
            onCategoryChanged: (value) => setState(() => _category = value),
            onSubmitSuccess: (category, detail) {
              _addNewTicket(category, detail);
            },
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat pengaduan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
              TextButton.icon(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.addReport,
                  );
                  if (result != null) {
                    _addNewTicket('Umum', 'Laporan baru telah ditambahkan.');
                  }
                },
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('Layar Form'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._tickets.map((ticket) {
            final isSuccess = ticket['type'] == 'success';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _TicketCard(
                status: ticket['status']!,
                title: ticket['title']!,
                body: ticket['body']!,
                color: isSuccess
                    ? const Color(0xFF28B957)
                    : const Color(0xFFF2A900),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFFFFE4DB),
      checkmarkColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: selected ? AppColors.accent : AppColors.border),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });
  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
      ),
      initiallyExpanded: expanded,
      onExpansionChanged: (_) => onTap(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            answer,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ComplaintForm extends StatefulWidget {
  const _ComplaintForm({
    required this.category,
    required this.onCategoryChanged,
    required this.onSubmitSuccess,
  });

  final String category;
  final ValueChanged<String> onCategoryChanged;
  final Function(String category, String detail) onSubmitSuccess;

  @override
  State<_ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<_ComplaintForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _detailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan/Keluhan berhasil dikirim!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      widget.onSubmitSuccess(widget.category, _detailController.text);
      _detailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Form Pengaduan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 11),
            DropdownButtonFormField<String>(
              value: widget.category,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: ['Pesanan', 'Pengiriman', 'Pembayaran', 'Keamanan']
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) =>
                  widget.onCategoryChanged(value ?? 'Pesanan'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _detailController,
              decoration: const InputDecoration(
                hintText: 'Jelaskan keluhan...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Keluhan wajib diisi!';
                }
                if (value.trim().length < 8) {
                  return 'Jelaskan keluhan minimal 8 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Kirim Pengaduan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.timer_outlined, color: Color(0xFF247A4D)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'SLA respon: 5–15 menit',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  Text(
                    'Aktif',
                    style: TextStyle(
                      color: Color(0xFF247A4D),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.status,
    required this.title,
    required this.body,
    required this.color,
  });
  final String status;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(.2),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
          const SizedBox(height: 9),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_rounded, size: 14),
            label: const Text('Live Chat CS', style: TextStyle(fontSize: 10)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ],
      ),
    );
  }
}