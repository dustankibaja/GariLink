import 'package:flutter/material.dart';
import '../../core/theme/animations.dart';

/// A paint-only response; the child keeps its own focus, taps and semantics.
class PressFeedback extends StatefulWidget {
  const PressFeedback({required this.child, this.enabled = true, super.key});
  final Widget child;
  final bool enabled;
  @override
  State<PressFeedback> createState() => _PressFeedbackState();
}

class _PressFeedbackState extends State<PressFeedback> {
  bool _pressed = false;
  void _change(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: widget.enabled ? (_) => _change(true) : null,
    onPointerUp: (_) => _change(false),
    onPointerCancel: (_) => _change(false),
    child: AnimatedScale(
      scale:
          widget.enabled &&
              _pressed &&
              !GariLinkAnimations.reduceMotion(context)
          ? .98
          : 1,
      duration: GariLinkAnimations.duration(context, GariLinkAnimations.short),
      curve: GariLinkAnimations.feedbackCurve,
      child: widget.child,
    ),
  );
}
