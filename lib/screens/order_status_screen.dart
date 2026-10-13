import 'package:flutter/material.dart';

import '../models/order_status_args.dart'; // [BARU] import model args
import '../theme/app_colors.dart';
import '../utils/validators.dart'; // [BARU] import validators

// [DIUBAH] Constructor menerima args bertipe OrderStatusArgs (FR-M3-01)
class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key, required this.args});

  final OrderStatusArgs args; // [BARU] field args

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Status Pesanan',
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
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDF2E7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF247A4D),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // [DIUBAH] Nama item dari args (FR-M3-01b)
                          Text(
                            'Pesanan berhasil dibuat — ${widget.args.item.title}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          // [DIUBAH] Kode pesanan dari args, bukan hardcode (FR-M3-01b)
                          Text(
                            'No. ${widget.args.orderCode}',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const _Timeline(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7F1),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0xFFDDF2E7)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        color: Color(0xFF247A4D),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CookBox aktif',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'Estimasi tiba • 15 mnt lagi',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // [DIUBAH] _ReviewCard mengelola state tags-nya sendiri
          const _ReviewCard(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.support_agent_rounded),
                  label: const Text('Live Chat'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call_rounded),
                  label: const Text('Telepon'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        // [DIPERBAIKI] Typo: step pertama diubah dari 'Dikirim' menjadi 'Pesanan Dibuat' (FR-M3-01c)
        _TimelineStep(title: 'Pesanan Dibuat', subtitle: '14:20', active: true),
        _TimelineLine(),
        _TimelineStep(title: 'Disiapkan UMKM', subtitle: '14:21', active: true),
        _TimelineLine(),
        _TimelineStep(title: 'Dikirim', subtitle: '14:30'),
        _TimelineLine(),
        _TimelineStep(title: 'Sampai', subtitle: '14:45'),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.title,
    required this.subtitle,
    this.active = false,
  });
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : const Color(0xFFE9E9EE),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 15,
            color: active ? Colors.white : AppColors.muted,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: active ? AppColors.ink : AppColors.muted,
            ),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.muted, fontSize: 9),
        ),
      ],
    );
  }
}

class _TimelineLine extends StatelessWidget {
  const _TimelineLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 24,
      margin: const EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.border, width: 2)),
      ),
    );
  }
}

// [DIUBAH] _ReviewCard mengelola seluruh state-nya sendiri (rating, tags, form, ulasan)
class _ReviewCard extends StatefulWidget {
  const _ReviewCard();

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  // State untuk rating (0 = belum pilih)
  int _rating = 0;

  // [BARU] Tags yang dipilih user — multi-select, default kosong
  final Set<String> _tags = {};

  // Controller untuk TextFormField ulasan
  final _commentController = TextEditingController();

  // GlobalKey untuk Form validasi
  final _formKey = GlobalKey<FormState>();

  // State untuk menandai apakah ulasan sudah terkirim
  bool _hasReview = false;

  // State untuk mode edit (membedakan teks tombol & pesan feedback)
  bool _isEditing = false;

  // Simpan ulasan yang sudah berhasil dikirim
  int _submittedRating = 0;
  String _submittedComment = '';
  // [BARU] Simpan tags yang sudah dikirim
  final Set<String> _submittedTags = {};

  // [BARU] Loading state untuk proses kirim
  bool _isLoading = false;

  // [BARU] Pesan error rating (ditampilkan di bawah bintang jika belum pilih)
  String? _ratingError;

  @override
  void dispose() {
    _commentController.dispose(); // [BARU] dispose controller (Ketentuan Teknis 2)
    super.dispose();
  }

