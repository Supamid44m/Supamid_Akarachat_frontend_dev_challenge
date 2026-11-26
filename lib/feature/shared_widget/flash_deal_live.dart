import 'package:flutter/material.dart';

import '../../service/flash_ticker.dart';

/// Live flash-sale countdown badge.
///
/// Only the inner [Text] rebuilds each second (via the shared [FlashTicker]);
/// the badge container and the parent card stay untouched.
class FlashDealLive extends StatelessWidget {
  final DateTime? endFlashDealDate;
  final Color? backgroundColor;
  final Color? textColor;

  const FlashDealLive({
    super.key,
    required this.endFlashDealDate,
    this.backgroundColor,
    this.textColor,
  });

  static String format(Duration remaining) {
    if (remaining.isNegative || remaining == Duration.zero) return 'Expired';
    final h = remaining.inHours;
    final mm = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final end = endFlashDealDate;
    if (end == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.red.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: AnimatedBuilder(
        animation: FlashTicker.instance,
        builder: (_, __) => Text(
          format(end.difference(DateTime.now())),
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.red.shade700),
        ),
      ),
    );
  }
}
