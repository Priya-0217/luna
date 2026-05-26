import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDisplayWidget extends StatelessWidget {
  final String code;
  final String partnerName;

  const QRDisplayWidget({
    super.key,
    required this.code,
    required this.partnerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9), // Ivory card
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Connect with $partnerName',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scan this code to link your accounts',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.darkText.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.roseSoft),
            ),
            child: QrImageView(
              data: 'luna://connect?code=$code',
              version: QrVersions.auto,
              size: 200.0,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color: AppColors.rosePrimary,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: AppColors.rosePrimary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.roseLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              code,
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: AppColors.rosePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
