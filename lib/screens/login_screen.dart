import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';
import 'home_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/cookbox_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await context.read<LoginProvider>().login(
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Masuk berhasil. Selamat datang di CookBox!'
              : 'Masuk belum berhasil.',
        ),
      ),
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 600
                ? constraints.maxWidth * 0.2
                : AppSpacing.page;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.top,
                horizontalPadding,
                AppSpacing.page,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TopBar(),
                      const SizedBox(height: AppSpacing.section),
                      const _CampusTag(),
                      const SizedBox(height: AppSpacing.small),
                      Text(
                        'Selamat Datang Kembali!',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        'Masuk untuk melanjutkan perjalanan masakmu.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.section),
                      _FieldLabel(label: 'Nomor HP'),
                      const SizedBox(height: AppSpacing.small),
                      AppTextField(
                        controller: _phoneController,
                        label: '',
                        hint: '812-3456-7890',
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_outlined, size: 15),
                        prefixText: '+62   ',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nomor HP wajib diisi';
                          }
                          if (value.trim().length < 8) {
                            return 'Masukkan nomor HP yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.field),
                      _FieldLabel(label: 'Password'),
                      const SizedBox(height: AppSpacing.small),
                      AppTextField(
                        controller: _passwordController,
                        label: '',
                        hint: 'Masukkan password',
                        obscureText: provider.obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outline, size: 15),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: provider.obscurePassword
                              ? 'Tampilkan password'
                              : 'Sembunyikan password',
                          onPressed: context
                              .read<LoginProvider>()
                              .togglePasswordVisibility,
                          icon: Icon(
                            provider.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 16,
                          ),
                        ),
                        validator: (value) => value == null || value.length < 6
                            ? 'Password minimal 6 karakter'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.small),
                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: provider.rememberMe,
                              activeColor: AppColors.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (_) => context
                                  .read<LoginProvider>()
                                  .toggleRememberMe(),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Ingat Saya',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Lupa Password?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.small),
                      AppButton(
                        label: 'Masuk  →',
                        isLoading: provider.isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: AppSpacing.field),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: const [
                              TextSpan(text: 'Belum punya akun? '),
                              TextSpan(
                                text: 'Daftar Sekarang',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.section),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.border),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'ATAU',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.border),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.field),
                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.buttonHeight,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context)
                              .pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (_) => const HomeScreen(),
                                ),
                              ),
                          icon: const Icon(Icons.account_circle, size: 15),
                          label: const Text('Lanjut sebagai Pengunjung'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            backgroundColor: AppColors.surface,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radius,
                              ),
                            ),
                            textStyle: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.ink, fontSize: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.section),
                      const _BenefitCard(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.backButton,
          height: AppSpacing.backButton,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F0FF),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(Icons.arrow_back, size: 16),
          ),
        ),
        const Spacer(),
        const CookBoxLogo(compact: true),
        const Spacer(),
        SizedBox(width: AppSpacing.backButton),
      ],
    );
  }
}

class _CampusTag extends StatelessWidget {
  const _CampusTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.tagBackground,
        borderRadius: BorderRadius.circular(AppSpacing.compactRadius),
      ),
      child: Text(
        '🍳  Masak praktis dari UMKM sekitar kampus',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w600,
          fontSize: 8,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium
          ?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.infoIcon,
            height: AppSpacing.infoIcon,
            decoration: const BoxDecoration(
              color: AppColors.infoAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_outlined,
              color: AppColors.accent,
              size: 15,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Dibuat untuk mahasiswa & anak kos • Bayar\ntunai/manual saat ambil di mitra UMKM kampus.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.ink, fontSize: 8, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
