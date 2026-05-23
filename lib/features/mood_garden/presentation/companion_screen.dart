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

class CompanionScreen extends ConsumerStatefulWidget {
  const CompanionScreen({super.key});

  @override
  ConsumerState<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends ConsumerState<CompanionScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLunaThinking = false;
  bool _showScrollToBottom = false;
  ChatMessage? _replyingTo;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      // With reverse: true, offset 0 is the bottom
      // Show button if we are more than 100px away from the bottom
      final offset = _scrollController.offset;
      final show = offset > 100;
      if (show != _showScrollToBottom) {
        debugPrint('CompanionScreen: offset=$offset, showScrollToBottom=$show');
        setState(() => _showScrollToBottom = show);
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      debugPrint('CompanionScreen: Scrolling to bottom (offset 0)');
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final replyingTo = _replyingTo;
    _textController.clear();
    setState(() {
      _isLunaThinking = true;
      _replyingTo = null;
    });

    try {
      if (text.contains('@summarize')) {
        // ... (existing summarize logic)
        final dashboardData = await ref.read(dashboardProvider.future);
        final summaryPrompt = """
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
        await ref.read(chatControllerProvider.notifier).sendMessage(summaryPrompt);
      } else {
        String finalPrompt = text;
        if (replyingTo != null) {
          finalPrompt = "Replying to your previous message: \"${replyingTo.content}\"\n\n$text";
        }
        await ref.read(chatControllerProvider.notifier).sendMessage(finalPrompt);
      }
    } finally {
      if (mounted) setState(() => _isLunaThinking = false);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messagesAsync = ref.watch(chatMessagesProvider);

    // Auto-scroll when messages update
    ref.listen(chatMessagesProvider, (prev, next) {
      if (next.hasValue && !_showScrollToBottom) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Luna Companion', style: AppTypography.titleLarge),
            Text('Always here for you 💕', 
              style: AppTypography.bodySmall.copyWith(color: AppColors.rosePrimary)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => ref.read(chatControllerProvider.notifier).clearHistory(),
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
              // Character Display
              _LunaCharacter(isThinking: _isLunaThinking),

              // Chat Messages
              Expanded(
                child: messagesAsync.when(
                  data: (messages) {
                    if (messages.isEmpty) {
                      return _EmptyChatView();
                    }
                    final reversedMessages = messages.reversed.toList();
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                      itemCount: reversedMessages.length + (_isLunaThinking ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isLunaThinking && index == 0) {
                          return const _ThinkingBubble();
                        }
                        final messageIndex = _isLunaThinking ? index - 1 : index;
                        final message = reversedMessages[messageIndex];
                        return GestureDetector(
                          onLongPress: () => setState(() => _replyingTo = message),
                          child: _ChatBubble(
                            message: message,
                            onReply: () => setState(() => _replyingTo = message),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: LunaLoading()),
                  error: (e, s) => Center(child: Text('Something went wrong... 💕')),
                ),
              ),

              // Input Area
              _ChatInput(
                controller: _textController,
                onSend: _handleSend,
                isThinking: _isLunaThinking,
                replyingTo: _replyingTo,
                onCancelReply: () => setState(() => _replyingTo = null),
              ),
            ],
          ),

          // Scroll to Bottom Button
          if (_showScrollToBottom)
            Positioned(
              bottom: 150, // Adjusted position
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
      child: Image.asset(
        isThinking ? AppIllustrations.focused : AppIllustrations.hello,
        fit: BoxFit.contain,
      ).animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).scale(
        begin: const Offset(1, 1),
        end: const Offset(1.05, 1.05),
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      ).rotate(
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
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                color: isDark ? AppColors.darkText : AppColors.charcoal,
                                height: 1.5,
                              ),
                              h1: AppTypography.displayMedium.copyWith(
                                color: isDark ? AppColors.darkText : AppColors.roseDark,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              h2: AppTypography.titleLarge.copyWith(
                                color: isDark ? AppColors.darkText : AppColors.roseDark,
                                fontWeight: FontWeight.bold,
                              ),
                              h3: AppTypography.titleMedium.copyWith(
                                color: isDark ? AppColors.darkText : AppColors.roseDark,
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
                  icon: const Icon(Icons.reply_rounded, size: 16, color: AppColors.warmGray400),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ] else ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onReply,
                  icon: const Icon(Icons.reply_rounded, size: 16, color: AppColors.warmGray400),
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
              style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.warmGray400),
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

  const _ChatInput({
    required this.controller,
    required this.onSend,
    required this.isThinking,
    this.replyingTo,
    required this.onCancelReply,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            if (replyingTo != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.roseSoft.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.rosePrimary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.reply_rounded, size: 16, color: AppColors.rosePrimary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            replyingTo!.role == MessageRole.user ? 'Replying to you' : 'Replying to Luna',
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
                              color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.roseSoft.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.charcoal,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Whisper something to Luna...',
                        hintStyle: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _AnimatedSendButton(
                  onTap: onSend,
                  isEnabled: !isThinking,
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                  'Tap to summarize your current cycle 💕',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10,
                    color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                  ),
                ),
              ],
            ),
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
          color: isEnabled ? AppColors.rosePrimary : AppColors.warmGray400.withOpacity(0.5),
          shape: BoxShape.circle,
          boxShadow: isEnabled ? [
            BoxShadow(
              color: AppColors.rosePrimary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : [],
        ),
        child: Icon(
          Icons.send_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    ).animate(target: isEnabled ? 1 : 0).scale(
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

  const _TagChip({required this.label, required this.onTap, required this.isDark});

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

class _EmptyChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppIllustrations.meditating, height: 160),
          const SizedBox(height: 24),
          Text(
            'Your Quiet Companion',
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'A peaceful chat room where you can get immediate, loving suggestions selected by him. Whisper anything to me 💕',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColors.warmGray600),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms),
    );
  }
}
