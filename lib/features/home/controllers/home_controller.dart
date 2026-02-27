import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../profile/data/services/user_service.dart';
import '../data/models/product_model.dart';

class HomeController extends GetxController {
  // Tab management
  var selectedTabIndex = 0.obs;
  final tabs = ['For You', 'Top Rated', 'Budget'];

  // Search controller
  late TextEditingController searchController;

  // Products list
  var allProducts = <ProductModel>[].obs;
  var forYouProducts = <ProductModel>[].obs;
  var topRatedProducts = <ProductModel>[].obs;
  var budgetProducts = <ProductModel>[].obs;

  // Username
  var userName = ''.obs;

  // Refresh state
  var isRefreshing = false.obs;

  // Scroll controller for unified scroll management
  late ScrollController scrollController;

  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    searchController = TextEditingController();
    _initializeProducts();
    _loadUserName();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

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

  void _initializeProducts() {
    // Sample product data - Extended for better scrolling demo
    final products = [
      ProductModel(
        id: '1',
        name: 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
        price: 109.95,
        rating: 3.9,
        image: 'https://via.placeholder.com/200x200?text=Backpack',
        category: 'backpack',
      ),
      ProductModel(
        id: '2',
        name: 'Mens Casual Premium Slim Fit T-Shirts',
        price: 22.30,
        rating: 4.1,
        image: 'https://via.placeholder.com/200x200?text=TShirt',
        category: 'clothing',
      ),
      ProductModel(
        id: '3',
        name: 'Mens Cotton Jacket',
        price: 55.99,
        rating: 4.7,
        image: 'https://via.placeholder.com/200x200?text=Jacket',
        category: 'clothing',
      ),
      ProductModel(
        id: '4',
        name: 'Mens Casual Slim Fit',
        price: 15.99,
        rating: 2.1,
        image: 'https://via.placeholder.com/200x200?text=SlimFit',
        category: 'clothing',
      ),
      ProductModel(
        id: '5',
        name: 'John Hardy Women\'s Legends Naga Gold & Silver Dragon Stat...',
        price: 695.00,
        rating: 4.6,
        image: 'https://via.placeholder.com/200x200?text=Bracelet',
        category: 'jewelry',
      ),
      // Additional products for scrolling
      ProductModel(
        id: '6',
        name: 'White Gold Plated Premium',
        price: 299.99,
        rating: 4.3,
        image: 'https://via.placeholder.com/200x200?text=Premium',
        category: 'jewelry',
      ),
      ProductModel(
        id: '7',
        name: 'Heavy Duty Work Boots',
        price: 89.99,
        rating: 4.5,
        image: 'https://via.placeholder.com/200x200?text=Boots',
        category: 'footwear',
      ),
      ProductModel(
        id: '8',
        name: 'Summer Cotton Shorts',
        price: 29.99,
        rating: 3.8,
        image: 'https://via.placeholder.com/200x200?text=Shorts',
        category: 'clothing',
      ),
    ];

    allProducts.value = products;
    forYouProducts.value = products;
    topRatedProducts.value = products.where((p) => p.rating >= 4.0).toList();
    budgetProducts.value = products.where((p) => p.price <= 50).toList();
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void onPageChanged(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> refreshProducts() async {
    isRefreshing.value = true;
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1000));
      _initializeProducts();
    } finally {
      isRefreshing.value = false;
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _initializeProducts();
      return;
    }

    final filtered = allProducts
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    forYouProducts.value = filtered;
  }

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
