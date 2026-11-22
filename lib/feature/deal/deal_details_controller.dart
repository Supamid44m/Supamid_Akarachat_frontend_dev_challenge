import 'dart:async';

import 'package:get/get.dart';

import '../../model/deal_model.dart';
import '../../repository/deal_repo.dart';
import '../../service/analytics_service.dart';
import '../../service/cart_service.dart';
import '../../util/log_service.dart';

class DealDetailsController extends GetxController {
  final DealRepo dealRepo;
  final CartService cartService;
  final AnalyticsService analytics;

  DealDetailsController({
    required this.dealRepo,
    required this.cartService,
    required this.analytics,
  });

  late final DealModel deal;

  final _quantityLeft = RxnInt();
  int? get quantityLeft => _quantityLeft.value;
  Worker? cartWorker;
  final flashExpired = false.obs;
  Timer? _flashTimer;

  @override
  void onInit() {
    super.onInit();
    deal = Get.arguments as DealModel;
    flashExpired.value = deal.isFlashDealExpire;
    _quantityLeft.value = deal.quantityLeft;
    analytics.logEvent('deal_details_view', {
      'deal_id': deal.id,
      'source': Get.parameters['source'] ?? 'unknown',
    });
    final end = deal.flashSaleEndsAt;
    if (end != null && !flashExpired.value) {
      _flashTimer = Timer(end.difference(DateTime.now()), () {
        flashExpired.value = true;
      });

    }
    // Whenever the cart changes, re-check this deal's remaining stock so the
    // details screen never shows stale availability.
    cartWorker = ever(cartService.itemCount, (_) => _recheckAvailability());
  }

  @override
  void onClose() {
    cartWorker?.dispose();
    _flashTimer?.cancel();
    super.onClose();
  }

  Future<void> _recheckAvailability() async {
    LogService.log('re-checking availability for deal ${deal.id}');
    final fresh = await dealRepo.fetchById(deal.id);
    _quantityLeft.value = fresh.quantityLeft;
  }

  void addToCart() {
    if (deal.isFlashDealExpire) return;
    cartService.add(deal);
    Get.snackbar(
      'Added to bag',
      '${deal.name} — pick up ${deal.pickupWindow.label}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
