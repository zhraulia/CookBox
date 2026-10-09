import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  bool _rated = false;
  String _tag = 'Bahan Segar';

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
                          Text(
                            'Pesanan berhasil dibuat',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            'No. CB-2026-1048',
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
          _ReviewCard(
            tag: _tag,
            rated: _rated,
            onTag: (value) => setState(() => _tag = value),
            onRate: () => setState(() => _rated = true),
          ),
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
        _TimelineStep(title: 'Dikirim', subtitle: '14:20', active: true),
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

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.tag,
    required this.rated,
    required this.onTag,
    required this.onRate,
  });
  final String tag;
  final bool rated;
  final ValueChanged<String> onTag;
  final VoidCallback onRate;

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
            'Beri laporan',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            'Bagaimana kualitas paketnya?',
            style: const TextStyle(color: AppColors.muted, fontSize: 10),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              5,
              (index) => IconButton(
                onPressed: onRate,
                icon: Icon(
                  index < 5 ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: index < 5 ? const Color(0xFFF2A900) : AppColors.border,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            children: ['Bahan Segar', 'Bumbu Lezat', 'Cepat']
                .map(
                  (value) => ChoiceChip(
                    label: Text(value, style: const TextStyle(fontSize: 9)),
                    selected: tag == value,
                    onSelected: (_) => onTag(value),
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
          TextFormField(
            minLines: 3,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Ulasan',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
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
          Text(
            rated
                ? 'Terima kasih, laporan Anda telah dikirim.'
                : 'Pilih rating terlebih dahulu untuk melaporkan.',
            style: const TextStyle(
              color: Color(0xFF247A4D),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
