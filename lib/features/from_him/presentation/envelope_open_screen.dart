import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_shadows.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';

class EnvelopeOpenScreen extends StatefulWidget {
  final String letterId;

  const EnvelopeOpenScreen({
    super.key,
    required this.letterId,
  });

  @override
  State<EnvelopeOpenScreen> createState() => _EnvelopeOpenScreenState();
}

class _EnvelopeOpenScreenState extends State<EnvelopeOpenScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  bool _isOpened = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack)),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.4, 1.0, curve: Curves.easeInOutCubic)),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _openEnvelope() {
    if (!_isOpened) {
      HapticFeedback.heavyImpact();
      setState(() => _isOpened = true);
      _animController.forward();
    }
  }

  String _getLetterContent(String id) {
    switch (id) {
      case 'cramps':
        return 'My love, I know your body hurts right now. I wish I could hold you and take all the pain away myself. Keep a warm water bag on your tummy, drink plenty of warm water, and sleep. I am thinking of you every single second. 💕';
      case 'sad':
        return 'Hey baby, please don\'t be sad or low. Your smile is my absolute favorite thing in the world. Whatever is on your mind, remember we will face it together. Breathe, settle in, and know I love you more than life itself. 💕';
      case 'sunny':
        return 'It\'s a beautiful day, isn\'t it? Just like you! I hope you are having an amazing time today. Go out, feel the sunshine, and remember you are the absolute best thing that ever happened to me. 💕';
      case 'argument':
        return 'My dear, I am so sorry if we had a little argument. Sometimes I can be stupid, but my heart is entirely yours. I never want to make you sad. Let\'s resolve it, cuddle, and remember we are a team forever. 💕';
      case 'miss_me':
        return 'Miss me? I miss you ten times more! Close your eyes for a second, trigger the virtual hug, and feel me there holding you. We will be together soon, my sweet rose. 💕';
      default:
        return 'I built this space for you because I care about your comfort and happiness more than anything. I want this space to be a warm embrace whenever you need it. You are loved, always. 💕';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final letterText = _getLetterContent(widget.letterId);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.goldSoft,
      appBar: AppBar(
        title: Text(_isOpened ? 'Letter Opened ✉️' : 'A Sealed Envelope 💌', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: _openEnvelope,
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final scale = _isOpened ? _scaleAnimation.value : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. BACK SHEET: The Letter that slides up
                          if (_isOpened)
                            Transform.translate(
                              offset: Offset(0, -180 * _slideAnimation.value),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _slideAnimation.value,
                                child: Container(
                                  width: 320,
                                  padding: const EdgeInsets.all(AppSpacing.xl),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkCard : AppColors.white,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    boxShadow: AppShadows.goldShadow,
                                    border: Border.all(
                                      color: isDark ? AppColors.darkBorder : AppColors.goldSoft,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Hey Priya,',
                                        style: AppTypography.handwrittenLg.copyWith(
                                          color: isDark ? AppColors.goldMid : AppColors.roseDark,
                                          fontSize: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        letterText,
                                        textAlign: TextAlign.center,
                                        style: AppTypography.handwritten.copyWith(
                                          fontSize: 16,
                                          height: 1.5,
                                          color: isDark ? AppColors.darkText : AppColors.charcoal,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '— Yours Forever 💕',
                                        style: AppTypography.handwrittenLg.copyWith(
                                          color: isDark ? AppColors.goldMid : AppColors.rosePrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // 2. FRONT SHEET: The Envelope cover
                          Container(
                            width: 330,
                            height: 200,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.goldSoft,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.goldPrimary,
                                width: 2.0,
                              ),
                              boxShadow: AppShadows.cardShadow,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isOpened ? '❤️' : '✉️',
                                  style: const TextStyle(fontSize: 48),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _isOpened ? 'Sent with Love' : 'Tap to Break Seal 🌸',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: isDark ? AppColors.goldMid : AppColors.roseDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!_isOpened) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Unlocks a handwritten note',
                                    style: AppTypography.bodySmall.copyWith(fontSize: 10),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
