import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/features/journal/domain/journal_entry.dart';
import 'package:her/features/journal/data/journal_repository.dart';
import 'package:her/features/journal/providers/journal_provider.dart';

class JournalWriteScreen extends ConsumerStatefulWidget {
  final JournalEntry? existingEntry;
  const JournalWriteScreen({super.key, this.existingEntry});

  @override
  ConsumerState<JournalWriteScreen> createState() => _JournalWriteScreenState();
}

class _JournalWriteScreenState extends ConsumerState<JournalWriteScreen> {
  final _bodyController = TextEditingController();
  String _selectedMood = 'happy';
  bool _isSaving = false;
  bool _isLoadingDecrypt = false;

  bool get _isEditing => widget.existingEntry != null;

  final List<Map<String, String>> moods = [
    {'key': 'happy',    'emoji': '🌸', 'label': 'Happy',    'asset': AppIllustrations.happy},
    {'key': 'cozy',     'emoji': '🧸', 'label': 'Cozy',     'asset': AppIllustrations.cozy},
    {'key': 'anxious',  'emoji': '🥺', 'label': 'Anxious',  'asset': AppIllustrations.anxious},
    {'key': 'down',     'emoji': '🌧️', 'label': 'Down',     'asset': AppIllustrations.sad},
    {'key': 'irritable','emoji': '🔥', 'label': 'Irritated','asset': AppIllustrations.irritated},
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _selectedMood = widget.existingEntry!.mood;
      _loadDecryptedContent();
    }
  }

  Future<void> _loadDecryptedContent() async {
    setState(() => _isLoadingDecrypt = true);
    try {
      final repo = ref.read(journalRepositoryProvider);
      final plaintext = await repo.decrypt(widget.existingEntry!.encryptedContent);
      _bodyController.text = plaintext;
    } catch (_) {
      _bodyController.text = '';
    } finally {
      if (mounted) setState(() => _isLoadingDecrypt = false);
    }
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final body = _bodyController.text.trim();
    if (body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please write down your feelings first 🌸')),
      );
      return;
    }

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      if (_isEditing) {
        // Update existing entry
        final repo = ref.read(journalRepositoryProvider);
        final entry = widget.existingEntry!;
        final driftId = await repo.getDriftId(entry.date);
        if (driftId != null) {
          await repo.updateEntry(
            driftId: driftId,
            firestoreId: entry.id,
            plaintextContent: body,
            mood: _selectedMood,
            originalDate: entry.date,
          );
          ref.invalidate(journalEntriesProvider);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Diary entry updated & re-encrypted 💕'),
              backgroundColor: AppColors.rosePrimary,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        // Create new entry via provider
        await ref.read(journalEntriesProvider.notifier).addEntry(
              plaintextContent: body,
              mood: _selectedMood,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Diary entry encrypted & sealed securely in your vault 💕'),
              backgroundColor: AppColors.rosePrimary,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Could not save: $e 💕 Your data remains secure.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _insertTag(String tag) {
    final text = _bodyController.text;
    final selection = _bodyController.selection;
    final newText = text.replaceRange(selection.start, selection.end, '$tag ');
    _bodyController.value = _bodyController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + tag.length + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Diary Entry ✏️' : 'Writing Diary... 🌸',
          style: AppTypography.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoadingDecrypt
            ? const Center(
                child:
                    CircularProgressIndicator(color: AppColors.rosePrimary))
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mood row selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mood Tint:', style: AppTypography.titleMedium),
                        Row(
                          children: moods.map((m) {
                            final isSelected = _selectedMood == m['key'];
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() => _selectedMood = m['key']!);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.rosePrimary.withOpacity(0.15)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.rosePrimary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Image.asset(
                                  m['asset']!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Text(
                                    m['emoji']!,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Context tag chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text('Tag: ',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.warmGray400,
                              )),
                          const SizedBox(width: 4),
                          _TagChip(
                            label: '@him',
                            onTap: () => _insertTag('@him'),
                          ),
                          const SizedBox(width: 6),
                          _TagChip(
                            label: '@cycle1',
                            onTap: () => _insertTag('@cycle1'),
                          ),
                          const SizedBox(width: 6),
                          _TagChip(
                            label: '@cycle2',
                            onTap: () => _insertTag('@cycle2'),
                          ),
                          const SizedBox(width: 6),
                          _TagChip(
                            label: '@cycle3',
                            onTap: () => _insertTag('@cycle3'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Encrypted writing pad
                    Expanded(
                      child: LunaCard(
                        borderColor:
                            isDark ? AppColors.darkBorder : AppColors.roseSoft,
                        child: TextField(
                          controller: _bodyController,
                          maxLines: null,
                          expands: true,
                          style: AppTypography.handwritten.copyWith(
                            fontSize: 18,
                            color:
                                isDark ? AppColors.darkText : AppColors.charcoal,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Share your thoughts... Use @him or @cycle1 to add context 💕',
                            hintStyle: AppTypography.handwrittenSm.copyWith(
                              color: AppColors.warmGray400,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Save Button
                    LunaButton(
                      text: _isEditing ? 'Update Entry 💕' : 'Seal with Love 💕',
                      isLoading: _isSaving,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TagChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.rosePrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.rosePrimary.withOpacity(0.4)),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.rosePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
