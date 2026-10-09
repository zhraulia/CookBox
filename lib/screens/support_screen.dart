import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool _openFaq = true;
  String _category = 'Pesanan';

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppColors.primary, size: 17),
                      SizedBox(width: 8),
                      Expanded(child: Text('Cari bantuan...')),
                      Icon(Icons.send, color: AppColors.primary),
                    ],
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
            answer: 'Pilih paket, atur jumlah peserta, lalu tekan Tambah ke Keranjang. Setelah checkout, konfirmasi pembayaran dan pilih antar alamat atau ambil di UMKM.',
            expanded: _openFaq,
            onTap: () => setState(() => _openFaq = !_openFaq),
          ),
          const SizedBox(height: 8),
          _FaqCard(
            question: 'Berapa lama masa simpan bahan?',
            answer: 'Simpan bahan pada suhu 4°C atau lebih rendah. Untuk paket matemat, gunakan dalam waktu 3 hari sejak dibeli.',
            expanded: false,
            onTap: () {},
          ),
          const SizedBox(height: 18),
          _ComplaintForm(
            category: _category,
            onCategoryChanged: (value) => setState(() => _category = value),
          ),
          const SizedBox(height: 16),
          Text(
            'Riwayat pengaduan',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const _TicketCard(
            status: 'Sedang Diproses',
            title: 'Paket kurang berat',
            body: 'Berat paket tidak sesuai rincian.',
            color: Color(0xFFF2A900),
          ),
          const SizedBox(height: 8),
          const _TicketCard(
            status: 'Selesai',
            title: 'Voucher tidak terpotong',
            body: 'Voucher mahasiswa belum masuk di checkout.',
            color: Color(0xFF28B957),
          ),
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
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
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
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
      ),
      initiallyExpanded: expanded,
      onExpansionChanged: (_) => onTap(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 16, 12),
          child: Text(
            answer,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ComplaintForm extends StatelessWidget {
  const _ComplaintForm({
    required this.category,
    required this.onCategoryChanged,
  });
  final String category;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Form Pengaduan',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 11),
          DropdownButtonFormField<String>(
            value: category,
            decoration: const InputDecoration(
              labelText: 'Kategori',
              border: OutlineInputBorder(),
            ),
            items: ['Pesanan', 'Pengiriman', 'Pembayaran', 'Keamanan']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => onCategoryChanged(value ?? 'Pesanan'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Jelaskan keluhan',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.image_outlined),
            label: const Text('Lampiran bukti kemasan'),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Color(0xFF247A4D)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'SLA respon: 5–15 menit',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                Text(
                  'Aktif',
                  style: const TextStyle(
                    color: Color(0xFF247A4D),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(.2),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: const TextStyle(color: AppColors.muted, fontSize: 9),
          ),
          const SizedBox(height: 9),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_rounded),
            label: const Text('Live Chat CS', style: TextStyle(fontSize: 9)),
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
