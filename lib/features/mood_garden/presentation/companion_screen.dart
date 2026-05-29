import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_loading.dart';
import 'package:her/core/widgets/particle_background.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:her/features/home/providers/dashboard_provider.dart';
import 'package:her/features/mood_garden/domain/chat_message.dart';
import 'package:her/features/mood_garden/providers/chat_provider.dart';
import 'package:intl/intl.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/him/providers/partner_data_provider.dart';
import 'package:her/features/cycle/utils/cycle_calculator.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

// Partner chat imports
import 'package:her/features/mood_garden/domain/partner_message.dart';
import 'package:her/features/mood_garden/providers/partner_chat_provider.dart';

enum ChatTab { ai, partner }

class CompanionScreen extends ConsumerStatefulWidget {
  const CompanionScreen({super.key});

  @override
  ConsumerState<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends ConsumerState<CompanionScreen> {
  final _textController = TextEditingController();
  final _aiScrollController = ScrollController();
  final _partnerScrollController = ScrollController();

  ChatTab _currentTab = ChatTab.ai;
  bool _isLunaThinking = false;
  bool _showScrollToBottom = false;

  ChatMessage? _replyingTo;
  PartnerMessage? _replyingToPartner;

  @override
  void initState() {
    super.initState();
    developer.log(
      'CompanionScreen: Initializing with tab $_currentTab',
      name: 'CompanionScreen',
    );
    _aiScrollController.addListener(_scrollListener);
    _partnerScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _aiScrollController.removeListener(_scrollListener);
    _partnerScrollController.removeListener(_scrollListener);
    _textController.dispose();
    _aiScrollController.dispose();
    _partnerScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final controller = _currentTab == ChatTab.ai
        ? _aiScrollController
        : _partnerScrollController;
    if (controller.hasClients) {
      final offset = controller.offset;
      final show = offset > 100;
      if (show != _showScrollToBottom) {
        setState(() => _showScrollToBottom = show);
      }
    }
  }

  void _scrollToBottom() {
    final controller = _currentTab == ChatTab.ai
        ? _aiScrollController
        : _partnerScrollController;
    if (controller.hasClients) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    developer.log(
      'CompanionScreen: Sending message on tab $_currentTab. Message length: ${text.length}',
      name: 'CompanionScreen',
    );

    if (_currentTab == ChatTab.ai) {
      final replyingTo = _replyingTo;
      _textController.clear();
      setState(() {
        _isLunaThinking = true;
        _replyingTo = null;
      });

      try {
        if (text.contains('@summarize')) {
          final isHim = ref.read(authProvider).valueOrNull?.role == 'him';
          developer.log(
            'CompanionScreen: Requesting AI cycle summary (isHim: $isHim)',
            name: 'CompanionScreen',
          );
          if (isHim) {
            final partnerProfile = ref.read(partnerProfileProvider).valueOrNull;
            final partnerEntries =
                ref.read(partnerCycleEntriesProvider).valueOrNull ?? [];
            final stats = CycleCalculator.calculate(partnerEntries);
            final summaryPrompt =
                """
Please provide a gentle and loving care summary and suggestions on how I can support my partner today.
Here is her data:
- Partner's Name: ${partnerProfile?.displayName ?? 'my partner'}
- Current Cycle Day: ${stats.dayOfCycle}
- Current Phase: ${stats.phase.name}
- Days until next period: ${stats.daysUntilPeriod}
- Cycle Average Length: 28
- Period Average Duration: 5
- Fertility Status: ${CycleCalculator.isFertile(cycleDay: stats.dayOfCycle, cycleLength: 28) ? 'Currently in her fertile window' : 'Not in her fertile window'}

Make it feel personal, focus 100% on how I can best support, comfort, and care for her today given her cycle phase.
""";
            await ref
                .read(chatControllerProvider.notifier)
                .sendMessage(summaryPrompt);
          } else {
            final dashboardData = await ref.read(dashboardProvider.future);
            final summaryPrompt =
                """
Please provide a gentle and loving summary of my current cycle status.
Here is my data:
- Username: ${dashboardData.username}
- Current Cycle Day: ${dashboardData.cycleDay}
- Current Phase: ${dashboardData.phase.name}
- Days until next period: ${dashboardData.daysUntilPeriod}
- Cycle Average Length: ${dashboardData.cycleLength}
- Period Average Duration: ${dashboardData.periodDuration}
- Fertility Status: ${dashboardData.isFertile ? 'Currently in fertile window' : 'Not in fertile window'}

Make it feel personal and supportive.
""";
            await ref
                .read(chatControllerProvider.notifier)
                .sendMessage(summaryPrompt);
          }
        } else {
          String finalPrompt = text;
          if (replyingTo != null) {
            developer.log(
              'CompanionScreen: Replying to AI message ID: ${replyingTo.id}',
              name: 'CompanionScreen',
            );
            finalPrompt =
                "Replying to your previous message: \"${replyingTo.content}\"\n\n$text";
          }
          await ref
              .read(chatControllerProvider.notifier)
              .sendMessage(finalPrompt);
        }
        developer.log(
          'CompanionScreen: AI message sent successfully',
          name: 'CompanionScreen',
        );
      } catch (e, stackTrace) {
        developer.log(
          'CompanionScreen: Error sending AI message',
          error: e,
          stackTrace: stackTrace,
          name: 'CompanionScreen',
        );
      } finally {
        if (mounted) setState(() => _isLunaThinking = false);
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } else {
      // Partner chat send
      final user = ref.read(authProvider).valueOrNull;
      if (user?.coupleId == null) {
        developer.log(
          'CompanionScreen: Cannot send partner message, coupleId is null',
          name: 'CompanionScreen',
          level: 900,
        );
        return;
      }

      final replyingTo = _replyingToPartner;
      _textController.clear();
      setState(() {
        _replyingToPartner = null;
      });

      try {
        developer.log(
          'CompanionScreen: Sending partner message (length: ${text.length}, replyToId: ${replyingTo?.id})',
          name: 'CompanionScreen',
        );
        await ref
            .read(partnerChatControllerProvider.notifier)
            .sendMessage(
              coupleId: user!.coupleId!,
              content: text,
              replyingTo: replyingTo,
            );
        developer.log(
          'CompanionScreen: Partner message sent successfully',
          name: 'CompanionScreen',
        );
      } catch (e, stackTrace) {
        developer.log(
          'CompanionScreen: Error sending partner message',
          error: e,
          stackTrace: stackTrace,
          name: 'CompanionScreen',
        );
      } finally {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    }
  }

  void _showReactionPicker(
    BuildContext context,
    PartnerMessage message,
    String coupleId,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    developer.log(
      'CompanionScreen: Showing reaction picker bottom sheet for message ID: ${message.id}',
      name: 'CompanionScreen',
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'React to message',
                style: AppTypography.titleMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['❤️', '😂', '😮', '😢', '👍', '🎉', '💩', '🦄', '🚀']
                    .map((emoji) {
                      return GestureDetector(
                        onTap: () {
                          developer.log(
                            'CompanionScreen: Toggled reaction $emoji on message ID: ${message.id}',
                            name: 'CompanionScreen',
                          );
                          ref
                              .read(partnerChatControllerProvider.notifier)
                              .toggleReaction(
                                coupleId: coupleId,
                                messageId: message.id,
                                emoji: emoji,
                              );
                          Navigator.pop(context);
                        },
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 32),
                        ).animate().scale(delay: 50.ms, duration: 200.ms),
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showIllustrationPicker(BuildContext context, String coupleId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    developer.log(
      'CompanionScreen: Showing illustration picker bottom sheet',
      name: 'CompanionScreen',
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.warmGray200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Send an Illustration 🌸',
                style: AppTypography.titleLarge.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children:
                      [
                        const _IllustrationItem(
                          keyName: 'in_love',
                          label: 'In Love',
                          asset: AppIllustrations.inLove,
                        ),
                        const _IllustrationItem(
                          keyName: 'laughing',
                          label: 'Laughing',
                          asset: AppIllustrations.laughing,
                        ),
                        const _IllustrationItem(
                          keyName: 'excited',
                          label: 'Excited',
                          asset: AppIllustrations.excited,
                        ),
                        const _IllustrationItem(
                          keyName: 'shy',
                          label: 'Shy',
                          asset: AppIllustrations.shy,
                        ),
                        const _IllustrationItem(
                          keyName: 'grateful',
                          label: 'Grateful',
                          asset: AppIllustrations.grateful,
                        ),
                        const _IllustrationItem(
                          keyName: 'warm',
                          label: 'Warm hugs',
                          asset: AppIllustrations.warm,
                        ),
                        const _IllustrationItem(
                          keyName: 'hello',
                          label: 'Hello',
                          asset: AppIllustrations.hello,
                        ),
                        const _IllustrationItem(
                          keyName: 'sleepy',
                          label: 'Sleepy',
                          asset: AppIllustrations.sleepy,
                        ),
                        const _IllustrationItem(
                          keyName: 'cozy',
                          label: 'Cozy',
                          asset: AppIllustrations.cozy,
                        ),
                        const _IllustrationItem(
                          keyName: 'sad',
                          label: 'Sad',
                          asset: AppIllustrations.sad,
                        ),
                        const _IllustrationItem(
                          keyName: 'crying',
                          label: 'Crying',
                          asset: AppIllustrations.crying,
                        ),
                        const _IllustrationItem(
                          keyName: 'cramps',
                          label: 'Cramps 🩸',
                          asset: AppIllustrations.cramps,
                        ),
                        const _IllustrationItem(
                          keyName: 'in_pain',
                          label: 'In Pain',
                          asset: AppIllustrations.inPain,
                        ),
                        const _IllustrationItem(
                          keyName: 'low_energy',
                          label: 'Low Energy',
                          asset: AppIllustrations.lowEnergy,
                        ),
                        const _IllustrationItem(
                          keyName: 'date_night',
                          label: 'Date Night',
                          asset: AppIllustrations.dateNight,
                        ),
                        const _IllustrationItem(
                          keyName: 'good_night',
                          label: 'Good Night',
                          asset: AppIllustrations.goodNight,
                        ),
                        const _IllustrationItem(
                          keyName: 'self_care',
                          label: 'Self Care',
                          asset: AppIllustrations.selfCare,
                        ),
                      ].map((item) {
                        return GestureDetector(
                          onTap: () {
                            developer.log(
                              'CompanionScreen: Sending illustration sticker ${item.keyName}',
                              name: 'CompanionScreen',
                            );
                            ref
                                .read(partnerChatControllerProvider.notifier)
                                .sendMessage(
                                  coupleId: coupleId,
                                  illustrationKey: item.keyName,
                                  replyingTo: _replyingToPartner,
                                );
                            setState(() {
                              _replyingToPartner = null;
                            });
                            Navigator.pop(context);
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _scrollToBottom(),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCard
                                  : AppColors.roseLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.roseSoft,
                              ),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    item.asset,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.label,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.darkText
                                        : AppColors.charcoal,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showGiftNoteDialog(
    BuildContext context,
    String coupleId,
    _GiftItem gift,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String noteText = '';
    final note = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          title: Text(
            'Add a note (optional)',
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.charcoal,
            ),
          ),
          content: TextField(
            maxLines: 3,
            onChanged: (value) => noteText = value,
            decoration: const InputDecoration(
              hintText: 'Write a short note...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, noteText.trim());
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    if (note == null) return;

    _sendGiftMessage(coupleId, gift, note);
  }

  void _sendGiftMessage(String coupleId, _GiftItem gift, String note) {
    final metadata = <String, dynamic>{
      'giftKey': gift.keyName,
      'giftLabel': gift.label,
    };
    if (note.isNotEmpty) {
      metadata['giftNote'] = note;
    }

    developer.log(
      'CompanionScreen: Sending gift ${gift.keyName} with note length ${note.length}',
      name: 'CompanionScreen',
    );

    ref
        .read(partnerChatControllerProvider.notifier)
        .sendMessage(
          coupleId: coupleId,
          content: note.isNotEmpty ? note : null,
          metadata: metadata,
          replyingTo: _replyingToPartner,
        );

    if (mounted) {
      setState(() => _replyingToPartner = null);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _showGiftPicker(BuildContext context, String coupleId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    developer.log(
      'CompanionScreen: Showing gift picker bottom sheet',
      name: 'CompanionScreen',
    );

    const gifts = [
      _GiftItem(keyName: 'coffee', label: 'Coffee', icon: Icons.local_cafe),
      _GiftItem(
        keyName: 'flowers',
        label: 'Flowers',
        icon: Icons.local_florist,
      ),
      _GiftItem(keyName: 'hug', label: 'Hug', icon: Icons.favorite),
      _GiftItem(keyName: 'gift', label: 'Surprise', icon: Icons.card_giftcard),
      _GiftItem(keyName: 'dinner', label: 'Dinner', icon: Icons.restaurant),
      _GiftItem(keyName: 'self_care', label: 'Self Care', icon: Icons.spa),
      _GiftItem(keyName: 'music', label: 'Playlist', icon: Icons.music_note),
      _GiftItem(keyName: 'movie', label: 'Movie Night', icon: Icons.movie),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.42,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.warmGray200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Send a Gift Note',
                style: AppTypography.titleLarge.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: gifts.map((gift) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showGiftNoteDialog(context, coupleId, gift);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.roseLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.roseSoft,
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              gift.icon,
                              size: 28,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.rosePrimary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              gift.label,
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.charcoal,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar(BuildContext context, bool isDark) {
    final activeColor = ref.watch(authProvider).valueOrNull?.role == 'him'
        ? AppColors.slateBluePrimary
        : AppColors.rosePrimary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface
            : AppColors.roseSoft.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.roseSoft.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Luna AI 🌙',
              isActive: _currentTab == ChatTab.ai,
              onTap: () {
                developer.log(
                  'CompanionScreen: Switch tab to Luna AI',
                  name: 'CompanionScreen',
                );
                setState(() => _currentTab = ChatTab.ai);
              },
              activeColor: activeColor,
              isDark: isDark,
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'My Love 💖',
              isActive: _currentTab == ChatTab.partner,
              onTap: () {
                developer.log(
                  'CompanionScreen: Switch tab to Partner Chat',
                  name: 'CompanionScreen',
                );
                setState(() => _currentTab = ChatTab.partner);
              },
              activeColor: activeColor,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messagesAsync = ref.watch(chatMessagesProvider);
    final user = ref.watch(authProvider).valueOrNull;

    developer.log(
      'CompanionScreen: Build state (tab: $_currentTab, role: ${user?.role}, linked: ${user?.isLinked}, coupleId: ${user?.coupleId})',
      name: 'CompanionScreen',
    );

    // Listeners for auto-scroll on new messages
    ref.listen(chatMessagesProvider, (prev, next) {
      if (next.hasValue && _currentTab == ChatTab.ai && !_showScrollToBottom) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    if (user?.coupleId != null) {
      ref.listen(partnerChatMessagesProvider(user!.coupleId!), (prev, next) {
        if (next.hasError) {
          final err = next.asError?.error;
          final stack = next.asError?.stackTrace;
          developer.log(
            'CompanionScreen: Partner chat stream error for coupleId ${user.coupleId}',
            error: err,
            stackTrace: stack,
            name: 'CompanionScreen',
          );
        }
        if (next.hasValue &&
            _currentTab == ChatTab.partner &&
            !_showScrollToBottom) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );
        }
      });
    } else if (_currentTab == ChatTab.partner) {
      developer.log(
        'CompanionScreen: Partner chat unavailable (missing coupleId)',
        name: 'CompanionScreen',
        level: 900,
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Luna Companion', style: AppTypography.titleLarge),
            Text(
              'Always here for you 💕',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.rosePrimary,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () {
              if (_currentTab == ChatTab.ai) {
                developer.log(
                  'CompanionScreen: Clearing AI chat history',
                  name: 'CompanionScreen',
                );
                ref.read(chatControllerProvider.notifier).clearHistory();
              } else {
                if (user?.coupleId != null) {
                  developer.log(
                    'CompanionScreen: Clearing Partner chat history for coupleId: ${user!.coupleId}',
                    name: 'CompanionScreen',
                  );
                  ref
                      .read(partnerChatControllerProvider.notifier)
                      .clearHistory(user!.coupleId!);
                }
              }
            },
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Animation
          const Positioned.fill(child: ParticleBackground()),

          Column(
            children: [
              // Custom Sliding Segmented Tab Bar
              _buildTabBar(context, isDark),

              // Character Display (Only show for Luna AI)
              if (_currentTab == ChatTab.ai)
                _LunaCharacter(isThinking: _isLunaThinking),

              // Chat Messages Area
              Expanded(
                child: _currentTab == ChatTab.ai
                    ? messagesAsync.when(
                        data: (messages) {
                          developer.log(
                            'CompanionScreen: AI Chat loaded ${messages.length} messages',
                            name: 'CompanionScreen',
                          );
                          if (messages.isEmpty) {
                            return _EmptyChatView();
                          }
                          final reversedMessages = messages.reversed.toList();
                          return ListView.builder(
                            controller: _aiScrollController,
                            reverse: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            itemCount:
                                reversedMessages.length +
                                (_isLunaThinking ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (_isLunaThinking && index == 0) {
                                return const _ThinkingBubble();
                              }
                              final messageIndex = _isLunaThinking
                                  ? index - 1
                                  : index;
                              final message = reversedMessages[messageIndex];
                              return GestureDetector(
                                onLongPress: () =>
                                    setState(() => _replyingTo = message),
                                child: _ChatBubble(
                                  message: message,
                                  onReply: () =>
                                      setState(() => _replyingTo = message),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: LunaLoading()),
                        error: (e, s) {
                          developer.log(
                            'CompanionScreen: Error loading AI Chat messages',
                            error: e,
                            stackTrace: s,
                            name: 'CompanionScreen',
                          );
                          return Center(
                            child: Text('Something went wrong... 💕'),
                          );
                        },
                      )
                    : (user == null || !user.isLinked || user.coupleId == null)
                    ? const _UnlinkedPartnerView()
                    : ref
                          .watch(partnerChatMessagesProvider(user.coupleId!))
                          .when(
                            data: (messages) {
                              developer.log(
                                'CompanionScreen: Partner Chat loaded ${messages.length} messages',
                                name: 'CompanionScreen',
                              );
                              if (messages.isEmpty) {
                                return const _EmptyPartnerChatView();
                              }
                              final reversedMessages = messages.reversed
                                  .toList();
                              return ListView.builder(
                                controller: _partnerScrollController,
                                reverse: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.md,
                                ),
                                itemCount: reversedMessages.length,
                                itemBuilder: (context, index) {
                                  final message = reversedMessages[index];
                                  return _PartnerChatBubble(
                                    message: message,
                                    currentUserId: user.uid,
                                    userRole: user.role,
                                    partnerRole: user.partnerRole,
                                    onReply: () => setState(
                                      () => _replyingToPartner = message,
                                    ),
                                    onReact: (emoji) {
                                      developer.log(
                                        'CompanionScreen: Toggled reaction $emoji on message ID: ${message.id}',
                                        name: 'CompanionScreen',
                                      );
                                      ref
                                          .read(
                                            partnerChatControllerProvider
                                                .notifier,
                                          )
                                          .toggleReaction(
                                            coupleId: user.coupleId!,
                                            messageId: message.id,
                                            emoji: emoji,
                                          );
                                    },
                                    onShowReactionPicker: () =>
                                        _showReactionPicker(
                                          context,
                                          message,
                                          user.coupleId!,
                                        ),
                                  );
                                },
                              );
                            },
                            loading: () => const Center(child: LunaLoading()),
                            error: (e, s) {
                              developer.log(
                                'CompanionScreen: Error loading Partner Chat messages',
                                error: e,
                                stackTrace: s,
                                name: 'CompanionScreen',
                              );
                              return Center(
                                child: Text('Something went wrong... 💕'),
                              );
                            },
                          ),
              ),

              // Input Area
              _ChatInput(
                controller: _textController,
                onSend: _handleSend,
                isThinking: _currentTab == ChatTab.ai ? _isLunaThinking : false,
                replyingTo: _currentTab == ChatTab.ai ? _replyingTo : null,
                onCancelReply: () => setState(() => _replyingTo = null),
                isHim: user?.role == 'him',
                currentTab: _currentTab,
                onSelectIllustration: () {
                  if (user?.coupleId != null) {
                    _showIllustrationPicker(context, user!.coupleId!);
                  }
                },
                onSelectGift: () {
                  if (user?.coupleId != null) {
                    _showGiftPicker(context, user!.coupleId!);
                  }
                },
                replyingToPartner: _currentTab == ChatTab.partner
                    ? _replyingToPartner
                    : null,
                onCancelReplyPartner: () =>
                    setState(() => _replyingToPartner = null),
                currentUserId: user?.uid ?? '',
              ),
            ],
          ),

          // Scroll to Bottom Button
          if (_showScrollToBottom)
            Positioned(
              bottom: 150,
              right: 16,
              child: FloatingActionButton(
                key: const ValueKey('jump_to_bottom_btn'),
                onPressed: _scrollToBottom,
                backgroundColor: AppColors.roseSoft,
                mini: true,
                elevation: 6,
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.rosePrimary,
                  size: 32,
                ),
              ).animate().scale(curve: Curves.easeOutBack).fadeIn(),
            ),
        ],
      ),
    );
  }
}

class _LunaCharacter extends StatelessWidget {
  final bool isThinking;
  const _LunaCharacter({required this.isThinking});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child:
          Image.asset(
                isThinking ? AppIllustrations.focused : AppIllustrations.hello,
                fit: BoxFit.contain,
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
              )
              .rotate(
                begin: -0.02,
                end: 0.02,
                duration: const Duration(seconds: 3),
                curve: Curves.easeInOut,
              ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onReply;

  const _ChatBubble({required this.message, required this.onReply});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.roseSoft,
                  child: Text('🌙', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.rosePrimary
                            : (isDark ? AppColors.darkCard : Colors.white),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isUser ? 20 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: isUser
                          ? Text(
                              message.content,
                              style: AppTypography.bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                            )
                          : MarkdownBody(
                              data: message.content,
                              styleSheet: MarkdownStyleSheet(
                                p: AppTypography.bodyMedium.copyWith(
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.charcoal,
                                  height: 1.5,
                                ),
                                h1: AppTypography.displayMedium.copyWith(
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.roseDark,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                                h2: AppTypography.titleLarge.copyWith(
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.roseDark,
                                  fontWeight: FontWeight.bold,
                                ),
                                h3: AppTypography.titleMedium.copyWith(
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.roseDark,
                                  fontWeight: FontWeight.bold,
                                ),
                                strong: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.rosePrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                listBullet: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.rosePrimary,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onReply,
                  icon: const Icon(
                    Icons.reply_rounded,
                    size: 16,
                    color: AppColors.warmGray400,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ] else ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onReply,
                  icon: const Icon(
                    Icons.reply_rounded,
                    size: 16,
                    color: AppColors.warmGray400,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 32, right: 32),
            child: Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.warmGray400,
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.roseSoft,
            child: Text('🌙', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const SizedBox(
              width: 24,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.roseSoft),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isThinking;
  final ChatMessage? replyingTo;
  final VoidCallback onCancelReply;
  final bool isHim;

  // Partner Chat specific attributes
  final ChatTab currentTab;
  final VoidCallback? onSelectIllustration;
  final VoidCallback? onSelectGift;
  final PartnerMessage? replyingToPartner;
  final VoidCallback? onCancelReplyPartner;
  final String currentUserId;

  const _ChatInput({
    required this.controller,
    required this.onSend,
    required this.isThinking,
    this.replyingTo,
    required this.onCancelReply,
    required this.isHim,
    this.currentTab = ChatTab.ai,
    this.onSelectIllustration,
    this.onSelectGift,
    this.replyingToPartner,
    this.onCancelReplyPartner,
    this.currentUserId = '',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPartnerChat = currentTab == ChatTab.partner;
    final replyGiftLabel = replyingToPartner?.metadata['giftLabel'];
    final hasGiftReply = replyGiftLabel is String && replyGiftLabel.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply Preview for Luna AI
            if (!isPartnerChat && replyingTo != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCard
                      : AppColors.roseSoft.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.rosePrimary.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.reply_rounded,
                      size: 16,
                      color: AppColors.rosePrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            replyingTo!.role == MessageRole.user
                                ? 'Replying to you'
                                : 'Replying to Luna',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.rosePrimary,
                            ),
                          ),
                          Text(
                            replyingTo!.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.warmGray400
                                  : AppColors.warmGray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onCancelReply,
                      icon: const Icon(Icons.close_rounded, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),
            ],

            // Reply Preview for Partner Chat
            if (isPartnerChat && replyingToPartner != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCard
                      : AppColors.roseSoft.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.rosePrimary.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.reply_rounded,
                      size: 16,
                      color: AppColors.rosePrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            replyingToPartner!.senderId == currentUserId
                                ? 'Replying to you'
                                : 'Replying to partner',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.rosePrimary,
                            ),
                          ),
                          if (replyingToPartner!.illustrationKey != null) ...[
                            Text(
                              'Illustration',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.warmGray400
                                    : AppColors.warmGray600,
                              ),
                            ),
                          ] else if (hasGiftReply) ...[
                            Text(
                              'Gift: $replyGiftLabel',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.warmGray400
                                    : AppColors.warmGray600,
                              ),
                            ),
                          ] else ...[
                            Text(
                              replyingToPartner!.content ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.warmGray400
                                    : AppColors.warmGray600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onCancelReplyPartner,
                      icon: const Icon(Icons.close_rounded, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),
            ],

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCard
                          : AppColors.roseSoft.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.roseSoft,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Illustration selector icon (Only for Partner Chat)
                        if (isPartnerChat) ...[
                          IconButton(
                            icon: const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.rosePrimary,
                            ),
                            onPressed: onSelectIllustration,
                            tooltip: 'Send Illustration',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            icon: const Icon(
                              Icons.card_giftcard,
                              color: AppColors.rosePrimary,
                            ),
                            onPressed: onSelectGift,
                            tooltip: 'Send Gift Note',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: TextField(
                            controller: controller,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.charcoal,
                            ),
                            decoration: InputDecoration(
                              hintText: isPartnerChat
                                  ? 'Whisper to your partner...'
                                  : 'Whisper something to Luna...',
                              hintStyle: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.warmGray400
                                    : AppColors.warmGray600,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            maxLines: 4,
                            minLines: 1,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => onSend(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _AnimatedSendButton(onTap: onSend, isEnabled: !isThinking),
              ],
            ),
            const SizedBox(height: 12),

            // Footer row
            if (!isPartnerChat) ...[
              Row(
                children: [
                  _TagChip(
                    label: '@summarize',
                    onTap: () {
                      controller.text = '@summarize';
                      onSend();
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isHim
                        ? 'Tap to summarize her current cycle & care tips 💙'
                        : 'Tap to summarize your current cycle 💕',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.warmGray400
                          : AppColors.warmGray600,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.security_outlined,
                    size: 11,
                    color: AppColors.rosePrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Real-time messages are private & synchronized 🔒',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.warmGray400
                          : AppColors.warmGray600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimatedSendButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;

  const _AnimatedSendButton({required this.onTap, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: isEnabled ? onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppColors.rosePrimary
                  : AppColors.warmGray400.withOpacity(0.5),
              shape: BoxShape.circle,
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: AppColors.rosePrimary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: const Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        )
        .animate(target: isEnabled ? 1 : 0)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _TagChip({
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.rosePrimary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.rosePrimary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.rosePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    ).animate().fadeIn().scale();
  }
}

class _EmptyChatView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHim = ref.watch(authProvider).valueOrNull?.role == 'him';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppIllustrations.meditating, height: 160),
          const SizedBox(height: 24),
          Text(
            isHim ? 'Your Partner Support Companion' : 'Your Quiet Companion',
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              isHim
                  ? 'A peaceful chat room where you can get immediate, loving suggestions on how to care for her today. Whisper anything to me 💙'
                  : 'A peaceful chat room where you can get immediate, loving suggestions selected by him. Whisper anything to me 💕',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.warmGray600,
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final bool isDark;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isActive
                ? Colors.white
                : (isDark
                      ? AppColors.darkText.withOpacity(0.6)
                      : AppColors.charcoal.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }
}

class _PartnerChatBubble extends StatelessWidget {
  final PartnerMessage message;
  final String currentUserId;
  final String? userRole;
  final String? partnerRole;
  final VoidCallback onReply;
  final Function(String emoji) onReact;
  final VoidCallback onShowReactionPicker;

  const _PartnerChatBubble({
    required this.message,
    required this.currentUserId,
    this.userRole,
    this.partnerRole,
    required this.onReply,
    required this.onReact,
    required this.onShowReactionPicker,
  });

  @override
  Widget build(BuildContext context) {
    final isSelf = message.senderId == currentUserId;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bubbleColor;
    Color textColor;

    if (isSelf) {
      bubbleColor = userRole == 'him'
          ? AppColors.slateBluePrimary
          : AppColors.rosePrimary;
      textColor = Colors.white;
    } else {
      if (isDark) {
        bubbleColor = AppColors.darkCard;
        textColor = AppColors.darkText;
      } else {
        bubbleColor = partnerRole == 'him'
            ? AppColors.slateBlueSoft
            : AppColors.roseSoft;
        textColor = partnerRole == 'him'
            ? AppColors.slateBlueDark
            : AppColors.roseDark;
      }
    }

    final hasContent =
        message.content != null && message.content!.trim().isNotEmpty;
    final hasIllustration = message.illustrationKey != null;
    final giftKey = message.metadata['giftKey'];
    final giftLabel = message.metadata['giftLabel'];
    final giftNote = message.metadata['giftNote'];
    final hasGift = giftLabel is String && giftLabel.isNotEmpty;
    final showGiftNote =
        giftNote is String &&
        giftNote.trim().isNotEmpty &&
        (!hasContent || message.content!.trim() != giftNote.trim());

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity.abs() < 250) return;
        onReply();
      },
      onLongPress: onShowReactionPicker,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: isSelf
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isSelf) ...[
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  message.senderName,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.warmGray400
                        : AppColors.warmGray600,
                  ),
                ),
              ),
            ],

            Row(
              mainAxisAlignment: isSelf
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isSelf) ...[
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: partnerRole == 'him'
                        ? AppColors.slateBlueSoft
                        : AppColors.roseSoft,
                    child: Text(
                      partnerRole == 'him' ? '💙' : '🌸',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                Flexible(
                  child: Column(
                    crossAxisAlignment: isSelf
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(isSelf ? 20 : 4),
                            bottomRight: Radius.circular(isSelf ? 4 : 20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (message.replyToId != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: isSelf
                                      ? Colors.black.withOpacity(0.12)
                                      : (isDark
                                            ? Colors.black.withOpacity(0.2)
                                            : Colors.white.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 3,
                                        color: isSelf
                                            ? Colors.white.withOpacity(0.6)
                                            : (partnerRole == 'him'
                                                  ? AppColors.slateBluePrimary
                                                  : AppColors.rosePrimary),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              message.replyToSenderName ?? '',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: isSelf
                                                    ? Colors.white
                                                    : (partnerRole == 'him'
                                                          ? AppColors
                                                                .slateBlueDark
                                                          : AppColors.roseDark),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            if (message
                                                    .replyToIllustrationKey !=
                                                null) ...[
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.favorite_rounded,
                                                    size: 10,
                                                    color:
                                                        AppColors.rosePrimary,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Illustration',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: isSelf
                                                          ? Colors.white
                                                                .withOpacity(
                                                                  0.7,
                                                                )
                                                          : AppColors
                                                                .warmGray600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ] else ...[
                                              Text(
                                                message.replyToText ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: isSelf
                                                      ? Colors.white
                                                            .withOpacity(0.7)
                                                      : AppColors.warmGray600,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            if (hasGift) ...[
                              _buildGiftCard(
                                label: giftLabel as String,
                                giftKey: giftKey is String ? giftKey : null,
                                isSelf: isSelf,
                                isDark: isDark,
                              ),
                              if (hasIllustration || hasContent || showGiftNote)
                                const SizedBox(height: 8),
                            ],

                            if (showGiftNote) ...[
                              Text(
                                giftNote as String,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: textColor,
                                ),
                              ),
                              if (hasIllustration || hasContent)
                                const SizedBox(height: 6),
                            ],

                            if (hasIllustration) ...[
                              _buildIllustration(message.illustrationKey!),
                              if (hasContent) const SizedBox(height: 8),
                            ],

                            if (hasContent) ...[
                              Text(
                                message.content!,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: textColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (message.reactions.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _buildReactionsRow(context, isDark),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 4, left: 32, right: 32),
              child: Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.warmGray400,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }

  Widget _buildIllustration(String key) {
    final asset = getIllustrationAsset(key);
    if (asset == null) return const SizedBox();

    return Container(
      constraints: const BoxConstraints(maxHeight: 140, maxWidth: 140),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }

  Widget _buildGiftCard({
    required String label,
    String? giftKey,
    required bool isSelf,
    required bool isDark,
  }) {
    final cardColor = isSelf
        ? Colors.white.withOpacity(0.16)
        : (isDark ? AppColors.darkSurface : Colors.white);
    final borderColor = isSelf
        ? Colors.white.withOpacity(0.2)
        : (isDark ? AppColors.darkBorder : AppColors.roseSoft);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelf
                  ? Colors.white.withOpacity(0.2)
                  : AppColors.roseSoft.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _giftIconForKey(giftKey),
              size: 18,
              color: isSelf ? Colors.white : AppColors.rosePrimary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelf
                        ? Colors.white
                        : (isDark ? AppColors.darkText : AppColors.charcoal),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _giftIconForKey(String? key) {
    switch (key) {
      case 'coffee':
        return Icons.local_cafe;
      case 'flowers':
        return Icons.local_florist;
      case 'hug':
        return Icons.favorite;
      case 'gift':
        return Icons.card_giftcard;
      case 'dinner':
        return Icons.restaurant;
      case 'self_care':
        return Icons.spa;
      case 'music':
        return Icons.music_note;
      case 'movie':
        return Icons.movie;
      default:
        return Icons.card_giftcard;
    }
  }

  Widget _buildReactionsRow(BuildContext context, bool isDark) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: message.typedReactions.entries.map((entry) {
        final emoji = entry.key;
        final userList = entry.value;
        final hasReacted = userList.contains(currentUserId);

        Color activeReactionBg = userRole == 'him'
            ? AppColors.slateBluePrimary.withOpacity(0.15)
            : AppColors.rosePrimary.withOpacity(0.15);
        Color activeReactionBorder = userRole == 'him'
            ? AppColors.slateBluePrimary
            : AppColors.rosePrimary;

        return GestureDetector(
          onTap: () => onReact(emoji),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: hasReacted
                  ? activeReactionBg
                  : (isDark ? AppColors.darkCard : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasReacted
                    ? activeReactionBorder
                    : (isDark ? AppColors.darkBorder : AppColors.roseSoft),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 4),
                Text(
                  '${userList.length}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: hasReacted
                        ? activeReactionBorder
                        : (isDark ? AppColors.darkText : AppColors.charcoal),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _UnlinkedPartnerView extends StatelessWidget {
  const _UnlinkedPartnerView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppIllustrations.meditating, height: 160),
            const SizedBox(height: 24),
            Text('Connect with Partner', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            Text(
              'Real-time partner chat is a private space for you and your partner. '
              'Link your accounts to start sharing funny reactions, illustrations, and more.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.warmGray600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.pushNamed(AppRoutes.us);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rosePrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Connect Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPartnerChatView extends StatelessWidget {
  const _EmptyPartnerChatView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppIllustrations.cozy, height: 160),
          const SizedBox(height: 24),
          Text('Your Shared Space 💖', style: AppTypography.titleLarge),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'This is a private, real-time chat just for the two of you. '
              'Send a loving word, a funny reaction, or a cute illustration to brighten their day! 💕',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.warmGray600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms),
    );
  }
}

class _IllustrationItem {
  final String keyName;
  final String label;
  final String asset;

  const _IllustrationItem({
    required this.keyName,
    required this.label,
    required this.asset,
  });
}

class _GiftItem {
  final String keyName;
  final String label;
  final IconData icon;

  const _GiftItem({
    required this.keyName,
    required this.label,
    required this.icon,
  });
}

String? getIllustrationAsset(String? key) {
  if (key == null) return null;
  return switch (key) {
    'in_love' => AppIllustrations.inLove,
    'laughing' => AppIllustrations.laughing,
    'excited' => AppIllustrations.excited,
    'shy' => AppIllustrations.shy,
    'grateful' => AppIllustrations.grateful,
    'warm' => AppIllustrations.warm,
    'hello' => AppIllustrations.hello,
    'sleepy' => AppIllustrations.sleepy,
    'cozy' => AppIllustrations.cozy,
    'sad' => AppIllustrations.sad,
    'crying' => AppIllustrations.crying,
    'cramps' => AppIllustrations.cramps,
    'in_pain' => AppIllustrations.inPain,
    'low_energy' => AppIllustrations.lowEnergy,
    'date_night' => AppIllustrations.dateNight,
    'good_night' => AppIllustrations.goodNight,
    'self_care' => AppIllustrations.selfCare,
    _ => null,
  };
}
