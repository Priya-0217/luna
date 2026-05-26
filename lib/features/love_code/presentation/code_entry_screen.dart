import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/features/auth/providers/auth_provider.dart';

class CodeEntryScreen extends ConsumerStatefulWidget {
  const CodeEntryScreen({super.key});

  @override
  ConsumerState<CodeEntryScreen> createState() => _CodeEntryScreenState();
}

class _CodeEntryScreenState extends ConsumerState<CodeEntryScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Default first segment to 'LUNA'
    _controllers[0].text = 'LUNA';
  }

  @override
  void dispose() {
    for (var c in _controllers) { c.dispose(); }
    for (var f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      // Auto-advance
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _linkPartner() async {
    final code = _controllers.map((c) => c.text.trim().toUpperCase()).join('-');
    if (code.length < 15) {
      setState(() => _errorMessage = 'Please enter a valid complete code.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not logged in');

      final appUser = ref.read(authProvider).valueOrNull;
      if (appUser == null) throw Exception('Profile not loaded');

      final db = FirebaseFirestore.instance;

      // Use a transaction for atomic linking
      await db.runTransaction((transaction) async {
        final codeRef = db.collection('loveCodes').doc(code);
        final codeDoc = await transaction.get(codeRef);

        if (!codeDoc.exists) {
          throw Exception('Code not found. Please check and try again.');
        }

        final codeData = codeDoc.data()!;
        if (codeData['linkedUid'] != null) {
          throw Exception('This code has already been used.');
        }

        if (codeData['ownerUid'] == user.uid) {
          throw Exception('You cannot link with your own code.');
        }

        // Determine Couple ID (sorted UIDs to ensure uniqueness)
        final uid1 = user.uid;
        final uid2 = codeData['ownerUid'] as String;
        final coupleId = [uid1, uid2]..sort();
        final coupleIdStr = '${coupleId[0]}_${coupleId[1]}';

        // Check Roles
        final myRole = appUser.role; // 'her' or 'him'
        final partnerRole = codeData['ownerRole'];
        
        // (Optional) Enforce opposite roles, or just allow it
        // if (myRole == partnerRole) throw Exception('Cannot link identical roles right now.');

        // Update Code Doc
        transaction.update(codeRef, {
          'linkedUid': user.uid,
          'linkedAt': FieldValue.serverTimestamp(),
          'isActive': false,
        });

        // Update Partner's User Doc
        final partnerRef = db.collection('users').doc(uid2);
        transaction.update(partnerRef, {
          'partnerUid': user.uid,
          'partnerRole': myRole,
          'partnerDisplayName': appUser.displayName,
          'coupleId': coupleIdStr,
          'isLinked': true,
        });

        // Update My User Doc
        final myRef = db.collection('users').doc(uid1);
        transaction.update(myRef, {
          'partnerUid': uid2,
          'partnerRole': partnerRole,
          'partnerDisplayName': codeData['ownerName'],
          'coupleId': coupleIdStr,
          'isLinked': true,
        });

        // Create Shared Doc
        final sharedRef = db.collection('shared').doc(coupleIdStr);
        transaction.set(sharedRef, {
          'herUid': myRole == 'her' ? uid1 : uid2,
          'himUid': myRole == 'him' ? uid1 : uid2,
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      // Refresh local auth state
      await ref.read(authProvider.notifier).refresh();

      HapticFeedback.heavyImpact();
      if (mounted) {
        // Navigate home
        context.goNamed(AppRoutes.home);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      HapticFeedback.vibrate();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.charcoal),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Love Code",
                style: AppTypography.h1.copyWith(
                  fontFamily: 'Cormorant Garamond',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Ask your partner for their 4-part love code.",
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.warmGray600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _CodeSegmentInput(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        onChanged: (v) => _onChanged(v, index),
                      ),
                    ),
                  );
                }),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Text(
                    _errorMessage!,
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.red.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const Spacer(),
              LunaButton(
                text: "Connect Hearts",
                isLoading: _isLoading,
                onPressed: _linkPartner,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeSegmentInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const _CodeSegmentInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmGray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: AppTypography.bodyLarge.copyWith(
          fontFamily: 'Cormorant Garamond',
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          LengthLimitingTextInputFormatter(6),
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        ),
      ),
    );
  }
}
