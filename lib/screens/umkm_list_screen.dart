import 'package:flutter/material.dart';

import '../data/umkm_repository.dart';
import '../models/umkm.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/state_views.dart';

/// Status tampilan layar: sedang memuat, berhasil, atau gagal.
enum _ViewStatus { loading, success, error }

/// Ukuran ikon kecil (bintang, lokasi) dan tinggi baris chip kategori.
/// Diberi nama agar angkanya tidak tertulis langsung di widget.
const double _iconSize = 16;
const double _chipRowHeight = 40;

class UmkmListScreen extends StatefulWidget {
  const UmkmListScreen({super.key});

  @override
  State<UmkmListScreen> createState() => _UmkmListScreenState();
}

class _UmkmListScreenState extends State<UmkmListScreen> {
  static const List<String> _categories = [
    'Semua',
    'Paket Masak',
    'Segar',
    'Lauk Instan',
    'Hemat Kos',
  ];

  final UmkmRepository _repository = UmkmRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Umkm> _umkmList = [];
  _ViewStatus _status = _ViewStatus.loading;
  String _errorMessage = '';
  String _selectedCategory = 'Semua';

  // Ubah ke true untuk menguji tampilan error.
  final bool _simulateError = false;

  @override
  void initState() {
    super.initState();
    _loadUmkm();
  }

  @override
  void dispose() {
    // Controller dibuang saat layar ditutup agar tidak memory leak.
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUmkm() async {
    // Saat "Coba Lagi" ditekan, kembali ke tampilan loading dulu.
    if (_status != _ViewStatus.loading) {
      setState(() => _status = _ViewStatus.loading);
    }
    try {
      final data = await _repository.fetchUmkm(simulateError: _simulateError);
      if (!mounted) return; // layar sudah ditutup saat menunggu data
      setState(() {
        _umkmList = data;
        _status = _ViewStatus.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _status = _ViewStatus.error;
      });
    }
  }

  /// UMKM yang lolos pencarian dan filter kategori.
  List<Umkm> get _filteredUmkm {
    final query = _searchController.text.trim().toLowerCase();
    return _umkmList.where((umkm) {
      final matchesQuery =
          query.isEmpty ||
          '${umkm.name} ${umkm.description} ${umkm.category}'
              .toLowerCase()
              .contains(query);
      final matchesCategory =
          _selectedCategory == 'Semua' || umkm.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _toggleFollow(String umkmId) {
    final updated = _repository.toggleFollow(umkmId);

    // Ganti hanya UMKM yang berubah, tanpa memuat ulang seluruh daftar.
    setState(() {
      _umkmList = _umkmList
          .map((umkm) => umkm.id == updated.id ? updated : umkm)
          .toList();
    });

    // Feedback ke pengguna setelah aksi.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated.isFollowing
              ? 'Kamu mengikuti ${updated.name}'
              : 'Berhenti mengikuti ${updated.name}',
        ),
      ),
    );
  }

  void _openDetail(Umkm umkm) {
    // Objek Umkm dikirim ke layar detail lewat arguments.
    Navigator.pushNamed(context, AppRoutes.umkmDetail, arguments: umkm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'UMKM Lokal',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppSpacing.page),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Cari nama UMKM...',
              prefixIcon: const Icon(Icons.search, color: AppColors.accent),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.field),
          SizedBox(
            height: _chipRowHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.small),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  showCheckmark: false,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                  selectedColor: AppColors.accent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.ink,
                  ),
                  side: const BorderSide(color: AppColors.border),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return switch (_status) {
      _ViewStatus.loading => const LoadingView(
        message: 'Memuat daftar UMKM...',
      ),
      _ViewStatus.error => ErrorView(
        message: _errorMessage,
        onRetry: _loadUmkm,
      ),
      _ViewStatus.success => _buildList(),
    };
  }

  Widget _buildList() {
    final umkmList = _filteredUmkm;
    if (umkmList.isEmpty) {
      final isFiltering =
          _searchController.text.trim().isNotEmpty ||
          _selectedCategory != 'Semua';
      return EmptyView(
        message: isFiltering
            ? 'UMKM yang kamu cari tidak ditemukan.'
            : 'Belum ada UMKM.',
        icon: isFiltering
            ? Icons.search_off_rounded
            : Icons.storefront_outlined,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.page),
      itemCount: umkmList.length,
      itemBuilder: (context, index) {
        final umkm = umkmList[index];
        return _UmkmCard(
          umkm: umkm,
          onTap: () => _openDetail(umkm),
          onToggleFollow: () => _toggleFollow(umkm.id),
        );
      },
    );
  }
}

class _UmkmCard extends StatelessWidget {
  final Umkm umkm;
  final VoidCallback onTap;
  final VoidCallback onToggleFollow;

  const _UmkmCard({
    required this.umkm,
    required this.onTap,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
    );

    return Card(
      elevation: 0,
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: AppSpacing.field),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(umkm.name, style: textTheme.headlineSmall),
                  ),
                  const SizedBox(width: AppSpacing.field),
                  const Icon(
                    Icons.star,
                    size: _iconSize,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Text(
                    umkm.rating.toStringAsFixed(1),
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                umkm.category,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              Text(umkm.description, style: textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.small),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: _iconSize,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Text(
                      umkm.address ?? 'Alamat tidak tersedia',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.field),
              Align(
                alignment: Alignment.centerRight,
                child: umkm.isFollowing
                    ? OutlinedButton.icon(
                        onPressed: onToggleFollow,
                        icon: const Icon(Icons.check),
                        label: const Text('Mengikuti'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: buttonShape,
                        ),
                      )
                    : FilledButton.icon(
                        onPressed: onToggleFollow,
                        icon: const Icon(Icons.add),
                        label: const Text('Ikuti'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: buttonShape,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
