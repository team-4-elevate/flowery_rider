import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessAnimationDialog extends StatefulWidget {
  final String message;
  final String animationAsset;
  final double animationHeight;
  final double animationWidth;
  final Color backgroundColor;
  final VoidCallback? onDismissed;
  final int dismissDelayMs;

  const SuccessAnimationDialog({
    super.key,
    required this.message,
    this.animationAsset = 'assets/ainmations/sucess_animation.json',
    this.animationHeight = 150,
    this.animationWidth = 150,
    this.backgroundColor = Colors.white,
    this.onDismissed,
    this.dismissDelayMs = 500,
  });

  @override
  State<SuccessAnimationDialog> createState() => _SuccessAnimationDialogState();
  static Future<void> show({
    required BuildContext context,
    required String message,
    String animationAsset = 'assets/ainmations/sucess_animation.json',
    double animationHeight = 150,
    double animationWidth = 150,
    Color backgroundColor = Colors.white,
    VoidCallback? onDismissed,
    int dismissDelayMs = 500,
  }) async {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (dialogContext) => SuccessAnimationDialog(
        message: message,
        animationAsset: animationAsset,
        animationHeight: animationHeight,
        animationWidth: animationWidth,
        backgroundColor: backgroundColor,
        onDismissed: onDismissed,
        dismissDelayMs: dismissDelayMs,
      ),
    );
  }
}

class _SuccessAnimationDialogState extends State<SuccessAnimationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.backgroundColor.withAlpha(204),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Lottie.asset(
            widget.animationAsset,
            repeat: false,
            height: widget.animationHeight,
            width: widget.animationWidth,
            fit: BoxFit.contain,
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
              _controller.forward().then((_) {
                Future.delayed(Duration(milliseconds: widget.dismissDelayMs),
                    () {
                  if (context.mounted && Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                    // Call the onDismissed callback if provided
                    if (widget.onDismissed != null) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        widget.onDismissed!();
                      });
                    }
                  }
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
