import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoveCodePage extends StatefulWidget {
  final String role;
  final String code; // LUNA-ROSE-MOON-1234
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onQR;
  final VoidCallback? onSkip;
  final Future<void> Function(String code)? onConnectCode;

  const LoveCodePage({
    super.key,
    required this.role,
    required this.code,
    required this.onCopy,
    required this.onShare,
    required this.onQR,
    this.onSkip,
    this.onConnectCode,
  });

  @override
  State<LoveCodePage> createState() => _LoveCodePageState();
}

class _LoveCodePageState extends State<LoveCodePage> {
  bool _revealed = false;
  bool _isInputMode = false;
  bool _isConnecting = false;
  final TextEditingController _partnerCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _partnerCodeController.text = 'LUNA-';
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _revealed = true);
    });
  }

  @override
  void dispose() {
    _partnerCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final segments = widget.code.split('-');
    final isHer = widget.role == 'her';
    final accentColor = isHer
        ? AppColors.rosePrimary
        : AppColors.slateBluePrimary;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(
            _isInputMode
                ? (isHer ? "Enter His Code 💙" : "Enter Her Code 🌸")
                : "Your love code",
            style: AppTypography.h1.copyWith(
              fontFamily: 'Cormorant Garamond',
              fontSize: 32,
            ),
          ),
          Text(
            _isInputMode
                ? (isHer ? "Ask him for his code" : "Ask her for her code")
                : (isHer
                      ? "Share this with him so he can find you"
                      : "Share this with her so she can find you"),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.warmGray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (!_isInputMode) ...[
            if (_revealed)
              _CodeCard(
                    segments: segments,
                    isHer: isHer,
                    accentColor: accentColor,
                    onCopy: widget.onCopy,
                    onShare: widget.onShare,
                    onQR: widget.onQR,
                  )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            if (widget.onConnectCode != null) ...[
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => setState(() => _isInputMode = true),
                child: Text(
                  isHer ? "Enter his code instead" : "Enter her code instead",
                  style: AppTypography.labelSmall.copyWith(color: accentColor),
                ),
              ),
            ],
          ] else ...[
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.charcoal.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: accentColor.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _partnerCodeController,
                textAlign: TextAlign.center,
                style: AppTypography.h3.copyWith(
                  fontFamily: 'Cormorant Garamond',
                  letterSpacing: 2,
                  color: AppColors.charcoal,
                ),
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: "LUNA-XXXX-XXXX-XXXX",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppSpacing.xl),
                ),
                onChanged: (value) {
                  final upperValue = value.toUpperCase();
                  if (upperValue.contains('LUNA-')) {
                    if (!upperValue.startsWith('LUNA-')) {
                      final index = upperValue.indexOf('LUNA-');
                      _partnerCodeController.text = upperValue.substring(index);
                      _partnerCodeController.selection =
                          TextSelection.fromPosition(
                            TextPosition(
                              offset: _partnerCodeController.text.length,
                            ),
                          );
                    }
                  } else if (upperValue.length >= 4 &&
                      !upperValue.startsWith('LUNA')) {
                    _partnerCodeController.text = 'LUNA-$upperValue';
                    _partnerCodeController
                        .selection = TextSelection.fromPosition(
                      TextPosition(offset: _partnerCodeController.text.length),
                    );
                  } else if (upperValue.isEmpty) {
                    _partnerCodeController.text = 'LUNA-';
                    _partnerCodeController
                        .selection = TextSelection.fromPosition(
                      TextPosition(offset: _partnerCodeController.text.length),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            LunaButton(
              text: "Connect Hearts",
              isLoading: _isConnecting,
              onPressed: () async {
                setState(() => _isConnecting = true);
                try {
                  await widget.onConnectCode?.call(
                    _partnerCodeController.text.trim(),
                  );
                } finally {
                  if (mounted) setState(() => _isConnecting = false);
                }
              },
            ),
            TextButton(
              onPressed: () => setState(() => _isInputMode = false),
              child: Text(
                "Back to my code",
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.warmGray600,
                ),
              ),
            ),
          ],
          if (widget.onSkip != null && !_isInputMode) ...[
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: widget.onSkip,
              child: Text(
                "Skip for now, connect later",
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.warmGray600,
                ),
              ),
            ),
          ],
          const Spacer(),
          Image.asset(
                _isInputMode
                    ? AppIllustrations.hello
                    : (_revealed
                          ? AppIllustrations.excited
                          : AppIllustrations.shy),
                height: 140,
              )
              .animate(target: _revealed ? 1 : 0)
              .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  final List<String> segments;
  final bool isHer;
  final Color accentColor;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onQR;

  const _CodeCard({
    required this.segments,
    required this.isHer,
    required this.accentColor,
    required this.onCopy,
    required this.onShare,
    required this.onQR,
  });

  @override
  Widget build(BuildContext context) {
    return LunaCard(
      color: AppColors.ivory,
      padding: const EdgeInsets.all(AppSpacing.xl),
      borderColor: isHer
          ? AppColors.roseMid.withOpacity(0.3)
          : AppColors.slateBlueMid.withOpacity(0.3),
      child: Column(
        children: [
          Text(
            "Your love code",
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.warmGray400,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (int i = 0; i < segments.length; i++) ...[
                Text(
                  segments[i],
                  style: const TextStyle(
                    fontFamily: 'Cormorant Garamond',
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 6,
                    color: AppColors.charcoal,
                  ),
                ),
                if (i < segments.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.circle,
                      size: 6,
                      color: AppColors.goldPrimary,
                    ),
                  ),
              ],
            ],
          ).animate().shimmer(
            duration: 2.seconds,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.goldMid),
          const SizedBox(height: AppSpacing.md),
          Text(
            isHer
                ? "Share with your partner so they can connect with you in Luna"
                : "Share with her so she can connect with you in Luna",
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(fontSize: 14),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(label: "Copy", icon: Icons.copy, onTap: onCopy),
              _ActionButton(label: "Share", icon: Icons.share, onTap: onShare),
              _ActionButton(label: "QR", icon: Icons.qr_code, onTap: onQR),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            "Code expires in 6 months if unused",
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.warmGray400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.charcoal,
        side: BorderSide(color: AppColors.warmGray200),
        shape: const StadiumBorder(),
      ),
    );
  }
}