  // [BARU] Kirim ulasan dengan pola async/await + try/catch/finally (FR-M3-04d)
  Future<void> _submitReview() async {
    // Validasi rating
    if (_rating == 0) {
      setState(() => _ratingError = 'Pilih rating terlebih dahulu');
      return;
    }
    setState(() => _ratingError = null);

    // Validasi form (komentar wajib diisi)
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    setState(() => _isLoading = true);

    try {
      // Simulasi proses async (misal panggilan API di masa depan)
      await Future.delayed(const Duration(milliseconds: 600));

      // Periksa mounted sebelum menggunakan context/setState (Ketentuan Teknis 4)
      if (!mounted) return;

      final savedRating = _rating;
      final savedComment = _commentController.text.trim();
      final savedTags = Set<String>.from(_tags); // [BARU] simpan salinan tags
      final wasEditing = _isEditing;

      setState(() {
        _submittedRating = savedRating;
        _submittedComment = savedComment;
        _submittedTags
          ..clear()
          ..addAll(savedTags); // [BARU] update submitted tags
        _hasReview = true;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            wasEditing
                ? 'Ulasan berhasil diperbarui'
                : 'Ulasan berhasil dikirim',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim ulasan, coba lagi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      // Matikan loading di blok finally (Ketentuan Teknis 3)
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Masuk mode edit: isi ulang form dengan nilai yang sudah dikirim (FR-M3-05b)
  void _startEdit() {
    setState(() {
      _hasReview = false;
      _isEditing = true;
      _rating = _submittedRating;
      _commentController.text = _submittedComment;
      _tags
        ..clear()
        ..addAll(_submittedTags); // [BARU] prefill tags dari yang sudah dikirim
      _ratingError = null;
    });
  }

  // [BARU] Dialog konfirmasi hapus ulasan (FR-M3-05c)
  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Ulasan?'),
        content: const Text('Yakin ingin menghapus ulasan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Batal: tutup dialog saja
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog
              // Reset semua state ulasan
              setState(() {
                _hasReview = false;
                _isEditing = false;
                _rating = 0;
                _commentController.clear();
                _tags.clear(); // [BARU] reset tags
                _submittedRating = 0;
                _submittedComment = '';
                _submittedTags.clear(); // [BARU] reset submitted tags
                _ratingError = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ulasan berhasil dihapus'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // [BARU] Judul berbeda tergantung state (FR-M3-05a)
            _hasReview ? 'Ulasan Anda' : 'Beri laporan',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          if (!_hasReview)
            Text(
              'Bagaimana kualitas paketnya?',
              style: const TextStyle(color: AppColors.muted, fontSize: 10),
            ),
          const SizedBox(height: 12),

          // ----------------------------------------------------------------
          // FR-M3-05a: Tampilan tergantung hasReview
          // ----------------------------------------------------------------
          if (_hasReview) ...[
            // --- TAMPILAN RINGKASAN ULASAN ---
            // Bintang terisi sesuai submittedRating (ikon saja, bukan tombol)
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < _submittedRating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: index < _submittedRating
                      ? const Color(0xFFF2A900)
                      : AppColors.border,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // [BARU] Tampilkan tags yang dipilih di ringkasan (jika ada)
            if (_submittedTags.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _submittedTags
                    .map(
                      (tag) => Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        backgroundColor: const Color(0xFFFFE4DB),
                        side: BorderSide.none,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 0),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
            ],
            // Teks ulasan yang sudah dikirim
            Text(
              _submittedComment,
              style: const TextStyle(fontSize: 13, color: AppColors.ink),
            ),
            const SizedBox(height: 12),
            // Tombol Edit & Hapus berdampingan (FR-M3-05a)
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _startEdit, // FR-M3-05b
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _confirmDelete, // FR-M3-05c
                  icon: const Icon(Icons.delete_outline, size: 15),
                  label: const Text('Hapus'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Color(0xFFFFCDD2)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ] else ...[
            // --- TAMPILAN FORM ULASAN ---

            // [DIPERBAIKI] Bintang rating: setiap tombol simpan rating = index+1 (FR-M3-04a)
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  // [DIPERBAIKI] Setiap bintang menyimpan nilai index+1, bukan bool
                  onPressed: () => setState(() {
                    _rating = index + 1;
                    _ratingError = null; // hapus error saat user pilih rating
                  }),
                  icon: Icon(
                    // [DIPERBAIKI] Terisi/tidak berdasarkan 'index < _rating' (bukan hardcode < 5)
                    index < _rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: index < _rating
                        ? const Color(0xFFF2A900)
                        : AppColors.border,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 28,
                    height: 28,
                  ),
                ),
              ),
            ),

            // [BARU] Tampilkan error rating jika belum pilih (FR-M3-04d)
            if (_ratingError != null) ...[
              const SizedBox(height: 4),
              Text(
                _ratingError!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 12),
            // [DIUBAH] FilterChip untuk multi-select (bisa pilih lebih dari satu)
            Wrap(
              spacing: 7,
              children: ['Bahan Segar', 'Bumbu Lezat', 'Cepat']
                  .map(
                    (value) => FilterChip(
                      label: Text(value, style: const TextStyle(fontSize: 9)),
                      selected: _tags.contains(value),
                      onSelected: (selected) => setState(() {
                        // Toggle: tambah jika belum ada, hapus jika sudah ada
                        if (selected) {
                          _tags.add(value);
                        } else {
                          _tags.remove(value);
                        }
                      }),
                      selectedColor: const Color(0xFFFFE4DB),
                      checkmarkColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(color: AppColors.border),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),

            // [BARU] Bungkus TextFormField dengan Form + GlobalKey (FR-M3-04c)
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _commentController, // [BARU] tambah controller (FR-M3-04b)
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Ulasan',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
                // [BARU] Validator dari Validators (FR-M3-04c)
                validator: (value) =>
                    Validators.minLength(value, 5, fieldName: 'Ulasan'),
              ),
            ),

            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.image_outlined),
              label: const Text('Foto hasil masakan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
              ),
            ),

            const SizedBox(height: 8),

            // [BARU] Tombol "Kirim Ulasan" / "Simpan Perubahan" (FR-M3-04d & FR-M3-05b)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _submitReview,
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        // [BARU] Teks berbeda tergantung mode edit (FR-M3-05b)
                        _isEditing ? 'Simpan Perubahan' : 'Kirim Ulasan',
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
