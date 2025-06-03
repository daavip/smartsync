import 'package:flutter/material.dart';

class RippleEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? rippleColor;
  final BorderRadius? borderRadius;

  const RippleEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.rippleColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              splashColor:
                  rippleColor?.withOpacity(0.1) ??
                  Theme.of(context).primaryColor.withOpacity(0.1),
              highlightColor:
                  rippleColor?.withOpacity(0.05) ??
                  Theme.of(context).primaryColor.withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }
}
