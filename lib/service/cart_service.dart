import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/cart_item_model.dart';
import '../model/deal_model.dart';
import '../util/log_service.dart';

/// App-wide cart. Lives for the whole session.
///
/// NOTE: the starter cart is purely local — it does not reserve stock on the
/// backend. See the "Reservations" feature task in PROBLEM.md.
class CartService extends GetxService {
  final items = <CartItemModel>[].obs;
  final itemCount = 0.obs;
  final _expiryTimers = <int, Timer>{};

  void add(DealModel deal) {
    if(deal.isFlashDealExpire) return;
    final existing = items.firstWhereOrNull((i) => i.deal.id == deal.id);
    if (existing != null) {
      if (existing.quantity >= deal.quantityLeft) {
        LogService.log('cart: cannot add more of deal ${deal.id}');
        return;
      }
      existing.quantity++;
      items.refresh();
    } else {
      items.add(CartItemModel(deal: deal));
      _scheduleExpiry(deal);
    }
    _recount();
  }

  void decrement(int dealId) {
    final existing = items.firstWhereOrNull((i) => i.deal.id == dealId);
    if (existing == null) return;
    existing.quantity--;
    if (existing.quantity <= 0) {
      items.removeWhere((i) => i.deal.id == dealId);
      _cancelExpiry(dealId);
    } else {
      items.refresh();
    }
    _recount();
  }

  void remove(int dealId) {
    items.removeWhere((i) => i.deal.id == dealId);
    _cancelExpiry(dealId);
    _recount();
  }

  void clear() {
    items.clear();
    _cancelAllExpiry();
    _recount();
  }

  num get total => items.fold(0, (sum, i) => sum + i.lineTotal);

  void _scheduleExpiry(DealModel deal) {
    final end = deal.flashSaleEndsAt;
    if (end == null) return;
    _expiryTimers[deal.id]?.cancel();
    _expiryTimers[deal.id] = Timer(end.difference(DateTime.now()), () {
      _expiryTimers.remove(deal.id);
      if (items.every((i) => i.deal.id != deal.id)) return;
      remove(deal.id);
      Get.snackbar(
        'Flash sale ended',
        '${deal.name} was removed from your bag',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    });
  }

  void _cancelExpiry(int dealId) => _expiryTimers.remove(dealId)?.cancel();

  void _cancelAllExpiry() {
    for (final t in _expiryTimers.values) {
      t.cancel();
    }
    _expiryTimers.clear();
  }

  @override
  void onClose() {
    _cancelAllExpiry();
    super.onClose();
  }

  void _recount() {
    itemCount.value = items.fold(0, (sum, i) => sum + i.quantity);
  }
}
