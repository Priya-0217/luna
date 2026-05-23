import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/widgets/luna_empty_state.dart';
import 'package:her/core/widgets/luna_loading.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/features/journal/domain/journal_entry.dart';
import 'package:her/features/journal/providers/journal_provider.dart';
import 'package:her/features/journal/data/journal_repository.dart';
import 'package:her/core/services/database.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final entriesAsync = ref.watch(journalEntriesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text('My Private Diary 📖', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.rosePrimary),
            onPressed: () => ref.invalidate(journalEntriesProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: entriesAsync.when(
                loading: () => const Center(
                  child: LunaLoading(width: 180, height: 140),
                ),
                error: (err, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      'Failed to load diary entries: $err 💕',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                data: (entries) {
                  if (entries.isEmpty) {
                    return LunaEmptyState(
                      illustration: AppIllustrations.journaling,
                      title: 'Your Private Diary Space',
                      subtitle:
                          'All entries are encrypted securely using AES-256 keys. Start writing down your beautiful moments 💕',
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return _JournalListItem(entry: entry);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: LunaButton(
                text: 'Write in Diary ✏️',
                onPressed: () async {
                  await context.pushNamed(AppRoutes.journalWrite);
                  ref.invalidate(journalEntriesProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalListItem extends ConsumerStatefulWidget {
  final JournalEntry entry;

  const _JournalListItem({required this.entry});

  @override
  ConsumerState<_JournalListItem> createState() => _JournalListItemState();
}

class _JournalListItemState extends ConsumerState<_JournalListItem> {
  String _decryptedBody = 'Decrypting secure vault... 🌸';
  bool _isDecrypting = true;

  @override
  void initState() {
    super.initState();
    _decrypt();
  }

  @override
  void didUpdateWidget(covariant _JournalListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.encryptedContent != widget.entry.encryptedContent) {
      _decrypt();
    }
  }

  Future<void> _decrypt() async {
    final text = await ref
        .read(journalEntriesProvider.notifier)
        .decryptEntry(widget.entry.encryptedContent);
    if (mounted) {
      setState(() {
        _decryptedBody = text;
        _isDecrypting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Truncate the decrypted preview to first 5 words
    final previewText = _isDecrypting
        ? 'Decrypting... 🌸'
        : (() {
            final words = _decryptedBody.split(RegExp(r'\s+'));
            if (words.length <= 5) return _decryptedBody;
            return '${words.take(5).join(' ')}...';
          })();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();
          await context.pushNamed(
            AppRoutes.journalWrite,
            extra: widget.entry,
          );
          ref.invalidate(journalEntriesProvider);
        },
        borderRadius: BorderRadius.circular(16),
        child: LunaCard(
          borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        _getMoodEmoji(widget.entry.mood),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMM dd, yyyy')
                            .format(widget.entry.date),
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.roseSoft
                              : AppColors.rosePrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        onPressed: () async {
                          HapticFeedback.mediumImpact();
                          final db = ref.read(journalRepositoryProvider);
                          final driftId = await db.getDriftId(widget.entry.date);
                          if (driftId != null) {
                            await db.deleteEntry(driftId, firestoreId: widget.entry.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Diary entry deleted 🌸'),
                                ),
                              );
                            }
                            ref.invalidate(journalEntriesProvider);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_isDecrypting)
                const LunaLoading(width: double.infinity, height: 40)
              else
                Text(
                  previewText,
                  style: AppTypography.handwritten.copyWith(
                    fontSize: 16,
                    height: 1.4,
                    color: isDark ? AppColors.darkText : AppColors.charcoal,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMoodEmoji(String key) {
    switch (key) {
      case 'happy':
        return '🌸';
      case 'cozy':
        return '🧸';
      case 'anxious':
        return '🥺';
      case 'down':
        return '🌧️';
      case 'irritable':
        return '🔥';
      default:
        return '🌸';
    }
  }
}
