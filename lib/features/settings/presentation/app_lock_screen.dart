import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/widgets/luna_card.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _biometricsEnabled = false;
  bool _appLockEnabled = false;
  String _pinCode = '';
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _loadSecuritySettings() {
    final box = Hive.box('settings');
    setState(() {
      _appLockEnabled = box.get('security_lock_enabled', defaultValue: false);
      _biometricsEnabled = box.get('security_biometrics_enabled', defaultValue: false);
      _pinCode = box.get('security_pin_code', defaultValue: '');
      _pinController.text = _pinCode;
    });
  }

  Future<void> _toggleBiometrics(bool value) async {
    HapticFeedback.lightImpact();
    
    if (value) {
      // Check device biometrics support
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;

      if (!isSupported || !canCheck) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your device does not support biometric checks 🌸')),
          );
        }
        return;
      }

      // Try local auth check
      try {
        final authenticated = await _auth.authenticate(
          localizedReason: 'Verify your face or fingerprint to lock LUNA securely',
          options: const AuthenticationOptions(stickyAuth: true),
        );

        if (authenticated) {
          final box = Hive.box('settings');
          await box.put('security_biometrics_enabled', true);
          setState(() => _biometricsEnabled = true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification error: $e 💕')),
          );
        }
      }
    } else {
      final box = Hive.box('settings');
      await box.put('security_biometrics_enabled', false);
      setState(() => _biometricsEnabled = false);
    }
  }

  Future<void> _savePinSettings() async {
    HapticFeedback.mediumImpact();
    final pin = _pinController.text.trim();
    if (_appLockEnabled && pin.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a secure 4-digit PIN 💕')),
      );
      return;
    }

    final box = Hive.box('settings');
    await box.put('security_lock_enabled', _appLockEnabled);
    await box.put('security_pin_code', pin);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Security parameters updated successfully 🔒'),
          backgroundColor: AppColors.rosePrimary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text('App Security 🔒', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Core description
              LunaCard(
                borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                child: Column(
                  children: [
                    const Icon(Icons.security, size: 48, color: AppColors.rosePrimary),
                    const SizedBox(height: 12),
                    Text(
                      'Privacy & Vault Lock',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lock the app or secure entry checks to keep your secret diary and calendar 100% private.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Settings toggles
              LunaCard(
                borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                child: Column(
                  children: [
                    // Main app lock toggle
                    SwitchListTile(
                      value: _appLockEnabled,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        setState(() => _appLockEnabled = val);
                      },
                      activeColor: AppColors.rosePrimary,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Enable Security PIN Lock', style: AppTypography.titleLarge),
                      subtitle: Text('Asks for a numeric PIN code on startup', style: AppTypography.bodySmall),
                    ),
                    const Divider(),

                    // Fingerprint/Biometrics toggle
                    SwitchListTile(
                      value: _biometricsEnabled,
                      onChanged: _toggleBiometrics,
                      activeColor: AppColors.rosePrimary,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Use FaceID / Biometrics', style: AppTypography.titleLarge),
                      subtitle: Text('Fast verification check with your fingerprint', style: AppTypography.bodySmall),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // PIN Code input card (only shows if app lock is toggled)
              if (_appLockEnabled)
                LunaCard(
                  borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Configure Numeric PIN', style: AppTypography.titleLarge),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 4,
                        style: AppTypography.titleLarge.copyWith(
                          letterSpacing: 10.0,
                          color: isDark ? AppColors.darkText : AppColors.charcoal,
                        ),
                        decoration: InputDecoration(
                          hintText: '••••',
                          hintStyle: AppTypography.titleLarge.copyWith(color: AppColors.warmGray400),
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurface : AppColors.roseLight.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),

              // Submit button
              LunaButton(
                text: 'Save Security Parameters',
                onPressed: _savePinSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
