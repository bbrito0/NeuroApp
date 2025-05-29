import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

class SlidingToggle extends StatefulWidget {
  final List<String> options;
  final int initialSelection;
  final double? width;
  final double height;
  final bool centered;
  final void Function(int) onToggle;
  final bool usePillIndicator;

  const SlidingToggle({
    Key? key,
    required this.options,
    required this.onToggle,
    this.initialSelection = 0,
    this.width,
    this.height = 44.0,
    this.centered = true,
    this.usePillIndicator = true,
  })  : assert(initialSelection >= 0 && initialSelection < options.length),
        super(key: key);

  @override
  State<SlidingToggle> createState() => _SlidingToggleState();
}

class _SlidingToggleState extends State<SlidingToggle> with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  List<GlobalKey> _optionKeys = [];
  
  // UI Constants
  static const Duration animationDuration = Duration(milliseconds: 200);
  static const double optionHorizontalPadding = 12.0;
  static const double pillInset = 4.0;
  static const List<Color> gradientColors = [
    Color.fromARGB(255, 0, 118, 169),
    Color.fromARGB(255, 18, 162, 183),
    Color.fromARGB(255, 92, 197, 217),
  ];
  static const List<double> gradientStops = [0.0, 0.5, 1.0];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelection;
    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    _slideAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _optionKeys = List.generate(widget.options.length, (index) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePillPosition(_selectedIndex);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updatePillPosition(int index) {
    if (_optionKeys.isEmpty || index >= _optionKeys.length) return;
    
    final RenderBox? renderBox = _optionKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final RenderBox containerBox = context.findRenderObject() as RenderBox;
    final Offset containerPosition = containerBox.localToGlobal(Offset.zero);
    
    final double localPosition = position.dx - containerPosition.dx;

    _slideAnimation = Tween<double>(
      begin: _slideAnimation.value,
      end: localPosition,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.getPrimaryWithOpacity(0.1),
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: Stack(
        children: [
          // The pill indicator
          if (widget.usePillIndicator)
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                if (_optionKeys.isEmpty || _selectedIndex >= _optionKeys.length) {
                  return const SizedBox.shrink();
                }
                
                final RenderBox? renderBox = _optionKeys[_selectedIndex].currentContext?.findRenderObject() as RenderBox?;
                if (renderBox == null) return const SizedBox.shrink();
                
                final double optionWidth = renderBox.size.width;
                
                return Positioned(
                  left: _slideAnimation.value,
                  top: pillInset,
                  bottom: pillInset,
                  width: optionWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                        stops: gradientStops,
                      ),
                      borderRadius: BorderRadius.circular((widget.height - (pillInset * 2)) / 2),
                    ),
                  ),
                );
              },
            ),
          
          // The options row
          Row(
            mainAxisAlignment: widget.centered ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: List.generate(
              widget.options.length,
              (index) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      widget.onToggle(index);
                      _updatePillPosition(index);
                    });
                  },
                  child: Center(
                    child: Container(
                      key: _optionKeys[index],
                      padding: const EdgeInsets.symmetric(horizontal: optionHorizontalPadding),
                      height: widget.height,
                      child: Center(
                        child: Text(
                          widget.options[index],
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodySmall,
                            _selectedIndex == index 
                              ? AppColors.surface
                              : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 