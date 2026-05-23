import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/auth/data/auth_repository.dart';
import 'package:her/features/cycle/data/cycle_repository.dart';
import 'package:her/features/home/providers/dashboard_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _remindersEnabled = true;
  bool _disguiseEnabled = false;
  double _cycleLength = 28.0;
  double _periodDuration = 5.0;
  DateTime _lastPeriodDate = DateTime.now().subtract(const Duration(days: 10));
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final box = Hive.box('settings');
    
    final appUser = ref.read(authProvider).valueOrNull;
    final cycleRepo = ref.read(cycleRepositoryProvider);
    
    final allEntries = await cycleRepo.getAllEntries();
    debugPrint('SettingsScreen: Found ${allEntries.length} cycle entries:');
    for (var e in allEntries) {
      debugPrint('  - ID: ${e.id}, Start: ${e.startDate}, End: ${e.endDate}');
    }

    final latestCycle = await cycleRepo.getLatestEntry();
    debugPrint('SettingsScreen: Latest cycle entry according to repo: ${latestCycle?.startDate}');
    
    // Safety check: If we have multiple active cycles, the UI might get confused.
    // Cleanup any duplicates that might be causing the "reverting" behavior.
    if (allEntries.where((e) => e.endDate == null).length > 1) {
      debugPrint('SettingsScreen: Found multiple active cycles, cleaning up...');
      final active = allEntries.where((e) => e.endDate == null).toList();
      // Keep only the one with the latest start date (or the one the user just set)
      active.sort((a, b) => b.startDate.compareTo(a.startDate));
      for (int i = 1; i < active.length; i++) {
        debugPrint('SettingsScreen: Removing duplicate active cycle ${active[i].id}');
        await cycleRepo.deleteCycleEntry(active[i].id);
      }
    }
    
    setState(() {
      _remindersEnabled = box.get('notifications_enabled', defaultValue: true);
      _disguiseEnabled = box.get('disguise_mode_enabled', defaultValue: false);
      
      if (appUser != null) {
        _cycleLength = appUser.cycleAverageLength.toDouble();
        _periodDuration = appUser.periodAverageLength.toDouble();
        _nameController.text = appUser.displayName;
      } else {
        _cycleLength = box.get('cycle_length', defaultValue: 28).toDouble();
        _periodDuration = box.get('period_duration', defaultValue: 5).toDouble();
        _nameController.text = box.get('username', defaultValue: 'Love');
      }
      
      if (latestCycle != null) {
        _lastPeriodDate = latestCycle.startDate;
      } else {
        final dateStr = box.get('last_period_date');
        if (dateStr != null) {
          _lastPeriodDate = DateTime.parse(dateStr);
        } else {
          _lastPeriodDate = DateTime.now().subtract(const Duration(days: 10));
        }
      }
    });
  }

  Future<void> _save() async {
    HapticFeedback.mediumImpact();
    debugPrint('SettingsScreen: Saving preferences...');
    
    final box = Hive.box('settings');
    debugPrint('SettingsScreen: Updating local Hive with: name=${_nameController.text.trim()}, cycle=$_cycleLength, period=$_periodDuration, date=$_lastPeriodDate');
    await box.putAll({
      'notifications_enabled': _remindersEnabled,
      'disguise_mode_enabled': _disguiseEnabled,
      'cycle_length': _cycleLength.toInt(),
      'period_duration': _periodDuration.toInt(),
      'username': _nameController.text.trim(),
      'last_period_date': _lastPeriodDate.toIso8601String(),
    });
    
    final appUser = ref.read(authProvider).valueOrNull;
    if (appUser != null) {
      final authNotifier = ref.read(authProvider.notifier);
      final cycleRepo = ref.read(cycleRepositoryProvider);

      try {
        debugPrint('SettingsScreen: Updating Firebase profile...');
        await authNotifier.updateProfile(appUser.copyWith(
          displayName: _nameController.text.trim(),
          cycleAverageLength: _cycleLength.toInt(),
          periodAverageLength: _periodDuration.toInt(),
        ));
      } catch (e) {
        debugPrint('SettingsScreen: Profile update failed: $e');
      }
      
      try {
        debugPrint('SettingsScreen: Force cleaning all active cycles to prevent reverts...');
        final currentEntries = await cycleRepo.getAllEntries();
        final active = currentEntries.where((e) => e.endDate == null).toList();
        for (var e in active) {
          await cycleRepo.deleteCycleEntry(e.id);
        }
        
        debugPrint('SettingsScreen: Setting single active cycle to $_lastPeriodDate');
        await cycleRepo.startPeriod(_lastPeriodDate);
      } catch (e) {
        debugPrint('SettingsScreen: Cycle update failed: $e');
      }
      
      debugPrint('SettingsScreen: Invalidating dashboard for recalculation');
      ref.invalidate(dashboardProvider);
    } else {
      debugPrint('SettingsScreen: No authenticated user, only local Hive updated.');
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferences saved successfully 🌸'),
          backgroundColor: AppColors.rosePrimary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.rosePrimary,
              onPrimary: AppColors.white,
              onSurface: AppColors.roseDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _lastPeriodDate) {
      setState(() {
        _lastPeriodDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text('Settings ⚙️', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Data
              LunaCard(
                borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Details', style: AppTypography.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _nameController,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.charcoal,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        labelStyle: TextStyle(color: AppColors.warmGray600),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.roseSoft)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.rosePrimary)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Cycle configurations
              LunaCard(
                borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cycle Configurations', style: AppTypography.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Last period start date
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Last Period Start Date', style: AppTypography.titleMedium),
                                const SizedBox(height: 2),
                                Text('Tap to change the date', style: AppTypography.bodySmall.copyWith(color: AppColors.warmGray600)),
                              ],
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy').format(_lastPeriodDate),
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.rosePrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Cycle length
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Average Cycle Duration', style: AppTypography.titleMedium),
                        Text('${_cycleLength.toInt()} Days', style: AppTypography.titleMedium.copyWith(color: AppColors.rosePrimary)),
                      ],
                    ),
                    Slider(
                      value: _cycleLength,
                      min: 21,
                      max: 45,
                      activeColor: AppColors.rosePrimary,
                      inactiveColor: AppColors.roseSoft,
                      onChanged: (val) => setState(() => _cycleLength = val),
                    ),
                    const SizedBox(height: 8),

                    // Period duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Average Period Duration', style: AppTypography.titleMedium),
                        Text('${_periodDuration.toInt()} Days', style: AppTypography.titleMedium.copyWith(color: AppColors.rosePrimary)),
                      ],
                    ),
                    Slider(
                      value: _periodDuration,
                      min: 3,
                      max: 10,
                      activeColor: AppColors.rosePrimary,
                      inactiveColor: AppColors.roseSoft,
                      onChanged: (val) => setState(() => _periodDuration = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Disguise & Alerts
              LunaCard(
                borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _remindersEnabled,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        setState(() => _remindersEnabled = val);
                      },
                      activeColor: AppColors.rosePrimary,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Loving Reminders', style: AppTypography.titleLarge),
                      subtitle: Text('Receive morning hints and cramp checkers', style: AppTypography.bodySmall),
                    ),
                    const Divider(),
                    SwitchListTile(
                      value: _disguiseEnabled,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        setState(() => _disguiseEnabled = val);
                      },
                      activeColor: AppColors.rosePrimary,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Disguise Mode (Calculator)', style: AppTypography.titleLarge),
                      subtitle: Text('Disguises entry points under standard calculator buttons', style: AppTypography.bodySmall),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Save button
              LunaButton(
                text: 'Save Preferences 🌸',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
