import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../profile/data/services/user_service.dart';
import '../data/models/product_model.dart';
import '../data/services/product_service.dart';

/// Controls the home screen state: products, tabs, search, and scroll.
///
/// ## Scroll Ownership
/// The single [scrollController] is the sole owner of vertical scrolling.
/// It is attached to the one [CustomScrollView] in [HomeScreen].
/// No other scrollable widgets exist on the screen.
///
/// ## State Management
/// Reactive state (.obs) is used for data that the UI observes via [Obx]:
/// tab index, product lists, loading/error flags.
/// [update()] is called sparingly for [GetBuilder] rebuilds (e.g., after
/// data loads, so non-reactive params like userName string propagate).
class HomeController extends GetxController {
  // ── Tab management ──
  var selectedTabIndex = 0.obs;
  final tabs = ['For You', 'Top Rated', 'Budget'];

  // ── Search ──
  late TextEditingController searchController;

  // ── Product data ──
  var allProducts = <ProductModel>[].obs;
  var forYouProducts = <ProductModel>[].obs;
  var topRatedProducts = <ProductModel>[].obs;
  var budgetProducts = <ProductModel>[].obs;

  // ── User ──
  var userName = ''.obs;

  // ── Loading & error ──
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var errorMessage = ''.obs;

  // ── Scroll ──
  // Single ScrollController — the ONLY scroll owner on the screen.
  late ScrollController scrollController;

  final UserService _userService = UserService();
  final ProductService _productService = ProductService();

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    searchController = TextEditingController();
    fetchProducts();
    _loadUserName();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // ────────────────── User ──────────────────

  Future<void> _loadUserName() async {
    final storedUserId = StorageService.userId;
    if (storedUserId == null) return;

    try {
      final id = int.tryParse(storedUserId) ?? 1;
      final user = await _userService.getUserById(
        id,
        token: StorageService.token,
      );

      if (user != null) {
        userName.value = user.name.firstname;
        update();
      }
    } catch (_) {
      userName.value = 'User';
    }
  }

  // ────────────────── Products (API) ──────────────────

  /// Fetches all products from the Fake Store API.
  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    update();

    try {
      final products = await _productService.getAllProducts(
        token: StorageService.token,
      );

      if (products.isNotEmpty) {
        allProducts.value = products;
        _categorizeProducts(products);
      } else {
        errorMessage.value = 'No products found';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load products. Please try again.';
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Splits products into tab-specific lists.
  void _categorizeProducts(List<ProductModel> products) {
    forYouProducts.value = products;
    topRatedProducts.value = products.where((p) => p.rating >= 4.0).toList();
    budgetProducts.value = products.where((p) => p.price <= 50).toList();
  }

  // ────────────────── Tab switching ──────────────────

  /// Selects a tab by index (called on tap or swipe).
  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  /// Handles horizontal swipe gestures detected by the top-level
  /// [GestureDetector] in [HomeScreen].
  ///
  /// Flutter's gesture arena ensures this only fires when the swipe
  /// is clearly horizontal — the [CustomScrollView]'s vertical drag
  /// recognizer will NOT be active for the same pointer sequence.
  ///
  /// A minimum velocity threshold of 300 px/s prevents accidental
  /// tab switches during slow or ambiguous movements.
  void handleHorizontalSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity > 300) {
      // Swiped right → previous tab
      int newIndex = selectedTabIndex.value - 1;
      if (newIndex < 0) newIndex = tabs.length - 1;
      selectTab(newIndex);
    } else if (velocity < -300) {
      // Swiped left → next tab
      int newIndex = (selectedTabIndex.value + 1) % tabs.length;
      selectTab(newIndex);
    }
  }

  // ────────────────── Refresh ──────────────────

  Future<void> refreshProducts() async {
    isRefreshing.value = true;
    try {
      await fetchProducts();
    } finally {
      isRefreshing.value = false;
    }
  }

  // ────────────────── Search ──────────────────

  void searchProducts(String query) {
    if (query.isEmpty) {
      _categorizeProducts(allProducts);
      return;
    }

    final filtered = allProducts
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    forYouProducts.value = filtered;
    topRatedProducts.value = filtered.where((p) => p.rating >= 4.0).toList();
    budgetProducts.value = filtered.where((p) => p.price <= 50).toList();
  }

  // ────────────────── Tab content ──────────────────

  /// Returns the product list for the currently selected tab.
  List<ProductModel> getProductsByTab() {
    switch (selectedTabIndex.value) {
      case 0:
        return forYouProducts.toList();
      case 1:
        return topRatedProducts.toList();
      case 2:
        return budgetProducts.toList();
      default:
        return forYouProducts.toList();
    }
  }
}
