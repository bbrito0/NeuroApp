import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'dart:math' show sin, pi;
import 'package:flutter_sficon/flutter_sficon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/tutorial_service.dart';
import 'tavus_call_screen.dart';
import '../services/tavus_service.dart';

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({
    super.key,
    required this.tabController,
    this.fromDailyCheckIn = false,
  });

  final CupertinoTabController tabController;
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
  final GlobalKey _videoChatKey = GlobalKey();
  
  late AnimationController _typingDotsController;
  late AnimationController _tooltipController;
  late Animation<double> _tooltipAnimation;
  
  final List<ChatMessage> _messages = [];
  final String _userName = "John"; // This should come from user profile
  
  final TavusService _tavusService = TavusService();

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
    
    // Add initial greeting
    Future.delayed(const Duration(milliseconds: 500), () {
      _addAIMessage("Hello $_userName, how can I help you today?");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Show tutorial after the widget is fully built and dependencies are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (TutorialService.shouldShowTutorial(TutorialService.AI_COACH_TUTORIAL) && mounted) {
        try {
          _showTutorial();
          TutorialService.markTutorialAsShown(TutorialService.AI_COACH_TUTORIAL);
        } catch (e) {
          print('Error showing tutorial: $e');
        }
      }
    });
  }

  void _showTutorial() {
    if (!mounted) return;
    
    try {
      final tutorial = TutorialService.createAICoachTutorial(
        context,
        [_videoChatKey, _chatInputKey],
        _scrollController,
      );
      
      // Add a small delay to ensure the widget tree is stable
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          tutorial.show(context: context);
        }
      });
    } catch (e) {
      print('Error showing tutorial: $e');
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

  void _handleSendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
    
    _messageController.clear();
    _scrollToBottom();
    
    _addAIMessage("I understand you're interested in $message. Let me help you with that.");
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
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      widget.tabController.index = 0;
    }
  }

  Future<void> _startTavusCall(BuildContext context) async {
    try {
      // End any existing conversations first
      await _tavusService.endAllActiveConversations();

      final conversation = await _tavusService.createConversation(
        conversationName: 'AI Coach Video Call',
        conversationalContext: 'You are having a video call with your AI health coach who helps you with mental wellness and cognitive training.',
        customGreeting: 'Hello! I\'m excited to have this video chat with you. How can I help you today?',
      );

      if (!mounted) return;

      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => TavusCallScreen(
            conversationUrl: conversation.conversationUrl,
            conversationId: conversation.conversationId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Failed to start video call: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: AppColors.getSurfaceWithOpacity(0.7),
          border: Border(
            bottom: BorderSide(
              color: AppColors.separator.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          middle: Text(
            'AI Coach',
            style: AppTextStyles.withColor(AppTextStyles.heading3, AppColors.textPrimary),
          ),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _handleBackPress,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SFIcon(
                  SFIcons.sf_chevron_left,
                  fontSize: 20,
                  color: AppColors.primary,
                ),
                Text(
                  'Back',
                  style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
                ),
              ],
            ),
          ),
          trailing: CupertinoButton(
            key: _videoChatKey,
            padding: EdgeInsets.zero,
            onPressed: () => _startTavusCall(context),
            child: SFIcon(
              SFIcons.sf_video_fill,
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.frostedGlassGradient,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      top: 90,
                      bottom: 100
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                ),
                if (_isTyping)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: _buildTypingIndicator(),
                  ),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.getSurfaceWithOpacity(0.7),
                        border: Border(
                          top: BorderSide(
                            color: AppColors.separator.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          key: _chatInputKey,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildTextInput(),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                onPressed: _messageController.text.isNotEmpty
                                    ? _handleSendMessage
                                    : null,
                                child: SFIcon(
                                  SFIcons.sf_arrow_up_circle_fill,
                                  fontSize: 24,
                                  color: _messageController.text.isNotEmpty
                                      ? AppColors.primary
                                      : AppColors.systemGrey3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final bubbleColor = isUser
        ? CupertinoColors.white
        : CupertinoColors.white;

    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 64 : 16,
        right: isUser ? 16 : 64,
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.getPrimaryWithOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  isUser ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.getPrimaryWithOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SFIcon(
          SFIcons.sf_brain,
          fontSize: 16,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getPrimaryWithOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.getPrimaryWithOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: AnimatedBuilder(
              animation: _typingDotsController,
              builder: (context, child) {
                final animation = sin((_typingDotsController.value * 2 * pi) + (index * pi / 2));
                return Transform.translate(
                  offset: Offset(0, -2 * animation),
                  child: child,
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextInput() {
    return CupertinoTextField.borderless(
      controller: _messageController,
      focusNode: _focusNode,
      placeholder: 'Message',
      placeholderStyle: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.secondaryLabel),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getPrimaryWithOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      onTap: () {
        _focusNode.requestFocus();
        _scrollToBottom();
      },
      onChanged: (value) {
        setState(() {});
      },
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          _handleSendMessage();
        }
      },
      textInputAction: TextInputAction.send,
      style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textPrimary),
      cursorColor: AppColors.primary,
    );
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