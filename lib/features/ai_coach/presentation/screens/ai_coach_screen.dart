import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:math' show sin, pi;
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// GoRouter imports
import 'package:go_router/go_router.dart';

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({
    super.key,
    this.fromDailyCheckIn = false,
  });

  final bool fromDailyCheckIn;

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  bool _showTooltip = true;
  
  // Add GlobalKeys for tutorial targets
  final GlobalKey _chatInputKey = GlobalKey();
  
  late AnimationController _typingDotsController;
  late AnimationController _tooltipController;
  late Animation<double> _tooltipAnimation;
  
  final List<ChatMessage> _messages = [];
  final String _userName = "John"; // This should come from user profile

  @override
  void initState() {
    super.initState();
    _typingDotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _tooltipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _tooltipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tooltipController,
      curve: Curves.easeOut,
    ));

    _tooltipController.forward();
    
    // Hide tooltip after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showTooltip = false;
        });
        _tooltipController.reverse();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Add initial greeting (safe to access localizations here)
    if (_messages.isEmpty) {
      final greeting = AppLocalizations.of(context).initialGreeting(_userName);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _addAIMessage(greeting);
        }
      });
    }
    
    // Show tutorial after the widget is fully built and dependencies are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      if (TutorialService.shouldShowTutorial(TutorialService.AI_COACH_TUTORIAL)) {
        try {
          _showTutorial();
          TutorialService.markTutorialAsShown(TutorialService.AI_COACH_TUTORIAL);
        } catch (e) {
          // Handle error without print
        }
      }
    });
  }

  void _showTutorial() {
    if (!mounted) return;
    
    try {
      final tutorial = TutorialService.createAICoachTutorial(
        context,
        [_chatInputKey],
        _scrollController,
      );
      
      // Add a small delay to ensure the widget tree is stable
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          tutorial.show(context: context);
        }
      });
    } catch (e) {
      // Handle error without print
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingDotsController.dispose();
    _tooltipController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addAIMessage(String message) {
    setState(() {
      _isTyping = true;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: message,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleBackPress() {
    if (widget.fromDailyCheckIn) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          GradientBackground(
            customGradient: AppColors.primaryGradient,
            hasSafeArea: false,
            child: Container(),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: _buildChatList(),
                  ),
                ),
                _buildMessageInput(),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: AppColors.getPrimaryWithOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _handleBackPress,
            child: const Icon(
              CupertinoIcons.back,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          Text(
            localizations.aiHealthCoachTitle,
            style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
          ),
          const Spacer(),
          // Removed video chat button - keeping space for symmetry
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final message = _messages[index];
              return _buildChatMessage(message);
            },
            childCount: _messages.length,
          ),
        ),
        SliverToBoxAdapter(
          child: _isTyping
              ? Padding(
                  padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FrostedCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        borderRadius: 20,
                        backgroundColor: AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
                        border: Border.all(
                          color: AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
                          width: 0.5,
                        ),
                        child: _buildTypingIndicator(),
                      ),
                    ],
                  ),
                )
              : const SizedBox(height: 16),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return AnimatedBuilder(
      animation: _typingDotsController,
      builder: (context, child) {
        final double firstOpacity = sin((_typingDotsController.value) * pi * 2) * 0.5 + 0.5;
        final double secondOpacity = sin((_typingDotsController.value + 0.2) * pi * 2) * 0.5 + 0.5;
        final double thirdOpacity = sin((_typingDotsController.value + 0.4) * pi * 2) * 0.5 + 0.5;
        
        return Row(
          children: [
            _buildDot(firstOpacity),
            const SizedBox(width: 4),
            _buildDot(secondOpacity),
            const SizedBox(width: 4),
            _buildDot(thirdOpacity),
          ],
        );
      },
    );
  }
  
  Widget _buildDot(double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    final bool isUser = message.isUser;
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final margin = isUser 
        ? const EdgeInsets.only(left: 64, right: 16, bottom: 8)
        : const EdgeInsets.only(left: 16, right: 64, bottom: 8);
    
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          FrostedCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            borderRadius: 20,
            backgroundColor: isUser
                ? AppColors.primary
                : AppColors.getSurfaceWithOpacity(AppColors.surfaceOpacity),
            border: Border.all(
              color: isUser
                  ? AppColors.primary
                  : AppColors.getPrimaryWithOpacity(AppColors.borderOpacity),
              width: 0.5,
            ),
            child: Text(
              message.text,
              style: AppTextStyles.withColor(
                AppTextStyles.bodyMedium,
                isUser ? AppColors.surface : AppColors.textPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
            child: Text(
              _formatTimestamp(message.timestamp),
              style: AppTextStyles.withColor(
                AppTextStyles.bodySmall,
                AppColors.secondaryLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      key: _chatInputKey,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: BorderSide(
            color: AppColors.getPrimaryWithOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  CustomTextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    hintText: localizations.typeMessage,
                    keyboardType: TextInputType.text,
                    onEditingComplete: _sendMessage,
                    borderRadius: 24,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabled: true,
                    onChanged: (value) {
                      // Update state if needed
                      setState(() {});
                    },
                  ),
                  if (_showTooltip)
                    Positioned(
                      top: -60,
                      left: 20,
                      child: FadeTransition(
                        opacity: _tooltipAnimation,
                        child: FrostedCard(
                          borderRadius: 12,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          backgroundColor: AppColors.getSurfaceWithOpacity(0.9),
                          border: Border.all(
                            color: AppColors.getPrimaryWithOpacity(0.1),
                            width: 0.5,
                          ),
                          child: Text(
                            localizations.askMeAnything,
                            style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textPrimary),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _sendMessage,
              child: const SFIcon(
                SFIcons.sf_arrow_up_circle_fill,
                fontSize: 24,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final localizations = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    if (messageDate == today) {
      // Today, just show time
      return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return localizations.yesterday;
    } else {
      // Show date
      return "${timestamp.month}/${timestamp.day}/${timestamp.year}";
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    final localizations = AppLocalizations.of(context);
    
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
    });
    
    _scrollToBottom();
    
    // Capture responses outside the async gap
    String helloResponse = localizations.greeting;
    String howAreYouResponse = localizations.howAreYou;
    String meditationResponse = localizations.meditationResponse;
    String sleepResponse = localizations.sleepResponse;
    String stressResponse = localizations.stressResponse;
    String exerciseResponse = localizations.exerciseResponse;
    String dietResponse = localizations.dietResponse;
    String gameResponse = localizations.gameResponse;
    String thankYouResponse = localizations.thankYouResponse;
    String defaultResponse = localizations.defaultResponse;
    
    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      String response;
      
      if (text.toLowerCase().contains("hello") || text.toLowerCase().contains("hi")) {
        response = helloResponse;
      } else if (text.toLowerCase().contains("how are you")) {
        response = howAreYouResponse;
      } else if (text.toLowerCase().contains("meditation")) {
        response = meditationResponse;
      } else if (text.toLowerCase().contains("sleep") || text.toLowerCase().contains("insomnia")) {
        response = sleepResponse;
      } else if (text.toLowerCase().contains("stress") || text.toLowerCase().contains("anxiety")) {
        response = stressResponse;
      } else if (text.toLowerCase().contains("exercise") || text.toLowerCase().contains("workout")) {
        response = exerciseResponse;
      } else if (text.toLowerCase().contains("diet") || text.toLowerCase().contains("nutrition") || text.toLowerCase().contains("eat")) {
        response = dietResponse;
      } else if (text.toLowerCase().contains("game") || text.toLowerCase().contains("puzzle") || text.toLowerCase().contains("challenge")) {
        response = gameResponse;
      } else if (text.toLowerCase().contains("thank")) {
        response = thankYouResponse;
      } else {
        response = defaultResponse;
      }
      
      _addAIMessage(response);
    });
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
} 