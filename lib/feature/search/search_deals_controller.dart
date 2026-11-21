import 'dart:async';

import 'package:get/get.dart';

import '../../model/deal_model.dart';
import '../../repository/deal_repo.dart';
import '../../util/log_service.dart';

class SearchDealsController extends GetxController {
  final DealRepo dealRepo;

  SearchDealsController({required this.dealRepo});

  final results = <DealModel>[].obs;
  final isLoading = false.obs;
  final hasSearched = false.obs;
  Timer? _debounce;

  void onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _search(query));
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      results.clear();
      hasSearched.value = false;
      return;
    }
    isLoading.value = true;
    hasSearched.value = true;
    try {
      final found = await dealRepo.search(query);
      results.assignAll(found);
    } catch (e) {
      LogService.error('search failed', e);
    }
    isLoading.value = false;
  }
}
