import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/love_code/data/love_code_repository.dart';

class LinkPartnerScreen extends ConsumerStatefulWidget {
  const LinkPartnerScreen({super.key});

  @override
  ConsumerState<LinkPartnerScreen> createState() => _LinkPartnerScreenState();
}

class _LinkPartnerScreenState extends ConsumerState<LinkPartnerScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _link() async {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(loveCodeRepositoryProvider).linkWithPartner(code);
      await ref.read(authProvider.notifier).refresh();
      if (mounted) context.go('/');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString().contains('Exception: ') 
            ? e.toString().split('Exception: ')[1] 
            : "Invalid code. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softIvory,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.favorite_outline, size: 80, color: AppColors.rosePrimary),
              const SizedBox(height: 32),
              Text("Connect with Partner", 
                style: AppTypography.h2, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Text(
                "Enter your partner's Love Code to sync your experiences.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.warmGray600),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Love Code",
                  hintText: "LUNA-XXXX-XXXX-XXXX",
                  errorText: _error,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _link,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rosePrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Connect Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.read(authProvider.notifier).signOut(),
                child: const Text("Sign Out", style: TextStyle(color: AppColors.warmGray500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
