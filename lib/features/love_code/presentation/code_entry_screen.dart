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
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedRole; // Added for when role isn't in DB yet

  @override
  void initState() {
    super.initState();
    debugPrint('💖 CodeEntry: Screen Initialized');
    _controller.text = 'LUNA-';
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  void dispose() {
    debugPrint('💖 CodeEntry: Screen Disposed');
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _errorMessage = null);

    final upperValue = value.toUpperCase();
    debugPrint('💖 CodeEntry: Input changed: $upperValue');

    // Handle pasting a full code or a partial code
    if (upperValue.contains('LUNA-')) {
      // If they pasted a whole thing, just clean it up slightly if needed
      if (!upperValue.startsWith('LUNA-')) {
        final index = upperValue.indexOf('LUNA-');
        _controller.text = upperValue.substring(index);
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    } else if (upperValue.length >= 4 && !upperValue.startsWith('LUNA')) {
      // If they pasted a code without the LUNA- prefix (e.g. ROSE-MOON-1234)
      _controller.text = 'LUNA-$upperValue';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    } else if (upperValue.isEmpty) {
      _controller.text = 'LUNA-';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  Future<void> _linkPartner() async {
    final rawInput = _controller.text.trim().toUpperCase();

    // Support pasting full "LUNA-XXXX" or just "XXXX"
    String code;
    if (rawInput.startsWith('LUNA-')) {
      code = rawInput;
    } else {
      code = 'LUNA-$rawInput';
    }

    debugPrint('💖 CodeEntry: Attempting to link with cleaned code: $code');

    // Validation
    if (code == 'LUNA-' || code.length < 10) {
      setState(() => _errorMessage = 'Please enter a valid complete code.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No authenticated session found.');

      // Ensure profile is fully loaded
      final appUser = ref.read(authProvider).valueOrNull;
      if (appUser == null) {
        throw Exception('Your profile is still syncing. Please wait a moment.');
      }

      // Role determination: priority to DB role, then local selection
      final effectiveRole = appUser.role ?? _selectedRole;
      debugPrint(
        '💖 CodeEntry: User role: ${appUser.role}, Selected role: $_selectedRole -> Effective: $effectiveRole',
      );

      if (effectiveRole == null) {
        debugPrint('⚠️ CodeEntry: No role selected');
        throw Exception('Please select who you are first (Her or Him).');
      }

      final db = FirebaseFirestore.instance;

      // Use a transaction for atomic linking
      debugPrint(
        '💖 CodeEntry: Starting atomic link transaction for UID: ${user.uid}',
      );
      await db.runTransaction((transaction) async {
        final codeRef = db.collection('loveCodes').doc(code);

        debugPrint('💖 CodeEntry: Fetching code document: $code');
        final codeDoc = await transaction.get(codeRef);

        if (!codeDoc.exists) {
          debugPrint('❌ CodeEntry: Code not found in database: $code');
          throw Exception('Invalid code. Please double-check it.');
        }

        final codeData = codeDoc.data()!;
        final ownerUid = codeData['ownerUid'] as String;
        final ownerRole = codeData['ownerRole'] as String;
        final ownerName = codeData['ownerName'] as String;

        debugPrint(
          '💖 CodeEntry: Code details - Owner: $ownerName ($ownerUid), Role: $ownerRole',
        );

        if (codeData['linkedUid'] != null || codeData['isActive'] == false) {
          debugPrint(
            '❌ CodeEntry: Code already linked to ${codeData['linkedUid']} or inactive',
          );
          throw Exception('This code has already been used.');
        }

        if (ownerUid == user.uid) {
          debugPrint('❌ CodeEntry: User attempted to link with their own code');
          throw Exception('You cannot link with your own code.');
        }

        // Role Check - Ensure opposite roles or at least valid roles
        if (effectiveRole == ownerRole) {
          debugPrint('❌ CodeEntry: Role Conflict - Both are $ownerRole');
          throw Exception(
            'Both users are registered as $ownerRole. Please check your roles.',
          );
        }

        // Determine Couple ID (sorted UIDs for consistency)
        final uids = [user.uid, ownerUid]..sort();
        final coupleId = '${uids[0]}_${uids[1]}';

        debugPrint(
          '💖 CodeEntry: Linking: Me($effectiveRole) <-> Partner($ownerRole) | CoupleID: $coupleId',
        );

        // 1. Mark code as used
        debugPrint('💖 CodeEntry: Step 1 - Marking code as used');
        transaction.update(codeRef, {
          'linkedUid': user.uid,
          'linkedAt': FieldValue.serverTimestamp(),
          'isActive': false,
        });

        // 2. Update My Doc
        debugPrint('💖 CodeEntry: Step 2 - Updating my user doc');
        transaction.update(db.collection('users').doc(user.uid), {
          'role': effectiveRole,
          'partnerUid': ownerUid,
          'partnerRole': ownerRole,
          'partnerDisplayName': ownerName,
          'coupleId': coupleId,
          'isLinked': true,
          'isOnboarded': true,
        });

        // 3. Update Partner Doc
        final myName = appUser.displayName.isEmpty
            ? 'Love'
            : appUser.displayName;
        debugPrint(
          '💖 CodeEntry: Step 3 - Updating partner user doc with my name: $myName',
        );
        transaction.update(db.collection('users').doc(ownerUid), {
          'partnerUid': user.uid,
          'partnerRole': effectiveRole,
          'partnerDisplayName': myName,
          'coupleId': coupleId,
          'isLinked': true,
          'isOnboarded': true,
        });

        // 4. Create/Initialize Shared Doc
        debugPrint(
          '💖 CodeEntry: Step 4 - Initializing shared couple document',
        );
        transaction.set(db.collection('shared').doc(coupleId), {
          'uids': uids,
          'herUid': effectiveRole == 'her' ? user.uid : ownerUid,
          'himUid': effectiveRole == 'him' ? user.uid : ownerUid,
          'linkedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'active',
        }, SetOptions(merge: true));
      });

      debugPrint('✅ CodeEntry: Link successful! Redirecting to home...');

      // Force a profile refresh to update the UI
      debugPrint('💖 CodeEntry: Refreshing auth provider...');
      await ref.read(authProvider.notifier).refresh();

      HapticFeedback.mediumImpact();
      if (mounted) {
        context.goNamed(AppRoutes.home);
      }
    } catch (e, stack) {
      debugPrint('❌ CodeEntry Error: $e');
      debugPrint('❌ CodeEntry StackTrace: $stack');
      setState(() {
        _errorMessage = e.toString().contains('permission-denied')
            ? 'Access Denied: Please check Firestore Rules.'
            : e.toString().replaceAll('Exception: ', '');
      });
      HapticFeedback.vibrate();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).valueOrNull;
    final needsRole = user?.role == null;
    final effectiveRole = user?.role ?? _selectedRole;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.charcoal),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  effectiveRole == 'her'
                      ? "Enter His Code 💙"
                      : effectiveRole == 'him'
                      ? "Enter Her Code 🌸"
                      : "Enter Love Code",
                  style: AppTypography.h1.copyWith(
                    fontFamily: 'Cormorant Garamond',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  effectiveRole == 'her'
                      ? "Ask him for his 4-part love code."
                      : effectiveRole == 'him'
                      ? "Ask her for her 4-part love code."
                      : "Ask your partner for their 4-part love code.",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warmGray600,
                  ),
                ),

                if (needsRole) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    "First, who are you?",
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _RoleButton(
                        label: "HER 🌸",
                        isSelected: _selectedRole == 'her',
                        onTap: () {
                          debugPrint('💖 CodeEntry: Selected role: HER');
                          setState(() => _selectedRole = 'her');
                        },
                        color: AppColors.rosePrimary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _RoleButton(
                        label: "HIM 💙",
                        isSelected: _selectedRole == 'him',
                        onTap: () {
                          debugPrint('💖 CodeEntry: Selected role: HIM');
                          setState(() => _selectedRole = 'him');
                        },
                        color: AppColors.slateBluePrimary,
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: AppSpacing.xxl),

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
                    border: Border.all(color: AppColors.roseMid, width: 1.5),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textAlign: TextAlign.center,
                    style: AppTypography.h3.copyWith(
                      fontFamily: 'Cormorant Garamond',
                      letterSpacing: 2,
                      color: AppColors.charcoal,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9\-]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: "LUNA-XXXX-XXXX-XXXX",
                      hintStyle: TextStyle(color: AppColors.warmGray400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(AppSpacing.xl),
                    ),
                    onChanged: _onChanged,
                  ),
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

                const SizedBox(height: AppSpacing.xxl),
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
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _RoleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.warmGray300,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.charcoal,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
