import 'dart:async';

import 'package:flutter/material.dart';

class FlashDealLive extends StatefulWidget {
  final DateTime? endFlashDealDate;
  final Color? backgroundColor;
  final Color? textColor;

  const FlashDealLive({
    super.key,
    required this.endFlashDealDate,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<FlashDealLive> createState() => _FlashDealLiveState();
}

class _FlashDealLiveState extends State<FlashDealLive> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String text;
    final remaining = widget.endFlashDealDate?.difference(DateTime.now());
    if (remaining == null) {
      return const SizedBox.shrink();
    } else if (remaining.isNegative) {
      text = 'Expired';
    } else {
      final h = remaining.inHours;
      final m = remaining.inMinutes % 60;
      final s = remaining.inSeconds % 60;
      final mm = m.toString().padLeft(2, '0');
      final ss = s.toString().padLeft(2, '0');
      text = h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: widget.backgroundColor ??Colors.red.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: widget.textColor?? Colors.red.shade700)),
    );
  }
}
