import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/widgets.dart';
import 'medical_record_screen.dart';
import 'code_scanner_screen.dart';
import 'dart:math' show min;

class Supplement {
  final String name;
  final String description;
  final List<String> benefits;
  final String dosage;
  final Color accentColor;
  final String? code;

  Supplement({
    required this.name,
    required this.description,
    required this.benefits,
    required this.dosage,
    required this.accentColor,
    this.code,
  });
}

class SupplementDetailsScreen extends StatefulWidget {
  final String scannedCode;
  // Add a list of existing supplements (optional)
  final List<Supplement>? existingSupplements;

  const SupplementDetailsScreen({
    super.key,
    required this.scannedCode,
    this.existingSupplements,
  });

  @override
  State<SupplementDetailsScreen> createState() => _SupplementDetailsScreenState();
}

class _SupplementDetailsScreenState extends State<SupplementDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _beginAlignment;
  late Animation<Alignment> _endAlignment;
  
  late List<Supplement> _supplements;
  // Track the currently selected supplement
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _beginAlignment = AlignmentTween(
      begin: const Alignment(-1.0, -1.0),
      end: const Alignment(1.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _endAlignment = AlignmentTween(
      begin: const Alignment(0.0, 0.0),
      end: const Alignment(2.0, 2.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Initialize supplements based on scanned code
    _loadSupplements();
  }

  void _loadSupplements() {
    // If we have existing supplements, use them
    if (widget.existingSupplements != null && widget.existingSupplements!.isNotEmpty) {
      _supplements = List.from(widget.existingSupplements!);
      
      // Add the new supplement based on the code
      // This is just a demonstration - in a real app, you'd fetch the supplement info from a database
      if (widget.scannedCode != _supplements.last.code) {
        // Add a new supplement with a different color based on the code
        _supplements.add(
          Supplement(
            name: 'SUPPLEMENT ${widget.scannedCode}',
            description: '',
            benefits: ['', '', '', ''],
            dosage: '',
            accentColor: _getColorForCode(widget.scannedCode),
            code: widget.scannedCode,
          ),
        );
      }
      
      // Set the selected index to the newest supplement
      _selectedIndex = _supplements.length - 1;
    } else {
      // Otherwise, start with just the current scanned supplement
      _supplements = [
        Supplement(
          name: 'REVITA',
          description: '',
          benefits: ['', '', '', ''],
          dosage: '',
          accentColor: const Color(0xFFFF1493),
          code: widget.scannedCode,
        ),
      ];
    }
  }
  
  // Generate a color based on the code - this would usually be more sophisticated
  Color _getColorForCode(String code) {
    // Generate different colors for different codes
    switch (code) {
      case 'dev-test-code':
        return const Color(0xFFFF1493); // Pink
      case 'code2':
        return const Color(0xFF4169E1); // Royal Blue
      case 'code3':
        return const Color(0xFF32CD32); // Lime Green
      default:
        // Generate a random color based on the code
        final int hash = code.hashCode;
        return Color.fromARGB(
          255, 
          ((hash & 0xFF0000) >> 16).abs() % 256,
          ((hash & 0x00FF00) >> 8).abs() % 256,
          (hash & 0x0000FF).abs() % 256,
        );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update with localized strings
    final localizations = AppLocalizations.of(context)!;
    
    // Create a new list with updated localizations to avoid modifying the original
    final updatedSupplements = <Supplement>[];
    
    for (final supplement in _supplements) {
      // Get the name from the original supplement
      final name = supplement.name;
      final code = supplement.code;
      final accentColor = supplement.accentColor;
      
      updatedSupplements.add(
        Supplement(
          name: name,
          description: localizations.supplementDescription ?? 'Premium cognitive enhancement supplement',
          benefits: [
            localizations.benefitImprovedFocus ?? 'Improved focus and concentration',
            localizations.benefitEnhancedMemory ?? 'Enhanced memory retention',
            localizations.benefitReducedBrainFog ?? 'Reduced brain fog',
            localizations.benefitIncreasedClarity ?? 'Increased mental clarity',
          ],
          dosage: localizations.supplementDosage ?? '2 capsules daily, preferably with food',
          accentColor: accentColor,
          code: code,
        ),
      );
    }
    
    setState(() {
      _supplements = updatedSupplements;
    });
  }

  void _addMoreSupplements() {
    // Quick testing version - directly add a new supplement without scanner
    setState(() {
      // Generate a unique code based on the current number of supplements
      final newCode = 'code${_supplements.length + 1}';
      
      // Create supplement with different colors based on index
      final List<Color> supplementColors = [
        const Color(0xFF4169E1), // Royal Blue
        const Color(0xFF32CD32), // Lime Green
        const Color(0xFFFF8C00), // Dark Orange
        const Color(0xFF9370DB), // Medium Purple
      ];
      
      // Get a color from the predefined list or fallback to a random one
      final colorIndex = (_supplements.length - 1) % supplementColors.length;
      final newColor = supplementColors[colorIndex];
      
      // Get localized text
      final localizations = AppLocalizations.of(context)!;
      
      // Create new supplement with a different name based on index
      final List<String> supplementNames = ['RESTORE', 'RENEW', 'RECHARGE', 'REVIVE'];
      final nameIndex = (_supplements.length - 1) % supplementNames.length;
      
      _supplements.add(
        Supplement(
          name: supplementNames[nameIndex],
          description: localizations.supplementDescription ?? 'Premium cognitive enhancement supplement',
          benefits: [
            localizations.benefitImprovedFocus ?? 'Improved focus and concentration',
            localizations.benefitEnhancedMemory ?? 'Enhanced memory retention',
            localizations.benefitReducedBrainFog ?? 'Reduced brain fog',
            localizations.benefitIncreasedClarity ?? 'Increased mental clarity',
          ],
          dosage: localizations.supplementDosage ?? '2 capsules daily, preferably with food',
          accentColor: newColor,
          code: newCode,
        ),
      );
      
      // Set selected index to the new supplement
      _selectedIndex = _supplements.length - 1;
    });
  }

  void _navigateToMedicalRecord() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const MedicalRecordScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CustomNavigationBar(
        title: localizations.yourSupplements,
        subtitle: localizations.reviewAndManage,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      child: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: _beginAlignment.value,
                    end: _endAlignment.value,
                    colors: AppColors.primaryGradient.colors,
                    tileMode: TileMode.mirror,
                  ),
                ),
              );
            },
          ),
          // Frosted glass effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.frostedGlassGradient,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card stack - showing all supplements in an Apple Wallet style
                  Expanded(
                    child: SupplementCardStack(
                      supplements: _supplements,
                      selectedIndex: _selectedIndex,
                      onCardSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      buildSupplementCard: (supplement, isSelected, isVisible) {
                        return _buildSupplementCard(supplement);
                      },
                    ),
                  ),
                  
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        ActionButton(
                          text: localizations.addMoreSupplements,
                          onPressed: _addMoreSupplements,
                          style: ActionButtonStyle.filled,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          textColor: AppColors.primary,
                          isFullWidth: true,
                          height: 44,
                          icon: SFIcon(
                            SFIcons.sf_plus,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ActionButton(
                          text: localizations.continueToHealthProfile,
                          onPressed: _navigateToMedicalRecord,
                          style: ActionButtonStyle.filled,
                          backgroundColor: AppColors.primary,
                          textColor: AppColors.surface,
                          isFullWidth: true,
                          height: 44,
                          icon: SFIcon(
                            SFIcons.sf_arrow_right,
                            fontSize: 18,
                            color: AppColors.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplementCard(Supplement supplement) {
    final localizations = AppLocalizations.of(context)!;
    
    return FrostedCard(
      borderRadius: 20,
      backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
      padding: const EdgeInsets.all(0), // No padding to allow for header
      border: Border.all(
        color: AppColors.getPrimaryWithOpacity(0.2),
        width: 0.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Use min to prevent expansion
        children: [
          // Colored header with name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  supplement.accentColor.withOpacity(0.8),
                  supplement.accentColor.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    supplement.name,
                    style: AppTextStyles.withColor(
                      AppTextStyles.heading2,
                      Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    localizations.verified,
                    style: AppTextStyles.withColor(
                      AppTextStyles.bodySmall,
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content - Wrap in a ConstrainedBox to limit its size and prevent overflow
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Use min to prevent expansion
                  children: [
                    Text(
                      supplement.description,
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyLarge,
                        AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Benefits section
                    _buildSectionHeader(localizations.benefits),
                    const SizedBox(height: 8),
                    ...supplement.benefits.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SFIcon(
                            SFIcons.sf_checkmark_circle_fill,
                            fontSize: 16,
                            color: supplement.accentColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              benefit,
                              style: AppTextStyles.withColor(
                                AppTextStyles.bodyMedium,
                                AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 16),
                    // Dosage section
                    _buildSectionHeader(localizations.recommendedDosage),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SFIcon(
                          SFIcons.sf_pills,
                          fontSize: 16,
                          color: supplement.accentColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            supplement.dosage,
                            style: AppTextStyles.withColor(
                              AppTextStyles.bodyMedium,
                              AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppColors.primarySurfaceGradient(startOpacity: 0.2, endOpacity: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.primary),
          ),
        ],
      ),
    );
  }
}

/// A widget that displays a stack of supplement cards in an Apple Wallet style.
class SupplementCardStack extends StatefulWidget {
  final List<Supplement> supplements;
  final int selectedIndex;
  final Function(int) onCardSelected;
  final Widget Function(Supplement, bool, bool) buildSupplementCard;

  const SupplementCardStack({
    Key? key,
    required this.supplements,
    required this.selectedIndex,
    required this.onCardSelected,
    required this.buildSupplementCard,
  }) : super(key: key);

  @override
  State<SupplementCardStack> createState() => _SupplementCardStackState();
}

class _SupplementCardStackState extends State<SupplementCardStack> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  // Store the previous selected index to track direction of animation
  int _previousSelectedIndex = 0;
  
  // Define constants for card positions
  final double _selectedCardTop = 40.0; // Pushed down further to align with top header
  final double _olderCardTopOffset = -10.0; // Adjusted to show less of older cards
  // Estimated height of the selected card to position newer cards directly below it
  final double _selectedCardHeight = 350.0; // This value needs to be approximately the height of your card
  final double _cardSpacing = 15.0;
  
  // Heights for visible portions
  final double _headerHeight = 70.0;
  final double _olderCardVisibleHeight = 70.0; // Match header height for older cards
  
  // For vertical drag detection
  bool _isDragging = false;
  double _dragStartY = 0.0;
  double _dragThreshold = 50.0; // Distance needed to trigger a card change
  
  // Computed property for newer card offset
  double get _newerCardTopOffset => 400;

  @override
  void initState() {
    super.initState();
    _previousSelectedIndex = widget.selectedIndex;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    
    // Start with the animation completed
    _animationController.value = 1.0;
  }
  
  @override
  void didUpdateWidget(SupplementCardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _previousSelectedIndex = oldWidget.selectedIndex;
      
      // Reset and run animation when selected index changes
      _animationController.reset();
      _animationController.forward();
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 500, // Fixed height container for the stack
      child: GestureDetector(
        // Add gesture detector at the Stack level to handle vertical swipes
        onVerticalDragStart: _handleDragStart,
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none, // Allow cards to be visible outside the stack
          children: _buildCardStack(),
        ),
      ),
    );
  }
  
  // Handle the start of a vertical drag
  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragStartY = details.globalPosition.dy;
    });
  }
  
  // Handle updates during a vertical drag
  void _handleDragUpdate(DragUpdateDetails details) {
    // Optional: add visual feedback during drag if desired
  }
  
  // Handle the end of a vertical drag
  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    
    final double dragDistance = details.velocity.pixelsPerSecond.dy;
    final bool isDraggingUp = dragDistance < 0;
    final bool isDraggingDown = dragDistance > 0;
    
    // If dragging up with sufficient force, select a newer card (if available)
    if (isDraggingUp && widget.selectedIndex < widget.supplements.length - 1) {
      widget.onCardSelected(widget.selectedIndex + 1);
    } 
    // If dragging down with sufficient force, select an older card (if available)
    else if (isDraggingDown && widget.selectedIndex > 0) {
      widget.onCardSelected(widget.selectedIndex - 1);
    }
    
    setState(() {
      _isDragging = false;
    });
  }
  
  List<Widget> _buildCardStack() {
    final List<Widget> stackedCards = [];
    final int totalCards = widget.supplements.length;
    
    // Process cards in reverse order to ensure proper z-stacking
    // Older cards first (at the bottom of the stack)
    for (int i = 0; i < widget.selectedIndex; i++) {
      stackedCards.add(_buildAnimatedCard(i));
    }
    
    // Selected card in the middle
    stackedCards.add(_buildAnimatedCard(widget.selectedIndex));
    
    // Newer cards on top
    for (int i = widget.selectedIndex + 1; i < totalCards; i++) {
      stackedCards.add(_buildAnimatedCard(i));
    }
    
    return stackedCards;
  }
  
  Widget _buildAnimatedCard(int index) {
    final bool isSelected = index == widget.selectedIndex;
    final bool isOlderCard = index < widget.selectedIndex;
    final bool isNewerCard = index > widget.selectedIndex;
    
    // Calculate how far this card is from the selected card (for stacking)
    final int distanceFromSelected = (index - widget.selectedIndex).abs();
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Calculate the animated top position
        double top = _calculateAnimatedTopPosition(index, isSelected, isOlderCard, isNewerCard, distanceFromSelected);
        
        // Set height constraint for both older and newer cards
        double? height;
        if (isNewerCard) {
          height = _headerHeight; // Show only header for newer cards
        } else if (isOlderCard) {
          height = _headerHeight; // Show only header for older cards too
        }
        
        return Positioned(
          top: top,
          left: 0,
          right: 0,
          height: height, // Constrain height for both older and newer cards
          child: _buildCardWithTapArea(index, isSelected, isOlderCard, isNewerCard),
        );
      },
    );
  }
  
  double _calculateAnimatedTopPosition(int index, bool isSelected, bool isOlderCard, bool isNewerCard, int distanceFromSelected) {
    double finalTop;
    double animationProgress = _animation.value;
    
    // Single card special case - center it
    if (widget.supplements.length == 1) {
      return _selectedCardTop;
    }
    
    // Determine the final resting position based on card type
    if (isSelected) {
      finalTop = _selectedCardTop;
    } else if (isOlderCard) {
      finalTop = _olderCardTopOffset - (_cardSpacing * (distanceFromSelected - 1));
    } else { // isNewerCard
      finalTop = _newerCardTopOffset + (_cardSpacing * (distanceFromSelected - 1));
    }
    
    // If this card was previously selected or is becoming selected, animate it
    if (index == _previousSelectedIndex) {
      // Card was previously selected, animate to its new position
      if (widget.selectedIndex > _previousSelectedIndex) {
        // Moving up (older)
        double startTop = _selectedCardTop;
        double endTop = _olderCardTopOffset;
        return startTop + ((endTop - startTop) * animationProgress);
      } else {
        // Moving down (newer)
        double startTop = _selectedCardTop;
        double endTop = _newerCardTopOffset;
        return startTop + ((endTop - startTop) * animationProgress);
      }
    } else if (isSelected) {
      // Card is becoming selected, animate from its previous position
      if (index > _previousSelectedIndex) {
        // Moving from newer to selected
        double startTop = _newerCardTopOffset + (_cardSpacing * (distanceFromSelected - 1));
        double endTop = _selectedCardTop;
        return startTop + ((endTop - startTop) * animationProgress);
      } else {
        // Moving from older to selected
        double startTop = _olderCardTopOffset - (_cardSpacing * (distanceFromSelected - 1));
        double endTop = _selectedCardTop;
        return startTop + ((endTop - startTop) * animationProgress);
      }
    }
    
    // Card that's not involved in the current selection change
    return finalTop;
  }
  
  Widget _buildCardWithTapArea(int index, bool isSelected, bool isOlderCard, bool isNewerCard) {
    // For selected cards: show the full card
    // For older cards: show full card but clip the tap area to the visible portion
    // For newer cards: only show and allow taps on the header
    
    Widget baseWidget;
    
    if (isNewerCard) {
      // For newer cards, completely isolate the header to prevent overflow
      baseWidget = SizedBox(
        height: _headerHeight,
        child: Builder(
          builder: (context) {
            // Get just the header part of the card
            final supplement = widget.supplements[index];
            final localizations = AppLocalizations.of(context)!;
            
            // Return only the header portion
            return FrostedCard(
              borderRadius: 20,
              backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
              padding: const EdgeInsets.all(0),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(0.2),
                width: 0.5,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      supplement.accentColor.withOpacity(0.8),
                      supplement.accentColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20), // Add bottom rounding for standalone header
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        supplement.name,
                        style: AppTextStyles.withColor(
                          AppTextStyles.heading2,
                          Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        localizations.verified,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodySmall,
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      );
    } else if (isOlderCard) {
      // For older cards, also use the same header-only approach
      baseWidget = SizedBox(
        height: _headerHeight,
        child: Builder(
          builder: (context) {
            // Get just the header part of the card
            final supplement = widget.supplements[index];
            final localizations = AppLocalizations.of(context)!;
            
            // Return only the header portion
            return FrostedCard(
              borderRadius: 20,
              backgroundColor: AppColors.getSurfaceWithOpacity(0.8),
              padding: const EdgeInsets.all(0),
              border: Border.all(
                color: AppColors.getPrimaryWithOpacity(0.2),
                width: 0.5,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      supplement.accentColor.withOpacity(0.8),
                      supplement.accentColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20), // Add bottom rounding for standalone header
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        supplement.name,
                        style: AppTextStyles.withColor(
                          AppTextStyles.heading2,
                          Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        localizations.verified,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodySmall,
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      );
    } else {
      // For selected cards, show the full card
      baseWidget = widget.buildSupplementCard(
        widget.supplements[index],
        isSelected,
        true,
      );
    }
    
    // Wrap in a GestureDetector to handle taps (as backup to main vertical swipe)
    if (!isOlderCard) {
      // Only selected or newer cards get tap handlers
      return GestureDetector(
        onTap: () {
          if (index != widget.selectedIndex) {
            widget.onCardSelected(index);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: baseWidget,
      );
    }
    
    // Older cards don't need tap handlers (using swipe instead)
    return baseWidget;
  }
} 