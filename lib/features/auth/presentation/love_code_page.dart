import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/features/auth/providers/auth_provider.dart';

class LoveCodePage extends ConsumerStatefulWidget {
  const LoveCodePage({super.key});

  @override
  ConsumerState<LoveCodePage> createState() => _LoveCodePageState();
}

class _LoveCodePageState extends ConsumerState<LoveCodePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFlip() {
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider).value;
    final code = auth?.coupleId?.substring(0, 6).toUpperCase() ?? "LUNA12";

    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(title: const Text("Love Code"), centerTitle: true, elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Secret Key", style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Text("Share this with your partner to sync", style: AppTypography.bodySmall),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: _onFlip,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final angle = _controller.value * pi;
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    alignment: Alignment.center,
                    child: angle < pi / 2 ? _buildFront() : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi),
                        child: _buildBack(code),
                      ),
                  );
                },
              ),
            ),
            const SizedBox(height: 64),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Code copied!")));
              },
              icon: const Icon(Icons.copy),
              label: const Text("Copy to Clipboard"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rosePrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      width: 250,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.rosePrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.rosePrimary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: const Center(
        child: Icon(Icons.favorite, color: Colors.white, size: 64),
      ),
    );
  }

  Widget _buildBack(String code) {
    return Container(
      width: 250,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.rosePrimary, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Center(
        child: Text(
          code,
          style: AppTypography.displayMedium.copyWith(color: AppColors.rosePrimary, letterSpacing: 4),
        ),
      ),
    );
  }
}
