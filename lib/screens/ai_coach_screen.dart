import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'dart:math' show sin, pi;
import 'package:flutter_sficon/flutter_sficon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({
    super.key,
    required this.tabController,
  });

  final CupertinoTabController tabController;

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isVoiceMode = false;
  bool _isTyping = false;
  bool _isListening = false;
  bool _showTooltip = true;
  
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
    
    // Add initial greeting
    Future.delayed(const Duration(milliseconds: 500), () {
      _addAIMessage("Hello $_userName, how can I help you today?");
    });
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

  void _toggleVoiceMode() {
    setState(() {
      _isVoiceMode = !_isVoiceMode;
      if (_isVoiceMode) {
        _isListening = false;
      }
    });
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
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
            onPressed: () {
              Navigator.of(context).pop();
              widget.tabController.index = 0;
            },
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
          trailing: Stack(
            clipBehavior: Clip.none,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _toggleVoiceMode,
                child: SFIcon(
                  _isVoiceMode ? SFIcons.sf_keyboard : SFIcons.sf_mic,
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
              if (_showTooltip)
                Positioned(
                  right: 30,
                  top: 0,
                  child: FadeTransition(
                    opacity: _tooltipAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.getSurfaceWithOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.getPrimaryWithOpacity(0.1),
                          width: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.getSurfaceWithOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Toggle voice input',
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodySmall,
                              AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
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
                // AI Avatar Section
                Container(
                  padding: const EdgeInsets.only(top: 48, bottom: 24),
                  child: Column(
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: AppColors.primarySurfaceGradient(startOpacity: 0.1, endOpacity: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.getPrimaryWithOpacity(0.1),
                            width: 0.5,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/openart-image_ayfupyiH_1741280793391_raw.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceWithOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.getPrimaryWithOpacity(0.1),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                      Text(
                              'Online',
                              style: AppTextStyles.withColor(
                                AppTextStyles.bodySmall,
                                AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 16, bottom: 100),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: _isVoiceMode
                                    ? _buildVoiceButton()
                                    : _buildTextInput(),
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
        ? AppColors.getPrimaryWithOpacity(0.1)
        : AppColors.getSurfaceWithOpacity(0.5);

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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUser
                      ? AppColors.getPrimaryWithOpacity(0.1)
                      : AppColors.separator.withOpacity(0.1),
                  width: 0.5,
                ),
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
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(right: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceWithOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.separator.withOpacity(0.1),
          width: 0.5,
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceWithOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.systemGrey4,
          width: 0.5,
        ),
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

  Widget _buildVoiceButton() {
    return GestureDetector(
      onTapDown: (_) => _toggleListening(),
      onTapUp: (_) => _toggleListening(),
      onTapCancel: () => _toggleListening(),
      child: Container(
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: _isListening
              ? AppColors.getPrimaryWithOpacity(0.15)
              : AppColors.getSurfaceWithOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isListening
                ? AppColors.getPrimaryWithOpacity(0.2)
                : AppColors.systemGrey4,
            width: 0.5,
          ),
        ),
        child: Center(
          child: Text(
            _isListening ? 'Listening...' : 'Hold to speak',
            style: AppTextStyles.withColor(
              AppTextStyles.bodySmall,
              _isListening ? AppColors.primary : AppColors.secondaryLabel,
            ),
          ),
        ),
      ),
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